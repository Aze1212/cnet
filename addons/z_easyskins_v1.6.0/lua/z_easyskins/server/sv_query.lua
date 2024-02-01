-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local function AddDefaultDataToTables()
	
	-- settings
	for key, value in pairs(SH_EASYSKINS.SETTINGS) do
	
		if istable(value) then
			 value = util.TableToJSON(value)
		end
	
		SV_EASYSKINS.DBQuery("INSERT IGNORE INTO ESKINS_SETTINGS(`Key`,Value) VALUES ('"..key.."',"..sql.SQLStr(value)..");")
		
	end
	
	-- categories
	local values = "1,'"..SH_EASYSKINS.VAR.UNCATEGORIZED.."'"
	SV_EASYSKINS.DBQuery("INSERT IGNORE INTO ESKINS_CATEGORIES(ID,Category) VALUES ("..values..");")
	
	-- materials
	local files = file.Find("materials/z_easyskins/camo/*.vmt","GAME")
	local extraFiles = file.Find("materials/z_easyskins/extra/*.vmt","GAME")
	local extraMaterials = SH_EASYSKINS.EXTRAMATERIALS
	local defaultMaterials = SH_EASYSKINS.EXTRADEFAULTMATERIALS
	local totalMats = #files + table.Count(defaultMaterials) + math.min(#extraFiles,table.Count(extraMaterials))
	local matsCreated = 0
	
	local function AddMaterialToDB(name,path)
	
		local mat = {
			name = name,
			path = path,
			isRemovable = false
		}
		
		-- add to db
		local values = "'"..mat.name.."','"..mat.path.."',"..SH_EASYSKINS.BoolToInt(mat.isRemovable)

		SV_EASYSKINS.DBQuery("INSERT IGNORE INTO ESKINS_MATS(Name,Path,IsRemovable) VALUES ("..values..");", function()
			
			matsCreated = matsCreated + 1

			if matsCreated == totalMats then
				hook.Run("sv_easyskins_DBInitialized")
			end
		
		end)

	end

	-- add materials from file
	for k,v in pairs( files ) do
		
		local name = SH_EASYSKINS.GetMaterialNameFromPath(v)
		local path = "z_easyskins/camo/"..v
		
		AddMaterialToDB(name,path)
		
	end
	
	-- add extra materials from file
	for k,v in pairs( extraFiles ) do
		
		local name = SH_EASYSKINS.GetMaterialNameFromPath(v)
		local path = "z_easyskins/extra/"..v
		
		-- make sure the icons aren't added as skins
		if SH_EASYSKINS.EXTRAMATERIALS[path] ~= nil then
			AddMaterialToDB(name,path)
		end
		
	end
	
	-- add materials from default mat list
	for k,v in pairs( defaultMaterials ) do
		
		AddMaterialToDB(v,k)
		
	end
	
end

local function CreateTables()

	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_MATS (
	ID INT NOT NULL AUTO_INCREMENT,
	Name VARCHAR(100) NOT NULL,
	Path VARCHAR(191) NOT NULL UNIQUE,
	IsRemovable BOOLEAN DEFAULT 1,
	PRIMARY KEY (ID));
	]])
	
	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_BLACKLIST (
	ID INT NOT NULL AUTO_INCREMENT,
	Material VARCHAR(255) NOT NULL,
	PRIMARY KEY (ID));
	]])

	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_CATEGORIES (
	ID INT NOT NULL,
	Category VARCHAR(255) NOT NULL,
	PRIMARY KEY (ID));
	]])
	
	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_SKINS (
	ID INT NOT NULL,
	MaterialID INT,
	CategoryID INT,
	DispName VARCHAR(100) NOT NULL,
	Currency VARCHAR(100) DEFAULT '',
	Price BIGINT UNSIGNED NOT NULL,
	DonatorPrice BIGINT UNSIGNED NOT NULL,
	DonatorOnly BOOLEAN DEFAULT 0,
	SteamgroupOnly BOOLEAN DEFAULT 0,
	NameTagOnly BOOLEAN DEFAULT 0,
	Purchasable BOOLEAN DEFAULT 1,
	Weapons TEXT,
	PRIMARY KEY (ID),
	FOREIGN KEY (MaterialID) REFERENCES ESKINS_MATS(ID) ON DELETE CASCADE,
	FOREIGN KEY (CategoryID) REFERENCES ESKINS_CATEGORIES(ID) ON DELETE CASCADE);
	]])
	
	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_PURCHASES (
	ID INT NOT NULL AUTO_INCREMENT,
	SteamID64 VARCHAR(20) NOT NULL,
	SkinID INT NOT NULL,
	WeaponClass VARCHAR(255) NOT NULL,
	Enabled BOOLEAN DEFAULT 0,
	Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (ID));
	]])
	
	SV_EASYSKINS.DBQuery([[
	CREATE TABLE IF NOT EXISTS ESKINS_SETTINGS (
	`Key` VARCHAR(100) UNIQUE NOT NULL,
	Value TEXT NOT NULL,
	PRIMARY KEY (`Key`));
	]])
	
	SV_EASYSKINS.VersionDB()
	
	AddDefaultDataToTables()

