local Utils = require('shared/utils')
local Notify = {}
function Notify.Show(message, type, title)
    if not message then return end
    
    local notificationTitle = title or 'Bus Job'
    local notificationDuration = Utils.DefaultConfig('NotificationDuration', 5000)
    local iconAnimation = nil
    local icon = 'fas fa-bus'
    
    if type == 'error' then
        icon = Utils.DefaultConfig('WarnIcon', 'fa-solid fa-triangle-exclamation')
    elseif type == 'success' then
        icon = Utils.DefaultConfig('SuccessIcon', 'fa-solid fa-circle-check')
        iconAnimation = Utils.DefaultConfig('IconAnim', 'pulse')
    end
    
    lib.notify({
        title = notificationTitle,
        description = message,
        type = type or 'inform',
        duration = notificationDuration,
        icon = icon,
        iconAnimation = iconAnimation
    })
end

-- Show text UI with ox_lib
function Notify.ShowTextUI(message)
    if not message then return end
    
    lib.showTextUI(message)
end

-- Hide text UI with ox_lib
function Notify.HideTextUI()
    lib.hideTextUI()
end

-- Show success notification
function Notify.Success(message, title)
    Notify.Show(message, 'success', title)
end

-- Show error notification
function Notify.Error(message, title)
    Notify.Show(message, 'error', title)
end

-- Show info notification
function Notify.Info(message, title)
    Notify.Show(message, 'inform', title)
end

-- Show warning notification
function Notify.Warning(message, title)
    Notify.Show(message, 'warning', title)
end

return Notify