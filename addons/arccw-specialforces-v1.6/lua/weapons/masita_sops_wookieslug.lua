AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "Wookie Slug-Blaster"
SWEP.Trivia_Class = "Slugthrower rifle"
SWEP.Trivia_Desc = "The Wookiee Slug-Thrower was a slugthrower rifle that was mass-produced by Wookiee workshops across the planet Kashyyyk around the time of the Clone Wars. Slugthrowers were primitive weapons that used an explosive force (from chemicals or compressed gas) to launch a solid projectile, called a slug, at high velocity."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Compressed Gas"
SWEP.IconOverride = "entities/sopsmisc/wookieslug.png"

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

-- Damage & Entity Option
SWEP.Damage = 43
SWEP.DamageMin = 28
SWEP.RangeMin = 302
SWEP.Range = 427
SWEP.Penetration = 1
SWEP.DamageTypeHandled = false
SWEP.MuzzleVelocity = 900

SWEP.DamageType = DMG_BULLET
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "astra_beam"
SWEP.TracerCol = Color(250, 150, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 18
SWEP.ExtendedClipSize = 28
SWEP.ReducedClipSize = 10

SWEP.MaxRecoilBlowback = 1.2
SWEP.Num = 1 

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 1.87
SWEP.RecoilRise = 1.02
SWEP.RecoilSide = 0.56
SWEP.AccuracyMOA = 1
SWEP.HipDispersion = 200
SWEP.MoveDispersion = 300
SWEP.RecoilPunch = 2.7

SWEP.Delay = 60 / 108
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
SWEP.ShootVol = 125
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "masita/weapons/bowcaster/frenzy/blasters_bowcaster_frenzy_laser_close_var_03.mp3"
SWEP.ShootSound = "masita/weapons/bowcaster/frenzy/blasters_bowcaster_frenzy_laser_close_var_03.mp3"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_orange"
SWEP.GMMuzzleEffect = false
SWEP.FastMuzzleEffect = nil
SWEP.MuzzleFlashColor = Color(250, 150, 0)

SWEP.IronSightStruct = {
    Pos = Vector(-3.050, -7, 0),
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

SWEP.ActivePos = Vector(0, 2, -1)
SWEP.ActiveAng = Angle(1, -0.5, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(9.824, 2, -2.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)


-- Attachments
SWEP.DefaultElements = {"wookie", "muzzle"}
SWEP.AttachmentElements = {
    ["wookie"] = {
        VMElements = {
            {
                Model = "models/tor/weapons/wookie_slug.mdl",
                Bone = "v_dlt19_reference001",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-0.3, 5, 1),
                    ang = Angle(0, -180, -10),
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
                Model = "models/tor/weapons/wookie_slug.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(1000, 0, -350),
                    ang = Angle(90, 90, -90),
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(2200, 140, -780),
                    ang = Angle(0, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}
WMOverride = "models/tor/weapons/wookie_slug.mdl"

SWEP.Attachments = {    
    {
        PrintName = "Muzzle",
        DefaultAttName = "None",
        Slot = {"muzzle", "cr2_muzzle", "cr2c_muzzle", "stealth_muzzle"},
        Bone = "v_dlt19_reference001",
        WMScale = Vector(180, 180, 180),
        VMScale = Vector(1.3,1.3,1.3),
        Offset = {
            vpos = Vector(0.6, 18.5, 3),
            vang = Angle(180, -90, 180),
            wpos = Vector(2400, 100, -790),
            wang = Angle(-10, 0, 180)
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        Bone = "v_dlt19_reference001",
        WMScale = Vector(90, 90, 90),
        VMScale = Vector(0.8, 0.8, 0.8),
        Offset = {
            vpos = Vector(2.1, 14, 2.6),
            vang = Angle(90, -90, 0),
            wpos = Vector(1900, 220, -700),
            wang = Angle(-10, 0, -90)
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
            vpos = Vector(1.2, -0.6, 3.8),
            vang = Angle(90, -90, -90),
            wpos = Vector(350, 165, -490),
            wang = Angle(-10, 0, 180)
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "v_dlt19_reference001",
        VMScale = Vector(0.8, 0.8, 0.8),
        WMScale = Vector(111, 111, 111),
        Offset = {
            vpos = Vector(1.150, -0.2, 1.80),
            vang = Angle(0, -90, 0),
            wpos = Vector(400, 170, -330),
            wang = Angle(-10, 0, 180)
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