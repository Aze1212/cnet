-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for Pointshop (1)
	Wiki: https://pointshop.burt0n.net/getting-started
*/

if PS == nil then return end

local pointshopShopSystem = {}
pointshopShopSystem.name = "Pointshop"
pointshopShopSystem.priority = 2

function pointshopShopSystem.GetPoints( ply )
	return ply:PS_GetPoints()
end

if SERVER then

	function pointshopShopSystem.TakePoints( ply, amount )
		ply:PS_TakePoints( amount )
	end

	function pointshopShopSystem.GivePoints( ply, amount )
		ply:PS_GivePoints( amount )
	end
	
end

return pointshopShopSystem