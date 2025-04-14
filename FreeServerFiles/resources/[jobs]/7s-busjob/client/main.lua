-- [ LOCALS] -- 
local Utils = require('shared/utils')
local State = require('shared/state')
local Notify = require('client/notifications')
local Vehicle = require('client/vehicle')
local Zones = require('client/zones')
local Blips = require('client/blips')
local Peds = require('client/peds')
local Menu = require('client/menu')
local ESX = nil
local QBX = exports.qbx_core
local PlayerData = {}
local isLoggedIn = false
local routeState = nil
local serverSyncTimer = 0
local processingStop = false
local lastProcessedStop = 0

-- FUNCTIONS 
local function HasJobAccess()
    if not Utils.DefaultConfig('IsJobNeeded', false) then
        return true
    end
    
    if Config.Framework == 'ESX' then
        return PlayerData.job and PlayerData.job.name == Config.JobName
    else
        local QBXPlayerData = QBX.GetPlayerData and QBX:GetPlayerData() or {}
        return QBXPlayerData.job and QBXPlayerData.job.name == Config.JobName
    end
end

-- Initialize job resources
local function InitializeJobResources()
    if not HasJobAccess() then return end
    
    -- Create bus depot blip
    if Config.busSpawnPoints and #Config.busSpawnPoints > 0 then
        Blips.CreateBusBlip(Config.busSpawnPoints[1])
    end
    
    -- Create bus driver ped
    local ped = Peds.CreateBusDriverPed()
    if ped and DoesEntityExist(ped) then
        Peds.InitTarget(ped, function()
            if HasJobAccess() then
                Menu.OpenBusDriverMenu()
            else
                Notify.Error('You don\'t have permission to use the bus job.')
            end
        end)
    end
    
    -- Create zones for spawn points
    Zones.CreateSpawnPointZones(Menu.GetSelectedRoute())
    
    Utils.DebugPrint('Job resources initialized', 'CLIENT')
end

-- Clean up job resources
local function CleanupJobResources()
    Blips.CleanupAll()
    Peds.CleanupBusDriverPed()
    Zones.CleanupAll()
    
    if Vehicle.GetCurrentBus() and DoesEntityExist(Vehicle.GetCurrentBus()) then
        TriggerServerEvent(Config.ResourceName..':server:ReturnBus', 
            NetworkGetNetworkIdFromEntity(Vehicle.GetCurrentBus())
        )
    end
    
    Vehicle.ClearCurrentBus()
    Menu.Reset()
    routeState = nil
    
    Utils.DebugPrint('Job resources cleaned up', 'CLIENT')
