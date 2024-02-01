-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for DarkRP
	Wiki: https://wiki.darkrp.com/index.php/Main_Page
*/

if !DarkRP then return end

local darkRPShopSystem = {}
darkRPShopSystem.name = "DarkRP"
darkRPShopSystem.priority = 10

function darkRPShopSystem.GetPoints( ply )
	return ply:getDarkRPVar("money") or 0
end

if SERVER then

	function darkRPShopSystem.TakePoints( ply, amount )
		ply:addMoney( -amount )
	end

	function darkRPShopSystem.GivePoints( ply, amount )
		ply:addMoney( amount )
	end
	
end

return darkRPShopSystem