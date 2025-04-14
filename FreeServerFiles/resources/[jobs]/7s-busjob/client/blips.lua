-- Blips manager for bus job
local Utils = require('shared/utils')

local Blips = {}
local busBlip = nil
local routeBlips = {}

-- Create a blip for the bus depot
function Blips.CreateBusBlip(coords)
    if busBlip then
        RemoveBlip(busBlip)
    end
    
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, Utils.DefaultConfig('MapBlip.sprite', 513))
    SetBlipDisplay(blip, Utils.DefaultConfig('MapBlip.display', 4))
    SetBlipScale(blip, Utils.DefaultConfig('MapBlip.scale', 0.8))
    SetBlipColour(blip, Utils.DefaultConfig('MapBlip.color', 5))
    SetBlipAsShortRange(blip, Utils.DefaultConfig('MapBlip.shortrange', true))
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Utils.DefaultConfig('MapBlip.name', 'Bus Job'))
    EndTextCommandSetBlipName(blip)
    
    busBlip = blip
    
    return blip
end

-- Clean up route blips
function Blips.CleanupRouteBlips()
    for _, blip in pairs(routeBlips) do
        RemoveBlip(blip)
    end
    routeBlips = {}
end

-- Clean up all blips
function Blips.CleanupAll()
    if busBlip then
        RemoveBlip(busBlip)
        busBlip = nil
    end
    
    Blips.CleanupRouteBlips()
end

-- Create blips for bus route
function Blips.CreateRouteBlips(route, currentStopIndex)
    Blips.CleanupRouteBlips()
    
    if not route or not route.stops then
        Utils.DebugPrint("Cannot create route blips: Invalid route", "CLIENT")
        return
    end
    
    for i, coords in ipairs(route.stops) do
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        
        if i == currentStopIndex then
            SetBlipColour(blip, 2)  -- Green for current stop
            SetBlipRoute(blip, true)
        else
            SetBlipColour(blip, 3)  -- Yellow for future stops
        end
        
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Bus Stop ' .. i)
        EndTextCommandSetBlipName(blip)
        
        table.insert(routeBlips, blip)
    end
    
    Utils.DebugPrint("Created " .. #routeBlips .. " route blips for route: " .. route.name, "CLIENT")
end

-- Update route blips based on current stop
function Blips.UpdateRouteBlips(route, oldStopIndex, newStopIndex)
    if not route or not route.stops then return end
    
    -- If we have a previous stop, mark it as completed
    if oldStopIndex > 0 and oldStopIndex <= #routeBlips then
        SetBlipColour(routeBlips[oldStopIndex], 1)  -- White for completed stops
        SetBlipRoute(routeBlips[oldStopIndex], false)
    end
    
    -- If we have a current stop, mark it as active
    if newStopIndex > 0 and newStopIndex <= #routeBlips then
        SetBlipColour(routeBlips[newStopIndex], 2)  -- Green for current stop
        SetBlipRoute(routeBlips[newStopIndex], true)
    end
end

return Blips