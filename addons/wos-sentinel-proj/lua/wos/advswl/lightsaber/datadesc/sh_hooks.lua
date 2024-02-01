--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2021
	
	Contact: www.wiltostech.com
		----------------------------------------]]--









































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.DataDesc = wOS.ALCS.DataDesc or {}

local function GMOD_istable_clrcheck( var )
	if istable( var ) then
		return !IsColor( var )
	end
	return false
end

function wOS.ALCS.DataDesc:Delete( ent, desc )
	if not ent then return end
	if not desc then return end
	if not ent.DataDescs then return end
	ent.DataDescs[ desc ] = nil
	ent[ "Get"  .. desc ] = nil
end

function wOS.ALCS.DataDesc:Install( ent, desc, typ )
	if not ent then return end
	if not desc then return end
	if not typ then return end

	ent.DataDescs = ent.DataDescs or {}

	ent.DataDescs[ desc ] = typ

	ent["Get" .. desc ] = function( self, key, no_fallback )
		if self[ desc ] and GMOD_istable_clrcheck( self[ desc ] ) then 
			key = key or 1
			key = tonumber( key )
			if no_fallback then return self[ desc ][ key ] end
			if self[ desc ][ key ] == nil then return self[ desc ][ 1 ] end
			return self[ desc ][ key ]
		end
		return self[ desc ]
	end

end


-- hook.Add( "wOS.ALCS.Lightsaber.OnInitialize", "wOS.ALCS.DataDesc.CreateSWEPDesc", function( wep ) 
--     wep:SetupDataDescs()
-- end )
