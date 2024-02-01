-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function CL_EASYSKINS.SaveSettings()
	
	if !SH_EASYSKINS.HasAccess() then return end
	
	net.Start("sv_easyskins_SaveSettings")
		net.WriteTable(SH_EASYSKINS.SETTINGS)
	net.SendToServer()
	
end

local function UpdateSettings()

	local svSettings = net.ReadTable()
	
	SH_EASYSKINS.SETTINGS = svSettings

end
net.Receive("cl_easyskins_UpdateSettings",UpdateSettings)