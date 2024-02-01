AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Empire Weapons"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "SX-21"
SWEP.Trivia_Class = "Pump-Action Scatter Blaster"
SWEP.Trivia_Desc = "The SX-21 pump-action scatter blaster, also known as the SX-21 scatterblaster, or the SX-21 blaster rifle, was a model of pump-action scatter blaster rifle made by Merr-Sonn Munitions, Inc., and proved invaluable to Imperial mudtroopers during the heavy fighting with the Mimbanese during the Mimban Campaign"
SWEP.Trivia_Manufacturer = "Merr-Sonn Munitions, Inc"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/sx21.png"

-- Viewmodel & Entity Properties
SWEP.ViewModel = "models/arccw/bf2017/c_dlt19.mdl"
SWEP.WorldModel = "models/arccw/bf2017/w_e11.mdl"
SWEP.ViewModelFOV = 65
SWEP.HideViewmodel = true
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.009
}

-- Damage & Tracer
SWEP.Damage = 30
SWEP.RangeMin = 54
SWEP.DamageMin = 23
SWEP.Range = 123
SWEP.Penetration = 7
SWEP.DamageType = DMG_BUCKSHOT

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 24
SWEP.ExtendedClipSize = 32
SWEP.ReducedClipSize = 15

SWEP.MuzzleVelocity = 400
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.Recoil = 1.28
SWEP.RecoilSide = 0.34
SWEP.RecoilRise = 0.65

SWEP.Delay = 60 / 220
SWEP.Num = 4
SWEP.Firemodes = {
    {
        Mode = 1,
        PrintName = "SINGLE",
    },
    {
        Mode = -2,
        PrintName = "DOUBLE-SCATTER",
        PostBurstDelay = 1,
    },
    {
        Mode = 0
    }
}

SWEP.AccuracyMOA = 50
SWEP.HipDispersion = 450
SWEP.MoveDispersion = 100

-- Ammo, Sounds & MuzzleEffect
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 150 
SWEP.ShootPitch = 90
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "weapons/wastelander/wastelanderfire1.wav"
SWEP.ShootSound = "weapons/wastelander/wastelanderfire2.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(250, 0, 0)

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-2.5, 2, 0.5),
    Ang = Angle(-0.8, -0.3, 0),
     Magnification = 1.2,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

-- Holdtype
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "shotgun"
SWEP.HoldtypeSights = "rpg"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(2, 3, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.HolsterPos = Vector(1, 0, 1)
SWEP.HolsterAng = Angle(-10, 12, 0)

SWEP.CustomizePos = Vector(9.824, 2, -2.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

-- Attachments
SWEP.DefaultElements = {"sx21", "muzzle"}
SWEP.AttachmentElements = {
    ["sx21"] = {
        VMElements = {
            {
                Model = "models/tor/weapons/sx21_base.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-0.5, 5.6, 1),
                    ang = Angle(0, -180, 0),
                }
            }
        }
    },
    ["muzzle"] = {
         VMElements = {
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "dlt19_sight",
                Scale = Vector(0, 0, 0),                
                Offset = {
                    pos = Vector(-2, 4, 7),
                    ang = Angle(90, 0, 0)
                },
                IsMuzzleDevice = true
            }
        },
        WMElements = {
            {
                Model = "models/tor/weapons/sx21_base.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(1050, 0, -480),
                    ang = Angle(85, 90, -90),
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(2200, 140, -745),
                    ang = Angle(-15, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}WMOverride = "models/tor/weapons/sx21_base.mdl"

SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "None", 
        Slot = "optic", 
        WMScale = Vector(111, 111, 111),
        Bone = "dlt19_sight",
        Offset = {
            vpos = Vector(-0.150, 0.4, -5.5),
            vang = Angle(90, 0, -90),
            wpos = Vector(500, 90, -770),
            wang = Angle(-5, 0, 180)
        },
        CorrectiveAng = Angle(0, -0.3, 0),
        CorrectivePos = Vector(0, 0, 0),
    },  
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },       
    {
        PrintName = "Muzzle", 
        DefaultAttName = "None",
        Slot = {"muzzle", "cr2_muzzle", "cr2c_muzzle", "stealth_muzzle"},
        VMScale = Vector(2, 2, 2),
        WMScale = Vector(200, 200, 200),
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(0.6, 21, 2.7),
            vang = Angle(0, -90, 0),
            wpos = Vector(2700, 100, -800),
            wang = Angle(-5, -1, 180)
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        WMScale = Vector(90, 90, 90),
        VMScale = Vector(0.7, 0.7, 0.7),
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(1.3, 16, 2.7),
            vang = Angle(0, -90, 90),
            wpos = Vector(2250, 200, -740),
            wang = Angle(-5, -1, -90)
        },
    },                
    {
        PrintName = "Energization", 
        DefaultAttName = "Standard",
        Slot = {"ammo", "ammo_masita", "ammo_stun"},
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
        PrintName = "Charm",
        DefaultAttName = "None",
        Slot = {"charm"},
        WMScale = Vector(90, 90, 90),
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(1.5, 2, 2),
            vang = Angle(0, -90, 0),
            wpos = Vector(1050, 215, -620),
            wang = Angle(-5, 0, 180)
        },
    },         
    {
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        WMScale = Vector(90, 90, 90),
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(1.2, -2, 2.9),
            vang = Angle(0, -90, 0),
            wpos = Vector(670, 230, -620),
            wang = Angle(-5, 0, 180)
        },
    },   
}

-- Don't touch this unless you know what you're doing
SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = {"shoot1", "shoot2", "shoot3"}
    },
    ["fire_iron"] = {
        Source = false,
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
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 0.1/30},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 80/30},
        },
    },
}