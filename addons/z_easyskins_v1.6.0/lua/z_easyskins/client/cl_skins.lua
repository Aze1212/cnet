-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	Handling skin requests on viewmodel and worldmodel
	- finding the correct vm and wm
	- applying skins
*/

-- weps that don't work with submaterials
local noSubmaterialSWEPS = {
	["weapon_ttt_ksg"] = true
}

// View Model
local function GetCustomBaseVM( vm, wep )

	-- Workaround weapons
	local workaroundVM = SH_EASYSKINS.WeaponWorkaroundViewModel( vm, wep )
	if workaroundVM ~= nil then
		return workaroundVM
	end

	-- CW2.0
	if wep.CW_VM ~= nil then
		return wep.CW_VM
	end
	
	-- FAS2.0
	if wep.Wep ~= nil then
		return wep.Wep
	end
	
	-- TFA
	if wep.OwnerViewModel ~= nil and wep.MaterialTable_V ~= nil then
	
		local indexes = SH_EASYSKINS.GetAllowedIndexesForMaterialChange(wep.OwnerViewModel)
		
		-- save the old material values
		if wep.MaterialTable_V_COPY == nil then
			wep.MaterialTable_V_COPY = table.Copy(wep.MaterialTable_V)
		end
		
		-- reset any material changes
		wep.MaterialTable_V = table.Copy(wep.MaterialTable_V_COPY)

		return wep.OwnerViewModel		
		
	end
	
	-- Modern Warfare --> they removed compatibility
	-- if wep.VModel ~= nil then
		-- return wep.VModel
	-- end
	//print(weapons.IsBasedOn(wep:GetClass(), "mg_base"))

	-- ARC9
	if wep.ARC9 ~= nil then
		return wep:GetVM()
	end

	return vm
	
end

local arc9_dev_benchgun = GetConVar("arc9_dev_benchgun")

function CL_EASYSKINS.ApplyMaterialToVM( vm, wep, material )

	-- Sleek Weapon Base -> calcs zoom in predraw func
	if !wep.SWBWeapon and !wep.ArcCW then
	
		-- override predraw func ( some weapons have custom submaterials set every call )
		wep.PreDrawViewModel = function() end
		
	end
	
	-- ARC9 expects cam.Start3D to be set up in PreDrawViewModel
	if wep.ARC9 then
		wep.PreDrawViewModel = function() 
			if !arc9_dev_benchgun:GetBool() then
				cam.Start3D()
			end
		end
	end
	
	-- SWSC -> clears sub materials every frame
	if wep.IsSWCSWeapon then
		//wep.ApplyWeaponSkin = function() print("called") end
		wep.RemoveWeaponSkin = function() end
	end
	
	-- Retro Boomboxes (disable default vm material reset)
	if RetroBoombox and wep.PlayStation and wep.PlayMusic then
		
		-- hook Easy Skins
		if !RetroBoombox.__EasySkins then
			
			RetroBoombox.__EasySkins = true
			
			local oldChangeColor = RetroBoombox.ChangeColor 
			
			RetroBoombox.ChangeColor = function(self, eBoombox, sType, sColor)
			
				oldChangeColor(self, eBoombox, sType, sColor)
				
				-- get enabled skin for boombox
				local ply = eBoombox.BoomboxOwner or LocalPlayer()
				local enabledSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(ply, "retroboombox_base")
				
				if enabledSkin ~= nil then
				
					-- get skin info
					local skin = SH_EASYSKINS.GetSkin(enabledSkin.skinID)
					
					if skin ~= nil then
					
						-- set enabled skin on boombox
						SH_EASYSKINS.ApplySkinToModel(eBoombox, skin.material.path, eBoombox, true)
					
					end
					
				end
				
			end
			
		end
		
	end
	
	-- TFA
	if wep.OwnerViewModel ~= nil and wep.MaterialTable_V ~= nil then
		
		local indexes = SH_EASYSKINS.GetAllowedIndexesForMaterialChange(wep.OwnerViewModel)
		
		for i=1, #indexes do
		
			local index = indexes[i]
			
			-- add the materials in the MaterialTable_V tbl so that TFA will reapply the materials on equip
			wep.MaterialTable_V[index+1] = material
		
		end
		
	end
	
	
	local class = wep:GetClass() or ""
	
	if noSubmaterialSWEPS[class] then
	
		-- non-submaterial weapons
		vm:SetMaterial(material)
	
	else
	
		-- the rest
		SH_EASYSKINS.ApplySkinToModel(vm, material, wep, true)
		
	end

