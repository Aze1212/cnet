-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for Credit Store 2
	Wiki: https://www.gmodstore.com/market/view/6778
*/

if BRICKSCREDITSTORE == nil then return end

local creditStore2ShopSystem = {}
creditStore2ShopSystem.name = "Credit Store 2"

function creditStore2ShopSystem.GetPoints( ply )
	return ply:GetBRCS_Credits()
end

if SERVER then

	function creditStore2ShopSystem.TakePoints( ply, amount )
		ply:RemoveBRCS_Credits( amount )
	end

	function creditStore2ShopSystem.GivePoints( ply, amount )
		ply:AddBRCS_Credits( amount )
	end
	
end

return creditStore2ShopSystem