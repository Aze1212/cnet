-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function CL_EASYSKINS.PrecacheMaterial(materialPath)
	
	-- render the material offscreen
	local matIcon = CL_EASYSKINS.CreateMaterialIcon(-1, -1, 1, "", materialPath)
	
	-- remove the icon after it rendered 1 frame
	timer.Simple(0,function()
		if IsValid(matIcon) then
			matIcon:Remove()
		end
	end)
	
end

local precachedWeapons = {}

function CL_EASYSKINS.PrecacheWeaponModels(weaponList)
	
	for cat, weps in pairs(weaponList) do

		for i=1, #weps do
			
			local wep = weps[i]
			
			if precachedWeapons[wep.class] then continue end 
			
			local vm, wm = SH_EASYSKINS.GetWeaponModels(wep.class)
					
			if isstring(vm) and util.IsValidModel(vm) then
			
				local vmEnt = ClientsideModel( vm, RENDERGROUP_BOTH )	
			
				SafeRemoveEntity(vmEnt)
				
			end
			
			if isstring(wm) and util.IsValidModel(wm) then
									
				local wmEnt = ClientsideModel( wm, RENDERGROUP_BOTH )
				
				SafeRemoveEntity(wmEnt)
				
			end
			
			precachedWeapons[wep.class] = true
			
		end
	
	end
	
end

function CL_EASYSKINS.ConstructLeftArrowPoly(x,y,size)
	
	local triangle = {
		{ x = x, y = y+(size/2) },
		{ x = x-size, y = y },
		{ x = x, y = y-(size/2) }
	}
	
	return triangle

end

function CL_EASYSKINS.ConstructRightArrowPoly(x,y,size)
	
	local triangle = {
		{ x = x, y = y+(size/2) },
		{ x = x, y = y-(size/2) },
		{ x = x+size, y = y }
	}
	
	return triangle

end