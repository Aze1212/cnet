-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local materialList = {} -- id, name, path, isRemovable

function SH_EASYSKINS.GetMaterialNameFromPath(path)

	local pathSplit = string.Split( path, "/" )
	local materialNameFull = pathSplit[#pathSplit]
	local materialName = string.Split( materialNameFull, ".vmt" )[1]
	
	-- uppercase first char
	return materialName:gsub( "^%l", string.upper )
	
end

function SH_EASYSKINS.GetMaterialList()
	return materialList
end

function SH_EASYSKINS.GetMaterial(id)

	for i=1, #materialList do
			
		if materialList[i].id == id then
			return materialList[i], i
		end

	end
	
end

function SH_EASYSKINS.GetMaterialByPath(path)

	for i=1, #materialList do
			
		if materialList[i].path == path then
			return materialList[i], i
		end
	
	end

end

function SH_EASYSKINS.GetSortedMaterialList()
	
	local materialList = table.Copy(SH_EASYSKINS.GetMaterialList())
	
	table.sort( materialList, function( a, b )
		
		if a.isRemovable == b.isRemovable then

			if a.isAnimated or b.isAnimated then
				return SH_EASYSKINS.BoolToInt(a.isAnimated) > SH_EASYSKINS.BoolToInt(b.isAnimated)
			else
				
				local isSpecialMaterialA = SH_EASYSKINS.IsMaterialSpecial(a)
				local isSpecialMaterialB = SH_EASYSKINS.IsMaterialSpecial(b)
				
				return SH_EASYSKINS.BoolToInt(isSpecialMaterialA) > SH_EASYSKINS.BoolToInt(isSpecialMaterialB)
				
			end
		else
		
			return SH_EASYSKINS.BoolToInt(a.isRemovable) > SH_EASYSKINS.BoolToInt(b.isRemovable)
			
		end
		
	end ) 
	
	return materialList
	
end

function SH_EASYSKINS.CanRemoveMaterial(material)

	-- can't remove material if it's used by a skin
	for _,skin in pairs(SH_EASYSKINS.GetSkins()) do
		if skin.material.path == material.path then
			return false
		end
	end
	
	return material.isRemovable

end

local vmtCache = {} -- cache

function SH_EASYSKINS.GetVMTFromPath(path)
	
	if vmtCache[path] == nil then
		vmtCache[path] = file.Read( 'materials/'..path, "GAME" )
	end

	return vmtCache[path] or ''

end

local animatedMatCache = {} -- cache

// works for both the material object and a string path
function SH_EASYSKINS.IsMaterialAnimated(material)

	local matIsObj = istable(material)
	
	if matIsObj and material.isAnimated ~= nil then
		return material.isAnimated
	elseif animatedMatCache[material] ~= nil then
		return animatedMatCache[material]
	end
	
	local path = matIsObj and material.path or material
	
	-- open the material vmt file
	local vmtFile = SH_EASYSKINS.GetVMTFromPath(path)
	local isAnimatedTexture = string.find(vmtFile, "AnimatedTexture") ~= nil
	local isTextureScroll = string.find(vmtFile, "TextureScroll") ~= nil
	local isAnimated = (isAnimatedTexture or isTextureScroll) and SH_EASYSKINS.EXTRAMATERIALS[path] == nil

	if matIsObj then
		material.isAnimated = isAnimated
	else
		animatedMatCache[material] = isAnimated
	end
	
	return isAnimated

end

function SH_EASYSKINS.IsMaterialSpecial(material)
	return SH_EASYSKINS.SPECIALMATERIALS[material.name]
end

if CLIENT then

	local animatedMaterialCache = {} -- cache

	function CL_EASYSKINS.AnimatedVMTToUnlitGeneric(matPath)
		
		-- create a new animated UnlitGeneric Material
		if animatedMaterialCache[matPath] == nil then
			
			animatedMaterialCache[matPath] = CreateMaterial( matPath.."_unlitgeneric", "UnlitGeneric", {
				["$basetexture"] = matPath,
				["$vertexcolor"] = 1,
				["$vertexalpha"] = 1,
				["$translucent"] = 1,
				["$nolod"] = 1,
				["Proxies"] = {
					["AnimatedTexture"] = {
						["animatedtexturevar"] = "$basetexture",
						["animatedtextureframenumvar"] = "$frame",
						["animatedtextureframerate"] = "15"
					}
				}
			})
			
		end
		
		return animatedMaterialCache[matPath]
		
	end

	local materialCache = {} -- cache

	function CL_EASYSKINS.VMTToUnlitGeneric(matPath)
		
		-- create a new UnlitGeneric Material
		if materialCache[matPath] == nil then
			
			materialCache[matPath] = CreateMaterial( matPath.."_unlitgeneric", "UnlitGeneric", {
				["$basetexture"] = matPath,
				["$vertexcolor"] = 1,
				["$vertexalpha"] = 1,
				["$translucent"] = 1,
				["$nolod"] = 1
			})
			
		end
		
		return materialCache[matPath]
		
	end

	function CL_EASYSKINS.AddMaterial(material, callback)
	
		if !SH_EASYSKINS.HasAccess() then return end
		
		-- update list on sv
		net.Start("sv_easyskins_AddMaterial")
			net.WriteTable(material)
		net.SendToServer()
		
		-- don't wait for server and add skin to list
		local materialList = SH_EASYSKINS.GetMaterialList()
		material.id = SH_EASYSKINS.CalcNewID(materialList)
		table.insert(materialList, 1, material)
		
		-- do callback
		callback()
		
	end

	function CL_EASYSKINS.RemoveMaterial(id)
		
		if !SH_EASYSKINS.HasAccess() then return end
		
		local materials = SH_EASYSKINS.GetMaterialList()
		local material, index = SH_EASYSKINS.GetMaterial(id)
		
		if !SH_EASYSKINS.CanRemoveMaterial(material) then return end
		
		net.Start("sv_easyskins_RemoveMaterial")
			net.WriteInt(id,16)
		net.SendToServer()
		
		-- don't wait for server and remove material
		table.remove(materials,index)
		
	end
	
	local function UpdateClientMaterials()

		local materialListSize = net.ReadInt(16)
		local newMaterialList = {}
		
		-- read all classes seperately
		for i=1,materialListSize do
			
			local mat = net.ReadTable()
		
			-- add to new material list
			table.insert(newMaterialList,mat)
			
			-- precache material
			CL_EASYSKINS.PrecacheMaterial(mat.path)
			
		end
		
		-- update old material list
		materialList = newMaterialList

	end
	net.Receive("cl_easyskins_UpdateClientMaterials",UpdateClientMaterials)

end

if SERVER then

	util.AddNetworkString("cl_easyskins_UpdateClientMaterials")
	function SV_EASYSKINS.UpdateClientMaterials(targets)
	
		targets = targets or player.GetHumans()
		
		net.Start("cl_easyskins_UpdateClientMaterials")
			
			local materialList = SH_EASYSKINS.GetMaterialList()
			
			-- the amount of tables we are going to send
			net.WriteInt(#materialList,16)
			
			-- 64kb limit so we split up the table and send per key
			for _,material in pairs(materialList) do 
				net.WriteTable(material)
			end
			
		net.Send(targets)

	end
	
	function SV_EASYSKINS.SetMaterials(materials)
	
		materialList = {}
	
		-- add loaded materials
		table.Add(materialList,materials)
		
		-- update client
		SV_EASYSKINS.UpdateClientMaterials()
		
	end
	
	util.AddNetworkString("sv_easyskins_AddMaterial")
	local function AddMaterial(len, ply)
	
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local materialList = SH_EASYSKINS.GetMaterialList()
		
		local material = net.ReadTable()
		material.id = SH_EASYSKINS.CalcNewID(materialList)
		material.isAnimated = SH_EASYSKINS.IsMaterialAnimated(material)
		
		-- add material to list
		table.insert(materialList, material)
		
		-- update clients
		SV_EASYSKINS.UpdateClientMaterials()
		
		-- add material to DB
		SV_EASYSKINS.DBAddMaterial(material)
	
	end
	net.Receive("sv_easyskins_AddMaterial",AddMaterial)
	
	util.AddNetworkString("sv_easyskins_RemoveMaterial")
	local function RemoveMaterial(len, ply)

		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local id = net.ReadInt(16)
		local materials = SH_EASYSKINS.GetMaterialList()
		local material, index = SH_EASYSKINS.GetMaterial(id)
		
		if !SH_EASYSKINS.CanRemoveMaterial(material) then return end
		
		-- remove material at index
		table.remove(materials,index)

		-- update clients
		SV_EASYSKINS.UpdateClientMaterials()
		
		-- remove material from DB
		SV_EASYSKINS.DBRemoveMaterial(material)
		
	end
	net.Receive("sv_easyskins_RemoveMaterial",RemoveMaterial)
	
end
