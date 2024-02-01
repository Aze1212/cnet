AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "Mandalorian Pulse Rifle"
SWEP.Trivia_Class = "Blaster Rifle"
SWEP.Trivia_Desc = "The Amban phase-pulse blaster, also known as an Amban sniper rifle, was a type of disruptor sniper rifle used by the Mandalorian bounty hunter Din Djarin. The weapon was capable of electrocuting opponents as well as completely disintegrating targets. It was also capable of listening to conversations at least a house away. Djarin used the deadly weapon to great effect during his bounty hunting career."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "Concordian Crescent Technologies"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/mandopulse.png"

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
SWEP.Damage = 114
SWEP.DamageMin = 76
SWEP.RangeMin = 405
SWEP.Range = 723
SWEP.Penetration = 1
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 400

SWEP.DamageType = DMG_BULLET
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_laser_big"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 8
SWEP.ExtendedClipSize = 12
SWEP.ReducedClipSize = 6

SWEP.MaxRecoilBlowback = 1
SWEP.Num = 1 

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 1.78
SWEP.RecoilRise = 0.76
SWEP.RecoilSide = 0.4
SWEP.RecoilPunch = 2.7
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 100
SWEP.MoveDispersion = 300

SWEP.Delay = 60 / 201
SWEP.Firemode = 1
SWEP.Firemodes = {
    {
		Mode = 1,
    },
	{
		Mode = 0,
   	}
}

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.40
SWEP.SightTime = 0.4 / 1.25

SWEP.Primary.Ammo = "ar2" 
SWEP.ShootVol = 150
SWEP.ShootPitch = 80
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "mando_rifle/mando.mp3"
SWEP.ShootSound = "mando_rifle/mando.mp3"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.GMMuzzleEffect = false
SWEP.FastMuzzleEffect = nil
SWEP.MuzzleFlashColor = Color(250, 0, 0)

SWEP.IronSightStruct = {
    Pos = Vector(-3, -9.494, 1.8),
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
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(0, 2, 1)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(9.824, -7, -2.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)


-- Attachments
SWEP.DefaultElements = {"mrifle", "muzzle"}
SWEP.AttachmentElements = {
    ["mrifle"] = {
        VMElements = {
            {
                Model = "models/weapons/twcustom/mando_sniper/mando_sniper.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(1.2, 1.2, 1.2),
                Offset = {
                    pos = Vector(0.7, 12, -3.7),
                    ang = Angle(0, -90, 0),
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
                    pos = Vector(-1, 3, 15),
                    ang = Angle(90, 0, 0)
                },
                IsMuzzleDevice = true
            }
        },
        WMElements = {
            {
                Model = "models/weapons/twcustom/mando_sniper/mando_sniper.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1.3, 1.3, 1.3),
                Offset = {
                    pos = Vector(1800, 90, 100),
                    ang = Angle(175, 180, 0),
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(4300, 140, -780),
                    ang = Angle(0, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}
WMOverride = "models/weapons/twcustom/mando_sniper/mando_sniper.mdl"

SWEP.Attachments = {    
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        VMScale = Vector(0.8, 0.8, 0.8),
        WMScale = Vector(111, 111, 111),
        Bone = "dlt19_sight",
        Offset = {
            vpos = Vector(0.150, 0.85, -1),
            vang = Angle(90, 0, -90),
            wpos = Vector(930, 75, -690),
            wang = Angle(-5, 0, 180)
        },
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
        Bone = "v_dlt19_reference001",
        WMScale = Vector(90, 90, 90),
        VMScale = Vector(0.9, 0.9, 0.9),
        Offset = {
            vpos = Vector(0.3, 22, 0.7),
            vang = Angle(0, -90, 0),
            wpos = Vector(2100, 80, -450),
            wang = Angle(-5, 0, 180)
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
        Bone = "v_dlt19_reference001",
        Offset = {
            vpos = Vector(1.1, 3, 1.5),
            vang = Angle(90, -90, -90),
            wpos = Vector(600, 160, -400),
            wang = Angle(-5, 0, 180)
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "v_dlt19_reference001",
        VMScale = Vector(0.7, 0.7, 0.7),
        WMScale = Vector(111, 111, 111),
        Offset = {
            vpos = Vector(1.6, 5.5, 2.5),
            vang = Angle(0, -90, 0),
            wpos = Vector(950, 200, -500),
            wang = Angle(-5, 0, 180)
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
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 0.1/30},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 80/30},
        },
    },
}