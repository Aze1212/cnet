-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function CL_EASYSKINS.BuySkin(skinID,weaponClass)
	
	if !SH_EASYSKINS.CanBuySkin(LocalPlayer(),skinID,weaponClass) then
		return
	end

	-- send to server
	net.Start("sv_easyskins_BuySkin")
		net.WriteInt(skinID,16)
		net.WriteString(weaponClass)
	net.SendToServer()
	
	-- show notification
	local skin = SH_EASYSKINS.GetSkin(skinID)
	CL_EASYSKINS.ReceiveSkinNotification(skin,weaponClass)
	
end

function CL_EASYSKINS.SellSkin(skinID,weaponClass)
	
	local ply = LocalPlayer()

	if !SH_EASYSKINS.HasPurchasedSkin(ply,skinID,weaponClass) then
		return
	end

	-- update on server
	net.Start("sv_easyskins_SellSkin")
		net.WriteInt(skinID,16)
		net.WriteString(weaponClass)
	net.SendToServer()
	
	-- don't wait for server
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local _, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(ply,skinID,weaponClass)
	table.remove(purchasedSkins,purchasedSkinID)
	
end

function CL_EASYSKINS.GiftSkin(skinID,weaponClass,steamID64)
	
	local ply = LocalPlayer()

	if !SH_EASYSKINS.HasPurchasedSkin(ply,skinID,weaponClass) then
		return
	end
	
	-- update on server
	net.Start("sv_easyskins_GiftSkin")
		net.WriteInt(skinID,16)
		net.WriteString(weaponClass)
		net.WriteString(steamID64)
	net.SendToServer()
	
	-- don't wait for server
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local _, purchasedSkinID = SH_EASYSKINS.GetPurchasedSkin(ply,skinID,weaponClass)
	table.remove(purchasedSkins,purchasedSkinID)
	
end

function CL_EASYSKINS.SetPurchasedSkinEnabled(purchasedSkin,enabled)

	if !SH_EASYSKINS.HasPurchasedSkin(LocalPlayer(),purchasedSkin.skinID,purchasedSkin.weaponClass) then
		return
	end
	
	-- update on server
	net.Start("sv_easyskins_SetPurchasedSkinEnabled")
		net.WriteInt(purchasedSkin.skinID,16)
		net.WriteString(purchasedSkin.weaponClass)
		net.WriteBool(enabled)
	net.SendToServer()
	
	-- don't wait for server
	purchasedSkin.enabled = enabled
	
	-- overload printname
	if SH_EASYSKINS.SETTINGS.ADDSKINTOWEAPONAME then
	
		local wep = LocalPlayer():GetWeapon(purchasedSkin.weaponClass)
		
		if wep ~= nil then
			CL_EASYSKINS.OverloadWeaponPrintName(wep)
		end
		
	end
	
end

local function UpdateClientPurchasedSkins()

	local ply = LocalPlayer()
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	local purchasedSkinCount = net.ReadInt(16)
	
	table.Empty(purchasedSkins)
	
	for i=1, purchasedSkinCount do
		
		local purchasedSkin = {
			skinID = net.ReadInt(16),
			weaponClass = net.ReadString(),
			enabled = net.ReadBool()
		}
		
		table.insert(purchasedSkins,purchasedSkin)
		
	end
	
	-- re-evaluate all viewmodel skins ( enabled skin may have changed )
	for _, wep in pairs(ply:GetWeapons()) do
		wep.__skinSet = false
	end

end
net.Receive("cl_easyskins_UpdateClientPurchasedSkins",UpdateClientPurchasedSkins)

/*
	Purchased skins are not networked -> Remember what skins were applied for which player
	Efficient way of getting enabled skins
	- we only add enabled skins -> 1 skin per class
*/

-- could be pointing to wrong skin -> small error margin but huge performance gain
local skinIDCache = {}

local function AddPurchasedSkin(target,class, material)

	if target == LocalPlayer() then return end
	
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(target)
	local skinID = skinIDCache[material]
	
	if skinID == nil or (skinID ~= nil and SH_EASYSKINS.GetSkin(skinID) == nil) then
		local skin = SH_EASYSKINS.GetSkinByMaterial(material)
		if skin ~= nil then
			skinID = skin.id
			skinIDCache[material] = skin.id
		end
	end
	
	-- skin not found
	if skinID == nil then return end
	
	for i=1,#purchasedSkins do
		
		local purchasedSkin = purchasedSkins[i]
		
		-- skin was already added just change the material
		if purchasedSkin.weaponClass == class then
			purchasedSkin.skinID = skinID
			return
		end
		
	end
	
	local purchasedSkin = {
		skinID = skinID,
		weaponClass = class,
		enabled = true
	}

	table.insert(purchasedSkins,purchasedSkin)
	
end
hook.Add("cl_easyskins_ApplyWorldModelSkin","cl_easyskins_AddPurchasedSkin", AddPurchasedSkin)