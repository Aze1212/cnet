AddCSLuaFile()

SWEP.Base = "arccw_meeks_sw_base"
SWEP.Spawnable = true

SWEP.Category = "[ArcCW] Republic Essentials - Meeks"
SWEP.Credits = "Meeks"
SWEP.PrintName = "Dual DC-17"
SWEP.Trivia_Class = "Dual Blaster Pistol"
SWEP.Trivia_Desc = "The DC-17 hand blaster, also known as DC-17 blaster pistol, was a heavy blaster pistol wielded by the clone troopers of the Grand Army of the Galactic Republic during the Clone Wars. An advanced firearm, it was fielded to elite soldiers in the army, most notably Advanced Recon Commandos, clone trooper commanders, and clone jet troopers."
SWEP.Trivia_Manufacturer = "BlasTech Industries"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = ""

SWEP.Slot = 1

SWEP.UseHands = true

SWEP.ViewModel = "models/arccw/ser/starwars/c_dual_dc-17.mdl"
SWEP.WorldModel = "models/rising/base/c_akimbo.mdl"
SWEP.ViewModelFOV = 80
SWEP.HideViewmodel = false
SWEP.MirrorVMWM = nil
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 180, 180),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.09
}

SWEP.DefaultBodygroups = "000000000000"
SWEP.NoHideLeftHandInCustomization = true
SWEP.Damage = 23
SWEP.RangeMin = 100
SWEP.DamageMin = 17
SWEP.Range = 350
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400

SWEP.DefaultWMSkin = 1
SWEP.DefaultSkin = 1

SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1

SWEP.TracerNum = 1
SWEP.Tracer = "tfa_tracer_blue"
SWEP.TracerCol = Color(0, 0, 255)
SWEP.HullSize = 1.5

SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 31

SWEP.Recoil = 0.345
SWEP.RecoilPunch = 0.6
SWEP.RecoilSide = 0.17
SWEP.RecoilRise = 0.22

SWEP.Delay = 60 / 348
SWEP.Num = 1
SWEP.Firemodes = {
	{
		Mode = 1
	},
    {
        Mode = 2
    },
    {
        Mode = 0
    },        
}

SWEP.AccuracyMOA = 0.34 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 210 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.RecoilDirection = Angle(1.1, 0, 0)
SWEP.RecoilDirectionSide = Angle(0, 1.1, 0)

SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 100
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2
SWEP.ShootSound = "weapons/bf3/dc17.wav"
SWEP.MuzzleFlashColor = Color(0, 0, 255)

SWEP.IronSightStruct = {
    Pos = Vector(0, -7, 1),
    Ang = Angle(0, 0, 0),
     Magnification = 1,
     SwitchToSound = "armasclasicas/wpn_cis_medequip.wav",
     ViewModelFOV = 90,
}
SWEP.HoldtypeHolstered = ""
SWEP.HoldtypeActive = "duel"
SWEP.HoldtypeSights = ""


SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2

SWEP.ActivePos = Vector(0, -5, -0.5)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(0, -14,-10)
SWEP.SprintAng = Angle(40, 0, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Vector(-25, 0, 0)

SWEP.ReloadPos = Vector(0, -5, -0)

SWEP.CustomizePos = Vector(-0.5, -8, -4.897)
SWEP.CustomizeAng = Angle(10, 0, 0)

SWEP.BarrelLength = 60
SWEP.BarrelOffsetSighted = Vector(0, 0, 0)
SWEP.BarrelOffsetHip = Vector(3, 0, -3)

SWEP.DefaultElements = {"akimbo"}
SWEP.AttachmentElements = {
    ["akimbo"] = {
        VMElements = {},
        WMElements = {
            {
                Model = "models/arccw/SW_Battlefront/Weapons/dc17_blaster.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1.1, 1.1, 1.1),
                Offset = {
                    pos = Vector(30, 15, -10),
                    ang = Angle(180, -180, 2)
                }
            },
            {
                Model = "models/arccw/SW_Battlefront/Weapons/dc17_blaster.mdl",
                Bone = "ValveBiped.Bip01_L_Hand",
                Scale = Vector(1.1, 1.1, 1.1),
                Offset = {
                    pos = Vector(-50, 230, -55),
                    ang = Angle(180, -180, 2)
                }
            },
        },            -- change the world model to something else. Please make sure it's compatible with the last one.
    }
}
WMOverride = "models/arccw/SW_Battlefront/Weapons/dc17_blaster.mdl"


--SWEP.Attachments 
SWEP.Attachments = {   
    [1] = {
        PrintName = "Energization", -- print name
        DefaultAttName = "Standard Energization", -- used to display the "no attachment" text
        Slot = "ammo",
    },
    [2] = {
        PrintName = "Internal Modifications", -- print name
        DefaultAttName = "Standard", -- used to display the "no attachment" text
        Slot = "uc_fg",
    },
}


SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["bash"] = {
        Source = "bash"
    },
    ["idle_inspect"] = {
        Source = "lookat01",
        Time = 7,
    },
    ["exit_inspect"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = {"shoot_l", "shoot_r"},
    },
    ["draw"] = {
        Source = "draw",
        Mult = 1.5,
        SoundTable = {
            {
                s = "draw/gunfoley_pistol_draw_var_10.mp3", -- sound; can be string or table
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
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_PHYSGUN,
        SoundTable = {
            {s = "armas/misc/dc17s_dual_reload.wav", t = 0}, 
        },
    },
}