end
hook.Add("Initialize","sv_easyskins_CreateTables",CreateTables)

-- copy of the original settings
local originalSettingsTbl = table.Copy(SH_EASYSKINS.SETTINGS)

util.AddNetworkString("sv_easyskins_ResetDB")
local function ResetDB(len, ply)

	-- never trust clients
	if !SH_EASYSKINS.HasAccess(ply) then return end

	-- reset settings
	SH_EASYSKINS.SETTINGS = table.Copy(originalSettingsTbl)

	-- despawn npcs
	SV_EASYSKINS.SpawnShopNpcs()
	
	-- add a temp hook to reload clients when the db is initialized
	hook.Add("sv_easyskins_DBInitialized","sv_easyskins_ReloadClients", function()
		
		-- Force close the menu
		ply:SendLua("CL_EASYSKINS.ToggleMenu(true)")
	
		-- Reload Clients
		for _, p in pairs(player.GetHumans()) do
			hook.Run("sv_easyskins_ReloadClient",p)
		end
		
		-- reset skin list for all connected clients
		SV_EASYSKINS.ResetSkins()
		
		-- Toggle menu to show changes
		timer.Simple(3,function()
			ply:SendLua("CL_EASYSKINS.ToggleMenu(true)")
			ply:SendLua("CL_EASYSKINS.ToggleMenu(false, true)")
		end)
		
		hook.Remove("sv_easyskins_DBInitialized","sv_easyskins_ReloadClients")
		
	end)
	
	-- drop tables
	SV_EASYSKINS.DBQuery([[
	DROP TABLE IF EXISTS ESKINS_SKINS,
						 ESKINS_MATS,
						 ESKINS_CATEGORIES,
						 ESKINS_BLACKLIST,
						 ESKINS_PURCHASES,
						 ESKINS_SETTINGS;
	]],function()
	
		-- Initialize DB & serverside
		CreateTables()

	end)

end
net.Receive("sv_easyskins_ResetDB",ResetDB)

function SV_EASYSKINS.DBGetMaterials(callback)
	
	SV_EASYSKINS.DBQuery([[
	SELECT * 
	FROM ESKINS_MATS;
	]],
	function(data)
		callback(data)
	end)
	
end

function SV_EASYSKINS.DBAddMaterial(mat)

	local values = mat.id..','..sql.SQLStr(mat.name)..','..sql.SQLStr(mat.path)..','..SH_EASYSKINS.BoolToInt(mat.isRemovable)

	SV_EASYSKINS.DBQuery([[
	INSERT INTO ESKINS_MATS(ID,Name,Path,IsRemovable)
	VALUES (]]..values..[[);
	]])

end

function SV_EASYSKINS.DBRemoveMaterial(mat)

	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_MATS
	WHERE ID = ]]..mat.id..[[;
	]])

end

function SV_EASYSKINS.DBGetBlacklist(callback)
	
	SV_EASYSKINS.DBQuery([[
	SELECT * 
	FROM ESKINS_BLACKLIST;
	]],
	function(data)
		callback(data)
	end)
	
