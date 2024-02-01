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
SWEP.PrintName = "Personal Lightsaber" --Name of the lightsaber
SWEP.Class = "weapon_lightsaber_personal" --The file name of this swep
SWEP.DualWielded = false --Should this be a dual wielded saber?
SWEP.CanMoveWhileAttacking = true -- Can the user move while attacking
SWEP.MaxForce = 100 --The maximum amount of force in the meter
SWEP.RegenSpeed = 1 --The MULTIPLIER for the regen speed. Half speed = 0.5, Double speed = 2, etc.
SWEP.CanKnockback = true --Should this saber be able to push people back when they get hit?
SWEP.ForcePowerList = { "Force Leap", "Meditate" } 
--Force powers you want the saber to have ( REMEMBER TO PUT A COMMA AFTER EACH ONE, AND COPY THE TITLE EXACTLY AS IT'S LISTED )
--For a list of options, just look at the keys in autorun/client/wos_forcematerialbuilding.lua
SWEP.UseSkills = true
SWEP.PersonalLightsaber = true

--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
--- EDIT DAMAGE, HILT, COLOR, AND OTHER PROPERTIES IN THE wos/advswl/config/crafting/sh_craftwos.lua FILE! ---
-----------------------------------------------------------END OF EDIT----------------------------------------------------------------


if !SWEP.DualWielded then
	SWEP.Base = "wos_adv_single_lightsaber_base"
else
	SWEP.Base = "wos_adv_dual_lightsaber_base"
end



if CLIENT then
	killicon.Add( SWEP.Class, "lightsaber/lightsaber_killicon", color_white )
end