end

local prevWepSet = nil
local function PreDrawViewModel( vm, ply, wep )
	
	if IsValid(vm,ply,wep) and !wep.__skinSet then

		wep.__skinSet = true
		
		-- make sure the skin can reapply the next time it is drawn
		if IsValid(prevWepSet) and prevWepSet ~= wep then
			prevWepSet.__skinSet = false
		end
		
		-- remember prev VM
		prevWepSet = wep
		
		local class = wep:GetClass()
		
		-- stop if weapon is blacklisted
		if SH_EASYSKINS.WEPBLACKLIST[class] then return end
		
		-- reset any prev set materials
		local vm = GetCustomBaseVM( vm, wep )
		vm:SetSubMaterial()
		vm:SetMaterial()
		
		local wepOwner = wep:GetOwner() or ply -- wepOwner != ply when spectating
		local purchasedSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(wepOwner,class)
		
		if purchasedSkin == nil then
			
			-- is no skin is enabled and base skin is set
			if #SH_EASYSKINS.SETTINGS.BASESKINMATERIAL > 0 then
			
				-- apply base skin
				CL_EASYSKINS.ApplyMaterialToVM( vm, wep, SH_EASYSKINS.SETTINGS.BASESKINMATERIAL )
				
			end
			
			return
			
		end
		
		local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
		
		if skin == nil then return end

		-- apply skin
		CL_EASYSKINS.ApplyMaterialToVM( vm, wep, skin.material.path )
		
	end
	
end
hook.Add("PreDrawViewModel","cl_easyskins_PreDrawViewModel",PreDrawViewModel)

// World Model
local function GetCustomBaseWM(wep, material)

	-- Workaround weapons
	local workaroundWM = SH_EASYSKINS.WeaponWorkaroundWorldModel(wep, material)
	if workaroundWM ~= nil then
		return workaroundWM
	end

	-- CW2.0
	if wep.WMEnt ~= nil then
		return wep.WMEnt
	end

	-- FAS2.0
	if wep.W_Wep ~= nil then
		return wep.W_Wep
	end
	
	-- Modern Warfare --> they removed compatibility
	-- if wep.m_WorldModel ~= nil then
		-- return wep.m_WorldModel
	-- end
	
	-- SWSC
	if wep.cl_wm ~= nil then
		return wep.cl_wm
	end
	
	-- ARC9
	if wep.ARC9 ~= nil then
		return wep:GetWM()
	end
	
	return wep

end

local entTries = {}
local ApplyWorldModelSkin

local function GetRetries(wepIndex)
	return entTries[wepIndex]
end

local function RetryApplyWorldModelSkin(wepIndex, material)

	if entTries[wepIndex] == nil then
		entTries[wepIndex] = 1
	else
		entTries[wepIndex] = entTries[wepIndex] + 1
	end

	-- give up after 10 retries
	if entTries[wepIndex] > 10 then
		entTries[wepIndex] = 0
		return
	end
	
	-- try again after a slightly longer delay each time
	timer.Simple(0.1*entTries[wepIndex],function()

		local success = ApplyWorldModelSkin(wepIndex, material)
		
		-- reset tries if it succeeded
		if success then
			entTries[wepIndex] = 0
		end
		
	end)
	
end

