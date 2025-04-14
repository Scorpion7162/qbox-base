-- Menu manager for bus job
local Utils = require('shared/utils')
local Notify = require('client/notifications')
local Vehicle = require('client/vehicle')
local State = require('shared/state')

local Menu = {}
local selectedRoute = nil
local currentRouteState = nil

-- Set the currently selected route
function Menu.SetSelectedRoute(route)
    selectedRoute = route
    return route
end

-- Get the currently selected route
function Menu.GetSelectedRoute()
    return selectedRoute
end

-- Set the current route state
function Menu.SetCurrentRouteState(routeState)
    currentRouteState = routeState
    return routeState
end

-- Get the current route state
function Menu.GetCurrentRouteState()
    return currentRouteState
end

-- Reset the menu state
function Menu.Reset()
    selectedRoute = nil
    currentRouteState = nil
end

-- Find a route by name
function Menu.FindRoute(routeName)
    for _, route in ipairs(Config.busRoutes) do
        if route.name == routeName then
            return route
        end
    end
    
    return nil
end

-- Open the route selection menu
function Menu.OpenRouteSelectionMenu()
    local options = {}
    
    -- Add each route as an option
    for i, route in ipairs(Config.busRoutes) do
        table.insert(options, {
            title = route.name,
            description = 'Payment: $' .. route.payment .. ' | Stops: ' .. #route.stops,
            icon = 'fas fa-map-marker-alt',
            onSelect = function()
                -- If player is already on a route, don't allow changing
                if currentRouteState and currentRouteState.routeName then
                    Notify.Error('You are already on a route! Complete it or return the bus first.')
                    return
                end
                
                -- If player already has a bus, request to start the route through server
                if Vehicle.GetCurrentBus() then
                    TriggerServerEvent(Config.ResourceName..':server:StartRoute', 
                        route.name, 
                        NetworkGetNetworkIdFromEntity(Vehicle.GetCurrentBus())
                    )
                else
                    -- Just save the selected route for when they get a bus
                    selectedRoute = route
                    Notify.Success('Route selected: ' .. route.name .. '. Now get a bus to start!')
                end
                
                -- Close the menu
                Menu.OpenBusDriverMenu()
            end
        })
    end
    
    -- Add back option
    table.insert(options, {
        title = 'Back',
        icon = 'fas fa-arrow-left',
        onSelect = function()
            Menu.OpenBusDriverMenu()
        end
    })
    
    lib.registerContext({
        id = 'route_selection_menu',
        title = 'Select a Route',
        menu = 'bus_driver_menu',
        options = options
    })
    
    lib.showContext('route_selection_menu')
end

-- Open the bus driver menu
function Menu.OpenBusDriverMenu()
    local options = {
        {
            title = 'Bus Routes',
            description = 'Select a route to drive',
            icon = 'fas fa-route',
            arrow = true,
            onSelect = function()
                Menu.OpenRouteSelectionMenu()
            end
        },
        {
            title = 'Get Bus',
            description = 'Request a bus vehicle',
            icon = 'fas fa-bus',
            disabled = not selectedRoute and not currentRouteState,
            onSelect = function()
                -- Check if player already has a bus
                if Vehicle.GetCurrentBus() then
                    Notify.Error('You already have a bus!')
                    return
                end
                
                -- Check if a route has been selected
                if not selectedRoute and not currentRouteState then
                    Notify.Error('You need to select a route first!')
                    return
                end
                
                -- Request bus from server
                Vehicle.RequestBusSpawn(selectedRoute.name)
            end
        },
        {
            title = 'Return Bus',
            description = 'Return your current bus',
            icon = 'fas fa-parking',
            disabled = not Vehicle.GetCurrentBus(),
            onSelect = function()
                if not Vehicle.GetCurrentBus() then
                    Notify.Error('You don\'t have a bus to return!')
                    return
                end
                
                Vehicle.ReturnBus()
            end
        },
        {
            title = 'Current Route Status',
            description = selectedRoute and ('Selected: ' .. selectedRoute.name) or 
                        (currentRouteState and ('Active: ' .. currentRouteState.routeName .. 
                         ' - Stop ' .. currentRouteState.stopIndex .. '/' .. 
                         State.GetTotalStops(currentRouteState.routeName)) or 'No route selected'),
            icon = 'fas fa-info-circle',
            disabled = not (selectedRoute or currentRouteState),
            onSelect = function()
                if currentRouteState and currentRouteState.routeName then
                    local totalStops = State.GetTotalStops(currentRouteState.routeName)
                    Notify.Info('Active route: ' .. currentRouteState.routeName .. 
                               ' - Stop ' .. currentRouteState.stopIndex .. '/' .. totalStops)
                elseif selectedRoute then
                    Notify.Info('Selected route: ' .. selectedRoute.name .. ' - Ready to start')
                else
                    Notify.Info('No route selected.')
                end
            end
        },
        {
            title = 'Exit',
            icon = 'fas fa-xmark',
            onSelect = function()
                -- Just close the menu
            end
        }
    }
    
    lib.registerContext({
        id = 'bus_driver_menu',
        title = 'Bus Driver',
        options = options
    })
    
    lib.showContext('bus_driver_menu')
end

return Menu