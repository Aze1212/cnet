-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

// MySQLOO

local HOST = ""
local USERNAME = ""
local PASS = ""
local DB_NAME = ""
local DB_PORT = 3306

-- verification check
if #HOST == 0 or #USERNAME == 0 or #PASS == 0 or #DB_NAME == 0 then
	return false
end

require( "mysqloo" )

local db = mysqloo.connect(HOST,USERNAME ,PASS, DB_NAME, DB_PORT )
local queue = {}

function db:onConnected()

	for k, v in pairs( queue ) do
		SV_EASYSKINS.DBQuery( v[ 1 ], v[ 2 ] )
	end
	queue = {}

end

function db:onConnectionFailed( err )

	error( "Connection to database failed!\n"..err )

end

function SV_EASYSKINS.DBQuery( query, callback )
	
	local q = db:query( query )
	
	local function TryAgain()
		table.insert( queue, { query, callback } )
		db:connect()
	end
	
	if q == nil then
		TryAgain()
		return
	end

	function q:onError( err )

		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			TryAgain()
			return
		end

		error( "Query Errored, Error: "..err.." Query: "..query )

	end
	
	function q:onSuccess( data )
		if callback ~= nil then 
			callback( data )
		end
	end

	q:start()

end

db:connect()