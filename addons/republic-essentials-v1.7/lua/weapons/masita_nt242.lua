AddCSLuaFile()

SWEP.Base = "arccw_masita_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 3 -- Change this if you want to select the weapon with other number

-- Trivia
SWEP.Category = "[ArcCW] Republic Essentials - Masita"
SWEP.Credits = "Kraken/Masita"
SWEP.PrintName = "NT-242"
SWEP.Trivia_Class = "Blaster Sniper Rifle"
SWEP.Trivia_Desc = "The NT-242 was a type of sniper rifle. The NT-242 was considered a tank buster by many users and was one of the heaviest longblasters. The NT-242 was powerful at range, and could be modified to have a disruptor shot which could engage vehicles."
SWEP.Trivia_Manufacturer = "Unknown"
SWEP.Trivia_Calibre = "Tibanna Gas"
SWEP.Trivia_Year = 2023
SWEP.IconOverride = "entities/masita/nt242.png"

SWEP.UseHands = true

SWEP.ViewModel = "models/everfall/weapons/viewmodels/c_nt242.mdl"
SWEP.WorldModel = "models/everfall/weapons/worldmodels/w_nt242.mdl"
SWEP.ViewModelFOV = 60
SWEP.MirrorVMWM = false
SWEP.HideViewmodel = false
SWEP.WorldModelOffset = {
    pos = Vector(0, 0, 0),
    ang = Angle(0, 0, 0),
    bone = "ValveBiped.Bip01_R_Hand",
    scale = 0.009
}

SWEP.NoHideLeftHandInCustomization = false

SWEP.DefaultWMBodygroups = "02"
SWEP.DefaultBodygroups = "02"

SWEP.BodyDamageMults = {
    [HITGROUP_HEAD] = 2,
    [HITGROUP_CHEST] = 1.3,
    [HITGROUP_LEFTARM] = 0.9,
    [HITGROUP_RIGHTARM] = 0.9,
}

SWEP.Damage = 176
SWEP.RangeMin = 273
SWEP.DamageMin = 69
SWEP.Range = 1072
SWEP.Penetration = 1.3
SWEP.DamageType = DMG_BULLET
SWEP.MuzzleVelocity = 400
SWEP.TraceNum = 1
SWEP.PhysTracerProfile = 1
SWEP.TracerNum = 1
SWEP.Tracer = "tracer_red"
SWEP.TracerCol = Color(250, 0, 0)
SWEP.HullSize = 1.5
SWEP.ChamberSize = 0
SWEP.Primary.ClipSize = 10
SWEP.Recoil = 1.4
SWEP.RecoilSide = 0.3
SWEP.RecoilRise = 0.19
SWEP.Delay = 60 / 185
SWEP.Num = 1
SWEP.Firemodes = {
    {
        Mode = 1
    },
    {
        Mode = 0
    },         
}

SWEP.AccuracyMOA = 0.55
SWEP.HipDispersion = 535
SWEP.MoveDispersion = 60
SWEP.NoFlash = nil
SWEP.MuzzleEffect = "wpn_muzzleflash_dc17_red"
SWEP.FastMuzzleEffect = nil
SWEP.GMMuzzleEffect = false
SWEP.MuzzleFlashColor = Color(255, 0, 0)
SWEP.Primary.Ammo = "ar2"
SWEP.ShootVol = 100
SWEP.ShootPitch = 100
SWEP.ShootSound = "armas/disparos/nt242.mp3"
SWEP.ShootSoundSilenced = "armas/disparos/silenced_sniper.mp3"
SWEP.IronSightStruct = {
    Pos = Vector(-3.71, -5.549, 1.526),
    Ang = Angle(0, 0, 0),
     Magnification = 1.2,
     SwitchToSound = "weapon_hand/ads/0242-00001a46.mp3",
     SwitchFromSound = "weapon_hand/ads/0242-00001a43.mp3",
     ViewModelFOV = 50,
}
SWEP.HoldtypeHolstered = "passive"
SWEP.HoldtypeActive = "ar2"
SWEP.HoldtypeSights = "rpg"
SWEP.AnimShoot = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ActivePos = Vector(1, 1, 1)
SWEP.ActiveAng = Angle(0, 0, 0)
SWEP.SprintPos = Vector(1, 0, -1)
SWEP.SprintAng = Angle(10, 20, -40)
SWEP.HolsterPos = Vector(0.2, -1, -1)
SWEP.HolsterAng = Vector(-15, 30, -15)
SWEP.CustomizePos = Vector(10.824, 0, 0.897)
SWEP.CustomizeAng = Angle(12.149, 27.547, 45)

SWEP.InBipodPos = Vector(-8, 0, -4)
SWEP.InBipodMult = Vector(2, 1, 1)

