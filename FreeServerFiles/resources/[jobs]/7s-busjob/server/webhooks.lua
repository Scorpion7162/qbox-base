-- Webhooks module for bus job logging
local Utils = require('shared/utils')

local Webhooks = {}

-- Default webhook URLs (to be set in config)
local webhookURLs = {
    jobStarted = Utils.DefaultConfig('Webhooks.jobStarted', ''),
    routeProgress = Utils.DefaultConfig('Webhooks.routeProgress', ''),
    jobFinished = Utils.DefaultConfig('Webhooks.jobFinished', '')
}

-- Get the player identifiers (discord, fivem, etc)
local function GetPlayerIdentifiers(source)
    local identifiers = {}
    
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        
        if string.find(id, "discord:") then
            identifiers.discord = string.gsub(id, "discord:", "")
        elseif string.find(id, "license:") then
            identifiers.license = string.gsub(id, "license:", "")
        elseif string.find(id, "steam:") then
            identifiers.steam = string.gsub(id, "steam:", "")
        end
    end
    
    return identifiers
end

-- Format the timestamp for logs
local function FormatTimestamp()
    return os.date("%Y-%m-%d %H:%M:%S")
end

-- Calculate time difference in a human-readable format
local function FormatTimeDifference(startTime, endTime)
    if not startTime or not endTime then 
        return "N/A" 
    end
    
    local diffSeconds = endTime - startTime
    
    -- Format as hours:minutes:seconds
    local hours = math.floor(diffSeconds / 3600)
    local minutes = math.floor((diffSeconds % 3600) / 60)
    local seconds = math.floor(diffSeconds % 60)
    
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- Format route completion data for Discord embed
local function FormatRouteData(routeData)
    local fields = {}
    
    -- Add route info
    table.insert(fields, {
        name = "Route Information",
        value = string.format(
            "**Route:** %s\n**Total Stops:** %d\n**Total Passengers:** %d",
            routeData.routeName or "Unknown",
            routeData.totalStops or 0,
            routeData.totalPassengers or 0
        ),
        inline = true
    })
    
    -- Add time info
    table.insert(fields, {
        name = "Time Information",
        value = string.format(
            "**Started:** %s\n**Finished:** %s\n**Duration:** %s",
            routeData.startTimeFormatted or "Unknown",
            routeData.endTimeFormatted or "Unknown",
            routeData.duration or "Unknown"
        ),
        inline = true
    })
    
    -- Add payment info
    table.insert(fields, {
        name = "Payment Information",
        value = string.format(
            "**Total Earned:** $%s\n**Bonus:** $%s\n**Final Payout:** $%s",
            routeData.totalEarned or 0,
            routeData.bonus or 0,
            routeData.finalPayout or 0
        ),
        inline = true
    })
    
    return fields
end

-- Send webhook to Discord
local function SendDiscordWebhook(webhookUrl, title, description, color, fields)
    if not webhookUrl or webhookUrl == '' then
        Utils.DebugPrint("Webhook URL not configured", "SERVER")
        return false
    end
    
    -- Default color (blue)
    color = color or 3447003
    
    -- Create the embed
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "Bus Job Logs | " .. FormatTimestamp()
            }
        }
    }
    
    -- Add fields if provided
    if fields and #fields > 0 then
        embed[1].fields = fields
    end
    
    -- Create the payload
    local payload = {
        username = Utils.DefaultConfig('Webhooks.botName', 'Bus Job Logger'),
        embeds = embed
    }
    
    -- Convert to JSON
    local jsonPayload = json.encode(payload)
    
    -- Send the webhook
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', jsonPayload, { ['Content-Type'] = 'application/json' })
    
    return true
end

