local Utils = require('shared/utils')
local State = require('shared/state')
local Payment = require('server/payment')

-- Variables
local QBX = exports['qbx_core']
local ESX = nil
local activeBuses = {} -- Track all active buses with player IDs
local activeRoutes = {} -- Track all active routes by player ID
local playerPositions = {} -- Track player positions to detect teleporting
local lastStopTimes = {} -- Anti-exploit: track last stop time per player
local busSpawnCooldowns = {} -- Prevent spam-spawning buses

-- Framework initialization
CreateThread(function()
    if Config.Framework == 'ESX' then
        ESX = exports['es_extended']:getSharedObject()
    end
end)

-- Check if player has the bus job
local function HasBusJob(src)
    if not Utils.DefaultConfig('IsJobNeeded', false) then
        return true
    end

    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        return xPlayer and xPlayer.job.name == Config.JobName
    elseif Config.Framework == 'QBox' then
        return QBX:HasPrimaryGroup(src, Config.JobName)
    end
    
    return false
end

-- Security check for possible teleport hacks
local function CheckForTeleport(src, currentPos)
    if not playerPositions[src] then
        playerPositions[src] = currentPos
        return false
    end
    
    local lastPos = playerPositions[src]
    local distance = #(vector3(currentPos.x, currentPos.y, currentPos.z) - vector3(lastPos.x, lastPos.y, lastPos.z))
    
    -- Update position
    playerPositions[src] = currentPos
    
    -- If distance covered is too large in a short time, possible teleport hack
    -- 150 units is approximately 150 meters, which is very difficult to travel legitimately in 5 seconds
    if distance > 150.0 then
        Utils.DebugPrint(string.format("POSSIBLE TELEPORT HACK: Player %s moved %s units since last check", 
            GetPlayerName(src), distance), "SERVER")
        return true
    end
    
    return false
end

-- Anti-spam protection: bus spawn cooldowns
local function IsOnBusSpawnCooldown(src)
    if not busSpawnCooldowns[src] then
        return false
    end
    
    if os.time() < busSpawnCooldowns[src] then
        return true
    end
    
    return false
end

-- Set bus spawn cooldown
local function SetBusSpawnCooldown(src, seconds)
    busSpawnCooldowns[src] = os.time() + (seconds or 5)
end

-- Vehicle keys handler
RegisterNetEvent(Config.ResourceName..':requestkeys')
AddEventHandler(Config.ResourceName..':requestkeys', function(playerId, vehicleNetId, plate)
    local src = source
    
    -- Verify the source matches the playerId for security
    if src ~= playerId then
        Utils.DebugPrint("Key request mismatch: source=" .. src .. ", playerId=" .. playerId, "SERVER")
        return
    end
    
    -- Check if the vehicle exists and is an active bus
    if not activeBuses[vehicleNetId] or activeBuses[vehicleNetId].player ~= src then
        Utils.DebugPrint("Invalid key request for vehicle: " .. vehicleNetId, "SERVER")
        return
    end
    
    -- Get the vehicle entity from the network ID
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not vehicle or not DoesEntityExist(vehicle) then
        Utils.DebugPrint("Vehicle entity not found for netID: " .. vehicleNetId, "SERVER")
        return
    end
    local vehicleKeySystem = Utils.DefaultConfig('Vehiclekeys', 'QBox')
    if vehicleKeySystem == "QBox" then
        exports.qbx_vehiclekeys:GiveKeys(src, vehicle, true)
    elseif vehicleKeySystem == "QB" then
        TriggerClientEvent('vehiclekeys:client:SetOwner', src, plate)
    elseif vehicleKeySystem == "Renewed" then
        exports['Renewed-Vehiclekeys']:addKey(src, plate)
    elseif vehicleKeySystem == "Jaksam" then
        exports["vehicles_keys"]:giveVehicleKeysToPlayerId(src, plate, "owned")
    elseif vehicleKeySystem == "Wasabi" then
        exports.wasabi_carlock:GiveKey(src, plate)
    elseif vehicleKeySystem == "MrNewB" then
        exports.MrNewbVehicleKeys:GiveKeys(src, vehicleNetId)
    elseif vehicleKeySystem == "custom" then
        -- Custom implementation goes here
    end
    
    Utils.DebugPrint("Vehicle keys given to player " .. src .. " for vehicle " .. vehicleNetId, "SERVER")
end)

