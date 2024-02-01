-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for Pointshop2 standard points
	Wiki: https://buildmedia.readthedocs.org/media/pdf/pointshop2/latest/pointshop2.pdf
*/

local ps2Conf = file.Find( "ps2/shared/sh_config.lua", "LUA" )[1]

if Pointshop2 == nil and ps2Conf == nil then return end

local ps2StandardShopSystem = {}
ps2StandardShopSystem.name = "PS2 Standard"
ps2StandardShopSystem.priority = 2

function ps2StandardShopSystem.GetPoints( ply )
	return ply.PS2_Wallet.points or 0
end

if SERVER then

	function ps2StandardShopSystem.TakePoints( ply, amount )
		ply:PS2_AddStandardPoints( -amount )
	end

	function ps2StandardShopSystem.GivePoints( ply, amount )
		ply:PS2_AddStandardPoints( amount )
	end
	
end

return ps2StandardShopSystem