end
-- Initialize event handlers
local function InitializeEventHandlers()
    -- Authorization for bus spawn
    RegisterNetEvent(Config.ResourceName..':client:SpawnBusAuthorized')
    AddEventHandler(Config.ResourceName..':client:SpawnBusAuthorized', function(routeName, spawnPointIndex)
        Utils.DebugPrint('Received spawn authorization for route: ' .. routeName, 'CLIENT')
        
        local bus = Vehicle.SpawnBus(routeName, spawnPointIndex)
        if not bus then return end
        
        local route = Menu.FindRoute(routeName)
        if not route then
            Notify.Error('Failed to find route: ' .. routeName)
            return
        end
        
        -- Initialize route state
        routeState = State.InitRouteState(
            routeName, 
            NetworkGetNetworkIdFromEntity(bus)
        )
        
        Menu.SetCurrentRouteState(routeState)
        Menu.SetSelectedRoute(nil)
        
        -- Create route blips and zones
        Blips.CreateRouteBlips(route, routeState.stopIndex)
        Zones.CreateBusStopZones(route, routeState)
        
        Notify.Success('Route started: ' .. routeName)
        
        -- Request vehicle keys
        Vehicle.RequestKeys(
            NetworkGetNetworkIdFromEntity(bus),
            GetVehicleNumberPlateText(bus)
        )
    end)
    
    -- Handle successful stop processing
    RegisterNetEvent(Config.ResourceName..':client:StopProcessed')
    AddEventHandler(Config.ResourceName..':client:StopProcessed', function(payment, passengers, isLastStop)
        processingStop = false
        
        -- Hide the TextUI
        Notify.HideTextUI()
        
        -- Update route state
        local oldStopIndex = routeState.stopIndex
        routeState = State.AdvanceToNextStop(routeState, payment, passengers)
        
        -- Display notification
        Notify.Success('Picked up ' .. passengers .. ' passengers. Earned $' .. payment)
        
        -- Update blips
        local route = Menu.FindRoute(routeState.routeName)
        if route then
            Blips.UpdateRouteBlips(route, oldStopIndex, routeState.stopIndex)
        end
        
        -- Update menu state
        Menu.SetCurrentRouteState(routeState)
        
        -- Handle route completion
        if isLastStop then
            Notify.Success('Route completed! Return to the depot for a new route.')
            
            -- Clean up route resources
            Blips.CleanupRouteBlips()
            Zones.CleanupBusStopZones()
            
            -- Reset route state
            routeState = nil
            Menu.SetCurrentRouteState(nil)
        else
            Notify.Info('Proceed to the next stop!')
            
            -- Update zones for the new stop
            if route then
                Zones.UpdateBusStopZones(route, routeState)
            end
        end
    end)
    
    -- Bus spawn denial
    RegisterNetEvent(Config.ResourceName..':client:BusSpawnDenied')
    AddEventHandler(Config.ResourceName..':client:BusSpawnDenied', function(reason)
        Notify.Error('Bus spawn denied: ' .. reason)
    end)
    
    -- Bus return confirmation
    RegisterNetEvent(Config.ResourceName..':client:BusReturned')
    AddEventHandler(Config.ResourceName..':client:BusReturned', function()
        -- Clean up resources
        Vehicle.ClearCurrentBus()
        routeState = nil
        Menu.SetCurrentRouteState(nil)
        
        Blips.CleanupRouteBlips()
        Zones.CleanupBusStopZones()
        
        Notify.Success('Bus returned to the depot.')
    end)
    
    -- Start route confirmation
    RegisterNetEvent(Config.ResourceName..':client:StartRoute')
    AddEventHandler(Config.ResourceName..':client:StartRoute', function(routeName)
        local route = Menu.FindRoute(routeName)
        if not route then
            Notify.Error('Invalid route selected: ' .. routeName)
            return
        end
        
        -- Initialize route state
        routeState = State.InitRouteState(
            routeName, 
            NetworkGetNetworkIdFromEntity(Vehicle.GetCurrentBus())
        )
        
        Menu.SetCurrentRouteState(routeState)
        Menu.SetSelectedRoute(nil)
        
        -- Create route blips and zones
        Blips.CreateRouteBlips(route, routeState.stopIndex)
        Zones.CreateBusStopZones(route, routeState)
        
        Notify.Success('Route started: ' .. routeName)
    end)
    
    -- Debug command responses
    RegisterNetEvent(Config.ResourceName..':client:DebugCmdResponse')
    AddEventHandler(Config.ResourceName..':client:DebugCmdResponse', function(cmd)
        if cmd == 'spawnbusped' then
            -- Re-create the bus driver ped
            local ped = Peds.CreateBusDriverPed()
            if ped and DoesEntityExist(ped) then
                Peds.InitTarget(ped, function()
                    if HasJobAccess() then
                        Menu.OpenBusDriverMenu()
                    else
                        Notify.Error('You don\'t have permission to use the bus job.')
                    end
                end)
                Notify.Success('Bus driver ped respawned')
            else
                Notify.Error('Failed to respawn bus driver ped')
            end
        elseif cmd == 'resetbusroute' then
            -- Reset the current route
            if routeState then
                Blips.CleanupRouteBlips()
                Zones.CleanupBusStopZones()
                
                routeState = nil
                Menu.SetCurrentRouteState(nil)
                
                Notify.Success('Bus route reset')
            else
                Notify.Error('No active route to reset')
            end
        end
    end)
end

