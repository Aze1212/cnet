-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local profileLink = "https://steamcommunity.com/profiles/%s/?xml=1"
local profileNameRegex = "<steamID><!.CDATA.(.*)]]></steamID>"
local localName = "Local Player"
local steamConnectionErr = "Steam Connection Error"
local nameCache = {}

-- names change often, no point in saving the value in a db 
local function RequestNameFromSteamID(steamID64,callback)

	local playerOnline = SH_EASYSKINS.IsPlayerOnline(steamID64)

	if nameCache[steamID64] ~= nil then
		
		-- if the name was cached, return it
		callback(nameCache[steamID64])
		 
	elseif steamID64 == '1' then

		-- singleplayer player
		callback(localName)
		
	elseif playerOnline then
	
		local pName = playerOnline:Nick()
		
		-- save in cache
		nameCache[steamID64] = pName
		
		-- online player
		callback(pName)
		
	else

		local fullProfileLink = string.format( profileLink, steamID64 )
		
		http.Fetch( fullProfileLink,
		
			function( body, len, headers, code )
			
				local nick = string.match( body, profileNameRegex )
				
				nick = nick or steamConnectionErr
				
				-- add the name to the cache
				nameCache[steamID64] = nick
				
				-- return the matched name from the profile page
				callback(nick)
				
			end,

			function( error )
				
				-- something wrong with the connection
				callback(steamConnectionErr)
				
			end
		)
		
	end

end

local function RetrieveAllPlayerData(ply, callback)

	SV_EASYSKINS.DBGetPlayersFromPurchases(function(data)
	
		local players = {}
		local playerCount = #data
		
		for i=1, #data do
			
			local dbPlayer = data[i]
			local p = {
				steamID64 = dbPlayer.SteamID64,
				skinCount = dbPlayer.SkinCount
			}
			
			RequestNameFromSteamID(dbPlayer.SteamID64,function(name)
			
				p.name = name
				
				table.insert(players,p)
				
				if #players == playerCount then
					
					-- all playerinfo has been retrieved
					callback(players)
				
				end
				
			end)
		
		end
		
		if #data == 0 then
			callback({})
		end
	
	end)
	
	
end

util.AddNetworkString("cl_easyskins_GetSkinOwnersResponse")
util.AddNetworkString("sv_easyskins_GetSkinOwners")
local function GetSkinOwners(len, ply)
	
	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end
	
	RetrieveAllPlayerData(ply, function(players)
	
		-- send response to client
		net.Start("cl_easyskins_GetSkinOwnersResponse")
			net.WriteTable(players)
		net.Send(ply)
	
	end)
	
end
net.Receive("sv_easyskins_GetSkinOwners",GetSkinOwners)

util.AddNetworkString("cl_easyskins_GetPlayerPurchasesResponse")
util.AddNetworkString("sv_easyskins_GetPlayerPurchases")
local function GetPlayerPurchases(len, ply)
	
	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end
	
	local steamID64 = net.ReadString()
	
	SV_EASYSKINS.DBGetPurchases(steamID64,function(_,data)
		
		local purchases = {}
		
		for i=1, #data do
			 
			local dbPurchase = data[i]
			
			local purchase = {
				skinID = tonumber(dbPurchase.SkinID),
				steamID64 = dbPurchase.SteamID64,
				weaponClass = dbPurchase.WeaponClass
			}
			
			table.insert(purchases,purchase)
		
		end
	
		net.Start("cl_easyskins_GetPlayerPurchasesResponse")
			net.WriteTable(purchases)
		net.Send(ply)	

	end)
	
end
net.Receive("sv_easyskins_GetPlayerPurchases",GetPlayerPurchases)

util.AddNetworkString("sv_easyskins_RemovePurchaseFromPlayer")
local function RemovePurchaseFromPlayer(len,ply)

	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end
	
	local purchasedSkin = net.ReadTable()
	
	local target = SH_EASYSKINS.IsPlayerOnline(purchasedSkin.steamID64)
	
	-- if the targetted player is ingame, remove it from the server/client tables
	if target then
	
		local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(target)
		local _, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(target,purchasedSkin.skinID,purchasedSkin.weaponClass)
		
		-- update server
		table.remove(purchasedSkins,purchasedSkinID)
	
		-- update client
		SV_EASYSKINS.UpdateClientPurchasedSkins(target,purchasedSkins)
		
	end
	
	-- remove purchase from DB
	SV_EASYSKINS.DBRemovePurchase(purchasedSkin.steamID64,purchasedSkin)
	
end
net.Receive("sv_easyskins_RemovePurchaseFromPlayer",RemovePurchaseFromPlayer)

util.AddNetworkString("cl_easyskins_ReceiveSkinNotification")
function SV_EASYSKINS.GiveSkinToPlayer(steamID64, skinID, weps)

	local target = SH_EASYSKINS.IsPlayerOnline(steamID64)
	
	local purchasedSkins = target and SH_EASYSKINS.GetPurchasedSkins(target) or {}
	
	for i=1, #weps do
	
		local class = weps[i]
	
		-- create a new purchase
		local purchase = {
			skinID = skinID,
			weaponClass = class,
			enabled = false
		}
		
		-- add purchase to DB
		SV_EASYSKINS.DBAddPurchase(steamID64,purchase)
		
		-- if the target is ingame
		if target then
		
			-- update server
			table.insert(purchasedSkins,purchase)
			
		end
		
	end

	-- if the target is ingame
	if target then
	
		-- update client
		SV_EASYSKINS.UpdateClientPurchasedSkins(target,purchasedSkins)

		-- send notification to client
		net.Start("cl_easyskins_ReceiveSkinNotification")
			net.WriteInt(skinID,16)
			net.WriteString(weps[1])
			net.WriteInt(#weps,16)
		net.Send(target)
		
	end

end

util.AddNetworkString("sv_easyskins_GiveSkinToPlayer")
local function GiveSkinToPlayer(len, ply)
	
	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end
	
	local steamID64 = net.ReadString()
	local skinID = net.ReadInt(16)
	local weps = net.ReadTable()
	
	SV_EASYSKINS.GiveSkinToPlayer(steamID64, skinID, weps)

end
net.Receive("sv_easyskins_GiveSkinToPlayer",GiveSkinToPlayer)
