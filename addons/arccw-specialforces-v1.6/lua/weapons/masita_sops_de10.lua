AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "DE-10"
SWEP.Trivia_Class = "Blaster Pistol"
SWEP.Trivia_Desc = "The DE-10 blaster pistol was a stylish and reliable heavy blaster pistol that was manufactured by Antrech Arms, a subsidiary of BlasTech Industries. It was vaunted for its reliability and ease of maintenance, and heavily resembled a slugthrower revolver."
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/de10.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/arccw/bf2017/c_scoutblaster.mdl"
SWEP.WorldModel = "models/arccw/bf2017/w_scoutblaster.mdl"
SWEP.ViewModelFOV = 60
SWEP.HideViewmodel = true
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.009
}

-- Damage & Entity options
SWEP.Damage = 45
SWEP.RangeMin = 122
SWEP.DamageMin = 27
SWEP.Range = 312
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400

SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_green"
SWEP.TracerCol = Color(25, 250, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 18

SWEP.Recoil = 0.34
SWEP.RecoilPunch = 1.4
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.17

SWEP.Delay = 60 / 202
SWEP.Num = 1
SWEP.Firemodes = {
	{
		Mode = 1
	},
    {
        Mode = 0
    },
}

SWEP.AccuracyMOA = 0.22
SWEP.HipDispersion = 320 
SWEP.MoveDispersion = 50

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_green"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(25, 250, 0)

-- Ammo & Stuff
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 100
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "masita/weapons/blasterpistol3/sturmfire1.wav"
SWEP.ShootSound = "masita/weapons/blasterpistol3/sturmfire2.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.IronSightStruct = {
    Pos = Vector(-3.940, -6.071, 1.2),
    Ang = Vector(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 60,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(1, -3, 1)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(1, -6, -10)
SWEP.SprintAng = Angle(40, 0, 0)

SWEP.HolsterPos = Vector(4, -3, 2)
SWEP.HolsterAng = Vector(-15, 30, -15)

SWEP.CustomizePos = Vector(10, 0, -1.08)
SWEP.CustomizeAng = Angle(6.8, 30.7, 10.3)

-- Attachments 
SWEP.DefaultElements = {"de10", "muzzle"}
SWEP.AttachmentElements = {
    ["de10"] = {
        VMElements = {
            {
                Model = "models/arccw/masita/de10/de10.mdl",
                Bone = "v_scoutblaster_reference001",
                Scale = Vector(1.2, 1.2, 1.2),
                Offset = {
                    pos = Vector(2.2, -4.8, -3),
                    ang = Angle(0.5, 180, 0)
                }
            }
        }
    },
    ["muzzle"] = {
         VMElements = {
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "v_scoutblaster_reference001",
                Scale = Vector(0, 0, 0),                
                Offset = {
                    pos = Vector(2, -8, -3),
                    ang = Angle(90, 0, 0)
                },
                IsMuzzleDevice = true
            }
        },
        WMElements = {
            {
                Model = "models/arccw/masita/de10/de10.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1.3, 1.3, 1.3),
                Offset = {
                    pos = Vector(900, -100, 75),
                    ang = Angle(-10, -90, 180)
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(1900, 100, -550),
                    ang = Angle(-15, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}
WMOverride = "models/arccw/masita/de10/de10.mdl"

SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "None", 
        Slot = "optic", 
        WMScale = Vector(111, 111, 111),
        Bone = "v_scoutblaster_reference001",
        Offset = {
            vpos = Vector(0, -7, 3.3),
            vang = Angle(0, 90, 0),
            wpos = Vector(1000, 160, -700),
            wang = Angle(-10, 0, 180)
        },
        CorrectivePos = Vector(0, 0, 0),
        CorrectiveAng = Angle(0, -180, 0)
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
        WMScale = Vector(111, 111, 111),
        Bone = "scoutblaster_sight",
        Offset = {
            vpos = Vector(0, -0.5, 15),
            vang = Angle(90, 0, -90),
            wpos = Vector(2020, 155, -825),
            wang = Angle(-10, 0, 180)
        },
    },  
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        WMScale = Vector(80, 80, 80),
        VMScale = Vector(0.7, 0.7, 0.7),
        Bone = "v_scoutblaster_reference001",
        Offset = {
            vpos = Vector(0, -11, 2),
            vang = Angle(0, 90, 0),
            wpos = Vector(1600, 155, -660),
            wang = Angle(-10, 0, 180)
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
        PrintName = "Charms/Killcounter",
        DefaultAttName = "None",
        Slot = {"charm"},
        WMScale = Vector(111, 111, 111),
        VMScale = Vector(0.7, 0.7, 0.7),
        Bone = "scoutblaster_sight",
        Offset = {
            vpos = Vector(0.4, 0, 7),
            vang = Angle(90, 0, -90),
            wpos = Vector(1000, 195, -600),
            wang = Angle(-10, 0, 180)
        },
    },     
}

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
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 2},
        },
    },
}