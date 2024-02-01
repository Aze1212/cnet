AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Explosives"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "Flechette Launcher"
SWEP.Trivia_Class = "High-Explosive Weapon"
SWEP.Trivia_Desc = "Flechette launchers were weapons that fired flechettes. Golan Arms's FC-1 flechette launcher and the Salus Corporation's DF-D1 Duo-Flechette Rifle were both models of flechette launcher."
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Rocket"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/flechette.png"

-- Viewmodel & Entity Properties
SWEP.ViewModel = "models/arccw/bf2017/c_dlt19.mdl"
SWEP.WorldModel = "models/arccw/bf2017/w_e11.mdl"
SWEP.ViewModelFOV = 70
SWEP.HideViewmodel = true
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.009
}

-- Grenade Launcher properties
SWEP.ShootEntity = "rocket_micro"
SWEP.MuzzleVelocity = 3400

SWEP.Jamming = true
SWEP.HeatGain = 1
SWEP.HeatCapacity = 5
SWEP.HeatDissipation = 2 
SWEP.HeatLockout = true
SWEP.HeatDelayTime = 2
SWEP.InfiniteAmmo = true
SWEP.BottomlessClip = true

-- Damage & Tracer
SWEP.ChamberSize = 0 
SWEP.Primary.ClipSize = 6
SWEP.ExtendedClipSize = 8
SWEP.ReducedClipSize = 4

SWEP.Recoil = 1.78
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 1.5
SWEP.RecoilPunch = 1.4

SWEP.Delay = 60 / 80
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 1,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 1
SWEP.HipDispersion = 300
SWEP.MoveDispersion = 200

SWEP.Primary.Ammo = "RPG_Round"
SWEP.MagID = "rpg7"

-- Speed Mult
SWEP.SightTime = 0.35
SWEP.SpeedMult = 0.76
SWEP.SightedSpeedMult = 0.75

-- Ammo, Sounds & MuzzleEffect
SWEP.ShootVol = 100
SWEP.ShootPitch = 90
SWEP.ShootPitchVariation = 0.2
SWEP.ShootSound = "masita/weapons/custom5/semioticianfire1.wav"
SWEP.ShootSoundSilenced = "masita/weapons/custom5/semioticianfire4.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_orange"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(250, 167, 0)

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-3.05, 5, -1.2),
    Ang = Vector(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 60,
}

-- Holdtype
SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(1, 0, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(15, 4.8, -3)
SWEP.CustomizeAng = Angle(11.199, 38, 0)

SWEP.HolsterPos = Vector(4, -3, 2)
SWEP.HolsterAng = Vector(-15, 30, -15)

SWEP.ExtraSightDist = 8

-- Attachments
SWEP.DefaultElements = {"fc1", "muzzle"}
SWEP.AttachmentElements = {
    ["fc1"] = {
        VMElements = {
            {
                Model = "models/arccw/masita/fc1/fc1.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(0.7, 3.5, 1.5),
                    ang = Angle(0, -90, 0)
                }
            }
        }
    },
    ["muzzle"] = {
        VMElements = {
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(0, 0, 0),                
                Offset = {
                    pos = Vector(2, 12, -3),
                    ang = Angle(90, 0, 0)
                },
                IsMuzzleDevice = true
            }
        },
        WMElements = {
            {
                Model = "models/arccw/masita/fc1/fc1.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(1000, 100, -470),
                    ang = Angle(-12, 0, 180),
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(2700, 100, -1000),
                    ang = Angle(-15, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        },
    }
}
WMOverride = "models/arccw/masita/fc1/fc1.mdl"

SWEP.Attachments = {         
    {
        PrintName = "Rocket", 
        DefaultAttName = "None",
        Slot = {"ammo_rocket"},
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
        Source = "idle"
    },
    ["fire"] = {
        Source = "fire",
        SoundTable = {
            {s = "armas3/gl_fire_1.wav", t = 0.1/30},
        },
    },
    ["fire_iron"] = {
        Source = "fire_iron",
        SoundTable = {
            {s = "armas3/gl_fire_1.wav", t = 0.1/30},
        },
    },
    ["draw"] = {
        SoundTable = {
            {
                s = "armasclasicas/wpn_empire_lgequip.wav",
                p = 100, 
                v = 75,
                t = 0, 
                c = CHAN_ITEM,
            },
        }
    },
    ["holster"] = {
        SoundTable = {
            {
                s = "armasclasicas/wpn_empire_medequip.wav",
                p = 100,
                v = 75,
                t = 0,
                c = CHAN_ITEM,
            },
        }
    },
}