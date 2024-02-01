-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	The player object (CL) isn't instantly valid on spawn.
	We want to know serverside if the clientside player object is valid ( to set values on it )
*/

if CLIENT then
	
	local function ClientValidChecker()
	
		if IsValid(LocalPlayer()) then
		
			-- let the sever know our client is valid
			net.Start("sv_easyskins_SetClientValid")
			net.SendToServer()
			
			-- once set, remove hook
			hook.Remove("Think","sh_easyskins_ClientValidChecker")
			
		end
	
	end
	hook.Add("Think","sh_easyskins_ClientValidChecker", ClientValidChecker) 
	
end

if SERVER then
	
	local ply = FindMetaTable('Player')
	
	util.AddNetworkString("sv_easyskins_SetClientValid")
	local function SetClientValid(len,ply)
		ply.__isClientValid = true
	end
	net.Receive("sv_easyskins_SetClientValid",SetClientValid)
	
	function ply:IsClientValid()
		return self.__isClientValid or false
	end

end