local OBJ = NCS_REQUISITION.RegisterCurrency("darkrp")

function OBJ:AddMoney(p, amount)
    p:addMoney(amount)
end

function OBJ:CanAfford(p, amount)
    return p:canAfford(amount)
end

function OBJ:FormatMoney(money)
    return DarkRP.formatMoney(money)
end