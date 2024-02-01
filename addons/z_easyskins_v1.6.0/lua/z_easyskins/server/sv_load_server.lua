-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	Loading all server data
*/

local function LoadMaterials(data)
	
	local materials = {}
	
	for i=1, #data do
		
		local dbMat = data[i]
		
		local material = {
			id = tonumber(dbMat.ID),
			name = dbMat.Name,
			path = dbMat.Path,
			isRemovable = tobool(dbMat.IsRemovable),
		}
		SH_EASYSKINS.IsMaterialAnimated(material)
		
		table.insert(materials,material)
	
	end
	
	SV_EASYSKINS.SetMaterials(materials)

end

local function LoadCategories(data)

	local categories = {}
	
	for i=1, #data do
		
		local dbCat = data[i]
		
		-- don't add the uncategorized category
		if dbCat.Category == SH_EASYSKINS.VAR.UNCATEGORIZED then
			continue
		end
		
		local category = {
			id = tonumber(dbCat.ID),
			name = dbCat.Category
		}
		
		table.insert(categories,category)
	
	end

	SV_EASYSKINS.SetCategories(categories)

end

local function LoadBlacklist(data)

	local blacklist = {} 
	
	for i=1, #data do
		
		local dbBlacklistMat = data[i]
		
		table.insert(blacklist,dbBlacklistMat.Material)
	
	end
	
	SV_EASYSKINS.SetMatBlacklist(blacklist)
	
end

local function LoadSkins(data)
	
	local skins = {}
	
	for i=1, #data do
		
		local dbSkin = data[i]
		
		local mat = SH_EASYSKINS.GetMaterial(tonumber(dbSkin.MaterialID))
		local cat = SH_EASYSKINS.GetCategory(tonumber(dbSkin.CategoryID))
		local wepTbl = util.JSONToTable(dbSkin.Weapons)

		local skin = {
			id = tonumber(dbSkin.ID),
			dispName = dbSkin.DispName,
			material = mat,
			category = cat,
			currency = dbSkin.Currency,
			price = tonumber(dbSkin.Price),
			donatorPrice = tonumber(dbSkin.DonatorPrice),
			donatorOnly = tobool(dbSkin.DonatorOnly),
			steamgroupOnly = tobool(dbSkin.SteamgroupOnly),
			nameTagOnly = tobool(dbSkin.NameTagOnly),
			purchasable = tobool(dbSkin.Purchasable),
			weaponTbl = wepTbl
		}
		
		table.insert(skins,skin)
	
	end
	
	SV_EASYSKINS.SetSkins(skins)
	
end

local function LoadSettings(data)

	for i=1, #data do
		
		local key, value = data[i].Key, data[i].Value
		
		if SH_EASYSKINS.SETTINGS[key] == nil then continue end
		
		local valueTbl = util.JSONToTable(value)
		
		if valueTbl ~= nil then
		
			SH_EASYSKINS.SETTINGS[key] = valueTbl
			
		elseif value == "true" or value == "false" then
		
			SH_EASYSKINS.SETTINGS[key] = tobool( value )
			
		else
		
			SH_EASYSKINS.SETTINGS[key] = value
			
		end
	
	end
	
	-- mark server as loaded
	SV_EASYSKINS.DATALOADED = true

end

// loading data serverside
local function InitializeServerData()
	
	-- materials
	SV_EASYSKINS.DBGetMaterials(LoadMaterials)
	
	-- categories
	SV_EASYSKINS.DBGetCategories(LoadCategories)
	
	-- blacklist
	SV_EASYSKINS.DBGetBlacklist(LoadBlacklist)
	
	-- skins
	SV_EASYSKINS.DBGetSkins(LoadSkins)
	
	-- settings
	SV_EASYSKINS.DBLoadSettings(LoadSettings)
	
end
hook.Add("sv_easyskins_DBInitialized","sv_easyskins_InitializeServerData",InitializeServerData)