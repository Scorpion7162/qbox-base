local State = {}

--   routeName = string,      -- Name of the active route
--   stopIndex = number,      -- Current stop index
--   vehicleNetId = number,   -- NetworkID of the bus
--   startTime = number,      -- When the route started (os.time())
--   lastStopTime = number,   -- When the last stop was processed
--   passengers = number,     -- Current passenger count
--   totalEarned = number,    -- Total money earned on this route
--   isCompleted = boolean    -- Whether the route is completed

-- Default state values
local DEFAULT_STATE = {
    routeName = nil,
    stopIndex = 1,
    vehicleNetId = nil,
    startTime = nil,
    lastStopTime = nil,
    passengers = 0,
    totalEarned = 0,
    isCompleted = false
}

-- Initialize route state
function State.InitRouteState(routeName, vehicleNetId)
    return {
        routeName = routeName,
        stopIndex = 1, 
        vehicleNetId = vehicleNetId,
        startTime = GetGameTimer() / 1000,
        lastStopTime = nil,
        passengers = 0,
        totalEarned = 0,
        isCompleted = false
    }
end

-- Get the total number of stops for a route
function State.GetTotalStops(routeName)
    for _, route in ipairs(Config.busRoutes) do
        if route.name == routeName then
            return #route.stops
        end
    end
    return 0
end

-- Check if the route is completed
function State.IsRouteCompleted(routeState)
    if not routeState or not routeState.routeName then return false end
    
    local totalStops = State.GetTotalStops(routeState.routeName)
    return routeState.stopIndex > totalStops
end

-- Advance to the next stop
function State.AdvanceToNextStop(routeState, payment, passengers)
    if not routeState then return nil end
    
    local totalStops = State.GetTotalStops(routeState.routeName)
    
    -- Update state
    routeState.lastStopTime = GetGameTimer() / 100
    routeState.stopIndex = routeState.stopIndex + 1
    routeState.passengers = passengers or 0
    routeState.totalEarned = (routeState.totalEarned or 0) + (payment or 0)
    
    -- Check if route is completed
    if routeState.stopIndex > totalStops then
        routeState.isCompleted = true
    end
    
    return routeState
end

-- Reset the route state
function State.ResetRouteState()
    return table.clone(DEFAULT_STATE)
end

-- Get the current stop coordinates
function State.GetCurrentStopCoords(routeState)
    if not routeState or not routeState.routeName then return nil end
    
    for _, route in ipairs(Config.busRoutes) do
        if route.name == routeState.routeName then
            if route.stops[routeState.stopIndex] then
                return route.stops[routeState.stopIndex]
            end
            return nil
        end
    end
    
    return nil
end

-- Validate a route exists
function State.ValidateRoute(routeName)
    for _, route in ipairs(Config.busRoutes) do
        if route.name == routeName then
            return route
        end
    end
    
    return nil
end

-- Check if the coordinates are near a bus stop
function State.IsNearBusStop(coords, routeName, stopIndex)
    local route = State.ValidateRoute(routeName)
    if not route or not route.stops or not route.stops[stopIndex] then
        return false
    end
    
    local stopCoords = route.stops[stopIndex]
    local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(stopCoords.x, stopCoords.y, stopCoords.z))
    
    return distance <= 15.0 
end

-- Calculate payment for a stop based on the route and passengers
function State.CalculateStopPayment(routeName, stopIndex, passengers)
    local route = State.ValidateRoute(routeName)
    if not route then return 0 end
    
    -- Calculate base stop payment
    local totalStops = #route.stops
    local basePayment = math.floor(route.payment / totalStops) 
    
    -- Adjust for passenger count
    local maxPassengers = Config.maxPassengers or 5
    local passengerMultiplier = passengers / maxPassengers
    local payment = math.floor(basePayment * passengerMultiplier)
    
    -- Cap payment to prevent exploits
    local maxPaymentPerStop = Config.MaxPaymentPerStop or 500
    if payment > maxPaymentPerStop then
        payment = maxPaymentPerStop
    end
    
    return payment
end

-- Get the route bonus
function State.GetRouteCompletionBonus(routeName)
    local route = State.ValidateRoute(routeName)
    if not route then return 0 end
    
    return Config.RouteCompletionBonus or 0
end

return State