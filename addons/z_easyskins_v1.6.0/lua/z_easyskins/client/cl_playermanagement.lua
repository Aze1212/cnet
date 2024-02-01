-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

-- get a reference to Responses[identifier]
function CL_EASYSKINS.GetNetworkedResponse(identifier)
		
	local ply = LocalPlayer()
	
	if ply.Responses == nil then
		ply.Responses = {}
	end
	
	if ply.Responses[identifier] == nil then
		ply.Responses[identifier] = {}
	end
	
	return ply.Responses[identifier] 
	
end

-- retrieves and removes the response
function CL_EASYSKINS.RetrieveNetworkedResponse(identifier)
	
	local response = CL_EASYSKINS.GetNetworkedResponse(identifier)
	
	if response and response.received then
		
		-- create copy to return
		local respCopy = table.Copy(response)
		
		-- remove from response cache
		table.Empty(response)
		
		return respCopy
	
	end
	
	return false

end

local function GetSkinOwnersResponse()

	-- hook the data to our player object so that we can listen for it
	local response = CL_EASYSKINS.GetNetworkedResponse("GetSkinOwnersResponse")
	response.players = net.ReadTable()
	response.received = true

end
net.Receive("cl_easyskins_GetSkinOwnersResponse",GetSkinOwnersResponse)

local function GetPlayerPurchasesResponse()
	
	-- hook the data to our player object so that we can listen for it
	local response = CL_EASYSKINS.GetNetworkedResponse("GetPlayerPurchasesResponse")
	response.purchases = net.ReadTable()
	response.received = true	

end
net.Receive("cl_easyskins_GetPlayerPurchasesResponse",GetPlayerPurchasesResponse)