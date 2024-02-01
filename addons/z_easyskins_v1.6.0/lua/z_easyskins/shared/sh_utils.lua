-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function SH_EASYSKINS.CalcNewID(tbl)

	local highestID = 0
	
	for i=1, #tbl do
		
		if tbl[i].id > highestID then
			highestID = tbl[i].id
		end

	end
	
	return highestID + 1
	
end

function SH_EASYSKINS.BoolToInt(bool)
	
	if bool then 
		return 1
	end
	
	return 0

end

function SH_EASYSKINS.IsSteamID64(str)

	local steamID64Pattern = '^'..string.rep("[0-9]",17)..'$'

	return string.match(str, steamID64Pattern) ~= nil
	
end

function SH_EASYSKINS.GetSteamID64(ply)

	if game.SinglePlayer() then
		return '1'
	else
		return ply:SteamID64()
	end
	
end

function SH_EASYSKINS.InSteamGroup(ply)
	return ply:GetNWBool("easyskins_InSteamGroup",false) 
end

local nameTagCache = {}
function SH_EASYSKINS.HasNameTag(ply)

	if #SH_EASYSKINS.SETTINGS.TAG == 0 then
		return false
	end
	
	local pName = ply:Nick()
	
	-- only return the cache result if the tag didn't change
	if nameTagCache[pName] ~= nil and nameTagCache[pName].tag == SH_EASYSKINS.SETTINGS.TAG then
		return nameTagCache[pName].hasTag
	end
	
	local pHasTag = string.match(pName, SH_EASYSKINS.SETTINGS.TAG) ~= nil
	
	nameTagCache[pName] = {
		tag = SH_EASYSKINS.SETTINGS.TAG,
		hasTag = pHasTag
	}
	
	return pHasTag
	
end

function SH_EASYSKINS.IsPlayerOnline(steamID64)

	if game.SinglePlayer() then
		return player.GetAll()[1]
	else
		return player.GetBySteamID64( steamID64 )
	end
	
end

function SH_EASYSKINS.GetAllPlayersAndGroups()

	local playersAndGroups = {}
	
	-- teams
	for teamNum, t in pairs(team.GetAllTeams()) do
		table.insert(playersAndGroups, { teamNum, t.Name })
	end
	
	-- ULX groups
	if ULib and ULib.ucl and ULib.ucl.groups ~= nil then 
		for usergroupName,usergroup in pairs(ULib.ucl.groups) do
			table.insert(playersAndGroups, { "ULX", usergroupName })
		end
	end
	
	-- XAdmin
	if xAdmin and xAdmin.Groups then
		for _, usergroup in pairs(xAdmin.Groups) do
			if usergroup.Name then
				table.insert(playersAndGroups, { "XAdmin", usergroup.Name })
			elseif usergroup.ID then
				table.insert(playersAndGroups, { "XAdmin2", usergroup.ID })
			end
		end
	end
	
	-- Server Guard
	if serverguard and serverguard.ranks and serverguard.ranks.stored then
		for _, usergroup in pairs(serverguard.ranks.stored) do
			table.insert(playersAndGroups, { "ServerGuard", usergroup.name })
		end
	end
	
	-- SAM
	if sam and sam.ranks then
		for _, rank in pairs(sam.ranks.get_ranks()) do
			table.insert(playersAndGroups, { "SAM", rank.name })
		end
	end
	
	-- sAdmin
	if sAdmin and sAdmin.usergroups then
		for usergroupName, usergroupColor in pairs(sAdmin.usergroups) do
			table.insert(playersAndGroups, { "sAdmin", usergroupName })
		end
	end
	
	-- players
	for _, ply in pairs(player.GetHumans()) do
		
		if game.SinglePlayer() then
			table.insert(playersAndGroups, { "STEAM_0:0:0", "LocalPlayer" })
			break
		end
	
		table.insert(playersAndGroups, { ply:SteamID(), ply:Nick() })
		
	end
	
	return playersAndGroups

end

-- helper function to find a value in a 2 dimensional table
function SH_EASYSKINS.IsInTable(tbl, val)
	
	for key, value in pairs(tbl) do
		
		if istable(value) then
			
			for i=1, #value do
				
				if value[i] == val then
					return true, key
				end
			
			end
			
		end
	
		if value == val then
			return true, key
		end
	
	end
	
	return false

end

function SH_EASYSKINS.IsPlayerInSettingsTbl(tbl, ply)
	
	local steamID = ply:SteamID()
	local usergroup = ply:GetUserGroup()
	local secondaryUsergroup = ply.GetSecondaryUserGroup ~= nil and ply:GetSecondaryUserGroup() or nil
	local t = ply:Team()
	
	if game.SinglePlayer() then
		steamID = "STEAM_0:0:0"
	end
	
	for key, value in pairs(tbl) do
		
		if value[1] == steamID or value[1] == t or value[2] == usergroup or value[2] == secondaryUsergroup then
			return true
		end

	end
	
	return false
	
end

function SH_EASYSKINS.FormatMoney(amount)
	
	amount = math.min(amount,99999999999) or 0
	
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	local formatAmount = left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	
	return SH_EASYSKINS.SETTINGS.CURRENCYSYMBOL..formatAmount
	
end

function SH_EASYSKINS.FormatMoneyToNum(amount)
	return string.Replace(amount,',','')
end