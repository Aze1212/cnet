-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

-- for custom weapon packs
local function HookWepActions( ply, wep, material )

	-- Ballistic Shields
	if wep.isBalisticShield then
		local workaround = SH_EASYSKINS.GetWorkarounds().BALLISTIC_SHIELDS
		workaround.hookWep(ply, wep, material)
	end
	
end


util.AddNetworkString("cl_easyskins_ApplyWorldModelSkinRequest")
function SV_EASYSKINS.ApplyMaterial( wep, material, target )

	-- don't apply any materials if worldmodel skins are disabled
	if !SH_EASYSKINS.SETTINGS.WORLDMODELSKINS then return end

	local wepIndex = wep:EntIndex()

	-- method 1: works for certain worldmodels ( HL2, CSS )
	timer.Simple(0, function()
		if IsValid(wep, skin) then
			SH_EASYSKINS.ApplySkinToModel( wep, material )
		end
	end)
	
	-- method 2: apply skin on worldmodel clientside
	net.Start("cl_easyskins_ApplyWorldModelSkinRequest")
		net.WriteInt(wepIndex,16)
		net.WriteString(material)
		
	if target == nil then
		net.Broadcast()
	else
		net.Send(target)
	end
	
end

function SV_EASYSKINS.ApplySkin( ply, wep, target )

	local class = wep:GetClass()

	local purchasedSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(ply,class)
	local material = ""
	
	if purchasedSkin ~= nil then
	
		local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
		
		if skin ~= nil then
			material = skin.material.path
		end
		
	end
	
	-- hook certain actions
	HookWepActions( ply, wep, material )
	
	-- apply material on CL and SV
	SV_EASYSKINS.ApplyMaterial( wep, material, target )
	
end

local function WeaponEquip( wep, ply )
	
	-- can be called too early when the player is still spawning in
	if !ply:IsClientValid() then 
		timer.Simple(0.1, function()
			if IsValid( wep, ply ) and wep:IsValid() then
				WeaponEquip( wep, ply )
			end
		end)
		return
	end
	
	-- apply skin on the equipped weapon
	SV_EASYSKINS.ApplySkin( ply, wep )
	
end
hook.Add("WeaponEquip","sv_easyskins_WeaponEquip",WeaponEquip)

local function PlayerInitialSpawn( ply )

	local delay = 0

	-- load all applied skins from all players
	for k,p in pairs (player.GetHumans()) do
		
		if p == ply then continue end
		
		local pWeapons = p:GetWeapons()
		
		for i=1, #pWeapons do
			
			local wep = pWeapons[i]
			delay = delay + (i/10)
			
			timer.Simple(delay,function()
			
				if IsValid(p, wep, ply) and wep:IsValid() then
					SV_EASYSKINS.ApplySkin(p, wep, ply)
				end
				
			end)
			
		end
		
	end
	
end
hook.Add("PlayerInitialSpawn","sv_easyskins_PlayerInitialSpawn",PlayerInitialSpawn)