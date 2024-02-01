-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local menu = nil
local lastOpened = 0

function CL_EASYSKINS.ToggleMenu(forceClose, isNpcRequest)
	
	if forceClose or (menu ~= nil and menu:IsVisible()) then

		if menu ~= nil then
			
			for _, child in pairs(menu:GetChildren()) do
				child:Remove()
			end
		
			menu:Remove()
			
			menu = nil
			
		end
		
	else
	
		menu = vgui.Create( "p_easyskins_menu" )
		
		local canOpenShop = isNpcRequest or SH_EASYSKINS.CanRemoteShop(LocalPlayer())
		menu:Init(canOpenShop)
		
		-- show notification to admins if new version is available
		if !SH_EASYSKINS.VAR.LATESTVERSION and SH_EASYSKINS.HasAccess() then
		
			SH_EASYSKINS.VAR.LATESTVERSION = true
			
			notification.AddLegacy( SH_EASYSKINS.VAR.LATESTVERSIONMSG, NOTIFY_GENERIC, 15 )
			
		elseif !SH_EASYSKINS.VAR.LATESTVERSION then
			SH_EASYSKINS.VAR.LATESTVERSION = true
		end
		
	end

end

local function OpenMenuByConCommand( ply, cmd, args )
	CL_EASYSKINS.ToggleMenu()
end
concommand.Add( "easyskins_open", OpenMenuByConCommand)

local function KeyPress( ply, key )

	if lastOpened > CurTime() then return end
	
	local keyFromBindTbl = SH_EASYSKINS.KEYBINDS[key]
	
	if keyFromBindTbl ~= nil and keyFromBindTbl == SH_EASYSKINS.SETTINGS.MENUKEY then
		CL_EASYSKINS.ToggleMenu()
		
		lastOpened = CurTime() + 1
		
	end

end
hook.Add("PlayerButtonDown","cl_easyskins_KeyPress",KeyPress)