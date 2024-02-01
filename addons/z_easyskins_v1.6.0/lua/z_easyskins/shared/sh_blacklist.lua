-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local blacklist = {} -- string

function SH_EASYSKINS.GetMatBlacklist()
	return blacklist
end

function SH_EASYSKINS.IsDefaultBlacklistMat(mat)
	return SH_EASYSKINS.MATBLACKLIST[mat]
end

function SH_EASYSKINS.IsBlackListMat(mat)
	return table.HasValue(blacklist,mat)
end

function SH_EASYSKINS.IsMatBlacklisted(mat)
	return SH_EASYSKINS.IsDefaultBlacklistMat(mat) or SH_EASYSKINS.IsBlackListMat(mat)
end

function SH_EASYSKINS.CanRemoveBlacklistMat(mat)
	
	-- if the material is in the default blacklist then block removing it!
	return !SH_EASYSKINS.IsDefaultBlacklistMat(mat)
	
end

function SH_EASYSKINS.CanAddBlacklistMat(mat)
	
	return !SH_EASYSKINS.IsMatBlacklisted(mat)

end

function SH_EASYSKINS.GetNameFromMat(mat)
	
	local matSplit = string.Split(mat,'/')
	
	return matSplit[#matSplit] or "ERROR"

end

local function RemoveMatFromList(mat)
	
	for i=1,#blacklist do
		
		if blacklist[i] == mat then
			table.remove(blacklist,i)
			break
		end
	
	end
	
end

if CLIENT then

	function CL_EASYSKINS.AddBlacklistMat(mat, callback)
		
		if !SH_EASYSKINS.HasAccess() or !SH_EASYSKINS.CanAddBlacklistMat(mat) then return end
		
		-- add on sv
		net.Start("sv_easyskins_AddBlacklistMat")
			net.WriteString(mat)
		net.SendToServer()	
	
		-- don't wait for server and add category
		table.insert(SH_EASYSKINS.GetMatBlacklist(), mat)
		
		if callback ~= nil then
			callback()
		end
		
	end
	
	function CL_EASYSKINS.RemoveBlacklistMat(mat,callback)
	
		if !SH_EASYSKINS.HasAccess() or !SH_EASYSKINS.CanRemoveBlacklistMat(mat) then return end
	
		net.Start("sv_easyskins_RemoveBlacklistMat")
			net.WriteString(mat)
		net.SendToServer()
		
		-- don't wait for server and remove category
		RemoveMatFromList(mat)
		
		if callback ~= nil then
			callback()
		end
		
	end
	
	local function UpdateClientMatBlacklist()
		
		-- update blacklist
		blacklist = net.ReadTable() 

		local ply = LocalPlayer()
		if IsValid(ply) then
		
			for _, wep in pairs(ply:GetWeapons()) do
				
				-- invalide weapon models to show changes
				if wep.__invalidateIndexes then
					wep.__invalidateIndexes[1] = true -- vm
					wep.__invalidateIndexes[2] = true -- wm
				end
				
				-- force vm to update
				wep.__skinSet = false
				
			end
			
		end

	end
	net.Receive("cl_easyskins_UpdateClientMatBlacklist",UpdateClientMatBlacklist)

end

if SERVER then

	util.AddNetworkString("cl_easyskins_UpdateClientMatBlacklist")
	function SV_EASYSKINS.UpdateClientMatBlacklist(targets)
	
		targets = targets or player.GetHumans()
		
		net.Start("cl_easyskins_UpdateClientMatBlacklist")
			net.WriteTable(SH_EASYSKINS.GetMatBlacklist())
		net.Send(targets)

	end
	
	function SV_EASYSKINS.SetMatBlacklist(matBlacklist)
	
		-- set on server
		blacklist = matBlacklist
		
		-- set on client
		SV_EASYSKINS.UpdateClientMatBlacklist()
		
	end
	
	util.AddNetworkString("sv_easyskins_AddBlacklistMat")
	local function AddBlacklistMat(len, ply)
	
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local mat = net.ReadString()
		
		if !SH_EASYSKINS.CanAddBlacklistMat(mat) then return end

		-- add material to list
		table.insert(SH_EASYSKINS.GetMatBlacklist(), mat)
		
		-- update clients
		SV_EASYSKINS.UpdateClientMatBlacklist()
		
		-- add material to DB
		SV_EASYSKINS.DBAddBlacklistMat(mat)
	
	end
	net.Receive("sv_easyskins_AddBlacklistMat",AddBlacklistMat)
	
	util.AddNetworkString("sv_easyskins_RemoveBlacklistMat")
	local function RemoveBlacklistMat(len, ply)
	
		-- never trust clients
		if !SH_EASYSKINS.HasAccess(ply) then return end
		
		local mat = net.ReadString()
		
		if !SH_EASYSKINS.CanRemoveBlacklistMat(mat) then return end
		
		-- remove material
		RemoveMatFromList(mat)
		
		-- update clients
		SV_EASYSKINS.UpdateClientMatBlacklist()
		
		-- remove material from DB
		SV_EASYSKINS.DBRemoveBlacklistMat(mat)
		
	end
	net.Receive("sv_easyskins_RemoveBlacklistMat",RemoveBlacklistMat)
	
end