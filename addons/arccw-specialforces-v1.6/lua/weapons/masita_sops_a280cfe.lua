AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "A-280CFE"
SWEP.Trivia_Class = "Blaster Rifle"
SWEP.Trivia_Desc = "The A280-CFE (covert field edition) convertible heavy blaster pistol, also known as an A280-CFE blaster rifle or simply a A280-CFE blaster, was a modular version of the A280 blaster rifle. It featured a core pistol that could be reconfigured into an assault rifle or sniper rifle.[1] Captain Cassian Andor used an A280-CFE during the Battle on Jedha, the mission to Eadu, and the Battle of Scarif."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/a280cfe.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_a280cfe.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_a280cfe.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-12, 4.5, -5),
    ang = Angle(-10, 0, 180),
    scale = 1.2,
}

SWEP.DefaultBodygroups  = "000102"

-- Damage & Entity Options
SWEP.Damage = 34
SWEP.DamageMin = 27
SWEP.RangeMin = 177
SWEP.Range = 289
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 400

SWEP.DamageType = DMG_BULLET
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_green"
SWEP.TracerCol = Color(12, 250, 0)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 34
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 10

SWEP.MaxRecoilBlowback = 1
SWEP.Num = 1 

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 0.78
SWEP.RecoilRide = 0.6
SWEP.RecoilSide = 0.4
SWEP.AccuracyMOA = 0.06 
SWEP.HipDispersion = 470
SWEP.MoveDispersion = 267

SWEP.Delay = 60 / 326
SWEP.Firemode = 1
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
SWEP.ShootPitchVariation = 0.05
SWEP.FirstShootSound = "armas3/a280cfe_1.wav"
SWEP.ShootSound = "armas3/a280cfe_2.wav", "armas3/a280cfe_3.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_green"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false 

SWEP.MuzzleEffectAttachment = 1 
SWEP.MuzzleFlashColor = Color(12, 250, 0)

SWEP.IronSightStruct = {
    Pos = Vector(-3.875, -12.188, 2.5),
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

SWEP.SprintPos = Vector(4.019, -5.226, -0.805)
SWEP.SprintAng = Angle(5, 40, 0)

SWEP.ActivePos = Vector(-.5, -3.1, -.1)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.HolsterPos = Vector(4, -3, 2)
SWEP.HolsterAng = Vector(-15, 30, -15)

SWEP.CustomizePos = Vector(7, -7, -1.206)
SWEP.CustomizeAng = Angle(18.291, 30.954, 17.587)

-- Attachments
SWEP.AttachmentElements = {
    ["a280cfe_barrel_short"] = {
        VMBodygroups = {
            {ind = 1, bg = 1},
        },
    },
    ["a280cfe_barrel_sniper"] = {
        VMBodygroups = {
            {ind = 1, bg = 2},
        },
    },
    ["a280cfe_powerpack"] = {
        VMBodygroups = {
            {ind = 4, bg = 1},
        },
    },
    ["a280cfe_stock_assault"] = {
        VMBodygroups = {
            {ind = 5, bg = 0},
        },
    },
    ["a280cfe_stock_heavy"] = {
        VMBodygroups = {
            {ind = 5, bg = 1},
        },
    },
}

SWEP.Attachments = {   
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        Bone = "a280cfe",
        Offset = {
            vpos = Vector(-0.175, -2.6, 3),
            vang = Angle(90, 0, -90),
        },
        CorrectiveAng = Angle(0, 0, 0),
        CorrectivePos = Vector(0, 0, -0.025),
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
        VMScale = Vector(0.7, 0.7, 0.7),
        Bone = "a280cfe",
        Offset = {
            vpos = Vector(0.4, -1.7, 11),
            vang = Angle(90, 0, 20),
        },
    },  
    {
        PrintName = "Foregrip",
        DefaultAttName = "None",
        Slot = {"foregrip"},
        Bone = "a280cfe",
        Offset = {
            vpos = Vector(-0.175, 0, 9),
            vang = Angle(90, 0, -90),
        },
    },  
    {
        PrintName = "Barrel",
        DefaultAttName = "None",
        Slot = {"cfe_barrel"},
    },   
    {
        PrintName = "Stock",
        DefaultAttName = "None",
        Slot = {"cfe_stock"},
    },   
    {
        PrintName = "Energization", 
        DefaultAttName = "Standard",
        Slot = {"ammo", "ammo_masita"},
    },
    {
        PrintName = "Powerpack", 
        DefaultAttName = "None",
        Slot = {"cfe_powerpack"},
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
        Bone = "a280cfe",
        Offset = {
            vpos = Vector(0.4, -1.7, 1),
            vang = Angle(90, 0, -70),
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "a280cfe",
        Offset = {
            vpos = Vector(0.2, -0.5, 1),
            vang = Angle(90, 0, -90),
        },
    },   
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = "fire",
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
            {s = "everfall/weapons/miscellaneous/reload/overheat/overheat_manualcooling_var_02.mp3", t = 12/30},
            {s = "reloading/reload_gentle/mag_eject/023d-00001014.mp3", t = 5/30},
            {s = "reloading/reload_gentle/mag_load/023d-00000dda.mp3", t = 52/30},
            {s = "everfall/weapons/miscellaneous/reload/reset/overheatactivecoolingsuccess_var_04.mp3", t = 72/30},
        },
    },
}