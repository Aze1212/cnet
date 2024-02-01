--[[-------------------------------------------------------------------
	Modified Lightsaber:
		Runs on the intuitive wOS Lightsaber Base
			Powered by
						  _ _ _    ___  ____  
				__      _(_) | |_ / _ \/ ___| 
				\ \ /\ / / | | __| | | \___ \ 
				 \ V  V /| | | |_| |_| |___) |
				  \_/\_/ |_|_|\__|\___/|____/ 
											  
 _____         _                 _             _           
|_   _|__  ___| |__  _ __   ___ | | ___   __ _(_) ___  ___ 
  | |/ _ \/ __| '_ \| '_ \ / _ \| |/ _ \ / _` | |/ _ \/ __|
  | |  __/ (__| | | | | | | (_) | | (_) | (_| | |  __/\__ \
  |_|\___|\___|_| |_|_| |_|\___/|_|\___/ \__, |_|\___||___/
                                         |___/             
----------------------------- Copyright 2022, David "King David" Wiltos ]]--[[
							  
	Lua Developer: King David
	Contact: www.wiltostech.com
		
-- Copyright 2022, David "King David" Wiltos ]]--

AddCSLuaFile()


SWEP.Author = "Robotboy655 + King David"
SWEP.Category = "Lightsabers"
SWEP.Contact = ""
SWEP.RenderGroup = RENDERGROUP_BOTH
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawWeaponInfoBox = false
SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
SWEP.ViewModelFOV = 55
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

------------------------------------------------------------THINGS YOU WILL EDIT ARE BELOW HERE-------------------------------------------------------------------------
SWEP.PrintName = "Nightsisters Blade" --Name of the lightsaber
SWEP.Class = "weapon_nightsisterblade_wos" --The file name of this swep
SWEP.DualWielded = true --Should this be a dual wielded saber?
SWEP.CanMoveWhileAttacking = true -- Can the user move while attacking
SWEP.SaberDamage = 150 --How much damage the saber does when it's being swung
SWEP.SaberBurnDamage = 0 -- How much damage the saber does when it's colliding with someone ( coming in contact with laser )
SWEP.MaxForce = 1000 --The maximum amount of force in the meter
SWEP.RegenSpeed = 5 --The MULTIPLIER for the regen speed. Half speed = 0.5, Double speed = 2, etc.
SWEP.CanKnockback = true --Should this saber be able to push people back when they get hit?
SWEP.ForcePowerList = {"Advanced Cloak", "Sisters Dagger", "Force Heal", "Sisters Apparitions", "Ichor Bolt", "Group Heal", "Essence of Ichor"} 
--Force powers you want the saber to have ( REMEMBER TO PUT A COMMA AFTER EACH ONE, AND COPY THE TITLE EXACTLY AS IT'S LISTED )
--For a list of options, just look at the keys in autorun/client/wos_forcematerialbuilding.lua

--Use these options to overwrite the player's commands
SWEP.UseHilt = "models/starwars/cwa/lightsabers/felucia1.mdl" -- Model path of the hilt
SWEP.UseLength = 24 -- Length of the saber 
SWEP.UseWidth = 2 -- Width of the saber
SWEP.UseColor = Color(0,255,0) -- RGB Color of saber. Red = Color( 255, 0, 0 ) Blue = Color( 0, 0, 255 ), etc.
SWEP.UseDarkInner = 1 -- Does it have a dark inner? 1 = true
SWEP.UseLoopSound = false -- The loop sound path
SWEP.UseSwingSound = false -- The swing sound path
SWEP.UseOnSound = false -- The on sound path
SWEP.UseOffSound = false -- The off sound path
SWEP.UseGrip = "Reverse Blade ( Left )"

--These are the ones for the second saber for dual wielding. If you are using a single saber, this doesn't do shit
SWEP.UseSecHilt = "models/starwars/cwa/lightsabers/felucia1.mdl"
SWEP.UseSecLength = 18
SWEP.UseSecWidth = 2
SWEP.UseSecColor = Color(0,255,0)
SWEP.UseSecDarkInner = 1
SWEP.UseSecGrip = "Reverse Blade ( Left )"

SWEP.SecCustomSettings = 

{

Blade = "Mastered",

}
SWEP.CustomSettings = 

{

Blade = "Mastered",

}
-----------------------------------------------------------END OF EDIT----------------------------------------------------------------


if !SWEP.DualWielded then
	SWEP.Base = "wos_adv_single_lightsaber_base"
else
	SWEP.Base = "wos_adv_dual_lightsaber_base"
end



if CLIENT then
	killicon.Add( SWEP.Class, "lightsaber/lightsaber_killicon", color_white )
end