-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Some packs use cuckoo ways when dealing with viewmodel and worldmodels.
*/

local workarounds = {}
local workaroundCache = {} -- cache

function SH_EASYSKINS.GetWorkarounds()
	return workarounds
end

function SH_EASYSKINS.WeaponNeedsWorkaround(regWep)

	local class = regWep.ClassName
	
	if workaroundCache[class] ~= nil then
		return workaroundCache[class]
	end
	
	-- try to find a workaround if possible
	for _, workaround in pairs(workarounds) do
		
		-- found a workaround
		if workaround.IsWorkaroundForWeapon(regWep) then
			workaroundCache[class] = workaround
			return workaround
		end
	
	end
	
	workaroundCache[class] = false
	
	return workaroundCache[class]
	
end

function SH_EASYSKINS.WeaponWorkaroundModels(class)

	local workaround = workaroundCache[class]
	
	if !workaround then return end
	
	return workaround.GetModels(class)
	
end

function SH_EASYSKINS.WeaponWorkaroundViewModel(vm, wep)
	
	local class = wep:GetClass()
	local workaround = workaroundCache[class]
	
	if !workaround then return end
	
	return workaround.GetViewModel(vm, wep)
	
end

function SH_EASYSKINS.WeaponWorkaroundMaterials(class)
	
	/* NOT GONNA HAPPEN
	* The idea was to make those external weapon renders skinnable with the blacklist 
	* Hurdles:
	*	- You would have to get a reference to every external model and loop their materials
	*	- Can only get materials by creating a clientside modal
	*/
	
	local workaround = nil

	if !workaround then return end 
	
	return workaround.GetMaterials(class)
	
end

function SH_EASYSKINS.WeaponWorkaroundWorldModel(wep, material)

	local class = wep:GetClass()
	local workaround = workaroundCache[class]

	if !workaround then return end

	return workaround.GetWorldModel(wep, material)

end

local function IsWorkaroundForWeapon(regWep,startsWith, match)
	
	-- faster then match
	for i=1, #startsWith do
		if string.StartWith(regWep.Category, startsWith[i]) then
			return true
		end
	end
	
	for i=1, #match do
		if string.match(regWep.Category, match[i]) then
			return true
		end
	end
	
	return false
	
end

/* 
	[TFA] StarWars Clone Republic Weapon Reworked Pack
	renders external models ontop of viewmodel and worldmodel
	-> challenge: getting reference to those models
	-> found solution:
		- TFA uses wep.elements.material, override it
		- wep:ClearStatCache() -> reapplies materials on external elements
*/

workarounds.TFA_STARWARS = {}
workarounds.TFA_STARWARS.categories = {
	startsWith = {
		"TFA StarWars",
		"Nick's weapons",
		"[Unity] Armas",
		"StarLegion New",
		"Оружие для дройдов",
		"Оружие для клонов",
		"Оружие для клонов (Личные)",
		"EA Battlefront II SWEPs",
		"Commandos 2k18 4k",
		"Metro 2033 RP", -- M9K pack
		"Darken217's SciFi Armory", -- Clavus SWEP Editor
		"Black Mesa",
		"S&G Munitions"
	},
	match = {
		"TFA Star Wars"
	}
}
workarounds.TFA_STARWARS.modelCache = {}
workarounds.TFA_STARWARS.materialCache = {}
workarounds.TFA_STARWARS.elementsBlackList = {
	["scope"] = true,
	["scope1"] = true,
	["scope2"] = true,
	["mag1"] = true,
	["mag2"] = true,
	["trd"] = true,
	["dc15_scope1"] = true,
	["dc15_scope2"] = true,
	["dc15_iron"] = true,
	["dc15_stock"] = true,
	["dc15_mag1"] = true,
	["element_scope"] = true,
	["element_scoped"] = true,
	["lazer"] = true,
	["visor"] = true,
	["scope3"] = true,
	["laser"] = true,
	["dc17m_holosight_holo"] = true,
	["dc17m_holosight"] = true,
	["dc17m_laser"] = true,
	["sniper_module_scope"] = true,
	["sniper_module_hp2"] = true,
	["sniper_module_hp1"] = true,
	["holosight"] = true,
	["txt_ammo"] = true,
	["txt_range"] = true,
	["txt_mod"] = true,
	["dc15sa_holo"] = true,
	["dc17m_holosights"] = true
}
workarounds.TFA_STARWARS.modelsBlackList = {
	["models/rtcircle.mdl"] = true
}

workarounds.TFA_STARWARS.IsWorkaroundForWeapon = function(regWep)
	
	local startsWith = workarounds.TFA_STARWARS.categories.startsWith
	local match = workarounds.TFA_STARWARS.categories.match
	
	return IsWorkaroundForWeapon(regWep,startsWith, match)
	
end

