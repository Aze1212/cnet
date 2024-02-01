att.PrintName = "Underload"

att.Icon = Material("interfaz/iconos/kraken/sith merc arsenal/756989185_3020183531.png")
att.Description = "Just because it fits, does not mean you have to fill it. Partially filled magazines reduces follower stress and improves feeding rate."
att.Desc_Pros = {
    "More fire rate, less reload time. More heat capacity & reliability"
}
att.Desc_Cons = {
    "Reduces ammo capacity."
}
att.Desc_Neutrals = {
}
att.Slot = "perk"

att.AutoStats = true
att.SortOrder = 1

function att.Hook_GetCapacity(wep, cap)
    return math.max(math.floor(cap * (1 - 0.14)), 1)
end

att.Hook_Compatible = function(wep)
    if wep.RejectMagSizeChange or wep:GetCapacity() == 1 then return false end
end


att.Mult_MalfunctionMean = 1.25
att.Mult_HeatCapacity = 1.25
att.Mult_RPM = 1.05
att.Mult_ReloadTime = 0.95

att.NotForNPCs = true