-- Initialize framework events
local function InitializeFrameworkEvents()
    if Config.Framework == 'ESX' then
        CreateThread(function()
            while ESX == nil do
                ESX = exports['es_extended']:getSharedObject()
                Wait(100)
            end
            
            PlayerData = ESX.GetPlayerData()
            isLoggedIn = true
            
            InitializeJobResources()
        end)
        
        RegisterNetEvent('esx:playerLoaded')
        AddEventHandler('esx:playerLoaded', function(xPlayer)
            PlayerData = xPlayer
            isLoggedIn = true
            
            InitializeJobResources()
        end)
        
        RegisterNetEvent('esx:setJob')
        AddEventHandler('esx:setJob', function(job)
            PlayerData.job = job
            
            if Utils.DefaultConfig('IsJobNeeded', false) then
                if job.name == Config.JobName then
                    InitializeJobResources()
                else
                    CleanupJobResources()
                end
            end
        end)
    elseif Config.Framework == 'QBox' then
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
        AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
            isLoggedIn = true
            
            InitializeJobResources()
        end)
        
        RegisterNetEvent('QBCore:Client:OnJobUpdate')
        AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
            if Utils.DefaultConfig('IsJobNeeded', false) then
                if JobInfo.name == Config.JobName then
                    InitializeJobResources()
                else
                    CleanupJobResources()
                end
            end
        end)
    end
end

local function InitializePositionSync()
    CreateThread(function()
        while true do
            local sleep = 1000
            
            if routeState and Vehicle.GetCurrentBus() then
                serverSyncTimer = serverSyncTimer + 1
                
                -- Sync position with server every 5 seconds for verification
                if serverSyncTimer >= 5 then
                    Vehicle.SyncPosition(routeState.routeName, routeState.stopIndex)
                    serverSyncTimer = 0
                end
                
                sleep = 200 -- More frequent checks when on a route
            end
            
            Wait(sleep)
        end
    end)
end

-- Main initialization function
local function Initialize()
    -- Initialize framework
    if Config.Framework == 'ESX' then
        while ESX == nil do
            ESX = exports['es_extended']:getSharedObject()
            Wait(100)
        end
        
        PlayerData = ESX.GetPlayerData()
    end
    
    isLoggedIn = true
    
    -- Initialize job resources
    InitializeJobResources()
    
    -- Initialize event handlers
    InitializeEventHandlers()
    
    -- Initialize framework events
    InitializeFrameworkEvents()
    
    InitializePositionSync()
    
    Utils.DebugPrint('Bus job initialized successfully', 'CLIENT')
end


-- Register the startbusroute command
RegisterCommand('startbusroute', function()
    local hasPermission = false
    local requiredAcePerms = Config.AcePermissions
    
    if not requiredAcePerms or next(requiredAcePerms) == nil then
        hasPermission = true
    else
        for permission, _ in pairs(requiredAcePerms) do
            if lib.callback.await('ox_lib:checkPlayerAce', false, permission) then
                hasPermission = true
                break
            end
        end
    end
    
    if HasJobAccess() and hasPermission and Vehicle.GetCurrentBus() and not routeState and Menu.GetSelectedRoute() then
        -- Request route start from server
        TriggerServerEvent(Config.ResourceName..':server:StartRoute', 
            Menu.GetSelectedRoute().name, 
            NetworkGetNetworkIdFromEntity(Vehicle.GetCurrentBus())
        )
    else
        local errorMessage = 'You need to be in a bus, have a selected route, and not have an active route.'
        
        if not HasJobAccess() then
            errorMessage = Utils.DefaultConfig('IsJobNeeded', false) and 
             'You need the ' .. Config.JobName .. ' job to use this command.' or
              'You don\'t have access to this command.'
        elseif not hasPermission then
            errorMessage = 'You don\'t have permission to use this command.'
        elseif not Vehicle.GetCurrentBus() then
            errorMessage = 'You need to be in a bus.'
        elseif not Menu.GetSelectedRoute() and not routeState then
            errorMessage = 'You need to select a route first.'
        elseif routeState then
            errorMessage = 'You already have an active route.'
        end
        
        Notify.Error(errorMessage)
    end
end, false)
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    CleanupJobResources()
    Utils.DebugPrint('Resource stopped, resources cleaned up', 'CLIENT')
end)
CreateThread(function()
    Wait(1000)
    Initialize()
    while true do
        Wait(1000)
        if not Vehicle.IsPlayerInBus() or not routeState or State.IsRouteCompleted(routeState) then
            Notify.HideTextUI()
        end
    end
end)