-- Log job started
function Webhooks.LogJobStarted(playerId, routeName, vehicleNetId, plate)
    if not webhookURLs.jobStarted or webhookURLs.jobStarted == '' then
        return false
    end
    
    -- Get player information
    local playerName = GetPlayerName(playerId) or "Unknown"
    local identifiers = GetPlayerIdentifiers(playerId)
    local discordId = identifiers.discord or "Unknown"
    local fivemId = identifiers.license or "Unknown"
    
    -- Get vehicle information
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local vehicleModel = vehicle and GetEntityModel(vehicle) or "Unknown"
    local modelName = vehicleModel ~= "Unknown" and GetLabelText(GetDisplayNameFromVehicleModel(vehicleModel)) or "Unknown"
    
    -- Create fields for the embed
    local fields = {
        {
            name = "Player Information",
            value = string.format(
                "**Name:** %s\n**Server ID:** %s\n**Discord ID:** <@%s>\n**FiveM ID:** %s",
                playerName, playerId, discordId, fivemId
            ),
            inline = true
        },
        {
            name = "Route Information",
            value = string.format(
                "**Route:** %s\n**Start Time:** %s",
                routeName, FormatTimestamp()
            ),
            inline = true
        },
        {
            name = "Vehicle Information",
            value = string.format(
                "**Model:** %s\n**Plate:** %s",
                modelName, plate
            ),
            inline = true
        }
    }
    
    -- Send the webhook
    return SendDiscordWebhook(
        webhookURLs.jobStarted,
        "Bus Job Started",
        "A player has started a bus route.",
        3066993, -- Green color
        fields
    )
end

-- Log route progress (stop completed)
function Webhooks.LogStopCompleted(playerId, routeName, stopIndex, totalStops, payment, passengers)
    if not webhookURLs.routeProgress or webhookURLs.routeProgress == '' then
        return false
    end
    
    -- Get player information
    local playerName = GetPlayerName(playerId) or "Unknown"
    
    -- Create fields for the embed
    local fields = {
        {
            name = "Player Information",
            value = string.format(
                "**Name:** %s\n**Server ID:** %s",
                playerName, playerId
            ),
            inline = true
        },
        {
            name = "Stop Information",
            value = string.format(
                "**Route:** %s\n**Stop:** %d/%d\n**Passengers:** %d\n**Payment:** $%d",
                routeName, stopIndex, totalStops, passengers, payment
            ),
            inline = true
        },
        {
            name = "Time Information",
            value = string.format(
                "**Timestamp:** %s",
                FormatTimestamp()
            ),
            inline = true
        }
    }
    
    -- Send the webhook
    return SendDiscordWebhook(
        webhookURLs.routeProgress,
        "Bus Stop Completed",
        string.format("Player completed stop %d/%d on route %s.", stopIndex, totalStops, routeName),
        16776960, -- Yellow color
        fields
    )
end

-- Log job finished (route completed)
function Webhooks.LogJobFinished(playerId, routeData)
    if not webhookURLs.jobFinished or webhookURLs.jobFinished == '' then
        return false
    end
    
    -- Get player information
    local playerName = GetPlayerName(playerId) or "Unknown"
    local identifiers = GetPlayerIdentifiers(playerId)
    local discordId = identifiers.discord or "Unknown"
    
    -- Format route data
    local fields = FormatRouteData(routeData)
    
    -- Add player info
    table.insert(fields, 1, {
        name = "Player Information",
        value = string.format(
            "**Name:** %s\n**Server ID:** %s\n**Discord ID:** <@%s>",
            playerName, playerId, discordId
        ),
        inline = false
    })
    
    -- Send the webhook
    return SendDiscordWebhook(
        webhookURLs.jobFinished,
        "Bus Job Completed",
        string.format("Player completed route %s.", routeData.routeName or "Unknown"),
        10181046, -- Purple color
        fields
    )
end

-- Initialize webhooks
function Webhooks.Initialize()
    -- Load webhook URLs from config
    webhookURLs = {
        jobStarted = Utils.DefaultConfig('Webhooks.jobStarted', ''),
        routeProgress = Utils.DefaultConfig('Webhooks.routeProgress', ''),
        jobFinished = Utils.DefaultConfig('Webhooks.jobFinished', '')
    }
    
    -- Log initialization status
    for name, url in pairs(webhookURLs) do
        if url and url ~= '' then
            Utils.DebugPrint("Webhook for " .. name .. " configured", "SERVER")
        else
            Utils.DebugPrint("Webhook for " .. name .. " not configured", "SERVER")
        end
    end
    
    return true
