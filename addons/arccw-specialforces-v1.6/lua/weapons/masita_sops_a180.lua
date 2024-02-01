AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "A-180"
SWEP.Trivia_Class = "Blaster Pistol"
SWEP.Trivia_Desc = "he A-180 blaster, also known as the A180 pistol, was a modular blaster manufactured by BlasTech Industries. It was a highly versatile design with multiple configurations that could be easily reconfigured from a blaster pistol to a blaster rifle, a sniper rifle/longblaster, or an portable ion launcher depending on the situation."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/a180.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_a180.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_a180.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-15, 7.5, -5),
    ang = Angle(-10, 0, 180)
}

-- Damage & Entity Options
SWEP.Damage = 41
SWEP.DamageMin = 27
SWEP.RangeMin = 177
SWEP.Range = 289
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.PrimaryClipSize = 15
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 10

SWEP.Num = 1 
SWEP.Recoil = 0.28
SWEP.RecoilSide = 0.42
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 170
SWEP.MoveDispersion = 267

SWEP.Delay = 60 / 290
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
SWEP.ShootPitchVariation = 0.05
SWEP.ShootSound = "armas3/a180_1.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.GMMuzzleEffect = false 

SWEP.MuzzleEffectAttachment = 1 
SWEP.ProceduralViewBobAttachment = 1
SWEP.MuzzleFlashColor = Color(250, 0, 0)

SWEP.IronSightStruct = {
    Pos = Vector(-6.126, -4.178, 3.4),
    Ang = Angle(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 55,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "pistol"
SWEP.HoldtypeSights = "revolver"
SWEP.HoldtypeCustomize = "slam"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.SprintPos = Vector(1, -6, -5)
SWEP.SprintAng = Angle(40, 0, 0)

SWEP.ActivePos = Vector(-2, 3, 3)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.CustomizePos = Vector(8, 0, 3)
SWEP.CustomizeAng = Angle(5, 30, 30)

-- Attachments
SWEP.AttachmentElements = {
    ["a180_barrele"] = {
        VMBodygroups = {
            {ind = 1, bg = 1},
        },
    },
    ["a180_grip"] = {
        VMBodygroups = {
            {ind = 2, bg = 1},
        },
    },
}
SWEP.Attachments = {   
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        Bone = "a180",
        Offset = {
            vpos = Vector(0.2, -1, 0),
            vang = Angle(90, 0, -90),
        },
        CorrectiveAng = Angle(0, 0, 0),
        CorrectivePos = Vector(0, 0, -0.025),
    },  
    {
        PrintName = "Tactical",
        DefaultAttName = "None",
        Slot = {"tactical", "tac_pistol", "tac"},
        VMScale = Vector(0.8, 0.8, 0.8),
        Bone = "a180",
        Offset = {
            vpos = Vector(0.5, -0.5, 5),
            vang = Angle(90, 0, 0),
        },
    },  
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Barrel",
        DefaultAttName = "None",
        Slot = "a180_barrele",
    },    
    {
        PrintName = "Grip",
        DefaultAttName = "None",
        Slot = "a180_grip",

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
        PrintName = "Killcounter",
        DefaultAttName = "None",
        Slot = {"killcounter"},
        Bone = "a180",
        Offset = {
            vpos = Vector(0.9, -0.5, 1),
            vang = Angle(90, 0, -90),
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
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 1.20},
        },
    },
}