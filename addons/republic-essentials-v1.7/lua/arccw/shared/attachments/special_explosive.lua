att.PrintName = "Explosive Rounds"
att.Icon = Material("interfaz/armas/sw_demolish.png")
att.Description = "Tibanna compression with explosive results"
att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.AutoStats = true
att.Slot = "special_ammo"

att.Mult_ShootPitch = 0.6
att.Mult_ShootVol = 1.7
att.Mult_Penetration = 1.1
att.Mult_Damage = 4
att.Mult_Range = 0.7

att.Override_DamageType = DMG_BURN

att.Override_Tracer = "tracer_yellow"

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