lib.addCommand('services', {
    description = 'View Services',
}, function()
    lib.showContext('services_menu')
end)

RegisterKeyMapping('services', 'View Services', 'keyboard', 'F9')

RegisterNetEvent('updateNumbers')
AddEventHandler('updateNumbers', function(ambulanceCount, policeCount, mechanicCount, burgershotCount)
    local policeState = nil
    local ambulanceState = nil
    local mechanicState = nil
    local burgershotState = nil
    
    if policeCount > 0 then
        policeState = 'Active'
        policeON = false
    else
        policeState = 'Inactive'
        policeON = true
    end
    
    if ambulanceCount > 0 then
        ambulanceState = 'Active'
        ambulanceON = false
    else
        ambulanceState = 'Inactive'
        ambulanceON = true
    end
    
    if mechanicCount > 0 then
        mechanicState = 'Active'
        mechanicON = false
    else
        mechanicState = 'Inactive'
        mechanicON = true
    end
    
    if burgershotCount > 0 then
        burgershotState = 'Active'
        burgershotON = false
    else
        burgershotState = 'Inactive'
        burgershotON = true
    end
    
    lib.registerContext({
        id = 'services_menu',
        title = 'Server Information',
        options = {
            {
                title = 'Players Online',
                description = 'Total: ' .. GetNumberOfPlayers() .. '/64',
                readOnly = true,
                icon = 'user',
                iconColor = '#FF8C00',
            },
            {
                title = 'Police Department',
                description = 'Status: ' .. tostring(policeState) .. ' | Officers: ' .. policeCount .. '/64',
                readOnly = true,
                icon = 'shield-halved',
                iconColor = '#FF8C00',
                disabled = policeON,
            },
            {
                title = 'Emergency Medical Services',
                description = 'Status: ' .. tostring(ambulanceState) .. ' | Medics: ' .. ambulanceCount .. '/64',
                readOnly = true,
                icon = 'truck-medical',
                iconColor = '#FF8C00',
                disabled = ambulanceON,
            },
            {
                title = 'Mechanic Shop',
                description = 'Status: ' .. tostring(mechanicState) .. ' | Mechanics: ' .. mechanicCount .. '/64',
                readOnly = true,
                icon = 'wrench',
                iconColor = '#FF8C00',
                disabled = mechanicON,
            },
            {
                title = 'BurgerShot',
                description = 'Status: ' .. tostring(burgershotState) .. ' | Employees: ' .. burgershotCount .. '/64',
                readOnly = true,
                icon = 'burger',
                iconColor = '#FF8C00',
                disabled = burgershotON,
            },
        }
    })
end)