-- Handle bus spawn authorization
RegisterNetEvent(Config.ResourceName..':server:AuthorizeBusSpawn')
AddEventHandler(Config.ResourceName..':server:AuthorizeBusSpawn', function(routeName, playerCoords)
    local src = source
    
    -- Debug output
    Utils.DebugPrint("Bus spawn authorization request from Player: " .. src .. " for route: " .. routeName, "SERVER")
    
    -- Check if player is on cooldown
    if IsOnBusSpawnCooldown(src) then
        TriggerClientEvent(Config.ResourceName..':client:BusSpawnDenied', src, 'Please wait before requesting another bus')
        return
    end
    
    -- Check if player already has an active bus
    for vehNetId, busData in pairs(activeBuses) do
        if busData.player == src then
            TriggerClientEvent(Config.ResourceName..':client:BusSpawnDenied', src, 'You already have an active bus')
            return
        end
    end
    
    -- Validate route exists
    local route = State.ValidateRoute(routeName)
    if not route then
        TriggerClientEvent(Config.ResourceName..':client:BusSpawnDenied', src, 'Invalid route selected')
        return
    end
    
    -- Check if player has the job
    if not HasBusJob(src) then
        TriggerClientEvent(Config.ResourceName..':client:BusSpawnDenied', src, 'You need to be a bus driver')
        return
    end
    
    -- Find an appropriate spawn point index
    local spawnPointIndex = math.random(1, #Config.busSpawnPoints)
    
    -- Set cooldown
    SetBusSpawnCooldown(src, 5)
    
    -- Send authorization to client
    TriggerClientEvent(Config.ResourceName..':client:SpawnBusAuthorized', src, routeName, spawnPointIndex)
    
    Utils.DebugPrint("Bus spawn authorized for player " .. src .. " at spawn point " .. spawnPointIndex, "SERVER")
end)

-- Register a client-spawned vehicle
RegisterNetEvent(Config.ResourceName..':server:RegisterClientVehicle')
AddEventHandler(Config.ResourceName..':server:RegisterClientVehicle', function(vehicleNetId, plate, routeName)
    local src = source
    
    -- Validate vehicle exists
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if not vehicle or not DoesEntityExist(vehicle) then
        Utils.DebugPrint("Failed to register non-existent vehicle from player " .. src, "SERVER")
        return
    end
    
    -- Track the bus
    activeBuses[vehicleNetId] = {
        player = src,
        spawnTime = os.time(),
        routeName = routeName,
        plate = plate,
        position = GetEntityCoords(vehicle)
    }
    
    -- Start route if requested
    if routeName then
        activeRoutes[src] = State.InitRouteState(routeName, vehicleNetId)
    end
    
    Utils.DebugPrint("Vehicle registered for player " .. src .. " with netID: " .. vehicleNetId, "SERVER")
end)

-- Start a route
RegisterNetEvent(Config.ResourceName..':server:StartRoute')
AddEventHandler(Config.ResourceName..':server:StartRoute', function(routeName, vehicleNetId)
    local src = source
    
    -- Validate vehicle exists and belongs to this player
    if not activeBuses[vehicleNetId] or activeBuses[vehicleNetId].player ~= src then
        Utils.DebugPrint("Invalid start route request: Vehicle " .. vehicleNetId .. " not owned by player " .. src, "SERVER")
        return
    end
    
    -- Validate route exists
    local route = State.ValidateRoute(routeName)
    if not route then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Bus Job',
            description = 'Invalid route selected.',
            type = 'error',
            icon = Utils.DefaultConfig('WarnIcon', 'fa-solid fa-triangle-exclamation'),
            duration = Utils.DefaultConfig('NotificationDuration', 5000)
        })
        return
    end
    
    -- Update active bus with route info
    activeBuses[vehicleNetId].routeName = routeName
    activeBuses[vehicleNetId].routeStartTime = os.time()
    
    -- Track in active routes
    activeRoutes[src] = State.InitRouteState(routeName, vehicleNetId)
    
    -- Notify client
    TriggerClientEvent(Config.ResourceName..':client:StartRoute', src, routeName)
    
    Utils.DebugPrint("Route started for player " .. src .. ": " .. routeName, "SERVER")
end)

-- Return a bus
RegisterNetEvent(Config.ResourceName..':server:ReturnBus')
AddEventHandler(Config.ResourceName..':server:ReturnBus', function(vehicleNetId)
    local src = source
    
    -- Validate vehicle exists and belongs to this player
    if not activeBuses[vehicleNetId] or activeBuses[vehicleNetId].player ~= src then
        Utils.DebugPrint("Invalid return bus request: Vehicle " .. vehicleNetId .. " not owned by player " .. src, "SERVER")
        return
    end
    
    -- Get the vehicle entity
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    
    -- Delete the vehicle if it exists
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
    
    -- Remove from tracking
    activeBuses[vehicleNetId] = nil
    
    -- Clean up any active routes for this player
    if activeRoutes[src] then
        activeRoutes[src] = nil
    end
    
    -- Notify client
    TriggerClientEvent(Config.ResourceName..':client:BusReturned', src)
    
    Utils.DebugPrint("Bus returned by player " .. src, "SERVER")
end)

