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
TREE.Name = "Sentinel Path"

--Description of the skill tree
TREE.Description = "Learn the way of the sentinel"

--Icon for the skill tree ( Appears in category menu and above the skills )
TREE.TreeIcon = "wos/skilltrees/characterstats/characterstats.png"

--What is the background color in the menu for this 
TREE.BackgroundColor = Color( 255, 0, 0, 25 )

--How many tiers of skills are there?
TREE.MaxTiers = 6

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
TREE.UserGroups = false

TREE.JobRestricted = { "TEAM_SENTINEL" }

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
	Name = "Cloak",
	Description = "Hide for 10s",
	Icon = "wos/forceicons/reflect.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Cloak" ) end,
}

TREE.Tier[1][2] = {
	Name = "Armor 1",
	Description = "Adds 10 Armor to your current Armor",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
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
        wep.SaberDamage = wep.SaberDamage + 25
    end,
}

TREE.Tier[2] = {}
TREE.Tier[2][1] = {
	Name = "Adrenaline",
	Description = "Become full of adrenaline",
	Icon = "wos/forceicons/cloak.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Adrenaline" ) end,
}

TREE.Tier[2][2] = {
	Name = "Armor 2",
	Description = "Adds 25 Armor to your current Armor",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 10 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2][3] = {
	Name = "Health 2",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[2][4] = {
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
	Name = "Shadow Strike",
	Description = "Strike from the Shadows",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Shadow Strike" ) end,
}

TREE.Tier[3][2] = {
	Name = "Armor 3",
	Description = "Adds 25 Armor to your current Armor",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 25 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
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
	Name = "Dual Wield",
	Description = "2 is better than 1",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 2,
	Requirements = {},
	OnPlayerSpawn = function( ply ) 
	ply.CanUseDuals = true end,
	OnPlayerDeath = function( ply ) end,
	
	
}

TREE.Tier[4][2] = {
	Name = "Armor 4",
	Description = "Adds 25 Armor to your current Armor",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 25 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4][3] = {
	Name = "Health 4",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[4][4] = {
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
TREE.Tier[5][2] = {
	Name = "Armor 5",
	Description = "Adds 25 Armor to your current Armor",
	Icon = "wos/skilltrees/characterstats/armor.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetArmor( ply:Armor() + 25 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5][3] = {
	Name = "Health 5",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[5][4] = {
    Name = "Damage 5",
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
TREE.Tier[6][3] = {
	Name = "Health 6",
	Description = "Adds 100 Health to your current Health",
	Icon = "wos/skilltrees/ravager/aid.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) ply:SetMaxHealth( ply:GetMaxHealth() + 100 ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) end,
}

TREE.Tier[6][4] = {
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
TREE.Tier[6][5] = {
    Name = "Cloak",
	Description = "Activate a 10 second cloak",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Cloak" ) end,
}
TREE.Tier[6][6] = {
    Name = "Shadow Strike",
	Description = "Strike from the Shadows",
	Icon = "wos/forceicons/charge.png",
	PointsRequired = 1,
	Requirements = {},
	OnPlayerSpawn = function( ply ) end,
	OnPlayerDeath = function( ply ) end,
	OnSaberDeploy = function( wep ) wep:AddForcePower( "Shadow Strike" ) end,
}

wOS:RegisterSkillTree( TREE )