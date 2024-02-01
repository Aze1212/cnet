-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for the XStore
	Wiki: https://www.gmodstore.com/market/view/6751
*/

if xStore == nil then return end

local xStoreShopSystem = {}
xStoreShopSystem.name = "xStore"

function xStoreShopSystem.GetPoints( ply )
	return ply:GetNetVar( "xStore_Points", 0 )
end

if SERVER then

	function xStoreShopSystem.TakePoints( ply, amount )
		xStore.RemovePoints( ply, amount )
	end

	function xStoreShopSystem.GivePoints( ply, amount )
		xStore.AddPoints( ply, amount )
	end
	
end

return xStoreShopSystem