-- Process a bus stop
RegisterNetEvent(Config.ResourceName..':server:ProcessBusStop')
AddEventHandler(Config.ResourceName..':server:ProcessBusStop', function(routeName, stopNumber, vehicleCoords, vehicleNetId)
    local src = source
    
    -- Basic validation
    if not activeBuses[vehicleNetId] or activeBuses[vehicleNetId].player ~= src then
        Utils.DebugPrint("Invalid process stop request: Vehicle " .. vehicleNetId .. " not owned by player " .. src, "SERVER")
        return
    end
    
    if not activeRoutes[src] or activeRoutes[src].routeName ~= routeName or activeRoutes[src].stopIndex ~= stopNumber then
        Utils.DebugPrint("Route mismatch for player " .. src, "SERVER")
        return
    end
    
    -- Check for time-based exploits
    local currentTime = os.time()
    if lastStopTimes[src] and (currentTime - lastStopTimes[src]) < 3 then
        Utils.DebugPrint("Stop processing too frequent for player " .. src, "SERVER")
        return
    end
    
    -- Update last stop time
    lastStopTimes[src] = currentTime
    
    -- Position validation
    if not State.IsNearBusStop(vehicleCoords, routeName, stopNumber) then
        Utils.DebugPrint("Player " .. src .. " not near bus stop", "SERVER")
        return
    end
    
    -- Calculate passengers and payment
    local maxPassengers = Utils.DefaultConfig('maxPassengers', 5)
    local passengers = math.random(1, maxPassengers)
    local payment = State.CalculateStopPayment(routeName, stopNumber, passengers)
    
    -- Process payment
    local success = Payment.AddPlayerMoney(src, payment)
    
    if success then
        -- Get route information
        local totalStops = State.GetTotalStops(routeName)
        local isLastStop = stopNumber >= totalStops
        
        -- Update route progress
        activeRoutes[src] = State.AdvanceToNextStop(activeRoutes[src], payment, passengers)
        
        -- If this was the last stop, complete the route
        if isLastStop then
            -- Handle completion bonus
            local bonusAmount = Utils.DefaultConfig('RouteCompletionBonus', 0)
            if bonusAmount > 0 then
                local bonusSuccess = Payment.AddPlayerMoney(src, bonusAmount)
                
                if bonusSuccess then
                    TriggerClientEvent('ox_lib:notify', src, {
                        title = 'Bus Job',
                        description = 'Route completion bonus: $' .. bonusAmount,
                        type = 'success',
                        icon = Utils.DefaultConfig('SuccessIcon', 'fa-solid fa-circle-check'),
                        iconAnimation = Utils.DefaultConfig('IconAnim', 'pulse'),
                        duration = Utils.DefaultConfig('NotificationDuration', 5000)
                    })
                end
            end
            
            -- Clean up route tracking
            activeRoutes[src] = nil
        end
        
        -- Notify client of successful stop processing
        TriggerClientEvent(Config.ResourceName..':client:StopProcessed', src, payment, passengers, isLastStop)
        
        Utils.DebugPrint("Stop processed for player " .. src .. ": $" .. payment, "SERVER")
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Bus Job',
            description = 'Payment failed. Please try again.',
            type = 'error',
            icon = Utils.DefaultConfig('WarnIcon', 'fa-solid fa-triangle-exclamation'),
            duration = Utils.DefaultConfig('NotificationDuration', 5000)
        })
    end
end)

-- Position sync for anti-teleport checks
RegisterNetEvent(Config.ResourceName..':server:SyncPosition')
AddEventHandler(Config.ResourceName..':server:SyncPosition', function(playerCoords, vehicleCoords, vehicleNetId, routeName, stopNumber)
    local src = source
    
    -- Verify vehicle ownership
    if not activeBuses[vehicleNetId] or activeBuses[vehicleNetId].player ~= src then
        Utils.DebugPrint("Position sync for unowned vehicle: " .. vehicleNetId .. " from player " .. src, "SERVER")
        return
    end
    
    -- Check for teleport hacks
    local possibleTeleport = CheckForTeleport(src, playerCoords)
    if possibleTeleport then
        -- Log suspicious activity
        Utils.DebugPrint("Possible teleport hack from player " .. src, "SERVER")
        
        -- Optional: Take action against player
        -- TriggerEvent('anticheat:report', src, 'teleport_detection')
    end
    
    -- Update vehicle position from server-side entity if available
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    if DoesEntityExist(vehicle) then
        activeBuses[vehicleNetId].position = GetEntityCoords(vehicle)
    else
        -- Fallback to client-provided coords
        activeBuses[vehicleNetId].position = vehicleCoords
    end
    
    -- Optional: Verify route progress
    if activeRoutes[src] and activeRoutes[src].routeName == routeName then
        if math.abs(activeRoutes[src].stopIndex - stopNumber) > 1 then
            Utils.DebugPrint("Route progress mismatch for player " .. src .. ": server=" .. 
                activeRoutes[src].stopIndex .. ", client=" .. stopNumber, "SERVER")
        end
    end
end)

