
local baseSteamGroupLink = "http://steamcommunity.com/groups/"

function SV_EASYSKINS.CheckSteamGroupMembership(ply)

	if #SH_EASYSKINS.SETTINGS.STEAMGROUPLINK == 0 then return end
	
	-- can't check in single player, always set in steamgroup if the link is set
	if game.SinglePlayer() and #SH_EASYSKINS.SETTINGS.STEAMGROUPLINK > 0 then
		ply:SetNWBool("easyskins_InSteamGroup", true)
		return
	end
	
	local steamGroupLink = baseSteamGroupLink..SH_EASYSKINS.SETTINGS.STEAMGROUPLINK
	
	http.Fetch( steamGroupLink.."/memberslistxml/?xml=1",
		function( body, len, headers, code )
		
			if !IsValid(ply) then return end

			-- checking if player is in steamgroup
			local isInGroup = string.find( body, "<steamID64>"..ply:SteamID64().."</steamID64>" ) ~= nil
			
			ply:SetNWBool("easyskins_InSteamGroup", isInGroup)
			
		end,
		function( error )
			Msg("Couldn't connect to steam group... ("..steamGroupLink..")")
		end
	)
	
end

util.AddNetworkString("sv_easyskins_CheckSteamGroupMembership")
local function CheckSteamGroupMembership(len, ply)

	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end
	
	for _, p in pairs(player.GetHumans()) do
		SV_EASYSKINS.CheckSteamGroupMembership(p)
	end

end
net.Receive("sv_easyskins_CheckSteamGroupMembership",CheckSteamGroupMembership)
