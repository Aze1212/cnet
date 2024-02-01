-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	This file loads the implementation for the detected database system
*/

local databases = file.Find( "z_easyskins/databases/*.lua", "LUA" )
local isLoaded

for i=1, #databases do

	local db = databases[i]
	local f = "../databases/"..db
	local includeRes = include( f )
	
	isLoaded = includeRes == nil

	if isLoaded then 
		SV_EASYSKINS.db = db
		SV_EASYSKINS.dbIsSQLITE = SV_EASYSKINS.db == "xsqlite.lua"
		break
	end
	
end

if isLoaded then
	
	local tblDataCache = {}
	local sqliteTableInfoQuery = "PRAGMA table_info(%s);"
	local mysqlTableInfoQuery = [[ 
		SELECT `COLUMN_NAME`'name'
		FROM `INFORMATION_SCHEMA`.`COLUMNS` 
		WHERE `TABLE_NAME`='%s';
	]]
	
	function SV_EASYSKINS.DBColumnExists( tbl, column, callback )
		
		local function CheckIfColumnExists(tblData)

			for i=1, #tblData do
				
				local tblColumn = tblData[i]

				if tblColumn.name == column then 
					callback(true)
					return
				end
				
			end
			
			callback(false)
			
		end
		
		-- use cache if tbl was querried before
		if tblDataCache[tbl] ~= nil then

			CheckIfColumnExists(tblDataCache[tbl])
		
		else
		
			local columnInfoQuery
			
			if SV_EASYSKINS.dbIsSQLITE then
				columnInfoQuery = sqliteTableInfoQuery
			else
				columnInfoQuery = mysqlTableInfoQuery
			end
			
			-- add tbl name to query
			columnInfoQuery = string.format( columnInfoQuery, tbl )
			
			SV_EASYSKINS.DBQuery(columnInfoQuery, function(tblData)
				
				-- save in cache
				tblDataCache[tbl] = tblData
			
				CheckIfColumnExists(tblData)
				
			end) 		
		
		end

	end

end