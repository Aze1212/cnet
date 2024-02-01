-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

// TMySQL

local HOST = ""
local USERNAME = ""
local PASS = ""
local DB_NAME = ""
local DB_PORT = 3306

-- verification check
if #HOST == 0 or #USERNAME == 0 or #PASS == 0 or #DB_NAME == 0 then 
	return false
end

require("tmysql4")

local db, err = tmysql.initialize(HOST, USERNAME, PASS, DB_NAME, DB_PORT)

if err ~= nil or type(db) == "boolean" then
	error( "Connection to database failed!\n"..err )

end

function SV_EASYSKINS.DBQuery( query, callback )

	local function OnResult(res)
		
		res = res[1]
	
		if not res.status then
			error( "Query Errored, Error: "..res.error.." Query: "..query )
		end
		
		if callback ~= nil then
			callback(res.data or {})
		end
	
	end
	
	db:Query(query, OnResult)
	
end