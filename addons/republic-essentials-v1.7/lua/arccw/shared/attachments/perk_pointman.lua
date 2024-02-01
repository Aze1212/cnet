att.PrintName = "Pointman"

att.Icon = Material("interfaz/iconos/kraken/jedi juns sharpshooter/3178788454_3701931000.png")
att.Description = "Firearms and dexterity training for quick response in breaching situations. Drills in confined spaces allow you to more effectively handle long weapons in close quarters.\n\nThe pointman is always the first to enter, and the first to identify and disable threats."
att.Desc_Pros = {
    "Reduces barrel length for CQB situations."
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = "perk"
att.SortOrder = 7

att.AutoStats = true
att.Add_BarrelLength = -10
att.M_Hook_Mult_RPM = function(wep, data)
    if wep:GetCurrentFiremode().Mode == 1 then
        data.mult = data.mult * 1.15
    end
end

att.NotForNPCs = true