-- Handle debug commands
RegisterNetEvent(Config.ResourceName..':server:DebugCmd')
AddEventHandler(Config.ResourceName..':server:DebugCmd', function(cmd)
    local src = source
    
    -- Only allow if debug is enabled
    if not Utils.DefaultConfig('Debug', false) then
        return
    end
    
    -- Check permissions
    local hasPermission = false
    local requiredAcePerms = Config.AcePermissions
    
    if not requiredAcePerms or next(requiredAcePerms) == nil then
        hasPermission = true
    else
        for permission, _ in pairs(requiredAcePerms) do
            if IsPlayerAceAllowed(src, permission) then
                hasPermission = true
                break
            end
        end
    end
    
    if not hasPermission then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Bus Job',
            description = 'You don\'t have permission to use debug commands.',
            type = 'error',
            icon = Utils.DefaultConfig('WarnIcon', 'fa-solid fa-triangle-exclamation'),
            duration = Utils.DefaultConfig('NotificationDuration', 5000)
        })
        return
    end
    
    -- Process commands
    if cmd == 'spawnbusped' or cmd == 'resetbusroute' then
        TriggerClientEvent(Config.ResourceName..':client:DebugCmdResponse', src, cmd)
        Utils.DebugPrint("Debug command " .. cmd .. " executed by " .. src, "SERVER")
    else
        Utils.DebugPrint("Unknown debug command: " .. cmd, "SERVER")
    end
end)

-- Cleanup entities on resource stop
RegisterNetEvent(Config.ResourceName..':server:CleanupEntities')
AddEventHandler(Config.ResourceName..':server:CleanupEntities', function(busNetId, pedNetId)
    local src = source
    
    -- Validate bus ownership if provided
    if busNetId and activeBuses[busNetId] and activeBuses[busNetId].player == src then
        local vehicle = NetworkGetEntityFromNetworkId(busNetId)
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
        activeBuses[busNetId] = nil
    end
    
    -- Clean up ped if provided (no ownership check needed)
    if pedNetId then
        local ped = NetworkGetEntityFromNetworkId(pedNetId)
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end)

-- Clean up tracking tables periodically
CreateThread(function()
    while true do
        Wait(300000) -- 5 minutes
        local currentTime = os.time()
        
        -- Clean up old debounce entries
        for id, time in pairs(busSpawnCooldowns) do
            if currentTime > time then
                busSpawnCooldowns[id] = nil
            end
        end
        
        -- Clean up inactive buses (if they've been active for more than 1 hour)
        for vehNetId, busData in pairs(activeBuses) do
            if (currentTime - busData.spawnTime) > 3600 then
                local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
                if DoesEntityExist(vehicle) then
                    DeleteEntity(vehicle)
                end
                activeBuses[vehNetId] = nil
                
                -- Notify player if they're still connected
                local player = busData.player
                if player and GetPlayerName(player) then
                    TriggerClientEvent('ox_lib:notify', player, {
                        title = 'Bus Job',
                        description = 'Your bus was returned due to inactivity.',
                        type = 'inform',
                        icon = 'fas fa-bus',
                        duration = Utils.DefaultConfig('NotificationDuration', 5000)
                    })
                end
                
                Utils.DebugPrint("Cleaned up inactive bus for player " .. tostring(busData.player), "SERVER")
            end
        end
        
        -- Clean up stale position data
        for playerId, _ in pairs(playerPositions) do
            if not GetPlayerName(playerId) then
                playerPositions[playerId] = nil
            end
        end
    end
end)

-- Handle player disconnect
AddEventHandler('playerDropped', function()
    local src = source
    
    -- Clean up any active buses for this player
    for vehNetId, busData in pairs(activeBuses) do
        if busData.player == src then
            local vehicle = NetworkGetEntityFromNetworkId(vehNetId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
            activeBuses[vehNetId] = nil
            Utils.DebugPrint("Cleaned up bus for disconnected player " .. src, "SERVER")
        end
    end
    
    -- Clean up route data
    if activeRoutes[src] then
        activeRoutes[src] = nil
    end
    
    -- Clean up other tracking data
    playerPositions[src] = nil
    lastStopTimes[src] = nil
    busSpawnCooldowns[src] = nil
end)