end

function SV_EASYSKINS.DBAddBlacklistMat(matName)
	
	SV_EASYSKINS.DBQuery([[
	INSERT INTO ESKINS_BLACKLIST(Material)
	VALUES (]]..sql.SQLStr(matName)..[[);
	]])

end

function SV_EASYSKINS.DBRemoveBlacklistMat(matName)

	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_BLACKLIST
	WHERE Material = ]]..sql.SQLStr(matName)..[[;
	]])

end

function SV_EASYSKINS.DBGetCategories(callback)
	
	SV_EASYSKINS.DBQuery([[
	SELECT * 
	FROM ESKINS_CATEGORIES;
	]],
	function(data)
		callback(data)
	end)
	
end

function SV_EASYSKINS.DBAddCategory(cat)
	
	local values = cat.id..','..sql.SQLStr(cat.name)
	
	SV_EASYSKINS.DBQuery([[
	INSERT INTO ESKINS_CATEGORIES(ID,Category)
	VALUES (]]..values..[[);
	]])

end

function SV_EASYSKINS.DBRemoveCategory(cat)

	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_CATEGORIES
	WHERE ID = ]]..cat.id..[[;
	]])
	
end

function SV_EASYSKINS.DBGetSkins(callback)
	
	SV_EASYSKINS.DBQuery([[
	SELECT * 
	FROM ESKINS_SKINS;
	]],
	function(data)
		callback(data)
	end)
	
end

function SV_EASYSKINS.DBAddSkin(skin)

	local values = skin.id..','..skin.material.id..','..skin.category.id..','..sql.SQLStr(skin.dispName)..','..
					sql.SQLStr(skin.currency)..','..skin.price..','..skin.donatorPrice..','..SH_EASYSKINS.BoolToInt(skin.donatorOnly)..','..
					SH_EASYSKINS.BoolToInt(skin.steamgroupOnly)..','..SH_EASYSKINS.BoolToInt(skin.nameTagOnly)..','..
					SH_EASYSKINS.BoolToInt(skin.purchasable)..',\''..util.TableToJSON(skin.weaponTbl)..'\''

	SV_EASYSKINS.DBQuery([[
	INSERT INTO ESKINS_SKINS(ID,MaterialID,CategoryID,DispName,Currency,Price,DonatorPrice,DonatorOnly,SteamgroupOnly,NameTagOnly,Purchasable,Weapons)
	VALUES (]]..values..[[);
	]])

end

function SV_EASYSKINS.DBUpdateSkin(skin)
	
	SV_EASYSKINS.DBQuery([[
	UPDATE ESKINS_SKINS
	SET CategoryID = ]]..skin.category.id..[[,
		DispName = ]]..sql.SQLStr(skin.dispName)..[[,
		Currency = ]]..sql.SQLStr(skin.currency)..[[,
		Price = ]]..skin.price..[[,
		DonatorPrice = ]]..skin.donatorPrice..[[,
		DonatorOnly = ]]..SH_EASYSKINS.BoolToInt(skin.donatorOnly)..[[,
		SteamgroupOnly = ]]..SH_EASYSKINS.BoolToInt(skin.steamgroupOnly)..[[,
		NameTagOnly = ]]..SH_EASYSKINS.BoolToInt(skin.nameTagOnly)..[[,
		Purchasable = ]]..SH_EASYSKINS.BoolToInt(skin.purchasable)..[[,
		Weapons = ']]..util.TableToJSON(skin.weaponTbl)..[['
	WHERE ID = ]]..skin.id..[[;
	]])
	
end

function SV_EASYSKINS.DBRemoveSkin(skin)

	-- remove all purchases who bought this skin
	SV_EASYSKINS.DBRemovePurchasesForSkin(skin.id)

	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_SKINS
	WHERE ID = ]]..skin.id..[[;
	]])
	
end

function SV_EASYSKINS.DBGetPlayersFromPurchases(callback)
	
	SV_EASYSKINS.DBQuery([[
	SELECT SteamID64, COUNT(*) 'SkinCount'
	FROM ESKINS_PURCHASES
	GROUP BY SteamID64;
	]],
	function(data)
		callback(data)
	end)
	
