--[[-------------------------------------------------------------------
	Lightsaber Force Powers:
		The available powers that the new saber base uses.
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

local TREE = {}

--Name of the skill tree
TREE.Name = "Consular Path"

--Description of the skill tree
TREE.Description = "Learn the way of the Consular"

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/characterstats/characterstats.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 255, 0, 0, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 6

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.UserGroups = false

TREE.JobRestricted = { "TEAM_CONSULAR" }

TREE.Tier = {}

--Tier format is as follows:
--To create the TIER Table, do the following
--TREE.Tier[ TIER NUMBER ] = {} 
--To populate it with data, the format follows this
--TREE.Tier[ TIER NUMBER ][ SKILL NUMBER ] = DATA
--Name, description, and icon are exactly the same as before
--PointsRequired is for how many skill points are needed to unlock this particular skill
--Requirements prevent you from unlocking this skill unless you have the pre-requisite skills from the last tiers. If you are on tier 1, this should be {}
--OnPlayerSpawn is a function called when the player just spawns
--OnPlayerDeath is a function called when the player has just died
--OnSaberDeploy is a function called when the player has just pulled out their lightsaber ( assuming you have SWEP.UsePlayerSkills = true )


TREE.Tier[1] = {}
TREE.Tier[1][1] = {
	Name = "Heal",
	Description = "Reflect fuck all back to the enemy",
	Icon = "wos/forceicons/reflect.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Force Heal" ) end,
}

TREE.Tier[1][2] = {
	Name = "Group Heal",
	Description = "Reflect even more fuck all back to the enemy",
	Icon = "wos/forceicons/reflect.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Group Heal" ) end,
}

TREE.Tier[1][3] = {
	Name = "Health 1",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[1][4] = {
    Name = "Damage 1",
    Description = "Adds 25 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Teleport",
	Description = "Start Teleporting",
	Icon = "wos/forceicons/cloak.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Teleport" ) end,
}

TREE.Tier[2][2] = {
	Name = "Health 2",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2][3] = {
    Name = "Damage 2",
    Description = "Adds 10 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

TREE.Tier[3] = {}
TREE.Tier[3][1] = {
	Name = "Overdrive Beam",
	Description = "Charge your force powers",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Overdrive Beam" ) end,
}

TREE.Tier[3][3] = {
	Name = "Health 3",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[3][4] = {
    Name = "Damage 3",
    Description = "Adds 10 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

TREE.Tier[4] = {}
TREE.Tier[4][1] = {
	Name = "Diamond Storm",
	Description = "Diamond stormier",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Diamond Storm" ) end,
}

TREE.Tier[4][2] = {
	Name = "Health 4",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4][3] = {
    Name = "Damage 4",
    Description = "Adds 10 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

TREE.Tier[5] = {}
TREE.Tier[5][1] = {
	Name = "Force Stasis",
	Description = "Freeze your enemies where they stand",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Force Stasis" ) end,
}

TREE.Tier[5][2] = {
	Name = "Health 4",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 50 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5][3] = {
    Name = "Damage 4",
    Description = "Adds 10 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

TREE.Tier[6] = {}
--[[-------------------
TREE.Tier[5][1] = {
	Name = "Force",
	Description = "Freeze your enemies where they stand",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Force Stasis" ) end,
}
]]

TREE.Tier[6][1] = {
	Name = "Health 6",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[6][2] = {
    Name = "Damage 6",
    Description = "Adds 10 damage to your lightsaber",
    Icon = "wos/skilltrees/ravager/comb.png",
    PointsRequired = 1,
    Requirements = {},
    OnPlayerSpawn = function( ply ) end,
    OnPlayerDeath = function( ply ) end,
    OnSaberDeploy = function( wep )
        wep.SaberDamage = wep.SaberDamage + 10
    end,
}

wOS:RegisterSkillTree( TREE )