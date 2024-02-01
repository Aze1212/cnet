AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Empire Weapons"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "ST-W48"
SWEP.Trivia_Class = "Blaster Rifle"
SWEP.Trivia_Desc = "This is the ST-W48. The weapon could be used in a blaster rifle configuration or a blaster carbine configuration where the stock was removed for use in confined spaces. Each ST-W48 had a quarrel-bolt launcher installed below its barrel that used enhanced bowcaster technology for a powerful explosive attack. The rifle's power cell cartridge was located around the mid-point of the weapon's length, above the trigger. The weapon had an auto fire mode that provided a high rate of fire."
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/stw48.png"

-- Viewmodel & Entity Properties
SWEP.UseHands = true
SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_stw48.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_stw48.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-11, 4, -3.3),
    ang = Angle(-10, 0, -180),
    scale = 1.2,
}

-- Special Properties
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "SMG1_Grenade"

-- Damage & Tracer
SWEP.Damage = 31
SWEP.DamageMin = 22
SWEP.Range = 382
SWEP.RangeMin = 221
SWEP.Penetration = 1

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 34
SWEP.ExtendedClipSize = 45
SWEP.ReducedClipSize = 15

SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 0.43
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.6

SWEP.Delay = 60 / 323
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

SWEP.AccuracyMOA = 0.56
SWEP.HipDispersion = 417
SWEP.MoveDispersion = 50

-- Ammo, Sounds & MuzzleEffect
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 110 
SWEP.ShootPitch = 100 
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "armas3/dlt20.wav"
SWEP.ShootSound = "armas3/dlt20.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(250, 0, 0)

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-3.227, -1.923, 1),
    Ang = Angle(0,-0.7, 5),
     Magnification = 1.2,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

-- Holdtype
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, 1, 0)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.CustomizePos = Vector(9.824, 2, -7)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.HolsterPos = Vector(1, 0, 1)
SWEP.HolsterAng = Angle(-10, 12, 0)

-- Attachments
SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "None", 
        Slot = "optic", 
        Bone = "stw48",
        VMScale = Vector(0.8, 0.8, 0.8),
        Offset = {
            vpos = Vector(-0.250, -2, 2),
            vang = Angle(90, 0, -90),
        },
        CorrectiveAng = Angle(0, 0, 0),
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
        Bone = "stw48",
        VMScale = Vector(1, 1, 1),
        Offset = {
            vpos = Vector(-0.250, -1, 10.3),
            vang = Angle(90, 0, -90),
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        VMScale = Vector(0.8, 0.8, 0.8),
        Bone = "stw48",
        Offset = {
            vpos = Vector(0.8, -1, 6),
            vang = Angle(90, 0, 0),
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
        Bone = "stw48",
        Offset = {
            vpos = Vector(0.6, -1.0, -0.425),
            vang = Angle(90, 0, -90),
        },
    },       
    {
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        Bone = "stw48",
        Offset = {
            vpos = Vector(0.3, -2, -2),
            vang = Angle(90, 0, -70),
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