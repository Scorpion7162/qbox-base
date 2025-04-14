-- Vehicle module for bus job
local Utils = require('shared/utils')
local Notify = require('client/notifications')
local State = require('shared/state')

local Vehicle = {}
local currentBus = nil
local busSpawnCooldown = 0

-- Freeze entity temporarily
function Vehicle.FreezeTemporarily(entity, duration)
    if not DoesEntityExist(entity) then return false end
    
    FreezeEntityPosition(entity, true)
    
    SetTimeout(duration or 5000, function()
        if DoesEntityExist(entity) then
            FreezeEntityPosition(entity, false)
        end
    end)
    
    return true
end

-- Check if on cooldown
function Vehicle.IsOnCooldown()
    return GetGameTimer() < busSpawnCooldown
end

-- Set cooldown for bus spawn
function Vehicle.SetCooldown(ms)
    busSpawnCooldown = GetGameTimer() + (ms or 5000)
end

-- Request bus spawn from server
function Vehicle.RequestBusSpawn(routeName)
    -- Check if already has a bus
    if currentBus and DoesEntityExist(currentBus) then
        Notify.Error('You already have a bus!')
        return false
    end
    
    -- Check if route exists
    if not routeName then
        Notify.Error('You need to select a route first!')
        return false
    end
    
    -- Check cooldown
    if Vehicle.IsOnCooldown() then
        Notify.Error('Please wait before requesting another bus.')
        return false
    end
    
    -- Set cooldown
    Vehicle.SetCooldown(5000)
    
    -- Get player coords for server verification
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    -- Request authorization from server
    TriggerServerEvent(Config.ResourceName..':server:AuthorizeBusSpawn', routeName, playerCoords)
    
    Utils.DebugPrint("Requesting bus spawn for route: " .. routeName, "CLIENT")
    Notify.Info('Requesting bus. Please wait...')
    
    return true
end

-- Return bus to depot
function Vehicle.ReturnBus()
    if not currentBus or not DoesEntityExist(currentBus) then
        Notify.Error('You don\'t have a bus to return!')
        return false
    end
    
    local vehicleNetId = NetworkGetNetworkIdFromEntity(currentBus)
    
    -- Request server to handle return
    TriggerServerEvent(Config.ResourceName..':server:ReturnBus', vehicleNetId)
    
    Utils.DebugPrint("Returning bus to depot", "CLIENT")
    
    return true
end

-- Get current bus entity
function Vehicle.GetCurrentBus()
    if currentBus and DoesEntityExist(currentBus) then
        return currentBus
    end
    
    return nil
end

-- Set current bus entity
function Vehicle.SetCurrentBus(busEntity)
    currentBus = busEntity
    return currentBus
end

-- Clear current bus reference
function Vehicle.ClearCurrentBus()
    currentBus = nil
end

-- Check if player is in the current bus
function Vehicle.IsPlayerInBus()
    if not currentBus or not DoesEntityExist(currentBus) then
        return false
    end
    
    return IsPedInVehicle(PlayerPedId(), currentBus, false)
end

-- Spawn bus locally after server authorization
function Vehicle.SpawnBus(routeName, spawnPointIndex)
    Utils.DebugPrint("Spawning bus for route: " .. routeName, "CLIENT")
    
    -- Get spawn point
    local spawnPoint = Config.busSpawnPoints[spawnPointIndex] or Utils.FindValidSpawnPoint()
    
    -- Get bus model
    local modelHash = Utils.DefaultConfig('BusModel', `bus`)
    
    -- Request model
    if not Utils.RequestModel(modelHash, 5000) then
        Notify.Error('Failed to load bus model. Please try again.')
        return nil
    end
    
    -- Create vehicle
    local bus = CreateVehicle(modelHash, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w, true, false)
    
    if not DoesEntityExist(bus) then
        Notify.Error('Failed to spawn bus. Please try again.')
        return nil
    end
    
    -- Set vehicle properties
    SetVehicleOnGroundProperly(bus)
    SetEntityAsMissionEntity(bus, true, true)
    SetVehicleNumberPlateText(bus, Utils.GenerateRandomPlate())
    SetVehicleDirtLevel(bus, 0.0)
    SetVehicleEngineOn(bus, true, true, false)
    
    -- Teleport player into vehicle
    TaskWarpPedIntoVehicle(PlayerPedId(), bus, -1)
    
    -- Set as current bus
    currentBus = bus
    
    -- Register with server
    local vehicleNetId = NetworkGetNetworkIdFromEntity(bus)
    local plate = GetVehicleNumberPlateText(bus)
    
    TriggerServerEvent(Config.ResourceName..':server:RegisterClientVehicle', vehicleNetId, plate, routeName)
    
    -- Free model memory
    SetModelAsNoLongerNeeded(modelHash)
    
    return bus
end

-- Request vehicle keys from server
function Vehicle.RequestKeys(vehicleNetId, plate)
    TriggerServerEvent(Config.ResourceName..':requestkeys', 
        GetPlayerServerId(PlayerId()), 
        vehicleNetId,
        plate
    )
end

-- Process a bus stop
function Vehicle.ProcessBusStop(routeName, stopIndex, stopCoords)
    if not currentBus or not DoesEntityExist(currentBus) then
        Utils.DebugPrint("Cannot process stop: No bus found", "CLIENT")
        return false
    end
    
    if not routeName or not stopIndex or not stopCoords then
        Utils.DebugPrint("Cannot process stop: Missing parameters", "CLIENT")
        return false
    end
    
    -- Get vehicle coordinates
    local vehCoords = GetEntityCoords(currentBus)
    
    -- Check distance
    if #(vehCoords - stopCoords) > 10.0 then
        Utils.DebugPrint("Cannot process stop: Too far from stop", "CLIENT")
        return false
    end
    
    -- Freeze bus temporarily
    Vehicle.FreezeTemporarily(currentBus, Utils.DefaultConfig('FreezeBus', 5000))
    
    -- Send stop processing event to server
    TriggerServerEvent(Config.ResourceName..':server:ProcessBusStop', 
        routeName,
        stopIndex,
        vehCoords,
        NetworkGetNetworkIdFromEntity(currentBus)
    )
    
    Utils.DebugPrint("Processing bus stop " .. stopIndex .. " for route " .. routeName, "CLIENT")
    
    return true
end

-- Sync bus position with server
function Vehicle.SyncPosition(routeName, stopIndex)
    if not currentBus or not DoesEntityExist(currentBus) then
        return
    end
    
    -- Only sync if player is in the bus
    if not IsPedInVehicle(PlayerPedId(), currentBus, false) then
        return
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehCoords = GetEntityCoords(currentBus)
    
    TriggerServerEvent(Config.ResourceName..':server:SyncPosition', 
        playerCoords,
        vehCoords,
        NetworkGetNetworkIdFromEntity(currentBus),
        routeName,
        stopIndex
    )
end

return Vehicle