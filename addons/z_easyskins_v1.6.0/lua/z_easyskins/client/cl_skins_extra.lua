-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	Extra functionality to support other addons
*/

// Weapon Holsters
local function AddWeaponHolsterSupport()

	if WepHolster and WepHolster.HolsteredWeps then
		
		local function GetSkinMaterialForClass(ply,class)
			
			ply.__EnabledSkins = ply.__EnabledSkins or {}
			
			local material = ply.__EnabledSkins[class]
			
			if material and #material == 0 then return end
			
			return material
		
		end
	
		-- save enabled skins for all players on client
		local function SaveEnabledSkinsOnPly(ply, class, material)
		
			ply.__EnabledSkins = ply.__EnabledSkins or {}
			ply.__EnabledSkins[class] = material
			
		end
		hook.Add("cl_easyskins_ApplyWorldModelSkin","cl_easyskins_WeaponHolster_SaveEnabledSkinsOnPly",SaveEnabledSkinsOnPly)

		-- remembers if a skin is set on a holstered class
		local wepHolsterSkinCache = {}

		local function PostPlayerDraw(ply)

			-- loop holstered weapons and set material
			for class, model in pairs(WepHolster.HolsteredWeps[ply:EntIndex()] or {}) do
				
				-- checked for skin already
				if wepHolsterSkinCache[class] ~= nil then continue end
				
				-- if the model is removed clear the cache
				model:CallOnRemove( "CleanCacheEntry", function()
					wepHolsterSkinCache[class] = nil
				end)
				
				local skinMaterial = GetSkinMaterialForClass(ply,class)
				
				-- check if skin is set for class
				wepHolsterSkinCache[class] = skinMaterial ~= nil
				
				if wepHolsterSkinCache[class] then 
				
					-- skin set on weapon
					SH_EASYSKINS.ApplySkinToModel(model, skinMaterial)
				
				else
					-- no skin set
					wepHolsterSkinCache[class] = false
				end
				
			end
		
		end
		hook.Add("PostPlayerDraw","cl_easyskins_WeaponHolster_PostPlayerDraw",PostPlayerDraw)

	end

end
hook.Add("Initialize","cl_easyskins_WeaponHolster",AddWeaponHolsterSupport)