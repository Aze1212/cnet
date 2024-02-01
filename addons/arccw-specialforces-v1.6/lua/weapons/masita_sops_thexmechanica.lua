AddCSLuaFile()

SWEP.Base = "arccw_imperialmasita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 1 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Special Forces - Galactic & Misc."
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "'Thex Mechanica'"
SWEP.Trivia_Class = "Blaster Revolver"
SWEP.Trivia_Desc = "Yours, until the last flame dies and all words have been spoken."
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/sopsmisc/thexmechanica.png"

SWEP.HideViewmodel = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/heated/c_the_last_word_ex.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_a180.mdl"
SWEP.ViewModelFOV = 58
SWEP.MirrorVMWM = true
SWEP.NoHideLeftHandInCustomization = true
SWEP.WorldModelOffset = {
    pos = Vector(-19, 6, -5),
    ang = Angle(-10, 0, 180)
}

-- Damage & Entity options
SWEP.Damage = 77
SWEP.RangeMin = 143
SWEP.DamageMin = 51
SWEP.Range = 298
SWEP.Penetration = 1
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 478

SWEP.TracerNum = 1
SWEP.TracerCol = Color(25, 125, 255)
SWEP.TracerWidth = 10
SWEP.PhysTracerProfile = "apex_bullet_energy"
SWEP.Tracer = "arccw_apex_tracer_energy_sniper"
SWEP.HullSize = 1.5
SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 8
SWEP.AmmoPerShot = 1

SWEP.Recoil = 1.3
SWEP.RecoilPunch = 1.4
SWEP.RecoilSide = 0.2
SWEP.RecoilRise = 0.17

SWEP.Delay = 60 / 200
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

SWEP.AccuracyMOA = 0.22 -- accuracy in Minutes of Angle. There are 60 MOA in a degree.
SWEP.HipDispersion = 530 -- inaccuracy added by hip firing.
SWEP.MoveDispersion = 50

SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false 

SWEP.MuzzleEffectAttachment = 1 
SWEP.ProceduralViewBobAttachment = 1
SWEP.MuzzleFlashColor = Color(0, 0, 250)

-- Ammo & Stuff
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 150
SWEP.ShootPitch = 100
SWEP.ShootPitchVariation = 0.2

SWEP.FirstShootSound = "weapons/duality/dualityfire2.wav"
SWEP.ShootSound = "weapons/duality/dualityfire2.wav"
SWEP.ShootSoundSilenced = "weapon/venator/dc17_badbatch.wav"

SWEP.IronSightStruct = {
    Pos = Vector(-5.373, -11.532, 1.552),
    Ang = Angle(0, 0, 0),
     Magnification = 1.5,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 60,
}

SWEP.HoldtypeHolstered = "normal"
SWEP.HoldtypeActive = "revolver"
SWEP.HoldtypeSights = "revolver"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER

SWEP.ActivePos = Vector(0, -3, 2)
SWEP.ActiveAng = Angle(0, 0, 0)

SWEP.SprintPos = Vector(-0.403, -12.664, -10.252)
SWEP.SprintAng = Angle(45, -1.407, 0)

SWEP.HolsterPos = Vector(0.532, -6, 0)
SWEP.HolsterAng = Angle(-15, 0, 0)

SWEP.CustomizePos = Vector(12.569, -9.849, -0.32)
SWEP.CustomizeAng = Angle(33.769, 31.658, 41.507)

-- Attachments 
SWEP.Attachments = {
    {
        PrintName = "Energization", 
        DefaultAttName = "Standard",
        Slot = {"ammo", "ammo_masita"},
    },
    {
        PrintName = "Grip",
        Slot = "grip",
        DefaultAttName = "Standard Grip"
    },
    {
        PrintName = "Perk",
        DefaultAttName = "None",
        Slot = {"perk", "mw3_pro"},
    },
}

SWEP.Animations = {
    ["idle"] = {
        Source = "idle"
    },
    ["fire"] = {
        Source = {"shoot"},
        Time = 0.9,
    },
    ["fire_iron"] = {
        ShellEjectAt = 0,
        Source = {"shoot"}
    },
    ["draw"] = {
        Source = "draw",
        SoundTable = {
            {s = "weapons/lastword/lwdraw.wav", t = 0.1},
        },
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
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
        SoundTable = {
            {s = "weapons/lastword/lwreload.wav", t = 0.1/30},
        },
    },
}