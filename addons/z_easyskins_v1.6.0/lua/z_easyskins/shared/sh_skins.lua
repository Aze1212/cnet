-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local skinList = {} -- id, dispName, material, category, price, donatorPrice, donatorOnly, steamgroupOnly, nameTagOnly, purchasable, weaponTbl

function SH_EASYSKINS.GetSkins()
	return skinList
end

function SH_EASYSKINS.GetSkin(id)
	
	local skinList = SH_EASYSKINS.GetSkins()

	for i=1, #skinList do
		
		if skinList[i].id == id then
			return skinList[i], i
		end

	end
	
	-- error("Skin with id <"..id.."> ".." not found! ("..#skinList.." skins)")

end

function SH_EASYSKINS.GetSkinByName(name)
	
	local skinList = SH_EASYSKINS.GetSkins()
	name = name:lower()

	for i=1, #skinList do
		
		if string.match(skinList[i].dispName:lower(), name) then
			return skinList[i], i
		end

	end
	
end

function SH_EASYSKINS.GetSkinByMaterial(material)
	
	local skinList = SH_EASYSKINS.GetSkins()

	for i=1, #skinList do
		
		if skinList[i].material.path == material then
			return skinList[i], i
		end

	end
	
end

function SH_EASYSKINS.GetSkinsByCategory(catName)
	
	local skinList = SH_EASYSKINS.GetSkins()
	local skins = {}
	catName = catName:lower()

	for i=1, #skinList do
		
		if skinList[i].category.name:lower() == catName then
			table.insert(skins,skinList[i])
		end

	end
	
	return skins

end

function SH_EASYSKINS.SkinFromParams(id,dispName,material,category,currency,price,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable,weaponTblSize)
	
	local skin = {
		id = id,
		dispName = dispName,
		material = material,
		category = category,
		currency = currency,
		price = price,
		donatorPrice = donatorPrice,
		donatorOnly = donatorOnly,
		steamgroupOnly = steamgroupOnly,
		nameTagOnly = nameTagOnly,
		purchasable = purchasable,
		weaponTbl = {}
	}
	
	-- read all classes seperately
	for i=1,weaponTblSize do
		table.insert(skin.weaponTbl,net.ReadString())
	end
	
	return skin
	
end

local function RemoveSkinFromList(id)
	
	local _, index = SH_EASYSKINS.GetSkin(id)
	
	if index ~= nil then
		table.remove(SH_EASYSKINS.GetSkins(),index)
	end

end

local modelMatCache = {}

-- GetMaterials checks files (can cause small lag when many active weapons)
function SH_EASYSKINS.GetModelMaterials(model, class, isViewModel)

	-- for workarounds
	if class ~= nil then
		local vmMats, wmMats = SH_EASYSKINS.WeaponWorkaroundMaterials(class)
		if vmMats ~= nil and wmMats ~= nil then
			return isViewModel and vmMats or wmMats
		end
	end

	local modelPath = model:GetModel()

	if !modelMatCache[modelPath] then
		modelMatCache[modelPath] = model:GetMaterials()
	end

	return modelMatCache[modelPath]

end

function SH_EASYSKINS.GetAllowedIndexesForMaterialChange(model, wep, isViewModel)
	
	local cacheID = isViewModel and 1 or 2

	-- setup a cache for performance + we want to be able to invalidate these indexes to show instant updates
	if wep and wep.__indexCache and wep.__indexCache[cacheID] and !wep.__invalidateIndexes[cacheID] then
		return wep.__indexCache[cacheID]
	end

	local modelMats = SH_EASYSKINS.GetModelMaterials(model)
	local indexes = {}
	
	for i=1, #modelMats do
		
		local mat = modelMats[i]
		local matName = SH_EASYSKINS.GetNameFromMat(mat)
		
		if SH_EASYSKINS.IsMatBlacklisted(matName) then continue end

		table.insert(indexes,i-1)
		
	end
	
	if wep then
		wep.__indexCache = wep.__indexCache or {}
		wep.__indexCache[cacheID] = indexes
		wep.__invalidateIndexes = wep.__invalidateIndexes or {}
		wep.__invalidateIndexes[cacheID] = false
	end

	return indexes
	
end

function SH_EASYSKINS.ApplySkinToModel(model, material, wep, isViewModel)

	if !IsValid(model,wep) then return end
	
	local indexes = SH_EASYSKINS.GetAllowedIndexesForMaterialChange(model, wep, isViewModel)
	
	-- reset any prev set materials
	model:SetSubMaterial()
	
	for i=1, #indexes do
		
		local index = indexes[i]
		model:SetSubMaterial(index,material)
	
	end
	
end

if CLIENT then

	function CL_EASYSKINS.CreateSkin(material,weaponTbl,dispName,category,currency,price,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable)

		if !SH_EASYSKINS.HasAccess() then return end

		net.Start("sv_easyskins_CreateSkin")
			net.WriteString(dispName)
			net.WriteTable(material)
			net.WriteTable(category)
			net.WriteString(currency)
			net.WriteUInt(price,32)
			net.WriteUInt(donatorPrice,32)
			net.WriteBool(donatorOnly)
			net.WriteBool(steamgroupOnly)
			net.WriteBool(nameTagOnly)
			net.WriteBool(purchasable)
			
			-- the amount of tables we are going to send
			net.WriteInt(#weaponTbl,16)
			
			-- 64kb limit so we split up the table and send per key
			for i=1, #weaponTbl do
				net.WriteString(weaponTbl[i])
			end
		net.SendToServer()
		
	end
	
	function CL_EASYSKINS.UpdateSkin(skin,callback)
	
		if !SH_EASYSKINS.HasAccess() then return end
	
		net.Start("sv_easyskins_UpdateSkin")
			net.WriteInt(skin.id,16)
			net.WriteString(skin.dispName)
			net.WriteTable(skin.material)
			net.WriteTable(skin.category)
			net.WriteString(skin.currency)
			net.WriteUInt(skin.price,32)
			net.WriteUInt(skin.donatorPrice,32)
			net.WriteBool(skin.donatorOnly)
			net.WriteBool(skin.steamgroupOnly)
			net.WriteBool(skin.nameTagOnly)
			net.WriteBool(skin.purchasable)
			
			-- the amount of tables we are going to send
			net.WriteInt(#skin.weaponTbl,16)
			
			-- 64kb limit so we split up the table and send per key
			for i=1, #skin.weaponTbl do
				net.WriteString(skin.weaponTbl[i])
			end
		net.SendToServer()
		
		-- don't wait for server and edit skin
		local _, index = SH_EASYSKINS.GetSkin(skin.id)
		if skinList[index] ~= nil then
			skinList[index] = skin
		else
			error("Tried to update invalid skin!")
		end
		
		if callback ~= nil then
			callback()
		end
		
	end
	
	function CL_EASYSKINS.RemoveSkin(skin,callback)
	
		if !SH_EASYSKINS.HasAccess() then return end
		
		net.Start("sv_easyskins_RemoveSkin")
			net.WriteInt(skin.id,16)
		net.SendToServer()
			
		-- don't wait for server and remove skin
		RemoveSkinFromList(skin.id)
		
		if callback ~= nil then
			callback()
		end
		
	end
	
	local function UpdateClientSkin()

		-- compose skin
		local id = net.ReadInt(16)
		local dispName = net.ReadString()
		local material = net.ReadTable()
		local category = net.ReadTable()
		local currency = net.ReadString()
		local price = net.ReadUInt(32)
		local donatorPrice = net.ReadUInt(32)
		local donatorOnly = net.ReadBool()
		local steamgroupOnly = net.ReadBool()
		local nameTagOnly = net.ReadBool()
		local purchasable = net.ReadBool()
		local weaponTblSize = net.ReadInt(16)
		
		local skin = SH_EASYSKINS.SkinFromParams(id,dispName,material,category,currency,price,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable,weaponTblSize)
		
		local _, index = SH_EASYSKINS.GetSkin(id)
		
		if table.IsEmpty(skin.material) then
			-- remove skin
			RemoveSkinFromList(skin.id)
		elseif index == nil then
			-- add skin
			table.insert(skinList,skin)
		else
			-- edit skin
			skinList[index] = skin
		end
		
		-- shop needs to recheck buyable skins
		timer.Create( "cl_easyskins_InvalidateShopCache", 0.25, 1, CL_EASYSKINS.InvalidateShopCache )
		
	end
	net.Receive("cl_easyskins_UpdateClientSkin",UpdateClientSkin)
	
	local function ResetSkins()
		
		-- empty skinlist
		skinList = {}
		
		-- empty shop
		CL_EASYSKINS.InvalidateShopCache()
		
	end
	net.Receive("cl_easyskins_ResetSkinList",ResetSkins)
	
end

if SERVER then

	util.AddNetworkString("cl_easyskins_UpdateClientSkin")
	function SV_EASYSKINS.UpdateClientSkin(skin,targets)
		
		targets = targets or player.GetHumans()
		
		net.Start("cl_easyskins_UpdateClientSkin")
			net.WriteInt(skin.id,16)
			net.WriteString(skin.dispName)
			net.WriteTable(skin.material)
			net.WriteTable(skin.category)
			net.WriteString(skin.currency)
			net.WriteUInt(skin.price,32)
			net.WriteUInt(skin.donatorPrice,32)
			net.WriteBool(skin.donatorOnly)
			net.WriteBool(skin.steamgroupOnly)
			net.WriteBool(skin.nameTagOnly)
			net.WriteBool(skin.purchasable)
			
			-- the amount of tables we are going to send
			net.WriteInt(#skin.weaponTbl,16)
			
			-- 64kb limit so we split up the table and send per key
			for i=1, #skin.weaponTbl do
				net.WriteString(skin.weaponTbl[i])
			end
		net.Send(targets)

	end
	
	function SV_EASYSKINS.SetSkins(skins)
	
		-- set on server
		skinList = skins
		
		-- set on client
		for i=1,#skins do
			SV_EASYSKINS.UpdateClientSkin(skins[i])
		end
		
	end
	
	util.AddNetworkString("cl_easyskins_ResetSkinList")
	function SV_EASYSKINS.ResetSkins()
	
		skinList = {}
		
		net.Start("cl_easyskins_ResetSkinList")
		net.Broadcast()
	
	end
	
	util.AddNetworkString("sv_easyskins_CreateSkin")
	local function CreateSkin(len, ply)
		
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local skins = SH_EASYSKINS.GetSkins()
		
		-- compose skin
		local id = SH_EASYSKINS.CalcNewID(skins)
		local dispName = net.ReadString()
		local material = net.ReadTable()
		local category = net.ReadTable()
		local currency = net.ReadString()
		local price = net.ReadUInt(32)
		local donatorPrice = net.ReadUInt(32)
		local donatorOnly = net.ReadBool()
		local steamgroupOnly = net.ReadBool()
		local nameTagOnly = net.ReadBool()
		local purchasable = net.ReadBool()
		local weaponTblSize = net.ReadInt(16)
		
		local skin = SH_EASYSKINS.SkinFromParams(id,dispName,material,category,currency,price,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable,weaponTblSize)
		
		-- add skin on server
		table.insert(skins,skin)
		
		-- update clients
		SV_EASYSKINS.UpdateClientSkin(skin)
		
		-- add skin in db
		SV_EASYSKINS.DBAddSkin(skin)
		
	end
	net.Receive("sv_easyskins_CreateSkin",CreateSkin)
	
	util.AddNetworkString("sv_easyskins_UpdateSkin")
	local function UpdateSkin(len, ply)
		
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		-- compose skin
		local id = net.ReadInt(16)
		local dispName = net.ReadString()
		local material = net.ReadTable()
		local category = net.ReadTable()
		local currency = net.ReadString()
		local price = net.ReadUInt(32)
		local donatorPrice = net.ReadUInt(32)
		local donatorOnly = net.ReadBool()
		local steamgroupOnly = net.ReadBool()
		local nameTagOnly = net.ReadBool()
		local purchasable = net.ReadBool()
		local weaponTblSize = net.ReadInt(16)

		local skin = SH_EASYSKINS.SkinFromParams(id,dispName,material,category,currency,price,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable,weaponTblSize)
		
		-- update skin
		local _, index = SH_EASYSKINS.GetSkin(skin.id)
		skinList[index] = skin
		
		-- update clients
		SV_EASYSKINS.UpdateClientSkin(skin)
		
		-- update db
		SV_EASYSKINS.DBUpdateSkin(skin)
		
	end
	net.Receive("sv_easyskins_UpdateSkin",UpdateSkin)
	
	util.AddNetworkString("sv_easyskins_RemoveSkin")
	local function RemoveSkin(len, ply)
	
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		-- setup an empty skin so that client knows to remove this id
		local skin = {
			id = net.ReadInt(16),
			dispName = "",
			material = {},
			category = {},
			currency = '',
			price = 0,
			donatorPrice = 0,
			donatorOnly = false,
			steamgroupOnly = false,
			nameTagOnly = false,
			purchasable = true,
			weaponTbl = {}
		}
		
		-- remove skin on server
		RemoveSkinFromList(skin.id)
		
		-- update clients
		SV_EASYSKINS.UpdateClientSkin(skin)

		-- remove skin from db
		SV_EASYSKINS.DBRemoveSkin(skin)
		
	end
	net.Receive("sv_easyskins_RemoveSkin",RemoveSkin)

end
