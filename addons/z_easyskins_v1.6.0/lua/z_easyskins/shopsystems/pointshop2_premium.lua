-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for Pointshop2 premium points
	Wiki: https://buildmedia.readthedocs.org/media/pdf/pointshop2/latest/pointshop2.pdf
*/

local ps2Conf = file.Find( "ps2/shared/sh_config.lua", "LUA" )[1]

if Pointshop2 == nil and ps2Conf == nil then return end
 
local ps2PremiumShopSystem = {}
ps2PremiumShopSystem.name = "PS2 Premium"
 
function ps2PremiumShopSystem.GetPoints( ply )
	return ply.PS2_Wallet.premiumPoints or 0
end

if SERVER then

	function ps2PremiumShopSystem.TakePoints( ply, amount )
		ply:PS2_AddPremiumPoints( -amount )
	end

	function ps2PremiumShopSystem.GivePoints( ply, amount )
		ply:PS2_AddPremiumPoints( amount )
	end
	
end

return ps2PremiumShopSystem