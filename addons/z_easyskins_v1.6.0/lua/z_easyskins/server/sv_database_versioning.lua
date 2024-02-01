-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	Versioning a database means sharing all changes of a database.
*/

local function VersionSQLite()

	-- patch 3: Add new skin boolean columns + skin currency
	SV_EASYSKINS.DBColumnExists( "ESKINS_SKINS", "SteamgroupOnly", function(exists)
		if !exists then
	
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD SteamgroupOnly BOOLEAN DEFAULT 0;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD NameTagOnly BOOLEAN DEFAULT 0;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD Purchasable BOOLEAN DEFAULT 1;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD Currency VARCHAR(100) DEFAULT '';")
			
		end
	end)
	
end 

function SV_EASYSKINS.VersionDB()
	
	if SV_EASYSKINS.dbIsSQLITE then
		VersionSQLite()
		return
	end
	
	-- patch 1: Varchar Size Error (MySQL)
	SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS MODIFY Weapons TEXT NOT NULL;")
	SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SETTINGS MODIFY Value TEXT NOT NULL;")
	
	-- patch 2: Size increase of prices
	SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS MODIFY Price BIGINT UNSIGNED NOT NULL;")
	SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS MODIFY DonatorOnly BIGINT UNSIGNED NOT NULL;")
	
	-- patch 3: Add new skin boolean columns + skin currency
	SV_EASYSKINS.DBColumnExists( "ESKINS_SKINS", "SteamgroupOnly", function(exists)
		if !exists then
	
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD SteamgroupOnly BOOLEAN DEFAULT 0;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD NameTagOnly BOOLEAN DEFAULT 0;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD Purchasable BOOLEAN DEFAULT 1;")
			SV_EASYSKINS.DBQuery("ALTER TABLE ESKINS_SKINS ADD Currency VARCHAR(100) DEFAULT '';")
			
		end
	end)

end