end

-- Create test logs (for debug purposes)
function Webhooks.SendTestLogs()
    -- Only send test logs if debug is enabled
    if not Utils.DefaultConfig('Debug', false) then
        return false
    end
    
    -- Test job started
    Webhooks.LogJobStarted(1, "Downtown Route", 12345, "BUS1234")
    
    -- Test stop completed
    Webhooks.LogStopCompleted(1, "Downtown Route", 3, 10, 150, 4)
    
    -- Test job finished
    local routeData = {
        routeName = "Downtown Route",
        totalStops = 10,
        totalPassengers = 42,
        startTime = os.time() - 3600, -- 1 hour ago
        endTime = os.time(),
        startTimeFormatted = os.date("%Y-%m-%d %H:%M:%S", os.time() - 3600),
        endTimeFormatted = os.date("%Y-%m-%d %H:%M:%S"),
        duration = "01:00:00",
        totalEarned = 1500,
        bonus = 300,
        finalPayout = 1800
    }
    Webhooks.LogJobFinished(1, routeData)
    
    Utils.DebugPrint("Test webhooks sent", "SERVER")
    return true
end

-- Track route session data (used for complete route stats)
local activeSessions = {}

-- Start tracking a new route session
function Webhooks.StartRouteSession(playerId, routeName, vehicleNetId, plate)
    activeSessions[playerId] = {
        routeName = routeName,
        vehicleNetId = vehicleNetId,
        plate = plate,
        startTime = os.time(),
        startTimeFormatted = FormatTimestamp(),
        totalStops = State.GetTotalStops(routeName),
        stopsCompleted = 0,
        totalPassengers = 0,
        totalEarned = 0,
        stopDetails = {}
    }
    
    -- Log job started
    Webhooks.LogJobStarted(playerId, routeName, vehicleNetId, plate)
    
    return true
end

-- Update session with stop completion
function Webhooks.UpdateRouteSession(playerId, stopIndex, payment, passengers)
    if not activeSessions[playerId] then
        return false
    end
    
    -- Update session data
    activeSessions[playerId].stopsCompleted = activeSessions[playerId].stopsCompleted + 1
    activeSessions[playerId].totalPassengers = activeSessions[playerId].totalPassengers + passengers
    activeSessions[playerId].totalEarned = activeSessions[playerId].totalEarned + payment
    
    -- Add stop details
    table.insert(activeSessions[playerId].stopDetails, {
        stopIndex = stopIndex,
        timestamp = os.time(),
        timestampFormatted = FormatTimestamp(),
        payment = payment,
        passengers = passengers
    })
    
    -- Log stop completed
    Webhooks.LogStopCompleted(
        playerId, 
        activeSessions[playerId].routeName, 
        stopIndex, 
        activeSessions[playerId].totalStops, 
        payment, 
        passengers
    )
    
    return true
end

-- Complete route session and log final stats
function Webhooks.CompleteRouteSession(playerId, bonus)
    if not activeSessions[playerId] then
        return false
    end
    
    -- Update completion data
    local session = activeSessions[playerId]
    session.endTime = os.time()
    session.endTimeFormatted = FormatTimestamp()
    session.duration = FormatTimeDifference(session.startTime, session.endTime)
    session.bonus = bonus or 0
    session.finalPayout = session.totalEarned + (bonus or 0)
    
    -- Log job finished
    Webhooks.LogJobFinished(playerId, session)
    
    -- Clean up
    activeSessions[playerId] = nil
    
    return true
end

-- Clean up sessions on player disconnect
function Webhooks.CleanupPlayerSession(playerId)
    if activeSessions[playerId] then
        activeSessions[playerId] = nil
    end
end

return Webhooks