workarounds.TFA_STARWARS.GetModels = function(class)
	
	local modelCache = workarounds.TFA_STARWARS.modelCache[class]
	
	if modelCache ~= nil then
		return modelCache.viewModel, modelCache.worldModel
	end
	
	local elementsBlackList = workarounds.TFA_STARWARS.elementsBlackList
	local modelsBlackList = workarounds.TFA_STARWARS.modelsBlackList
	local weapon = weapons.Get(class)
	
	local viewModel, worldModel
	
	-- find viewmodel
	if weapon.VElements ~= nil then
		for k, vElement in pairs(weapon.VElements) do
			
			if !elementsBlackList[k] and !modelsBlackList[vElement.model or ''] then
			
				/* debug
				print(class,'vElement debug: '..k)
				if k == 'element_name' then
					PrintTable(vElement)
				end
				-- */
				
				viewModel = vElement.model
				
				-- viewmodel and worldmodel are the same
				worldModel = viewModel
				
			end
			
		end
	else
		-- some models use correct models
		viewModel = weapon.ViewModel
		worldModel = weapon.WorldModel
	end

	-- save result in cache
	workarounds.TFA_STARWARS.modelCache[class] = {
		viewModel = viewModel,
		worldModel = worldModel
	}

	return viewModel, worldModel
	
end

/* EXPERIMENT: Code is never called */
workarounds.TFA_STARWARS.GetMaterials = function(class)
	
	local materialCache = workarounds.TFA_STARWARS.materialCache[class]
	
	if materialCache ~= nil then
		return materialCache.vmMats, materialCache.wmMats
	end 
	 
	local elementsBlackList = workarounds.TFA_STARWARS.elementsBlackList
	local modelsBlackList = workarounds.TFA_STARWARS.modelsBlackList
	local weapon = weapons.Get(class)
	
	local vmMats, wmMats = {}, {}
	
	-- viewmodel mats
	if weapon.VElements ~= nil then
		for k, vElement in pairs(weapon.VElements) do
			
			if !elementsBlackList[k] and !modelsBlackList[vElement.model or ''] then	
				if vElement.model then
					local model = ClientsideModel( vElement.model, RENDERGROUP_OTHER )
					if IsValid(model) and IsEntity(model) and model.GetMaterials ~= nil then
						table.Add( vmMats, model:GetMaterials() )
					end
					SafeRemoveEntity(model)
				end
			end
			
		end
	end
	
	-- worldmodel mats
	if weapon.WElements ~= nil then
		for k, wElement in pairs(weapon.WElements) do
			
			if !elementsBlackList[k] and !modelsBlackList[wElement.model or ''] then	
				if wElement.model then
					local model = ClientsideModel( wElement.model, RENDERGROUP_OTHER )
					if IsValid(model) and IsEntity(model) and model.GetMaterials ~= nil then
						table.Add( wmMats, model:GetMaterials() )
					end
					SafeRemoveEntity(model) 
				end
			end
			
		end
	end

	PrintTable(vmMats)
	PrintTable(wmMats)

	-- save result in cache
	workarounds.TFA_STARWARS.materialCache[class] = {
		vmMats = vmMats,
		wmMats = wmMats
	}

	return vmMats, wmMats
	
end

