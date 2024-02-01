AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3

SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "DC-A4"
SWEP.Trivia_Class = "Blaster-Experimental Rifle"
SWEP.Trivia_Desc = "An ancient instrument of war, renewed and enhanced by BlasTech Industries."
SWEP.Trivia_Year = 2023
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.IconOverride = "entities/sopsmisc/dc16a4.png"

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_khvostov7g0x.mdl"
SWEP.WorldModel = "models/arccw/bf2017/w_e11.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = false
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.009
}


-- Special properties
SWEP.ShellModel = "models/shells/shell_556.mdl"
SWEP.ShellPitch = 95
SWEP.ShellScale = 1.4

-- Damage & Entity Options
SWEP.Damage = 43
SWEP.DamageMin = 23
SWEP.RangeMin = 237
SWEP.Range = 549
SWEP.Penetration = 1
SWEP.DamageTypeHandled = false

SWEP.MuzzleVelocity = 400

SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 125, 255)
SWEP.TracerWidth = 10
SWEP.PhysTracerProfile = "apex_bullet_energy"
SWEP.Tracer = "arccw_apex_tracer_energy_sniper"
SWEP.HullSize = 1.5
SWEP.AmmoPerShot = 1

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 34
SWEP.ExtendedClipSize = 20
SWEP.ReducedClipSize = 10

SWEP.MaxRecoilBlowback = 1
SWEP.Num = 1 

SWEP.VisualRecoilMult = 0
SWEP.Recoil = 0.98
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
SWEP.FirstShootSound = "weapons/khvostov7g0x/kvfire1.wav"
SWEP.ShootSound = "weapons/khvostov7g0x/kvfire2.wav", "weapons/khvostov7g0x/kvfire3.wav", "weapons/khvostov7g0x/kvfire4.wav", "weapons/khvostov7g0x/kvfire5.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false 

SWEP.CaseEffectAttachment = 2
SWEP.MuzzleEffectAttachment = 1 
SWEP.MuzzleFlashColor = Color(0, 0, 250)

SWEP.IronSightStruct = {
    Pos = Vector(-6.244, -9.494, 1.947),
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

SWEP.ActivePos = Vector(-2, -3.1, 2)
SWEP.ActiveAng = Angle(1, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-4.633, 36.881, 0)

SWEP.CustomizePos = Vector(7, -7, -1.206)
SWEP.CustomizeAng = Angle(18.291, 30.954, 17.587)

-- Attachments
SWEP.DefaultElements = {"dca4"}
SWEP.AttachmentElements = {
    ["dca4"] = {
        WMElements = {
            {
                Model = "models/weapons/c_khvostov7g0x.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1, 1, 1),
                Offset = {
                    pos = Vector(-1650, 800, -450),
                    ang = Angle(-10, 0, 180)
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(3200, 200, -800),
                    ang = Angle(-15, 0, 180)
                },
                IsMuzzleDevice = true
            },            
        }, 
    }
}WMOverride = "models/weapons/c_khvostov7g0x.mdl"


SWEP.Attachments = {    
    {
        PrintName = "Sight",
        DefaultAttName = "None",
        Slot = "optic",
        WMScale = Vector(111, 111, 111),
        Bone = "WeaponBone",
        Offset = {
            vpos = Vector(0, -6, 1.8),
            vang = Angle(0, 90, 180),
            wpos = Vector(600, 100, -535),
            wang = Angle(-10, -0.50, 180)
        },
        CorrectiveAng = Angle(0, -180, 0),
        CorrectivePos = Vector(0, 0, -0),
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
        Bone = "WeaponBone",
        WMScale = Vector(111, 111, 111),
        VMScale = Vector(1.3,1.3,1.3),
        Offset = {
            vpos = Vector(0.1, -30, 3),
            vang = Angle(0, 90, 180),
            wpos = Vector(3520, 100, -908),
            wang = Angle(-10, -1, 180)
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
        Bone = "WeaponBone",
        Offset = {
            vpos = Vector(0.5, -4, 4.5),
            vang = Angle(90, 90, -90),
            wpos = Vector(500, 145, -200),
            wang = Angle(-10, 0, 180)
        },
    },     
    {
        PrintName = "Charms",
        DefaultAttName = "None",
        Slot = {"charm"},
        Bone = "WeaponBone",
        WMScale = Vector(111, 111, 111),
        Offset = {
            vpos = Vector(0.9, -7.5, 7.5),
            vang = Angle(90, 90, -90),
            wpos = Vector(1100, 210, -0),
            wang = Angle(-10, 0, 180)
        },
    },   
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = "shoot1",
        ShellEjectAt = 0,
    },
    ["fire_iron"] = {
        Source = "shoot1",
        ShellEjectAt = 0,
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = "everfall/weapons/miscellaneous/draw_holster/deploy_draw/gunfoley_blaster_draw_var_01.mp3", t = 0.1/30},
        },
    },
    ["holster"] = {
        SoundTable = {
            {s = "everfall/weapons/miscellaneous/draw_holster/undeploy_sheathe/gunfoley_blaster_sheathe_var_04.mp3", t = 0.1/30},
        },
    },
    ["reload"] = {
        Source = "reload",
        LHIK = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        SoundTable = {
            {s = "weapons/khvostov7g0x/kvreload.wav", t = 5/30},
        },
    },
}