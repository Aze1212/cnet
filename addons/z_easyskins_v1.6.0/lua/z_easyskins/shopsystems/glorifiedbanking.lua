-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for GlorifiedBanking
	- Implementation by Tom.bat
*/

if !GlorifiedBanking then return end

local gbShopSystem = {}
gbShopSystem.name = "GlorifiedBanking"

function gbShopSystem.GetPoints( ply )
	return GlorifiedBanking.GetPlayerBalance( ply )
end

if SERVER then

	function gbShopSystem.TakePoints( ply, amount )
		GlorifiedBanking.RemovePlayerBalance( ply, amount )
	end

	function gbShopSystem.GivePoints( ply, amount )
		GlorifiedBanking.AddPlayerBalance( ply, amount )
	end
	
end

return gbShopSystem