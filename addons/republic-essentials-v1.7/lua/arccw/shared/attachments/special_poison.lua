att.PrintName = "Poison Rounds"
att.AbbrevName = "Poison Rounds"
att.Icon = Material("interfaz/iconos/jedi/1226256349_2572987182.png")
att.Description = "Experimental overcharged plasma that can poison targets."

att.Desc_Pros = {
}
att.Desc_Cons = {
}
att.Desc_Neutrals = {
}
att.Slot = {"special_ammo"}

att.AutoStats = true
att.Override_AmmoPerShot = 10
att.Override_Tracer = "tracer_yellow"
att.Hook_BulletHit = function(wep, data)
	GMSERV:AddStatus(data.tr.Entity, data.att, "heal", 10, 5, true) --Entity,Owner,Status Effect Type (Yes, you can add the others),Duration, Damage, ParticleEffect
end
att.Hook_GetShootSound = function(wep, sound)
    return false
end
att.Hook_AddShootSound = function(wep, data)
    wep:MyEmitSound("everfall/weapons/deadeye/blasters_deadeye_laser_close_var_03.mp3", data.volume, data.pitch, 1, CHAN_WEAPON - 1)
end