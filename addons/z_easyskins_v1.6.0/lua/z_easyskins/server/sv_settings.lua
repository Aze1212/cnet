-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

util.AddNetworkString("cl_easyskins_UpdateSettings")
function SV_EASYSKINS.UpdateClientSettings()

	net.Start("cl_easyskins_UpdateSettings")
		net.WriteTable(SH_EASYSKINS.SETTINGS)
	net.Broadcast()

end

local function SpecialActionsForUpdate(oldSettings,newSettings)
	
	-- shop model changed -> respawn shop npcs
	if oldSettings.SHOPMODEL ~= newSettings.SHOPMODEL then
		timer.Simple(0, function()
			SV_EASYSKINS.SpawnShopNpcs()
		end)
	end
	
end

util.AddNetworkString("sv_easyskins_SaveSettings")
local function SaveSettings(len, ply)
	
	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end

	local clSettings = net.ReadTable() 
	
	-- any actions that need to happen
	SpecialActionsForUpdate(SH_EASYSKINS.SETTINGS,clSettings)
	
	-- don't accept new keys from clients
	for key, value in pairs(SH_EASYSKINS.SETTINGS) do
		SH_EASYSKINS.SETTINGS[key] = clSettings[key]
	end
	
	-- update clients
	SV_EASYSKINS.UpdateClientSettings()
	
	-- save to DB
	SV_EASYSKINS.DBSaveSettings(SH_EASYSKINS.SETTINGS)

end
net.Receive("sv_easyskins_SaveSettings",SaveSettings)
