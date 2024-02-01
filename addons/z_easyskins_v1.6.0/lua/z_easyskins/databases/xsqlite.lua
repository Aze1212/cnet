-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	SQLite
	- the local database located at garrysmod/sv.db
	- will be used by default
*/

local function SanitizeQueryForSqlite(query)
	
	-- use the default sqlite rowID feature
	query = string.Replace( query, "ID INT NOT NULL AUTO_INCREMENT", "ID INTEGER" )
	
	-- INSERT IGNORE needs an extra keyword to work
	query = string.Replace( query, "INSERT IGNORE INTO", "INSERT OR IGNORE INTO" )
	
	-- LIMIT does not work in sqlite when deleting (ESKINS_PURCHASES only)
	query = string.Replace( query, "LIMIT 1", '' )
	
	-- sqlite cannot remove multiple db's at the same time
	local resetDBQuery = [[
	DROP TABLE IF EXISTS ESKINS_SKINS,
						 ESKINS_MATS,
						 ESKINS_CATEGORIES,
						 ESKINS_BLACKLIST,
						 ESKINS_PURCHASES,
						 ESKINS_SETTINGS;
	]]
	
	if query == resetDBQuery then
		query = [[ 
			BEGIN;
			DROP TABLE IF EXISTS ESKINS_SKINS;
			DROP TABLE IF EXISTS ESKINS_MATS;
			DROP TABLE IF EXISTS ESKINS_CATEGORIES;
			DROP TABLE IF EXISTS ESKINS_BLACKLIST;
			DROP TABLE IF EXISTS ESKINS_PURCHASES;
			DROP TABLE IF EXISTS ESKINS_SETTINGS;
			COMMIT;
		]]
	end
	
	return query
	
end

function SV_EASYSKINS.DBQuery( query, callback )

	query = SanitizeQueryForSqlite(query)
	
	local result = sql.Query( query )
	
	if result == false then
		error( "Query Errored, Error: "..sql.LastError().." Query: "..query )
	end
	
	if callback ~= nil then
		callback(result or {})
	end
	
end