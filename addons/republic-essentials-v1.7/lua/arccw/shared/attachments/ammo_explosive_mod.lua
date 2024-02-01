att.PrintName = "Explosive Mod"
att.Icon = Material("entities/acwatt_go_ammo_blanks.png", "mips smooth")
att.Description = "Explosive rounds"
att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "special_ammo"

att.Mult_ShootPitch = 0.9
att.Mult_ShootVol = 1.3
att.Mult_Penetration = 0
att.Mult_Damage = 4
att.Mult_Range = 0.7

att.Override_DamageType = DMG_BURN

att.Override_Tracer = "tfa_tracer_yellow" -- tracer effect name

att.Hook_GetCapacity = function(wep, cap)
    return math.Clamp(math.Round(wep.RegularClipSize * 1), 1, 12)
end

att.Hook_BulletHit = function(wep, data)
    local ent = data.tr.Entity
    util.BlastDamage(wep, wep:GetOwner(), data.tr.HitPos, 96, wep:GetDamage(data.range))
    if ent:IsValid() and ent:GetClass() == "npc_helicopter" then
        data.dmgtype = DMG_AIRBOAT
    end
end