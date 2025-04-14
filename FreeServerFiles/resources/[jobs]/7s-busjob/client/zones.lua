-- Zone manager for bus stops and spawn points
local Utils = require('shared/utils')
local Notify = require('client/notifications')
local Vehicle = require('client/vehicle')
local State = require('shared/state')

local Zones = {}
local busStopZones = {}
local spawnPointZones = {}

-- Clean up bus stop zones
function Zones.CleanupBusStopZones()
    if busStopZones and #busStopZones > 0 then
        for _, zone in ipairs(busStopZones) do
            zone:remove()
        end
        busStopZones = {}
    end
end

-- Clean up spawn point zones
function Zones.CleanupSpawnPointZones()
    if spawnPointZones and #spawnPointZones > 0 then
        for _, zone in ipairs(spawnPointZones) do
            zone:remove()
        end
        spawnPointZones = {}
    end
end

-- Clean up all zones
function Zones.CleanupAll()
    Zones.CleanupBusStopZones()
    Zones.CleanupSpawnPointZones()
    Notify.HideTextUI()
end

-- Create zones for bus stops based on route
function Zones.CreateBusStopZones(route, routeState)
    if not route or not route.stops or #route.stops < 1 then
        Utils.DebugPrint("Cannot create bus stop zones: Invalid route", "CLIENT")
        return false
    end
    
    -- Clean up any existing zones first
    Zones.CleanupBusStopZones()
    
    busStopZones = {}
    
    for i, coords in ipairs(route.stops) do
        local zone = lib.zones.sphere({
            coords = coords,
            radius = Utils.DefaultConfig('DistanceNotif', 15.0),
            debug = Utils.DefaultConfig('Debug', false),
            onEnter = function()
                local currentStopIndex = routeState and routeState.stopIndex or 1
                if Vehicle.IsPlayerInBus() and currentStopIndex == i then
                    if GetEntitySpeed(Vehicle.GetCurrentBus()) > 1.0 then
                        Notify.ShowTextUI('Slow down to service stop')
                    else
                        Notify.ShowTextUI('[E] - Pickup Passengers')
                    end
                end
            end,
            onExit = function()
                Notify.HideTextUI()
            end,
            inside = function(self)
                local currentStopIndex = routeState and routeState.stopIndex or 1
                
                if Vehicle.IsPlayerInBus() and currentStopIndex == i then
                    -- Update UI based on speed when inside zone
                    if GetEntitySpeed(Vehicle.GetCurrentBus()) > 1.0 then
                        Notify.ShowTextUI('Slow down to service stop')
                    else
                        Notify.ShowTextUI('[E] - Pickup Passengers')
                        
                        -- Check for E press
                        if IsControlJustPressed(0, 38) then
                            Vehicle.ProcessBusStop(route.name, currentStopIndex, coords)
                        end
                    end
                end
            end
        })
        
        table.insert(busStopZones, zone)
    end
    
    Utils.DebugPrint("Created " .. #busStopZones .. " bus stop zones for route: " .. route.name, "CLIENT")
    
    return true
end

-- Create zones for bus spawn points
function Zones.CreateSpawnPointZones(selectedRoute)
    -- Clean up any existing zones first
    Zones.CleanupSpawnPointZones()
    
    spawnPointZones = {}
    
    for i, spawnPoint in ipairs(Config.busSpawnPoints) do
        local zone = lib.zones.sphere({
            coords = vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z),
            radius = 3.0,
            debug = Utils.DefaultConfig('Debug', false),
            onEnter = function()
                local playerPed = PlayerPedId()
                
                if not IsPedInAnyVehicle(playerPed, false) then
                    if selectedRoute then
                        Notify.ShowTextUI('[E] - Get Bus')
                    else
                        Notify.ShowTextUI('Select a route from the Bus Driver first!')
                    end
                elseif Vehicle.IsPlayerInBus() then
                    Notify.ShowTextUI('[E] - Return Bus')
                end
            end,
            onExit = function()
                Notify.HideTextUI()
            end,
            inside = function(self)
                local playerPed = PlayerPedId()
                
                if not IsPedInAnyVehicle(playerPed, false) then
                    if selectedRoute then
                        Notify.ShowTextUI('[E] - Get Bus')
                        
                        if IsControlJustPressed(0, 38) then
                            local success = Vehicle.RequestBusSpawn(selectedRoute.name)
                            if success then
                                Notify.HideTextUI()
                            end
                        end
                    else
                        Notify.ShowTextUI('Select a route from the Bus Driver first!')
                    end
                elseif Vehicle.IsPlayerInBus() then
                    Notify.ShowTextUI('[E] - Return Bus')
                    
                    if IsControlJustPressed(0, 38) then
                        if Vehicle.ReturnBus() then
                            Notify.HideTextUI()
                        end
                    end
                end
            end
        })
        
        table.insert(spawnPointZones, zone)
    end
    
    Utils.DebugPrint("Created " .. #spawnPointZones .. " spawn point zones", "CLIENT")
    
    return true
end

-- Update bus stop zones with the current route state
function Zones.UpdateBusStopZones(route, routeState)
    if not route or not routeState then return end
    
    Zones.CleanupBusStopZones()
    Zones.CreateBusStopZones(route, routeState)
end

return Zones