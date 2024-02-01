-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local weaponList = nil

local function FillWeaponList()
	
	local regWeps = list.Get("Weapon") -- regWep: Category, ClassName, PrintName, Spawnable
	table.Add(regWeps,SH_EASYSKINS.EXTRASELECTABLEWEAPONS)
	
	weaponList = {}
	
	for _,regWep in pairs(regWeps) do
	
		-- don't add bases to the list
		if !regWep.ForceInList and string.find( regWep.ClassName, "base" ) ~= nil or #regWep.Category == 0 then
			continue
		end
		
		weaponList[regWep.Category] = weaponList[regWep.Category] or {}
		
		-- some weapons like #GMOD_Toolgun need to be translated
		local translatedName = CLIENT and language.GetPhrase(regWep.PrintName) or regWep.PrintName
		
		-- for TTT weapons
		if LANG ~= nil and istable(LANG) and LANG.GetTranslation ~= nil then

			-- bug where TTT lang isn't loaded yet
			if !LANG.__initialized then 
				LANG.Init()
				LANG.__initialized = true
			end
		
			local tttTranslation = LANG.GetRawTranslation(translatedName)
			if tttTranslation ~= nil then
				translatedName = tttTranslation
			end
			
		end
		
		-- mark if weapon needs workaround or not
		if SH_EASYSKINS.WeaponNeedsWorkaround(regWep) then
			-- cache result
			SH_EASYSKINS.WeaponWorkaroundModels(regWep.ClassName)
		end
		
		table.insert( weaponList[regWep.Category], { class = regWep.ClassName, name = translatedName } )
		
		-- precache weapon models serverside 
		if SERVER then
			local vm, wm = SH_EASYSKINS.GetWeaponModels(regWep.ClassName)
			
			if vm ~= nil and isstring(vm) then
				util.PrecacheModel(vm)
			end
			
			if vm ~= nil and isstring(wm) then
				util.PrecacheModel(wm)
			end  
		end  
	end
	
	-- precache weapon models clientside 
	if CLIENT then
		CL_EASYSKINS.PrecacheWeaponModels(weaponList)
	end
	 
end 
hook.Add("Initialize","sh_easyskins_FillWeaponList",FillWeaponList)

function SH_EASYSKINS.GetWeaponList()
	
	if weaponList == nil then 
		FillWeaponList()
	end
	
	return weaponList
	
end

function SH_EASYSKINS.GetWeaponInfo(class)

	if weaponList == nil then 
		FillWeaponList()
	end
	
	for cat,weaponTbl in pairs(weaponList) do 
		
		for i=1,#weaponTbl do
		
			local weaponInfo = weaponTbl[i]
			
			if weaponInfo.class == class then
				return weaponInfo
			end
		
		end
	
	end
	
	-- error("Weapon info for class <"..class.."> not found!")
	
end

local weaponModelCache = {}

function SH_EASYSKINS.GetWeaponModels(class)

	local modelCache = weaponModelCache[class]

	-- check cache
	if modelCache ~= nil then
		return modelCache.vm, modelCache.wm
	end

	local weapon = weapons.Get(class)
	local viewModel,worldModel = "", ""
	
	if weapon ~= nil then
		
		-- workaround weapons
		local workaroundVM, workaroundWM = SH_EASYSKINS.WeaponWorkaroundModels(class)
		if workaroundVM ~= nil then
		
			-- save in cache
			weaponModelCache[class] = {
				vm = workaroundVM,
				wm = workaroundWM
			} 
	
			return workaroundVM, workaroundWM
			
		end
		
		if weapon.WM ~= nil then 
			worldModel = weapon.WM
		elseif weapon.WorldModel ~= nil then
			worldModel = weapon.WorldModel
		end
		
		if weapon.VM ~= nil then
			viewModel = weapon.VM
		elseif weapon.ViewModel ~= nil then
			viewModel = weapon.ViewModel
		end
		
	elseif SH_EASYSKINS.NONLINKEDMODELS[class] ~= nil then
		
		local nonLinkedModel = SH_EASYSKINS.NONLINKEDMODELS[class]
		
		worldModel = nonLinkedModel.WorldModel
		viewModel = nonLinkedModel.ViewModel
		
	end
	
	-- save in cache
	weaponModelCache[class] = {
		vm = viewModel,
		wm = worldModel
	}
	
	return viewModel,worldModel

end

local duplicateNameCache = {}

-- checks if there are multiple registered weapons with the same name
function SH_EASYSKINS.IsDuplicateWeaponName(name)

	local nameCache = duplicateNameCache[name]
	
	if nameCache ~= nil then
		return nameCache
	end
	
	local weaponList = SH_EASYSKINS.GetWeaponList()
	local count = 0
	
	for cat,weaponTbl in pairs(weaponList) do
		
		for i=1,#weaponTbl do
		
			local weaponInfo = weaponTbl[i]
			
			if weaponInfo.name:lower() == name:lower() then
				count = count + 1
			end
			
			if count > 1 then
				
				-- save in cache
				duplicateNameCache[name] = true
			
				return true
				
			end
		
		end
	
	end
	
	-- save in cache
	duplicateNameCache[name] = false
	
	return false

end

/*
	Create a clientside WeaponEquip hook
*/

if CLIENT then

	local function CallWeaponEquipHook(wepIndex,try)
	
		try = try or 1
		
		if try == 10 then return end

		local wep = Entity(wepIndex)

		if !wep:IsValid() then
			timer.Simple(0.1*try,function()
				CallWeaponEquipHook(wepIndex,try+1)
			end)
			
			return false
		end
		
		hook.Run("cl_easyskins_WeaponEquip", wep)

	end
	
	local function WeaponEquipFix(len, ply)
	
		local wepIndex = net.ReadInt(16)
		
		CallWeaponEquipHook(wepIndex)
	
	end
	net.Receive("cl_easyskins_WeaponEquipFix", WeaponEquipFix)

end

if SERVER then

	util.AddNetworkString("cl_easyskins_WeaponEquipFix")
	local function WeaponEquipFix( wep, ply )

		-- can be called too early when the player is still spawning in
		if !ply:IsClientValid() then 
			timer.Simple(0.1, function()
				if IsValid( wep, ply ) then
					WeaponEquipFix( wep, ply )
				end
			end)
			return
		end
		
		-- weapon index
		local wepIndex = wep:EntIndex()
		
		-- send to client
		net.Start("cl_easyskins_WeaponEquipFix")
			net.WriteInt(wepIndex,16)
		net.Send(ply)
		
	end
	hook.Add( "WeaponEquip", "sv_easyskins_WeaponEquipFix", WeaponEquipFix )
	
end