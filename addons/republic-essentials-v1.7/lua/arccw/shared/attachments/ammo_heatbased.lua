att.PrintName = "Heat-Based Weapon"
att.Icon = Material("interfaz/armas/sw_powercell1.png")
att.Description = "The weapon has now infinite ammo at the heat cost. You'll do less damage and it will decay more in distance."
att.Override_MuzzleEffect = nil
att.Override_Tracer = nil
att.Desc_Pros = {
}
att.Desc_Cons = {
}

att.NotForNPCs = true
att.AutoStats = true
att.Slot = "ammo"

att.Override_InfiniteAmmo = true
att.Override_BottomlessClip = true
att.Override_Jamming = true
att.Mult_HeatCapacity = 1
att.Mult_FixTime = 1
att.Mult_HeatGain = 2
att.Mult_HeatDissipation = 5
att.Mult_HeatDelayTime = 1
att.Override_HeatLockout = true 

att.Mult_ShootPitch = 1.1
att.Reload = 0.9
att.Mult_DamageMin = 0.74
att.Mult_Recoil = 1.2
att.Mult_SightTime = 1
att.Mult_RPM = 0.8
att.Mult_Damage = 0.85
att.Mult_MuzzleVelocity = 0.9