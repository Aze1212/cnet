-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	DarkRP workarounds:
		1. skins for /drop
		2. skins on dropped inventory weapons
*/

local function OnDarkRPWeaponDropped(ply, ent, weapon)

	local class = weapon:GetClass() or ''
	local enabledSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(ply,class)

	if enabledSkin then
		
		local skinInfo = SH_EASYSKINS.GetSkin(enabledSkin.skinID)
	
		if skinInfo and IsValid(ent) then
			SH_EASYSKINS.ApplySkinToModel(ent, skinInfo.material.path)
		end

	end

end
hook.Add("onDarkRPWeaponDropped","sv_easyskins_OnDarkRPWeaponDropped",OnDarkRPWeaponDropped)


-- https://wiki.darkrp.com/index.php/Hooks/Server/onPocketItemDropped

-- + add PlayerSpawnedSENT( Player ply, Entity ent ) in utopia v2