AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Empire Weapons"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "EE-4"
SWEP.Trivia_Class = "Blaster Carabine"
SWEP.Trivia_Desc = "The EE-4 carbine rifle, also known as the EE-4 blaster rifle, was a powerful medium-ranged blaster carbine model that was manufactured by BlasTech Industries during the reign of the Galactic Empire. Successor to the EE-3 carbine rifle, the EE-4's shorter and stubbier barrel allowed the blaster rifle to fire more effectively at close range with spread shots but at the cost of a reduced accuracy at range compared to its predecessor."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/ee4.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_ee4.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_ee4.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-12, 6, -4),
    ang = Angle(-10, 0, 180),
    scale = 1.2,
}

SWEP.DefaultBodygroups  = "00111"

-- Damage & Entity Options
SWEP.Damage = 23
SWEP.DamageMin = 14
SWEP.RangeMin = 126
SWEP.Range = 227
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 472

SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 500
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 44
SWEP.ExtendedClipSize = 56
SWEP.ReducedClipSize = 17

SWEP.VisualRecoilMult = 0.2
SWEP.Recoil = 0.28
SWEP.RecoilSide = 0.42
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 170
SWEP.MoveDispersion = 267

SWEP.Delay = 60 / 1020
SWEP.Num = 1 
SWEP.Firemode = -3
SWEP.Firemodes = {
    {
		Mode = -3,
    },
    {
		Mode = 1,
    },
	{
		Mode = 0,
   	}
}

SWEP.SpeedMult = 1
SWEP.SightedSpeedMult = 0.70
SWEP.SightTime = 0.4 / 1.25

SWEP.Primary.Ammo = "ar2" 
SWEP.ShootVol = 125
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.05
SWEP.FirstShootSound = "armas3/ee4.wav"
SWEP.ShootSound = "armas3/ee4.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.GMMuzzleEffect = false
SWEP.FastMuzzleEffect = nil
SWEP.MuzzleFlashColor = Color(250, 0, 0)

SWEP.MuzzleEffectAttachment = 1 
SWEP.CaseEffectAttachment = 2
SWEP.ProceduralViewBobAttachment = 1

SWEP.IronSightStruct = {
    Pos = Vector(-5.090, -8.242, 2.068),
    Ang = Angle(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

SWEP.SightTime = 0.13
SWEP.SprintTime = 0

SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "smg"
SWEP.HoldtypeSights = "smg"
SWEP.HoldtypeCustomize = "slam"

SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.CanBash = true
SWEP.MeleeDamage = 27
SWEP.MeleeRange = 16
SWEP.MeleeDamageType = DMG_CLUB
SWEP.MeleeTime = 0.5
SWEP.MeleeGesture = nil
SWEP.MeleeAttackTime = 0.2

SWEP.SprintPos = Vector(7, -4, -4)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.ActivePos = Vector(-1, 0, 1)
SWEP.ActiveAng = Angle(0.5, 0.5, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.CustomizePos = Vector(7, -7, -1.206)
SWEP.CustomizeAng = Angle(18.291, 30.954, 17.587)

-- Attachments
SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "None", 
        Slot = "optic", 
        Bone = "ee4",
        VMScale = Vector(0.8, 0.8, 0.8),
        Offset = {
            vpos = Vector(-0.050, -2, -0.5),
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
        Bone = "ee4",
        Offset = {
            vpos = Vector(0, -0.650, 12.4),
            vang = Angle(90, 0, -90),
        },
    },   
    {
        PrintName = "Tactical", 
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        VMScale = Vector(0.5, 0.5, 0.5),
        Bone = "ee4",
        Offset = {
            vpos = Vector(1.2, -0.8, 9),
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
        Bone = "ee4",
        Offset = {
            vpos = Vector(0.8, -0.350, -0.425),
            vang = Angle(90, 0, -90),
        },
    },       
    {
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        Bone = "ee4",
        Offset = {
            vpos = Vector(0.650, -1.4, 0.750),
            vang = Angle(90, 0, -70),
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