-- Ped manager for bus job
local Utils = require('shared/utils')
local Notify = require('client/notifications')

local Peds = {}
local busDriverPed = nil

-- Create the bus driver ped
function Peds.CreateBusDriverPed()
    if busDriverPed and DoesEntityExist(busDriverPed) then
        DeleteEntity(busDriverPed)
        busDriverPed = nil
    end
    
    local model = Utils.DefaultConfig('PedModel', `A_M_O_SouCent_02`)
    
    -- Request and load the model with timeout
    if not Utils.RequestModel(model, 5000) then
        Utils.DebugPrint("Failed to load bus driver ped model", "CLIENT")
        return nil
    end
    
    -- Get ped location from config
    local pedLocation = Utils.DefaultConfig('PedLocation', vector4(454.01, -637.64, 28.5, 255.43))
    local x, y, z, w = pedLocation.x, pedLocation.y, pedLocation.z, pedLocation.w
    
    -- Create the ped
    local ped = CreatePed(4, model, x, y, z - 1.0, w, false, true)
    
    if not DoesEntityExist(ped) then
        Utils.DebugPrint("Failed to create bus driver ped", "CLIENT")
        return nil
    end
    
    -- Set ped properties
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    
    -- Free up model memory
    SetModelAsNoLongerNeeded(model)
    
    busDriverPed = ped
    
    Utils.DebugPrint("Bus driver ped created: " .. tostring(ped), "CLIENT")
    
    return ped
end

-- Get the bus driver ped
function Peds.GetBusDriverPed()
    if busDriverPed and DoesEntityExist(busDriverPed) then
        return busDriverPed
    end
    
    return nil
end

-- Clean up the bus driver ped
function Peds.CleanupBusDriverPed()
    if busDriverPed and DoesEntityExist(busDriverPed) then
        DeleteEntity(busDriverPed)
        busDriverPed = nil
        
        Utils.DebugPrint("Bus driver ped cleaned up", "CLIENT")
    end
end

-- Initialize ox_target for the bus driver ped
function Peds.InitTarget(ped, onInteract)
    if not ped or not DoesEntityExist(ped) then
        Utils.DebugPrint("Cannot initialize ox_target: Invalid ped", "CLIENT")
        return false
    end
    
    if not onInteract then
        Utils.DebugPrint("Cannot initialize ox_target: No interaction callback", "CLIENT")
        return false
    end
    
    exports.ox_target:addLocalEntity(ped, {
        {
            name = 'bus_driver',
            icon = 'fa-solid fa-bus',
            label = 'Talk to Bus Driver',
            distance = 2.0,
            onSelect = function()
                onInteract()
            end
        }
    })
    
    Utils.DebugPrint("ox_target initialized for bus driver ped", "CLIENT")
    
    return true
end

return Peds