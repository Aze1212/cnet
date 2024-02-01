AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Empire Weapons"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "TL-50"
SWEP.Trivia_Class = "Blaster Heavy Repeater"
SWEP.Trivia_Desc = "The TL-50 Heavy Repeater was a model of heavy repeating blaster rifle that was manufactured for the special forces of the Galactic Empire. In addition to sending storms of blaster bolts from its multiple barrels, the rifle could gather its energy into a powerful concussion blast. It could also be modified with an extended barrel for reduced spread and with a power cell for increased cooling power. During the Galactic Civil War against the Rebel Alliance, Commander Iden Versio of the Empire's elite Inferno Squad carried a TL-50 Heavy Repeater."
SWEP.Trivia_Manufacturer = "Unkown"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/tl50.png"

-- Viewmodel & Entity Properties
SWEP.UseHands = true
SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_tl-50.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_tl-50.mdl"
SWEP.ViewModelFOV = 55
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-22, 10, -6),
    ang = Angle(-10, 0, 180)
}

-- Damage & Tracer
SWEP.Damage = 30
SWEP.RangeMin = 199
SWEP.DamageMin = 23
SWEP.Range = 299
SWEP.Penetration = 7
SWEP.DamageType = DMG_BULLET

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 65 
SWEP.ExtendedClipSize = 75
SWEP.ReducedClipSize = 30

SWEP.MuzzleVelocity = 400
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_blue"
SWEP.TracerCol = Color(0, 0, 250)
SWEP.HullSize = 1.5

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 0.31
SWEP.RecoilSide = 0.31
SWEP.RecoilRise = 0.64

SWEP.Delay = 60 / 540 
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 2,
    },
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

-- Speed Mult
SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.83
SWEP.SightTime = 0.3

-- Ammo, Sounds & MuzzleEffect
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 110 
SWEP.ShootPitch = 100 
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "armas3/tl50.wav"
SWEP.ShootSound = "armas3/tl50.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(0, 0, 250)

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-9.122, -19.1, 2.43),
    Ang = Angle(0, 0, 0),
     Magnification = 1.2,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

-- Holdtype
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(-6, -12, 3)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(7, -12, -1.206)
SWEP.CustomizeAng = Angle(18.291, 30.954, 17.587)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.HolsterPos = Vector(4, -3, 2)
SWEP.HolsterAng = Vector(-15, 30, -15)

-- Attachments
SWEP.Attachments = {   
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        Bone = "TL-50",
        Offset = {
            vpos = Vector(-0.1, -5, -2.7),
            vang = Angle(0, 90, 180),
        },
        CorrectiveAng = Angle(0, -180, 0),
        CorrectivePos = Vector(0, 0, 0),
    }, 
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    }, 
    {
        PrintName = "Tactical",
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        VMScale = Vector(0.7, 0.7, 0.7),
        Bone = "TL-50",
        Offset = {
            vpos = Vector(-0.1, -15, 1.5),
            vang = Angle(0, 90, -180),
        },
    },  
    {
        PrintName = "Energization", 
        DefaultAttName = "Standard",
        Slot = {"ammo", "ammo_masita"},
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
    {
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        Bone = "TL-50",
        Offset = {
            vpos = Vector(0.7, -6, -2),
            vang = Angle(0, 90, 205),
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "TL-50",
        Offset = {
            vpos = Vector(1.2, -0, 0.250),
            vang = Angle(0, 90, 180),
        },
    },   
}

-- Don't touch this unless you know what you're doing
SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = "fire",
    },
    ["fire_iron"] = {
        Source = "fire",
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {
                s = "draw/gunfoley_pistol_draw_var_06.mp3", -- sound; can be string or table
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
                s = "holster/gunfoley_pistol_sheathe_var_09.mp3", -- sound; can be string or table
                p = 100, -- pitch
                v = 75, -- volume
                t = 0, -- time at which to play relative to Animations.Time
                c = CHAN_ITEM, -- channel to play the sound
            },
        }
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 12/30},
            {s = "reloading/reload_gentle/mag_eject/023d-00001014.mp3", t = 5/30},
            {s = "reloading/reload_gentle/mag_load/023d-00000dda.mp3", t = 32/30},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 72/30},
        },
    },
}