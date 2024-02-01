att.PrintName = "Stealth Rounds"

att.SortOrder = 17
att.Icon = Material("interfaz/armas/sw_blastersilencer.png", "smooth mips")
att.Description = [[Stealth load low enough to make the plasma travel slower than the normal speed. This reduces range significantly, but makes gunfire very comfortable and quiet.
The sonic boom typical of the round is eliminated, rendering it even more silent than usual with a suppressed firearm.]]
att.Desc_Pros = {
    "Invisible tracers",
    -- "uc.subsonic"
}
att.Desc_Cons = {
    "Lower plasma speed"
}
att.Desc_Neutrals = {
}
att.Slot = "ammo_masita"

att.AutoStats = true

att.Mult_RecoilSide = 0.75
att.Mult_Recoil = 0.8
att.Mult_RangeMin = 0.75
att.Mult_Range = 0.7

att.Mult_RPM = 0.89
att.Mult_ShootVol = 0.8
--att.Mult_ShootPitch = 1.1 please don't

att.Override_PhysTracerProfile = 7
att.Override_TracerNum = 0

att.Mult_MalfunctionMean = 1.3
att.Override_PhysBulletMuzzleVelocity = 339
att.Override_PhysBulletMuzzleVelocity_Priority = 2