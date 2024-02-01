att.PrintName = "Gunslinger"

att.Icon = Material("interfaz/iconos/kraken/jedi guns dirty fighting/1908223959_3315526753.png")
att.Description = "Specialist training and a little extra gun care allow you to cycle the action more quickly after a shot, improving your rate of fire."
att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "perk"

att.AutoStats = true
att.Mult_CycleTime = .7

att.Hook_Compatible = function(wep)
    if wep:GetBuff_Override("Override_ManualAction", wep.ManualAction) then return end
    for i, v in pairs(wep.Firemodes) do
        if !v then continue end
        if v.Mode and v.Override_ManualAction then
            return
        end
    end
    return false
end

att.NotForNPCs = true