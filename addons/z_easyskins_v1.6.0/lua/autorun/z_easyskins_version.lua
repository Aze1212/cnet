-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	This file is used to check if Easy Skins is using the latest version
*/

local gmodstoreLink = "https://www.gmodstore.com/api/v3/products/%s/versions"
local apiKey = "bb7fc6fd-d28c-4bcb-b864-db6a409fa50f|l4OpPCggdfo0jd1xBBtEiLcl3SGoWLP4tNjXDwjZ"
local easySkinsID = "f70eb5bc-a809-4960-b57f-5a62e0b432b6"
local easySkinsVersion = "1.6.0"
local updateMsg = "[Easy Skins] New version %s available! (curr: %s)"

local function VersionCheck()

	-- retrieve versions from gmodstore
	http.Fetch( string.format(gmodstoreLink,easySkinsID),
		function( body, len, headers, code )

			local response = util.JSONToTable(body)
			
			-- gmodstore api problem -> do nothing
			if response == nil then return end
			
			local data = response.data

			if data and istable(data) and #data > 0 then
			
				local latestVersion = data[1].name
				local latestVersionNum = tonumber(string.Replace( latestVersion, '.', '' ))
				local installedVersionNum = tonumber(string.Replace( easySkinsVersion, '.', '' ))
				
				if installedVersionNum < latestVersionNum then
					
					local updateMsg = string.format(updateMsg,latestVersion,easySkinsVersion)
					
					if SERVER then
						print(updateMsg)
					end
					
					SH_EASYSKINS.VAR.LATESTVERSION = false
					SH_EASYSKINS.VAR.LATESTVERSIONMSG = updateMsg
					
				end
				
			end

		end,
		function( error )
			-- do nothing
		end,
		{
			["Authorization"] = "Bearer "..apiKey
		}
	)
	
end
timer.Simple(0, VersionCheck)