local function CustomBaseFix(wep)
	
	local class = wep:GetClass()
	
	-- Vape Sweps
	if string.StartWith( class, "weapon_vape" ) then
		wep.forceExtraDraw = true
	end
	
	-- ArcCW
	if wep.ArcCW ~= nil then
		wep.forceExtraDraw = true
	end
	
end

local function CustomEntityFix(wep, material)

	-- Ballistic Shields
	if wep.isBalisticShield then
		GetCustomBaseWM(wep, material)		
	end
	
end

function ApplyWorldModelSkin( wepIndex, material )
	
	local wep = Entity(wepIndex)

	if !wep:IsValid() then
		RetryApplyWorldModelSkin(wepIndex, material)
		return false
	end
	
	local class = wep:GetClass() or ""
	local wepOwner = wep:GetOwner() or LocalPlayer()
	
	-- notify that a skin was set for target
	if IsValid(wepOwner) then
		hook.Run( "cl_easyskins_ApplyWorldModelSkin", wepOwner, class, material )
	end
	
	-- for custom entities that aren't weapons
	if CustomEntityFix(wep,material) then return end
	
	-- these weapons have no DrawWorldModel function
	if SH_EASYSKINS.NONLINKEDMODELS[class] ~= nil then
		wep:SetMaterial(material)
		return
	end
	
	if wep.DrawWorldModel == nil then
		RetryApplyWorldModelSkin(wepIndex, material)
		return false
	end
	
	-- fixes for certain bases
	CustomBaseFix(wep)
	
	wep.__DrawWorldModel = wep.__DrawWorldModel or wep.DrawWorldModel
	
	local oldDrawWorldModelValid = isfunction(wep.__DrawWorldModel)
	
	wep.DrawWorldModel = function(self)
	
		if oldDrawWorldModelValid then
			self:__DrawWorldModel()
		end
	
		local model = GetCustomBaseWM(self, material)
		
		if noSubmaterialSWEPS[class] then
		
			-- non-submaterial weapons
			model:SetMaterial(material)
		
		else
			
			-- apply skin to worldmodel
			SH_EASYSKINS.ApplySkinToModel( model, material, wep, false )
			
		end
		
		-- is needed in some instances
		if self.forceExtraDraw then
			
			-- check if ArcCW is using custom model drawing
			if self.ArcCW ~= nil then
				
				if istable(self.WM) and self.WM[1] then
				
					local model = self.WM[1].Model
					
					SH_EASYSKINS.ApplySkinToModel( model, material, wep, false )
					
					-- self:DrawCustomModel(true)
				
					return
						
				end
							
			end
			
			self:DrawModel()
			
		end
		
	end
	
	-- Modern Warfare
	if wep.m_WorldModel ~= nil then 
		wep.__DrawWorldModelTranslucent = wep.__DrawWorldModelTranslucent or wep.DrawWorldModelTranslucent
		
		local oldDrawWorldModelTranslucentValid = isfunction(wep.__DrawWorldModelTranslucent)
		
		wep.DrawWorldModelTranslucent = function(self, flags)
			
			if oldDrawWorldModelTranslucentValid then
				self:__DrawWorldModelTranslucent()
			end
		
			local model = GetCustomBaseWM(self, material)
				
			-- apply skin to worldmodel
			SH_EASYSKINS.ApplySkinToModel( model, material, wep, false )
			
		end
	end
	
	return true
	
end

local function ApplyWorldModelSkinRequest(len, ply)

	local wepIndex = net.ReadInt(16)
	local material = net.ReadString()

	-- if a base mat is set and material set to 'none' -> change material
	if #SH_EASYSKINS.SETTINGS.BASESKINMATERIAL > 0 and #material == 0 then
		material = SH_EASYSKINS.SETTINGS.BASESKINMATERIAL
	end
	
	-- apply skin to worldmodel
	ApplyWorldModelSkin(wepIndex, material)

end
net.Receive("cl_easyskins_ApplyWorldModelSkinRequest",ApplyWorldModelSkinRequest)