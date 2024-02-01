-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for Credit Store
	Wiki: https://www.gmodstore.com/market/view/credit-store-flat-ui-permanent-weapons-donations
*/

if CreditShop_Config == nil then return end

local creditStoreShopSystem = {}
creditStoreShopSystem.name = "Credit Store"

function creditStoreShopSystem.GetPoints( ply )
	
	if CLIENT then
		return i_credits
	end

	return ply.i_credits
	
end

if SERVER then

	function creditStoreShopSystem.TakePoints( ply, amount )
		ply:TakeCredits( amount )
	end

	function creditStoreShopSystem.GivePoints( ply, amount )
		ply:AddCredits( amount )
	end
	
end

return creditStoreShopSystem