SWEP.Bipod_Integral = true -- Integral bipod (ie, weapon model has one)
SWEP.BipodDispersion = 1 -- Bipod dispersion for Integral bipods
SWEP.BipodRecoil = 1 -- Bipod recoil for Integral bipods

SWEP.DefaultElements = {"nt242"}
SWEP.AttachmentElements = {
    ["nt242"] = {
        WMElements = {
            {
                Model = "models/everfall/weapons/worldmodels/w_nt242.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(1.1, 1.1, 1.1),
                WBodygroups = {{ind = 1, bg = 1}},
                Offset = {
                    pos = Vector(1200, 0, -570),
                    ang = Angle(-15, 180, 180)
                }
            },
            {
                Model = "models/hunter/plates/plate.mdl",
                Bone = "ValveBiped.Bip01_R_Hand",
                Scale = Vector(0, 0, 0),
                Offset = {
                    pos = Vector(4700, 150, -1500),
                    ang = Angle(-15, 0, 100)
                },
                IsMuzzleDevice = true
            },
        },
    },
}
WMOverride = "models/everfall/weapons/worldmodels/w_nt242.mdl"

SWEP.Attachments = {
    {
        PrintName = "Sight",
        DefaultAttName = "Standard", 
        Slot = "optic",
        WMScale = Vector(111, 111, 111),
        Bone = "nt242", 
        Offset = {
            vpos = Vector(0, -1.1, 4.93),
            vang = Angle(90, 0, -90),
            wpos = Vector(900, 150, -750),
            wang = Angle(-15, 0, 180)
        },
        CorrectiveAng = Angle(0, 0, 0),
        CorrectivePos = Vector(0, 0, 0),
    },
    {
        PrintName = "Muzzle",
        DefaultAttName = "Standard",
        Slot = {"muzzle", "dlt19_muzzle", "dc15a_muzzle", "cr2_muzzle", "cr2c_muzzle", "stealth_muzzle", "b1120_muzzle"},
        WMScale = Vector(111, 111, 111),
        Bone = "nt242",
        Offset = {
            vpos = Vector(0.007, 0.98, 40.043),
            vang = Angle(90, 0, 0),
            wpos = Vector(4700, 150, -1500),
            wang = Angle(-15, 0, -90)
        },
    },
    {
        PrintName = "Grip",
        DefaultAttName = "None",
        Slot = {"foregrip", "bipod"},
        WMScale = Vector(111, 111, 111),
        Bone = "nt242", 
        Offset = {
            vpos = Vector(0, 2.253, 15.001),
            vang = Angle(90, 0, -90),
            wang = Angle(165, 180, 0),
        },
        SlideAmount = {
            vmin = Vector(0, 2, 15),
            vmax = Vector(0, 2, 25),
            wmin = Vector(2400, 150, -750), 
            wmax = Vector(2400, 150, -750) 
        },  
    }, 
    {
        PrintName = "Laser/Flashlight", 
        DefaultAttName = "None",
        Slot = {"tactical","tac_pistol"},
        WMScale = Vector(111, 111, 111),
        Bone = "nt242", 
        Offset = {
            vpos = Vector(0.939, 0.982, 14.303),
            vang = Angle(90, 0, 0),
            wpos = Vector(2000, 220, -750),
            wang = Angle(-15, 0, -90)
        },
    },    
    {
        PrintName = "Ammo", 
        DefaultAttName = "Standard",
        Slot = "ammo",
    },  
    {
        PrintName = "Perk", 
        DefaultAttName = "Standard",
        Slot = "perk",
    },
    {
        PrintName = "Charm", 
        DefaultAttName = "None", 
        Slot = {"charm"},
        WMScale = Vector(111, 111, 111),
        Bone = "nt242", 
        Offset = {
            vpos = Vector(0.931, 1.174, 0),
            vang = Angle(90, 0, -90),
            wpos = Vector(900, 245, -470),
            wang = Angle(-10 , 0, -180)
        },
    },          
}
SWEP.Animations = {
    ["idle"] = {
        Source = "idle",
    },
    ["fire"] = {
        Source = "shoot"
    },
    ["draw"] = {
        Source = "draw",
        Mult = 1.1,
        SoundTable = {
            {s = "everfall/weapons/handling/reload_heavy/locknload/023d-00000f08.mp3", t = 1}
        },
    },
    ["reload"] = {
        Source = "reload",
        LHIK = true,
        TPAnim = ACT_HL2MP_GESTURE_RELOAD_AR2, 
        SoundTable = {
            {s = "nt242_r1", t = 3 / 30}, --s sound file
            {s = "everfall/weapons/handling/reload_heavy/locknload/023d-00000f08.mp3", t = 2.2}
        },
    },


sound.Add({
    name =          "nt242_r1",
    channel =       CHAN_ITEM,
    volume =        1.5,
    sound =             "armasclasicas/wpn_republic_medreload.wav"
    }),
}