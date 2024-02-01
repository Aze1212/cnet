-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

-- playerObj.__Skins: skinID, weaponClass, enabled

function SH_EASYSKINS.GetPurchasedSkins(ply)
	
	if !ply then return {} end
	
	if ply.__Skins == nil then
		ply.__Skins = {}
	end

	return ply.__Skins or {}
	
end

function SH_EASYSKINS.GetPurchasedSkin(ply,skinID,weaponClass)

	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)

	for i=1, #purchasedSkins do

		local purchasedSkin = purchasedSkins[i]

		if purchasedSkin.skinID == skinID and purchasedSkin.weaponClass == weaponClass then
			return purchasedSkin, i
		end
	
	end
	
	return nil

end

function SH_EASYSKINS.GetPurchasedSkinsByClass(ply,weaponClass)
	
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local purchasedSkinsByClass = {}

	for i=1, #purchasedSkins do

		local purchasedSkin = purchasedSkins[i]

		if purchasedSkin.weaponClass == weaponClass then
			table.insert(purchasedSkinsByClass,purchasedSkin)
		end
	
	end
	
	return purchasedSkinsByClass
	
end

function SH_EASYSKINS.GetEnabledPurchasedSkinByClass(ply,class)

	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	
	for i=1, #purchasedSkins do

		local purchasedSkin = purchasedSkins[i]
		
		if purchasedSkin.weaponClass == class and purchasedSkin.enabled then
			return purchasedSkin
		end
	
	end
	
end

function SH_EASYSKINS.CanBuySkin(ply,skinID,weaponClass)
	
	if !IsValid(ply,skinID,weaponClass) then return false end
	
	local skin = SH_EASYSKINS.GetSkin(skinID)
	
	-- skin was removed by an admin
	if skin == nil then
		return false, "Skin was removed"
	end
	
	-- skin isn't purchasable
	if !skin.purchasable then
		return false, "Skin is unpurchasable"
	end
	
	-- check for custom currency
	local realPrice = SH_EASYSKINS.GetRealPrice(ply,skin)
	local plyIsDonator = SH_EASYSKINS.IsDonator(ply)
	local points = 0
	
	if #skin.currency > 0 and SH_EASYSKINS.ShopSystems.nameref[skin.currency] ~= nil then
		
		-- custom currency
		local shopCurrency = SH_EASYSKINS.ShopSystems.nameref[skin.currency]
		
		points = shopCurrency.GetPoints(ply)
		
	else
		-- default currency
		points = SH_EASYSKINS.GetPoints(ply)
	end

	
	-- donator only
	if skin.donatorOnly and !plyIsDonator then
		return false, "Skin is donator only"
	end
	
	-- steamgroup only
	if skin.steamgroupOnly and !SH_EASYSKINS.InSteamGroup(ply) then
		return false, "Skin is steam group only"
	end
	
	-- name tag only
	if skin.nameTagOnly and !SH_EASYSKINS.HasNameTag(ply) then
		return false, "Skin is name tag only"
	end

	-- skin was already bought for this class
	if SH_EASYSKINS.HasPurchasedSkin(ply,skinID,weaponClass) then
		return false, "You already own this skin"
	end
	
	-- not enough money
	if realPrice > points then
		return false, "Insuficient funds"
	end
	
	return true
	
end

function SH_EASYSKINS.HasPurchasedSkin(ply,skinID,weaponClass)

	if !IsValid(ply,skinID,weaponClass) then return false end

	local purchasedSkin = SH_EASYSKINS.GetPurchasedSkin(ply,skinID,weaponClass)
	
	return purchasedSkin ~= nil
	
end

function SH_EASYSKINS.GetRealPrice(ply,skin)

	-- skin was removed by an admin
	if !IsValid(ply,skin) then
		return 0
	end

	local plyIsDonator = SH_EASYSKINS.IsDonator(ply)
	local price = skin.price
	
	-- donator only
	if skin.donatorOnly then
		return skin.donatorPrice
	end
	
	-- donator discount
	if plyIsDonator then
		price = skin.donatorPrice
	end
	
	local discountPrice = price
	
	if !skin.steamgroupOnly and !skin.nameTagOnly then

		-- steamgroup discount
		if SH_EASYSKINS.InSteamGroup(ply) then
			discountPrice = price - (price * SH_EASYSKINS.SETTINGS.STEAMGROUPDISCOUNT)
		end

		-- name tag discount
		if SH_EASYSKINS.HasNameTag(ply) then
			discountPrice = discountPrice - (price * SH_EASYSKINS.SETTINGS.TAGDISCOUNT)
		end

	end
	
	return math.Round(discountPrice)
	
end

function SH_EASYSKINS.GetSellPrice(ply,skin)
	
	local realPrice = SH_EASYSKINS.GetRealPrice(ply,skin)
	local sellPrice = math.Round(realPrice*SH_EASYSKINS.SETTINGS.SELLRATE)
	
	return sellPrice
	
end