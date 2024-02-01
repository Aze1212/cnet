AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "SG-X2 'Invective'"
SWEP.Trivia_Class = "Blaster Shotgun"
SWEP.Trivia_Desc = "'I tried to talk them down. They made a grab for my Spices. After that it was a short conversation.'"
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/blacksunshotgun.png"

-- Viewmodel & Entity Properties
SWEP.HideViewmodel = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_invective.mdl"
SWEP.WorldModel = "models/invective.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-13, 6, -3),
    ang = Angle(-20, 0, 180)
}

-- Special properties
SWEP.ShotgunReload = true
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 2

-- Damage & Tracer
SWEP.Damage = 32
SWEP.RangeMin = 28
SWEP.DamageMin = 22
SWEP.Range = 119
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400

SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 125, 255)
SWEP.TracerWidth = 10
SWEP.PhysTracerProfile = "apex_bullet_energy"
SWEP.Tracer = "arccw_apex_tracer_energy_sniper"
SWEP.HullSize = 1.5

SWEP.AmmoPerShot = 1
SWEP.ChamberSize = 1
SWEP.Primary.ClipSize = 8
SWEP.ExtendedClipSize = 12
SWEP.ReducedClipSize = 4

SWEP.MaxRecoilBlowback = 1
SWEP.VisualRecoilMult = 1
SWEP.Recoil = 1.6
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 1.2
SWEP.RecoilPunch = 2

SWEP.Delay = 60 / 76
SWEP.Num = 5
SWEP.Firemode = 1

SWEP.Firemodes = {
    {
		Mode = 1,
    },
	{
		Mode = 0,
   	}
}

SWEP.AccuracyMOA = 50
SWEP.HipDispersion = 460
SWEP.MoveDispersion = 100

-- Speed Mult
SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.77
SWEP.ShootSpeedMult = 1

-- Ammo, Sounds & MuzzleEffect
SWEP.Primary.Ammo = "ar2"

SWEP.ShootVol = 120
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "weapons/invectivefire1.wav"
SWEP.ShootSound = "weapons/invectivefire2.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17"
SWEP.MuzzleEffectAttachment = 1 
SWEP.CaseEffectAttachment = 2
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(0, 0, 250)

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-5.128, -10.308, 2.405),
    Ang = Angle(0,0,0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

-- Holdtype
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "ar2"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(-.5, -6, 1.7)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.SprintPos = Vector(4.019, -5.226, -0.805)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(4.221, -9.849, -4.222)
SWEP.CustomizeAng = Angle(24.622, 25.326, 9.848)

SWEP.HolsterPos = Vector(4, -3, 2)
SWEP.HolsterAng = Vector(-15, 30, -15)

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

-- Don't touch this unless you know what you're doing
SWEP.Animations = {
    ["idle"] = {
        Source = "idle_retracted",
    },
	["fire"] = {
        Source = "shoot",
        ShellEjectAt = 0,
        SoundTable = {
            {s = "weapons/wastelander/wastelanderpump.wav", t = 10/30},
        },
    },
    ["fire_empty"] = {
        Source = {"shoot"},
        ShellEjectAt = 0,
        SoundTable = {
            {s = "weapons/invectivefirefinal.wav", t = 0.1},
            {s = "weapons/wastelander/wastelanderpump.wav", t = 10/30},
        },
    },
    ["fire_iron"] = {
        Source = "shootiron",
        ShellEjectAt = 0,
        SoundTable = {
            {s = "weapons/wastelander/wastelanderpump.wav", t = 10/30},
        },
    },
    ["fire_iron_empty"] = {
        Source = "shootiron",
        ShellEjectAt = 0,
        SoundTable = {
            {s = "weapons/invectivefirefinal.wav", t = 0.1},
            {s = "weapons/wastelander/wastelanderpump.wav", t = 10/30},
        },
    },
    ["sgreload_start"] = {
        Source = "start reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        SoundTable = {
                        {s = "weapons/wastelander/wastelanderreloadstart.wav", t = 0.1},
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
                        {s = "weapons/wastelander/wastelanderreloadin.wav", t = 3/30},
                    },
        TPAnimStartTime = 0.3,
        LHIK = true,
        LHIKIn = 0,
        LHIKOut = 0,
    },
    ["sgreload_finish"] = {
        Source = "finish reload",
        SoundTable = {
                        {s = "weapons/wastelander/wastelanderreloadend.wav", t = 0.01},
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