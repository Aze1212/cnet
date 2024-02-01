AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "Deathwatch Blaster"
SWEP.Trivia_Class = "Blaster Rifle"
SWEP.Trivia_Desc = "This blaster carbine was a popular blaster carbine manufactured by the Mandalorian arms giant Concordian Crescent Technologies. It was named after the galaar, a common bird of prey that was native to the planet Mandalore. It was a sleek, short-barreled rifle constructed from high-quality materials and was covered in shock-resistant polycarbonate. And while relatively rare, this blaster was a frequent item that appeared on the black market. Due to its high-quality design, the rifle became a popular weapon among bounty hunters and other professional killers. Its popularity allowed arms dealers to charge a premium for this weapon, with even used weapons going above their standard value.."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "Concordian Crescent Technologies"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/deathwatch_blaster.png"

SWEP.UseHands = true

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

-- Damage & Entity Options
SWEP.Damage = 32
SWEP.DamageMin = 22
SWEP.RangeMin = 220
SWEP.Range = 455
SWEP.Penetration = 1
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 400

SWEP.DamageType = DMG_BULLET
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_orange"
SWEP.TracerCol = Color(250, 175, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 42
SWEP.ExtendedClipSize = 55
SWEP.ReducedClipSize = 10

SWEP.MaxRecoilBlowback = 1
SWEP.Num = 1 

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 1.12
SWEP.RecoilRise = 0.6
SWEP.RecoilSide = 0.2
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 300
SWEP.MoveDispersion = 267

SWEP.Delay = 60 / 420
SWEP.Firemode = 2
SWEP.Firemodes = {
    {
		Mode = 1,
    },
    {
		Mode = 2,
    },
	{
		Mode = 0,
   	}
}

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.40
SWEP.SightTime = 0.4 / 1.25

SWEP.Primary.Ammo = "ar2" 
SWEP.ShootVol = 125
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "masita/weapons/custom2/eleaticprinciplefire1.wav"
SWEP.ShootSound = "masita/weapons/custom2/eleaticprinciplefire3.wav"
SWEP.ShootSoundSilenced = "everfall/weapons/deadeye/blasters_deadeye_laser_close_var_01.mp3"

SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_orange"
SWEP.GMMuzzleEffect = false
SWEP.FastMuzzleEffect = nil
SWEP.MuzzleFlashColor = Color(250, 175, 0)

SWEP.IronSightStruct = {
    Pos = Vector(-3, -5, 1),
    Ang = Angle(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 2, -1)
SWEP.ActiveAng = Angle(1, -0.5, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(9.824, 2, -2.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)


-- Attachments
SWEP.DefaultElements = {"mrifle", "muzzle"}
SWEP.AttachmentElements = {
    ["mrifle"] = {
        VMElements = {
            {
                Model = "models/arccw/masita/deathwatch_blaster/deathwatch_blaster.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(1.3, 1.3, 1.3),
                Offset = {
                    pos = Vector(1.3, 3.5, -5),
                    ang = Angle(0, 0, 0),
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
                    pos = Vector(-1, 3, 10),
                    ang = Angle(90, 0, 0)
                },
                IsMuzzleDevice = true
            }
        },
        WMElements = {
            {
                Model = "models/arccw/masita/deathwatch_blaster/deathwatch_blaster.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1.2, 1.2, 1.2),
                Offset = {
                    pos = Vector(800, 110, 250),
                    ang = Angle(-15, -90, -180),
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(2400, 140, -1000),
                    ang = Angle(0, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}
WMOverride = "models/arccw/masita/deathwatch_blaster/deathwatch_blaster.mdl"

SWEP.Attachments = {    
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        VMScale = Vector(0.8, 0.8, 0.8),
        WMScale = Vector(111, 111, 111),
        Bone = "dlt19_sight",
        Offset = {
            vpos = Vector(0.15, -0.35, -4.3),
            vang = Angle(90, 0, -90),
            wpos = Vector(450, 35, -690),
            wang = Angle(-15, 0, 180)
        },
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
        Bone = "v_dlt19_reference001",
        WMScale = Vector(111, 111, 111),
        VMScale = Vector(1.3,1.3,1.3),
        Offset = {
            vpos = Vector(0.7, 23, 2.55),
            vang = Angle(180, -90, 180),
            wpos = Vector(2500, 40, -1000),
            wang = Angle(-15, 0, 180)
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        Bone = "v_dlt19_reference001",
        WMScale = Vector(90, 90, 90),
        VMScale = Vector(0.6, 0.6, 0.6),
        Offset = {
            vpos = Vector(1.5, 20, 2.5),
            vang = Angle(90, -90, 0),
            wpos = Vector(1900, 130, -850),
            wang = Angle(-15, 0, -90)
        },
    },   
    {
        PrintName = "Underbarrel",
        DefaultAttName = "None",
        Slot = {"foregrip"},
        WMScale = Vector(111, 111, 111),
        VMScale = Vector(1.2,1.2,1.2),
        Bone = "dlt19_sight",
        Offset = {
            vpos = Vector(-0.5, 3.2, 6),
            vang = Angle(90, 0, -90),
            wpos = Vector(1500, 45, -650),
            wang = Angle(-15, 0, -180)

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
        WMScale = Vector(111, 111, 111),
        VMScale = Vector(0.7,0.7,0.7),
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(1.4, 5, 3.2),
            vang = Angle(120, -90, -90),
            wpos = Vector(800, 150, -550),
            wang = Angle(-15, 0, 200)
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "v_dlt19_reference001",
        WMScale = Vector(80, 80, 80),
        VMScale = Vector(0.5,0.5,0.5),
        Offset = {
            vpos = Vector(1.15, 5, 0),
            vang = Angle(0, -90, 0),
            wpos = Vector(785, 85, -260),
            wang = Angle(-15, 0, 180)
        },
    },   
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = {"shoot1", "shoot2", "shoot3"},
    },
    ["fire_iron"] = {
        Source = false,
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = "draw/gunfoley_pistol_draw_var_06.mp3", t = 0.1/30},
        },
    },
    ["holster"] = {
        SoundTable = {
            {s = "holster/gunfoley_pistol_sheathe_var_09.mp3", t = 0.1/30},
        },
    },
    ["reload"] = {
        Source = "reload",
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 0.1/80},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 140/60},
        },
    },
}