end

function SV_EASYSKINS.DBGetPurchases(ply,callback)
	
	local steamID64
	
	if isstring(ply) then
		steamID64 = ply
	else
		steamID64 = SH_EASYSKINS.GetSteamID64(ply)
	end
	
	SV_EASYSKINS.DBQuery([[
	SELECT *
	FROM ESKINS_PURCHASES
	WHERE SteamID64 = ']]..steamID64..[['
	ORDER BY WeaponClass;
	]],
	function(data)
		callback(ply,data)
	end)
	
end

function SV_EASYSKINS.DBAddPurchase(ply,purchase,callback)

	local steamID64
	
	if isstring(ply) then
		steamID64 = ply
	else
		steamID64 = SH_EASYSKINS.GetSteamID64(ply)
	end
	
	local values = "'"..steamID64.."',"..purchase.skinID..",'"..purchase.weaponClass.."',"..SH_EASYSKINS.BoolToInt(purchase.enabled)
	
	SV_EASYSKINS.DBQuery([[
	INSERT INTO ESKINS_PURCHASES(SteamID64,SkinID,WeaponClass,Enabled)
	VALUES (]]..values..[[);
	]], function()
		if callback ~= nil then
			callback()
		end
	end)
	
end

function SV_EASYSKINS.DBRemovePurchase(ply,purchase,callback)
	
	local steamID64
	
	if isstring(ply) then
		steamID64 = ply
	else
		steamID64 = SH_EASYSKINS.GetSteamID64(ply)
	end

	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_PURCHASES
	WHERE SteamID64 = ']]..steamID64..[[' AND
		  SkinID = ]]..purchase.skinID..[[ AND
		  WeaponClass = ']]..purchase.weaponClass..[['
	LIMIT 1;
	]],function()
		if callback ~= nil then
			callback()
		end
	end)
	
end

-- exceptional case when an admin removes a skin bought by players
function SV_EASYSKINS.DBRemovePurchasesForSkin(skinID)

	-- remove purchase from DB
	SV_EASYSKINS.DBQuery([[
	DELETE FROM ESKINS_PURCHASES
	WHERE ID > 0 AND
		  SkinID = ]]..skinID..[[;
	]])
	
	-- remove purchases serverside & update clientside
	for _, ply in pairs(player.GetHumans()) do
		
		for k, purchase in pairs(ply.__Skins or {}) do
			
			if !IsValid(purchase) then continue end
		
			-- remove the skin from purchases
			if purchase.skinID == skinID then
				table.remove(ply.__Skins,k)
			end
		
		end
	
		-- update client
		SV_EASYSKINS.UpdateClientPurchasedSkins(ply,ply.__Skins)
	
	end
	
end

function SV_EASYSKINS.DBUpdatePurchase(ply,purchase)

	local steamID64 = SH_EASYSKINS.GetSteamID64(ply)

	SV_EASYSKINS.DBQuery([[
	UPDATE ESKINS_PURCHASES
	SET Enabled = ]]..SH_EASYSKINS.BoolToInt(purchase.enabled)..[[
	WHERE SteamID64 = ']]..steamID64..[[' AND
		  SkinID = ]]..purchase.skinID..[[ AND
		  WeaponClass = ']]..purchase.weaponClass..[[';
	]])
	
end

function SV_EASYSKINS.DBSaveSettings(settings)

	for key, value in pairs(settings) do
		
		if istable(value) then
			 value = util.TableToJSON(value)
		end
	
		SV_EASYSKINS.DBQuery([[
		UPDATE ESKINS_SETTINGS
		SET Value = ]]..sql.SQLStr(value)..[[
		WHERE `Key` = ']]..key..[[';
		]])
	end

end

function SV_EASYSKINS.DBLoadSettings(callback)

	SV_EASYSKINS.DBQuery([[
	SELECT *
	FROM ESKINS_SETTINGS;
	]],
	function(data)
		callback(data)
	end)
	
end
