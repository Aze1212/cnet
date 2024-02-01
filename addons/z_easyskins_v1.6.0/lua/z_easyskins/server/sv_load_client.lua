-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	Loading all client data
*/

local function LoadPurchases(ply,data)
	
	local purchases = {}
	
	for i=1, #data do
		 
		local dbPurchase = data[i]
		
		local purchase = {
			skinID = tonumber(dbPurchase.SkinID),
			weaponClass = dbPurchase.WeaponClass,
			enabled = tobool(dbPurchase.Enabled)
		}
		
		-- check if the skin linked to the purchase still exists
		local skin = SH_EASYSKINS.GetSkin(purchase.skinID)
		if !skin then continue end
		
		table.insert(purchases,purchase)

	end

	SV_EASYSKINS.SetPurchasedSkins(ply,purchases)
	
end

/*
	Timers are being used to reduce the net footprint 
	-> Overflowed reliable channel errors
*/

local function InitializeClientData(ply)

	-- materials
	SV_EASYSKINS.UpdateClientMaterials(ply)
	
	timer.Simple(0.5, function()
	
		-- ply could have disconnected
		if !IsValid(ply) then return end
	
		-- categories
		SV_EASYSKINS.UpdateClientCategories(ply)

		-- blacklist
		SV_EASYSKINS.UpdateClientMatBlacklist(ply)
		
	end)
	
	-- skins
	timer.Simple(2, function()
	
		local skins = SH_EASYSKINS.GetSkins()
		
		for i=1,#skins do
		
			timer.Simple(0.1*i,function()
			
				-- ply could have disconnected
				if !IsValid(ply) then return end
			
				SV_EASYSKINS.UpdateClientSkin(skins[i],ply)
				
			end)
			
		end
		
	end)

	-- purchases
	timer.Simple(1, function()
		
		-- ply could have disconnected
		if !IsValid(ply) then return end
	
		SV_EASYSKINS.DBGetPurchases(ply,LoadPurchases)
		
	end)
	
	-- settings
	SV_EASYSKINS.UpdateClientSettings()

	-- check if player is in steamgroup
	SV_EASYSKINS.CheckSteamGroupMembership(ply)

end
hook.Add("PlayerInitialSpawn","sv_easyskins_InitializeClientData",InitializeClientData)
hook.Add("sv_easyskins_ReloadClient","sv_easyskins_InitializeClientData",InitializeClientData)