workarounds.TFA_STARWARS.SetSkin = function(wep,elementsTblID,material)
	
	local elementsBlackList = workarounds.TFA_STARWARS.elementsBlackList
	local modelsBlackList = workarounds.TFA_STARWARS.modelsBlackList
	local wepElements = wep[elementsTblID]
	
	if wepElements ~= nil then
		for k, wepElement in pairs(wepElements) do
		
			wepElement.model = wepElement.model or ''
			
			if !elementsBlackList[k] and !modelsBlackList[wepElement.model or ''] then
			
				-- check global blacklist
				local matName = SH_EASYSKINS.GetNameFromMat(wepElement.model)
				matName = string.sub( matName, 1, #matName-4 ) -- remove .mdl from name
				if SH_EASYSKINS.IsMatBlacklisted(matName) then continue end
			
				-- set material
				wepElement.material = material
				
			end
			
		end
	else
		
		-- some weapons use correct view & worldmodel
		-- if elementsTblID == "VElements" then
		
		-- else
		
		-- end
	
	end
	
	-- apply on weapon
	if wep.ClearStatCache ~= nil then
		wep:ClearStatCache()
	end
	
end

workarounds.TFA_STARWARS.GetViewModel = function( vm, wep )
	
	local class = wep:GetClass()
	local purchasedSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(LocalPlayer(),class)
	local material = ""
	
	if purchasedSkin then
	
		local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
		material = skin.material.path
		
	elseif #SH_EASYSKINS.SETTINGS.BASESKINMATERIAL > 0 then
	
		material = SH_EASYSKINS.SETTINGS.BASESKINMATERIAL
		
	end
	
	-- apply skin -> no vm to return
	workarounds.TFA_STARWARS.SetSkin(wep,"VElements",material)
	
	return vm

end

workarounds.TFA_STARWARS.GetWorldModel = function(wep,material)
	
	-- apply skin -> no wm to return
	workarounds.TFA_STARWARS.SetSkin(wep,"WElements",material)
	
	return wep

end

/* 
	M9K using external weapon rendering
	-> challenge: getting reference to those models
	-> found solution:
		- M9K also uses WElements, override it
*/

workarounds.M9K_EXTERNAL = {}
workarounds.M9K_EXTERNAL.categories = {
	startsWith = {
		"Resurrections Custom Weapons"
	},
	match = {}
}
workarounds.M9K_EXTERNAL.modelCache = {}

workarounds.M9K_EXTERNAL.IsWorkaroundForWeapon = function(regWep)
	
	local startsWith = workarounds.M9K_EXTERNAL.categories.startsWith
	local match = workarounds.M9K_EXTERNAL.categories.match
	
	return IsWorkaroundForWeapon(regWep,startsWith, match)
	
end

workarounds.M9K_EXTERNAL.GetModels = function(class)
	
	
	local modelCache = workarounds.M9K_EXTERNAL.modelCache[class]
	
	if modelCache ~= nil then
		return modelCache.viewModel, modelCache.worldModel
	end
	
	local weapon = weapons.Get(class)
	
	-- for the tested weapon base the creator set both models correctly
	local viewModel, worldModel = weapon.ViewModel, weapon.WorldModel
	
	-- save result in cache
	workarounds.M9K_EXTERNAL.modelCache[class] = {
		viewModel = viewModel,
		worldModel = worldModel
	}
	
	return viewModel, worldModel
	
end

workarounds.M9K_EXTERNAL.GetViewModel = function( vm, wep )
	-- use default method
end

workarounds.M9K_EXTERNAL.GetWorldModel = function(wep,material)

	-- use TFA_STARWARS method of applying skin
	workarounds.TFA_STARWARS.SetSkin(wep,"WElements",material)
	
	return wep

end

/* 
	Ballistic Shields 🛡️
	-> challenge: getting reference to shield entities
	-> found solution:
		- Shield entities are linked to player object
*/

workarounds.BALLISTIC_SHIELDS = {}
workarounds.BALLISTIC_SHIELDS.categories = {
	startsWith = {
		"Ballistic shields",
	}
}

workarounds.BALLISTIC_SHIELDS.IsWorkaroundForWeapon = function(regWep)
	
	local startsWith = workarounds.BALLISTIC_SHIELDS.categories.startsWith
	local isWorkaroundForWeapon = IsWorkaroundForWeapon(regWep,startsWith, {})
	
	if isWorkaroundForWeapon then

		local weapon = weapons.GetStored(regWep.ClassName)
		weapon.isBalisticShield = true
		
	end
	
	return isWorkaroundForWeapon
	
end

workarounds.BALLISTIC_SHIELDS.GetModels = function(class)
	-- use default method
end

workarounds.BALLISTIC_SHIELDS.GetViewModel = function( vm, wep )
	-- use default method
end

workarounds.BALLISTIC_SHIELDS.GetWorldModel = function(wep,material)

	local ply = wep:GetOwner() or LocalPlayer()
	
	local function ApplySkinToShield(shieldEnt)
					
		-- apply skin to shield
		SH_EASYSKINS.ApplySkinToModel( shieldEnt, material, wep, false )
	
	end
	
	if CLIENT then
		
		local shieldIndex= ply.bs_shieldIndex
		
		if shieldIndex ~= nil then
		
			local shieldEnt = Entity(shieldIndex)
			
			if shieldEnt:IsValid() then
				ApplySkinToShield(shieldEnt)
			end
			
		end
	
	else
	
		local shieldEnt = ply.bs_shield
	
		if IsValid(shieldEnt) then
			ApplySkinToShield(shieldEnt)
		end
		
	end

	-- fallback to prevent errors
	return wep

end

if SERVER then

	workarounds.BALLISTIC_SHIELDS.hookWep = function(ply,wep,material)
	
		if wep.__alreadyHooked then return end
	
		wep.__alreadyHooked = true
	
		-- shield ent is recreated on deploy
		local __oldDeploy = wep.Deploy
		wep.Deploy = function(self)
		
			-- create shield ent
			__oldDeploy(self)
			
			timer.Simple(0,function()
				if IsValid(ply, self) then
					-- apply skin
					SV_EASYSKINS.ApplySkin( ply, self )
				end
			end)
			
		end
		
		local __oldPrimaryAttack = wep.PrimaryAttack 
		wep.PrimaryAttack = function(self)

			local ply = self:GetOwner() or ply
		
			-- create deployed shield ent
			__oldPrimaryAttack(self)
			
			timer.Simple(0,function()
		
				if !IsValid(ply, self) then return end
				
				local entTbl = ply.bs_shields
				
				for i=1, #entTbl do
					
					local ent = entTbl[i]
					
					if ent.hasSkin == material then continue end
					
					ent.hasSkin = material
					
					-- set material serverside
					SH_EASYSKINS.ApplySkinToModel( ent, material )
				
				end
				
			end)
		
		end

	end

	
end
