NCS_REQUISITION.CURRENCIES = {}

function NCS_REQUISITION.RegisterCurrency(NAME)
    NCS_REQUISITION.CURRENCIES[NAME] = {}

    return NCS_REQUISITION.CURRENCIES[NAME]
end

function NCS_REQUISITION.CurrencyExists(NAME)
    if not NCS_REQUISITION.CURRENCIES[NAME] then
        return false
    else
        return true
    end
end

--[[
    Currency Functions.
--]]

function NCS_REQUISITION.AddMoney(ply, currency, amount)
    if !currency then
        currency = NCS_REQUISITION.CFG.currency
    end

    local TAB = NCS_REQUISITION.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.AddMoney) then
        return false
    end

    TAB:AddMoney(ply, amount)
end

function NCS_REQUISITION.CanAfford(ply, currency, amount)
    if !currency then
        currency = NCS_REQUISITION.CFG.currency
    end

    local TAB = NCS_REQUISITION.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.CanAfford) then
        return false
    end

    return TAB:CanAfford(ply, amount)
end

function NCS_REQUISITION.FormatMoney(currency, amount)
    if !currency then
        currency = NCS_REQUISITION.CFG.currency
    end
    
    local TAB = NCS_REQUISITION.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.FormatMoney) then
        return false
    end

    return TAB:FormatMoney(amount)
end