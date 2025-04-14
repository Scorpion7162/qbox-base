local QBCore = exports['qb-core']:GetCoreObject()
local ShowNumbers = true

CreateThread(function()
    while true do
        local Players = QBCore.Functions.GetQBPlayers()
        
        local AmbulanceConnected = 0
        local PoliceConnected = 0
        local BurgerShotConnected = 0
        local UnicornConnected = 0
        local GangsConnected = 0
        local MechanicConnected = 0
        local LawyerConnected = 0
        
        for _, Player in pairs(Players) do
            local citizenid = Player.PlayerData.citizenid
            local job = Player.PlayerData.job.name
            
            if job == 'ambulance' then
                AmbulanceConnected = AmbulanceConnected + 1
            end
            
            if job == 'police' then
                PoliceConnected = PoliceConnected + 1
            end
            
            if job == 'burgershot' then
                BurgerShotConnected = BurgerShotConnected + 1
            end
            
            if job == 'mechanic' then
                MechanicConnected = MechanicConnected + 1
            end
        end
        
        TriggerClientEvent('updateNumbers', -1, AmbulanceConnected, PoliceConnected, MechanicConnected, BurgerShotConnected)
        
        Wait(1000) -- Update Rate (1 second)
    end
end)