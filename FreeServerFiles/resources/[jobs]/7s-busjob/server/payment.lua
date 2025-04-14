-- Payment module to handle different payment methods
local Utils = require('shared/utils')
local Payment = {}

-- Get the player from the source based on framework
local function GetPlayer(src)
    if Config.Framework == 'ESX' then
        return ESX.GetPlayerFromId(src)
    elseif Config.Framework == 'QBox' then
        return exports.qbx_core:GetPlayer(src)
    end
    return nil
end

-- Pay player in cash
function Payment.PayCash(src, amount)
    if not src or not amount or amount <= 0 then return false end
    
    Utils.DebugPrint("Paying " .. src .. " $" .. amount .. " in cash", "SERVER")
    
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addMoney(amount)
            return true
        end
    elseif Config.Framework == 'QBox' then
        return exports.qbx_core:AddMoney(src, 'cash', amount, Utils.DefaultConfig('PaymentReason', 'Bus Job Payment'))
    end
    
    return false
end

-- Pay player to bank account
function Payment.PayBank(src, amount)
    if not src or not amount or amount <= 0 then return false end
    
    Utils.DebugPrint("Paying " .. src .. " $" .. amount .. " to bank", "SERVER")
    
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addAccountMoney('bank', amount)
            return true
        end
    elseif Config.Framework == 'QBox' then
        return exports.qbx_core:AddMoney(src, 'bank', amount, Utils.DefaultConfig('PaymentReason', 'Bus Job Payment'))
    end
    
    return false
end

-- Pay player in dirty money (if enabled)
function Payment.PayDirtyMoney(src, amount)
    if not src or not amount or amount <= 0 then return false end
    
    -- Check if dirty money payments are enabled
    if not Utils.DefaultConfig('PayInDirtyMoney', false) then
        Utils.DebugPrint("Dirty money payments are disabled", "SERVER")
        return false
    end
    
    Utils.DebugPrint("Paying " .. src .. " $" .. amount .. " in dirty money", "SERVER")
    
    local itemName = Utils.DefaultConfig('DirtyMoneyItemName', 'black_money')
    
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(itemName, amount)
            return true
        end
    elseif Config.Framework == 'QBox' then
        if exports.ox_inventory and type(exports.ox_inventory.CanCarryItem) == 'function' then
            if exports.ox_inventory:CanCarryItem(src, itemName, amount) then
                exports.ox_inventory:AddItem(src, itemName, amount)
                return true
            else
                Utils.DebugPrint("Player cannot carry dirty money item", "SERVER")
            end
        else
            Utils.DebugPrint("ox_inventory not available", "SERVER")
        end
    end
    
    return false
end

-- Add money to player based on config settings
function Payment.AddPlayerMoney(src, amount)
    if not src or not amount or amount <= 0 then return false end
    
    -- Get payment type from config
    local paymentType = Utils.DefaultConfig('PaymentType', 'cash')
    
    if paymentType == 'cash' then
        return Payment.PayCash(src, amount)
    elseif paymentType == 'bank' then
        return Payment.PayBank(src, amount)
    elseif paymentType == 'DirtyMoney' then
        return Payment.PayDirtyMoney(src, amount)
    else
        -- Default to cash if invalid payment type
        Utils.DebugPrint("Invalid payment type: " .. paymentType .. ". Defaulting to cash.", "SERVER")
        return Payment.PayCash(src, amount)
    end
end

-- Process a bus stop payment with passenger calculation
function Payment.ProcessStopPayment(src, routeName, stopIndex)
    -- Generate random number of passengers
    local maxPassengers = Utils.DefaultConfig('maxPassengers', 5)
    local passengers = math.random(1, maxPassengers)
    
    -- Get the route
    local route = nil
    for _, r in ipairs(Config.busRoutes) do
        if r.name == routeName then
            route = r
            break
        end
    end
    
    if not route then
        Utils.DebugPrint("Invalid route for payment: " .. tostring(routeName), "SERVER")
        return false, 0, 0
    end
    
    -- Calculate payment for this stop
    local totalStops = #route.stops
    local basePayment = math.floor(route.payment / totalStops)
    local passengerMultiplier = passengers / maxPassengers
    local payment = math.floor(basePayment * passengerMultiplier)
    
    -- Cap payment to prevent exploits
    local maxPaymentPerStop = Utils.DefaultConfig('MaxPaymentPerStop', 500)
    if payment > maxPaymentPerStop then
        payment = maxPaymentPerStop
    end
    
    -- Process the payment
    local success = Payment.AddPlayerMoney(src, payment)
    
    return success, payment, passengers
end

-- Process route completion bonus
function Payment.ProcessRouteCompletionBonus(src)
    local bonusAmount = Utils.DefaultConfig('RouteCompletionBonus', 0)
    
    if bonusAmount <= 0 then
        return true, 0
    end
    
    local success = Payment.AddPlayerMoney(src, bonusAmount)
    
    return success, bonusAmount
end

return Payment