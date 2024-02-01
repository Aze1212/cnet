att.PrintName = "Condition Overload"

att.Icon = Material("interfaz/armas/sw_powercell2.png")
att.Description = "With a little grease and some compression charge, most magazines can be made to accept an extra round."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "perk"

att.AutoStats = true
att.Add_ClipSize = 20

att.Hook_Compatible = function(wep)
    if wep.RejectMagSizeChange or wep:GetCapacity() == 1 then return false end
end

att.NotForNPCs = true