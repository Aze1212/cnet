-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

util.AddNetworkString("cl_easyskins_UpdateClientPurchasedSkins")
function SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
	
	if !ply:IsClientValid() then
		timer.Simple(0.5,function()
			SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
		end)
		return
	end
	
	local skinCount = #purchasedSkins
	
	net.Start("cl_easyskins_UpdateClientPurchasedSkins")
		
		-- the amount of tables we are going to send
		net.WriteInt(skinCount,16)
		
		-- 64kb limit so we split up the table
		for i=1,skinCount do
			
			local purchasedSkin = purchasedSkins[i]
			
			net.WriteInt(purchasedSkin.skinID,16)
			net.WriteString(purchasedSkin.weaponClass)
			net.WriteBool(purchasedSkin.enabled)
			
		end
		
	net.Send(ply)
	
end

function SV_EASYSKINS.SetPurchasedSkins(ply,skins)
	
	-- set on server
	ply.__Skins = skins
	
	-- set on client
	SV_EASYSKINS.UpdateClientPurchasedSkins(ply,skins)
	
end

function SV_EASYSKINS.BuySkin(ply, skinID, weaponClass)
	
	local purchasedSkin = {
		skinID = skinID,
		weaponClass = weaponClass,
		enabled = false
	}

	if !SH_EASYSKINS.CanBuySkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass) then
		return
	end

	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	
	-- update server
	table.insert(purchasedSkins,purchasedSkin)
	
	-- update client
	SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
	
	-- add purchase to DB
	SV_EASYSKINS.DBAddPurchase(ply,purchasedSkin, function()
	
		-- take points when the purchase is saved
		local skin  = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
		local realPrice = SH_EASYSKINS.GetRealPrice(ply,skin)
		
		if realPrice == 0 then return end
		
		if #skin.currency > 0 and SH_EASYSKINS.ShopSystems.nameref[skin.currency] ~= nil then
			
			-- custom currency
			local shopCurrency = SH_EASYSKINS.ShopSystems.nameref[skin.currency]
			shopCurrency.TakePoints(ply,realPrice)
			
		else
			SV_EASYSKINS.TakePoints(ply,realPrice)
		end
		
	end)
	
end

util.AddNetworkString("sv_easyskins_BuySkin")
local function BuySkin(len,ply)

	local skinID = net.ReadInt(16)
	local weaponClass = net.ReadString()
	
	SV_EASYSKINS.BuySkin(ply, skinID, weaponClass)

end
net.Receive("sv_easyskins_BuySkin",BuySkin)

function SV_EASYSKINS.SellSkin(ply, skinID, weaponClass)
	
	local purchasedSkin = {
		skinID = skinID,
		weaponClass = weaponClass
	}

	if !SH_EASYSKINS.HasPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass) then
		return
	end
	
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local _, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass)
	
	local function OnRemove()
		
		if !IsValid(ply) then return end
	
		-- give points
		local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
		local sellPrice = SH_EASYSKINS.GetSellPrice(ply,skin)
		
		if sellPrice == 0 then return end
		
		if #skin.currency > 0 and SH_EASYSKINS.ShopSystems.nameref[skin.currency] ~= nil then
			
			-- custom currency
			local shopCurrency = SH_EASYSKINS.ShopSystems.nameref[skin.currency]
			shopCurrency.GivePoints(ply,sellPrice)
			
		else
			SV_EASYSKINS.GivePoints(ply,sellPrice)
		end

	end
	
	-- update server
	table.remove(purchasedSkins,purchasedSkinID)
	
	-- update client
	SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
	
	-- remove purchase from DB
	SV_EASYSKINS.DBRemovePurchase(ply,purchasedSkin,OnRemove)
	
end

util.AddNetworkString("sv_easyskins_SellSkin")
local function SellSkin(len,ply)

	local skinID = net.ReadInt(16)
	local weaponClass = net.ReadString()
	
	SV_EASYSKINS.SellSkin(ply, skinID, weaponClass)

end
net.Receive("sv_easyskins_SellSkin",SellSkin)

function SV_EASYSKINS.GiftSkin(ply, skinID, weaponClass, steamID64)

	local purchasedSkin = {
		skinID = skinID,
		weaponClass = weaponClass
	}

	if !SH_EASYSKINS.HasPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass) then
		return
	end
	
	// remove skin from player
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local _, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass)
	
	-- update server
	table.remove(purchasedSkins,purchasedSkinID)
	
	-- update client
	SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
	
	-- remove purchase from DB
	SV_EASYSKINS.DBRemovePurchase(ply,purchasedSkin)
	
	// give skin to target
	SV_EASYSKINS.GiveSkinToPlayer(steamID64, skinID, {weaponClass})
	
end

util.AddNetworkString("sv_easyskins_GiftSkin")
local function GiftSkin(len,ply)

	if !SH_EASYSKINS.SETTINGS.ALLOWSKINGIFTING then return end

	local skinID = net.ReadInt(16)
	local weaponClass = net.ReadString()
	local steamID64 = net.ReadString()
	
	SV_EASYSKINS.GiftSkin(ply, skinID, weaponClass, steamID64)

end
net.Receive("sv_easyskins_GiftSkin",GiftSkin)

util.AddNetworkString("sv_easyskins_SetPurchasedSkinEnabled")
local enableSkinTimeout = 0
local function SetPurchasedSkinEnabled(len,ply)
	
	if enableSkinTimeout > CurTime() then
		print("[ALERT] "..ply:Nick().."("..ply:SteamID()..") is trying to DOS the server by spamming an Easy Skins net message!")
		return
	end
	
	enableSkinTimeout = CurTime()+0.3
	
	local purchasedSkin = {
		skinID = net.ReadInt(16),
		weaponClass = net.ReadString(),
		enabled = net.ReadBool()
	}
	
	if !SH_EASYSKINS.HasPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass) then
		return
	end
	
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local purchasedSkinRef, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(ply,purchasedSkin.skinID,purchasedSkin.weaponClass)
	
	-- update enabled status
	purchasedSkinRef.enabled = purchasedSkin.enabled
	
	-- update purchased skin on DB
	SV_EASYSKINS.DBUpdatePurchase(ply,purchasedSkinRef)
	
	-- toggle all other skins from the same weapon to false
	if purchasedSkin.enabled then
	
		for i=1,#purchasedSkins do

			local pSkin = purchasedSkins[i]
			
			if pSkin.enabled and pSkin.weaponClass == purchasedSkin.weaponClass and pSkin.skinID ~= purchasedSkin.skinID then

				pSkin.enabled = false
				
				-- update purchased skin on DB
				SV_EASYSKINS.DBUpdatePurchase(ply,pSkin)
				
			end
		
		end
	
	end
	
	-- update client
	SV_EASYSKINS.UpdateClientPurchasedSkins(ply,purchasedSkins)
	
	-- apply skin on weapon
	local weapon = ply:GetWeapon( purchasedSkin.weaponClass )
	
	if IsValid(weapon) then
		SV_EASYSKINS.ApplySkin( ply, weapon )
	end
	
end
net.Receive("sv_easyskins_SetPurchasedSkinEnabled",SetPurchasedSkinEnabled)