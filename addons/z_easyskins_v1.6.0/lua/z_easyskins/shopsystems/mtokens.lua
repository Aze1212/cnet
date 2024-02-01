-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Currency implementation for mTokens
	Wiki: https://www.gmodstore.com/market/view/6712
*/

if mTokens == nil then return end 

local mTokensShopSystem = {}
mTokensShopSystem.name = "mTokens"

function mTokensShopSystem.GetPoints( ply )
    return mTokens.GetPlayerTokens(ply)
end

if SERVER then

    function mTokensShopSystem.TakePoints( ply, amount )
        mTokens.TakePlayerTokens(ply, amount)
    end

    function mTokensShopSystem.GivePoints( ply, amount )
        mTokens.AddPlayerTokens(ply, amount)
    end
    
end

return mTokensShopSystem