-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for SH Pointshop
	Wiki: https://github.com/Shendow/SH-Pointshop-Docs/wiki
*/

if SH_POINTSHOP == nil then return end

local pointshopSHShopSystem = {}
pointshopSHShopSystem.name = "Pointshop SH"

function pointshopSHShopSystem.GetPoints( ply )
	return ply:SH_GetStandardPoints()
end

if SERVER then

	function pointshopSHShopSystem.TakePoints( ply, amount )
		ply:SH_AddStandardPoints( -amount )
	end

	function pointshopSHShopSystem.GivePoints( ply, amount )
		ply:SH_AddStandardPoints( amount )
	end
	
end

return pointshopSHShopSystem