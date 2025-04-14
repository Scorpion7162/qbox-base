Config = {}
-- Debug Mode -- Enable debug mode to see debug messages in the console
Config.Debug = false  -- Enable debug mode (true/false)
Config.ResourceName = GetCurrentResourceName() -- Do Not Mess with this unless you understand what you are doing 
----------------------------------------------------------------------------------
-- FRAMEWORK CONFIGURATION--
Config.Framework = 'QBox'  -- Framework name (options: ESX, QBox)
Config.Vehiclekeys = 'QBox'  -- Vehicle key system (options: QBox, QB, Renewed, Jaksam, Wasabi, MrNewB, custom) - Can be changed in server/main.lua
---------------------------------------------------------------------------------------
--- DISCORD WEBHOOKS FOR LOGGING ----
--- 
--- 
Config.Webhooks = {
    -- Enable or disable webhook logging
    enabled = true,
    
    -- Discord webhook URLs
    jobStarted = '', -- Job Started logs
    routeProgress = '', -- Route Progress logs
    jobFinished = '', -- Job Finished logs
    botName = 'Bus Job Logger',
    includeDiscordMentions = true -- Set to false if you don't want Discord mentions in logs
}
---------------------------------------------------------------------------------------
Config.IsJobNeeded = false -- Is a job needed to use the bus? (true/false)
Config.UseMarkers = false  -- Set to false to disable the red circle markers
Config.PayInDirtyMoney = false -- Pay in dirty money (true/false) -- This HAS to be true with Config.PaymentType -- ONLY FOR QBX_CORE 
Config.DirtyMoneyItemName = 'black_money' -- Item name for dirty money -- ONLY FOR QBX_CORE
Config.PaymentType = 'cash' -- Payment Options - 'cash', 'bank', 'DirtyMoney'
Config.JobName = 'bus' -- Job name for the bus job (only if Config.IsJobNeeded is true)
Config.PaymentReason = 'lorem ipsum or whatever the fuck' -- Fairly self explanitory 
Config.FreezeBus = 5000 -- How long should the bus be frozen for at the stop?
Config.AcePermissions = {
    ['group.god'] = true,
    ['group.admin'] = true, -- Admin group
    ['group.mod'] = true, -- Moderator group
}

-- ox_lib Notifications Configuration
Config.WarnIcon = 'fa-solid fa-triangle-exclamation' -- Fontawesome Icons https://fontawesome.com/search?ic=free
Config.SuccessIcon = 'fa-solid fa-circle-check' -- Fontawesome Icons https://fontawesome.com/search?ic=free
Config.NotificationDuration = 5000 -- Notification duration in milliseconds
Config.IconAnim = 'pulse' -- Options: 'spin', 'spinPulse', 'spinReverse', 'pulse', 'beat', 'fade', 'beatFade', 'bounce', 'shake',
Config.DistanceNotif = 15.0 -- [THIS IS A FLOAT] ------ How far away from the stop should the notification start? 



-- Config for the Bus itself
Config.CustomLicensePlate = 'BUS' -- MAX 4 CHARACTERS (4 Random Numbers at the end, can be changed in client/main.lua)
Config.BusModel = `bus`  -- Vehicle model name
Config.MaxPaymentPerStop = 650  -- Maximum payment per stop (For Security, Set to your highest paying bus route.)
Config.PedModel = `A_M_O_SouCent_02`  -- Ped model name
Config.PedLocation = vector4(454.01, -637.64, 28.5, 255.43)  -- Ped spawn location (x, y, z, heading)


-- Config for the Blip on the map
Config.MapBlip = {
    sprite = 513, -- Blip sprite ID
    display = 513,
    color = 5,  -- Blip color
    scale = 0.8,  -- Blip scale
    name = 'Bus Job',  -- Blip name
    shortrange = true,  -- Is the Blip short range? 
}

Config.busSpawnPoints = {
    vector4(462.22, -641.15, 28.45, 175.0),  -- Example spawn point (x, y, z, heading)
}
Config.busRoutes = {
    {
        name = 'Downtown Route',
        payment = 500,  -- Base payment for completing the route
        stops = {
            vector3(307.95, -765.95, 29.27),
            vector3(115.46, -784.34, 31.29),
            vector3(-82.67, -639.18, 36.23),
            vector3(58.18, -661.74, 31.5),
            vector3(59.95, -995.64, 29.28),
            vector3(356.13, -1064.73, 29.4)
        }
    },
    {
        name = 'Suburban Route',
        payment = 650,
        stops = {
            vector3(812.34, -1200.56, 26.2),
            vector3(950.87, -1350.23, 25.8),
            vector3(1100.45, -1200.67, 23.5),
            vector3(900.23, -1050.78, 24.7),
        }
    }
}
Config.maxPassengers = 5  -- Maximum number of passengers per stop
