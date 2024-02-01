-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local categoryList = {} -- id, name

-- returns all the skin categories
function SH_EASYSKINS.GetCategories()
	return categoryList
end

function SH_EASYSKINS.GetCategory(id)

	for i=1, #categoryList do
	
		if categoryList[i].id == id then
			return categoryList[i], i
		end

	end
	
	return { id = 1, name = SH_EASYSKINS.VAR.UNCATEGORIZED}
	
end

function SH_EASYSKINS.GetCategoryByName(name)

	name = name:lower()

	for i=1, #categoryList do

		if categoryList[i].name:lower() == name then
			return categoryList[i], i
		end
	
	end
	
	return { id = 1, name = SH_EASYSKINS.VAR.UNCATEGORIZED}, 1

end

function SH_EASYSKINS.GetCategoryNameTbl()
	
	local categoryList = SH_EASYSKINS.GetCategories()
	local catNameTbl = {}
	
	for i=1, #categoryList do
		table.insert(catNameTbl,categoryList[i].name)
	end
	
	return catNameTbl
	
end

function SH_EASYSKINS.CanRemoveCategory(cat)

	if cat.name == SH_EASYSKINS.VAR.UNCATEGORIZED then 
		return false
	end
	
	return true
	
end

if CLIENT then

	function CL_EASYSKINS.AddCategory(cat, callback)
		
		if !SH_EASYSKINS.HasAccess() then return end
		
		-- add on sv
		net.Start("sv_easyskins_AddCategory")
			net.WriteString(cat)
		net.SendToServer()
		
		-- don't wait for server and add category
		local categoryList = SH_EASYSKINS.GetCategories()
		local cat = {
			id = SH_EASYSKINS.CalcNewID(categoryList) + 1,
			name = cat
		}
		table.insert(categoryList, cat)
		
		if callback ~= nil then
			callback()
		end
		
	end
	
	function CL_EASYSKINS.RemoveCategory(id)
		
		if !SH_EASYSKINS.HasAccess() then return end
		
		local cat, index = SH_EASYSKINS.GetCategory(id)

		if !SH_EASYSKINS.CanRemoveCategory(cat) then return end
	
		net.Start("sv_easyskins_RemoveCategory")
			net.WriteInt(id,8)
		net.SendToServer()
		
		-- don't wait for server and remove category
		table.remove(SH_EASYSKINS.GetCategories(),index)
		
	end
	
	local function UpdateClientCategories()
		
		-- update category list
		categoryList = net.ReadTable() 
		
	end
	net.Receive("cl_easyskins_UpdateClientCategories",UpdateClientCategories)

end

if SERVER then

	util.AddNetworkString("cl_easyskins_UpdateClientCategories")
	function SV_EASYSKINS.UpdateClientCategories(targets)
		
		targets = targets or player.GetHumans()
		
		net.Start("cl_easyskins_UpdateClientCategories")
			net.WriteTable(SH_EASYSKINS.GetCategories())
		net.Send(targets)

	end
	
	function SV_EASYSKINS.SetCategories(categories)
	
		-- set on server
		categoryList = categories
		
		-- set on client
		SV_EASYSKINS.UpdateClientCategories()
		
	end
	
	util.AddNetworkString("sv_easyskins_AddCategory")
	local function AddCategory(len, ply)
	
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local name = net.ReadString()
		
		local categoryList = SH_EASYSKINS.GetCategories()
		local cat = {
			id = SH_EASYSKINS.CalcNewID(categoryList) + 1, -- +1 because on pos 1 -> UNCATEGORIZED
			name = name
		}

		-- add category to list
		table.insert(categoryList, cat)
		
		-- update clients
		SV_EASYSKINS.UpdateClientCategories()
		
		-- add category to DB
		SV_EASYSKINS.DBAddCategory(cat)
	
	end
	net.Receive("sv_easyskins_AddCategory",AddCategory)
	
	util.AddNetworkString("sv_easyskins_RemoveCategory")
	local function RemoveCategory(len, ply)
		
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
			
		local id = net.ReadInt(8)
		local categories = SH_EASYSKINS.GetCategories()	
		local cat, index = SH_EASYSKINS.GetCategory(id)
		
		-- never trust clients
		if !SH_EASYSKINS.CanRemoveCategory(cat) then return end
		
		-- remove category at index
		table.remove(categories,index)
		
		-- update clients
		SV_EASYSKINS.UpdateClientCategories()
		
		-- remove category from DB
		SV_EASYSKINS.DBRemoveCategory(cat)
		
	end
	net.Receive("sv_easyskins_RemoveCategory",RemoveCategory)
	
end