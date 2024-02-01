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
TREE.Name = "Jesters Tree"

--Description of the skill tree
TREE.Description = "WOOF WOOF WOOF WOOF WOOF WOOF WOOF uwu"

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/characterstats/characterstats.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 255, 0, 0, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 6

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.UserGroups = false

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.JobRestricted = {"TEAM_JESTER"}

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
	Name = "Health 1",
	Description = "Adds 200 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply )ply:SetMaxHealth( ply:GetMaxHealth() + 200 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}
TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Force Lightning",
	Description = "hiiii jesterrrrrrrrrrr :3 x3 ;3",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Force Lightning" ) end,
}

TREE.Tier[3] = {}
TREE.Tier[3][1] = {
	Name = "Force 1",
	Description = "Adds 25 force",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnSaberDeploy = function( wep ) wep:SetMaxForce( wep:GetMaxForce() + 25 ) end,
	OnPlayerDeath = function( ply ) end,
}

TREE.Tier[4] = {}
TREE.Tier[4][1] = {
	Name = "Force 2",
	Description = "Adds 25 force",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnSaberDeploy = function( wep ) wep:SetMaxForce( wep:GetMaxForce() + 25 ) end,
	OnPlayerDeath = function( ply ) end,
}

TREE.Tier[5] = {}
TREE.Tier[5][1] = {
	Name = "Vitriolic Discharge",
	Description = "rarw rawr rawr rawr rawr rawr",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Vitriolic Discharge" ) end,
}

TREE.Tier[6] = {}
TREE.Tier[6][1] = {
	Name = "Force Breach",
	Description = "MEOW MEOW MEOW MEOW MEOW MEOW MEOW MEOW MEOW MEOW",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Force Breach" ) end,
}

wOS:RegisterSkillTree( TREE )