local Utils = {}
function Utils.DebugPrint(message, context)
    if not Config.Debug then return end
    
    local prefix = '[BUS JOB'
    if context then
        prefix = prefix .. ' ' .. context
    end
    prefix = prefix .. '] '
    
    print(prefix .. message)
end
function Utils.GetConfigValue(path, default)
    local keys = {}
    for key in string.gmatch(path, "([^.]+)") do
        table.insert(keys, key)
    end
    
    local current = Config
    for i, key in ipairs(keys) do
        if current[key] == nil then
            return default
        end
        current = current[key]
    end
    
    return current
end
function Utils.DoesModelExist(model)
    if type(model) == 'string' then
        model = GetHashKey(model)
    end
    
    return IsModelInCdimage(model)
end
function Utils.GenerateRandomPlate()
    local prefix = Utils.GetConfigValue('CustomLicensePlate', 'BUS')
    if #prefix > 4 then
        prefix = string.sub(prefix, 1, 4)
    end
    
    -- Seed the random number generator
    math.randomseed(GetGameTimer())
    
    -- Generate a 4-digit random number
    local number = math.random(1000, 9999)
    
    return prefix .. tostring(number)
end

-- Request and load a model with timeout
function Utils.RequestModel(model, timeout)
    timeout = timeout or 5000
    local timeoutAt = GetGameTimer() + timeout
    
    if type(model) == 'string' then
        model = GetHashKey(model)
    end
    
    RequestModel(model)
    
    -- Wait for model to load with timeout
    while not HasModelLoaded(model) do
        if GetGameTimer() >= timeoutAt then
            Utils.DebugPrint("Failed to load model in time: " .. tostring(model), "CLIENT")
            return false
        end
        Wait(10)
    end
    
    return true
end

-- Format currency
function Utils.FormatCurrency(amount)
    local formatted = tostring(math.floor(amount))
    local k
    
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    
    return '$' .. formatted
end

-- Check if config exists or return default
function Utils.DefaultConfig(configPath, default)
    -- Split the path by dots
    local parts = {}
    for part in string.gmatch(configPath, "[^%.]+") do
        table.insert(parts, part)
    end
    
    -- Navigate through the config
    local current = Config
    for i, part in ipairs(parts) do
        if current[part] == nil then
            return default
        end
        current = current[part]
    end
    
    return current
end

-- Find an element in a table
function Utils.FindInTable(tbl, predicate)
    for k, v in pairs(tbl) do
        if predicate(v, k) then
            return v, k
        end
    end
    return nil, nil
end

-- Get a valid spawn point that's not occupied
function Utils.FindValidSpawnPoint()
    for _, point in ipairs(Config.busSpawnPoints) do
        local clear = true
        local coords = vector3(point.x, point.y, point.z)
        
        -- Check if there's any vehicle within 3.0 units of the spawn point
        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
            Utils.DebugPrint("Spawn point " .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. " is occupied", "CLIENT")
            clear = false
        end
        
        if clear then
            return point
        end
    end
    
    -- If all spawn points are occupied, use the first one anyway
    return Config.busSpawnPoints[1]
end

return Utils