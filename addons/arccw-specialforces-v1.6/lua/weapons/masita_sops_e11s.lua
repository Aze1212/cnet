AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Empire Weapons"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "E-11s"
SWEP.Trivia_Class = "Blaster Sniper Rifle"
SWEP.Trivia_Desc = "Blastech's E-11 platform was considered to be one of the most successful blaster designs in history. It was no surprise that when the Galactic Empire wanted a dedicated sniper rifle, the company looked to its most successful design for inspiration. The E-11s used the same frame, but incorporated a composite alloy buttstock and the barrel was double the length than a regular E-11 medium blaster rifle. The elongated barrel featured the same perforated shroud and heat-abating fins the E-11 was known for. Unfortunately, heat management problems reduced the weapon's fire rate well below that of market competitors. The Empire deployed E-11s with scout troopers, infantry platoon sharpshooters and special forces snipers. Other than the Empire, Blastech sold E-11s to special law-enforcement units, planetary defense forces; and permitted bounty hunters and mercenaries. The prevalence of the weapon meant they found their way onto the black market usually through salvage from battlefields or hijacked factory shipments."
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/e11s.png"

-- Viewmodel & Entity Properties
SWEP.ViewModel = "models/weapons/ven/custom/longrange/sniper/e11s/e11s_rifle.mdl"
SWEP.WorldModel = "models/weapons/ven/custom/longrange/sniper/e11s/e11s_worldmodel.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = true
SWEP.WorldModelOffset = {
    pos = Vector(-8, 3, -6),
    ang = Angle(-5, 0, -180),
    scale = 1.2,
}

-- Damage & Tracer
SWEP.Damage = 134
SWEP.DamageMin = 113
SWEP.Range = 894
SWEP.RangeMin = 542
SWEP.Penetration = 22

SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 500
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 10
SWEP.ExtendedClipSize = 15
SWEP.ReducedClipSize = 5

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 0.28
SWEP.RecoilSide = 0.42
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 170
SWEP.MoveDispersion = 267

SWEP.Delay = 60 / 75
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 1,
    }, 
    {
        Mode = 0
    }
}

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.40
SWEP.SightTime = 0.4 / 1.25

-- Ammo, Sounds & MuzzleEffect
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.GMMuzzleEffect = false
SWEP.FastMuzzleEffect = nil
SWEP.MuzzleFlashColor = Color(250, 0, 0)
SWEP.Primary.Ammo = "ar2"

SWEP.ShootVol = 140
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.04

SWEP.FirstShootSound = nil
SWEP.ShootSound = "weapons/repsniper2.mp3"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.MuzzleEffectAttachment = 1
SWEP.CaseEffectAttachment = 1

-- Ironsight
SWEP.IronSightStruct = {
    Pos = Vector(-3, -5.161, 1.784),
    Ang = Vector(0, 0, -3.113),
     Magnification = 1.50,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 34,
}

-- Holdtype
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN

SWEP.ActivePos = Vector(0, 4, 1)
SWEP.ActiveAng = Angle(1, -0.5, 0)

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.CustomizePos = Vector(9.824, 2, -2.897)
SWEP.CustomizeAng = Angle(12.149, 30.547, 0)

-- Attachments
SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "None", 
        Slot = "optic", 
        Bone = "E11S_CONTR",
        Offset = {
            vpos = Vector(0.1, -4, 1),
            vang = Angle(0, -90, 0),
        },
        CorrectiveAng = Angle(0, -180, 0),
        CorrectivePos = Vector(0, 0, -0.125),
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
        Bone = "E11S_CONTR",
        Offset = {
            vpos = Vector(0.1, 28, -0.3),
            vang = Angle(0, -90, 0),
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        Bone = "E11S_CONTR",
        Offset = {
            vpos = Vector(0.5, 17, -0.4),
            vang = Angle(90, -90, 0),
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
        Bone = "E11S_CONTR",
        Offset = {
            vpos = Vector(0.6, -0.65, 0),
            vang = Angle(0, -90, 0),
        },
    },       
    {
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        Bone = "E11S_CONTR",
        Offset = {
            vpos = Vector(0.9, 9, -0.3),
            vang = Angle(0, -90, 0),
        },
    },        
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = "shoot",
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
        LHIK = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 0.1/30},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 2},
        },
    },
}