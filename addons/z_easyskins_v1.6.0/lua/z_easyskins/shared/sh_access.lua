-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function SH_EASYSKINS.HasAccess(ply)

	if CLIENT and ply == nil then
		ply = LocalPlayer()
	end

	if ply:IsSuperAdmin() then
		return true
	end

	return SH_EASYSKINS.IsPlayerInSettingsTbl(SH_EASYSKINS.SETTINGS.ADMINS, ply)
	
end

function SH_EASYSKINS.CanRemoteShop(ply)
	
	if CLIENT and ply == nil then
		ply = LocalPlayer()
	end
	
	if ply:IsSuperAdmin() then
		return true
	end
	
	if SH_EASYSKINS.SETTINGS.ADMINREMOTESHOP then
		
		if SH_EASYSKINS.IsPlayerInSettingsTbl(SH_EASYSKINS.SETTINGS.ADMINS, ply) then
			return true
		end
		
	end
	
	if SH_EASYSKINS.SETTINGS.DONATORREMOTESHOP then
		
		if SH_EASYSKINS.IsPlayerInSettingsTbl(SH_EASYSKINS.SETTINGS.DONATORS, ply) then
			return true
		end
	
	end
	
	return SH_EASYSKINS.SETTINGS.PLAYERREMOTESHOP

end