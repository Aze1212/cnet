AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "'Dead Man's Tale'"
SWEP.Trivia_Class = "Blaster Rifle"
SWEP.Trivia_Desc = "Galactic Lever-Action rifle. Unkown origin. 'Long, short, they all end the same way.'"
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Mechanism = "Lever-Action"
SWEP.IconOverride = "entities/sopsmisc/lever2.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/deadmanstale/c_dead_mans_tale.mdl"
SWEP.WorldModel = "models/tor/weapons/w_quadblaster.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-12, 6, -5),
    ang = Angle(-10, 0, 180)
}

-- Special properties
SWEP.ShotgunReload = true
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 2

-- Damage & Entity Options
SWEP.Damage = 34
SWEP.DamageMin = 27
SWEP.RangeMin = 179
SWEP.Range = 390
SWEP.Penetration = 1.1
SWEP.DamageType = DMG_BULLET
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 472

SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 125, 255)
SWEP.TracerWidth = 10
SWEP.PhysTracerProfile = "apex_bullet_energy"
SWEP.Tracer = "arccw_apex_tracer_energy_sniper"
SWEP.HullSize = 1.5
SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 14
SWEP.AmmoPerShot = 1

SWEP.MaxRecoilBlowback = 1
SWEP.Recoil = 1.2
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 1.2
SWEP.RecoilPunch = 2

SWEP.Delay = 60 / 80
SWEP.Num = 1 
SWEP.Firemode = 1
SWEP.Firemodes = {
    {
		Mode = 1,
    },
	{
		Mode = 0,
   	}
}

SWEP.AccuracyMOA = 0.5 
SWEP.HipDispersion = 475
SWEP.MoveDispersion = 50

SWEP.Primary.Ammo = "ar2" 
SWEP.ShootVol = 125
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.05
SWEP.FirstShootSound = "weapons/deadmanstale/deadmansfire1.wav"
SWEP.ShootSound = "weapons/deadmanstale/deadmansfire3.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false 

SWEP.MuzzleEffectAttachment = 1 
SWEP.CaseEffectAttachment = 2
SWEP.ProceduralViewBobAttachment = 1
SWEP.MuzzleFlashColor = Color(0, 0, 250)

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.77
SWEP.ShootSpeedMult = 1

SWEP.IronSightStruct = {
    Pos = Vector(-5.237, -10.469, 0.91),
    Ang = Angle(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

SWEP.SightTime = 0.13
SWEP.SprintTime = 0

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.CanBash = true
SWEP.MeleeDamage = 27
SWEP.MeleeRange = 16
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeTime = 0.5
SWEP.MeleeGesture = nil
SWEP.MeleeAttackTime = 0.2

SWEP.SprintPos = Vector(.5, -6, -12)
SWEP.SprintAng = Angle(40, 0, 0)

SWEP.ActivePos = Vector(-.5, -3.1, -.1)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.CustomizePos = Vector(7, -7, -1.206)
SWEP.CustomizeAng = Angle(18.291, 30.954, 17.587)

-- Attachments
SWEP.Attachments = {       
    {
        PrintName = "Energization", 
        DefaultAttName = "Standard",
        Slot = {"ammo", "ammo_masita", "ammo_stun"},
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Perk",
        DefaultAttName = "None",
        Slot = {"perk", "mw3_pro"},
    },
    {
        PrintName = "Internal Modifications",
        DefaultAttName = "None",
        Slot = {"uc_fg"},
    },         
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle_retracted",
    },
	["fire"] = {
        Source = "shoot",
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shootiron",
        ShellEjectAt = 0,
    },
    ["sgreload_start"] = {
        Source = "start reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
                        {s = "weapons/deadmanstale/deadmansreloadstart.wav", t = 0.1},
                    },
        LHIK = true,
        LHIKIn = 0.5,
        LHIKOut = 0,
    },
    ["sgreload_insert"] = {
        Source = "insert",
        RestoreAmmo = 1,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
                        {s = "weapons/deadmanstale/deadmansreloadinsert.wav", t = 3/30},
                    },
        TPAnimStartTime = 0.3,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0,
    },
    ["sgreload_finish"] = {
        Source = "finish reload",
        SoundTable = {
                        {s = "weapons/deadmanstale/deadmansreloadend.wav", t = 0.01},
                    },
        LHIK = true,
        LHIKIn = 0.4,
        LHIKOut = 0.4,
    },  
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {
                s = "weapons/deadmanstale/deadmansdraw.wav", -- sound; can be string or table
                p = 100, -- pitch
                v = 75, -- volume
                t = 0, -- time at which to play relative to Animations.Time
                c = CHAN_ITEM, -- channel to play the sound
            },
        }
    },
    ["holster"] = {
        Source = "holster",
        SoundTable = {
            {
                s = "weapons/deadmanstale/deadmansdraw.wav", -- sound; can be string or table
                p = 100, -- pitch
                v = 75, -- volume
                t = 0, -- time at which to play relative to Animations.Time
                c = CHAN_ITEM, -- channel to play the sound
            },
        }
    },
}