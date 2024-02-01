-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	A compact chat command system
*/

local CHATCMD = {}

-- open inventory
CHATCMD["skins"] = function(ply)
	ply:SendLua("CL_EASYSKINS.ToggleMenu(false,false)")
end
CHATCMD["skin"] = CHATCMD["skins"]

-- DEBUG
-- CHATCMD["dp"] = function(ply)
	-- ply:DropWeapon()
-- end

local function TextHasCommand( txt, cmd )

	local targetTxt = string.sub(txt:lower(), 1, string.len(cmd)+1 )
	
	return targetTxt == '!'..cmd or targetTxt == '/'..cmd
	
end

local function PlayerSay( ply , txt )

	for cmd, func in pairs(CHATCMD) do
		
		if TextHasCommand(txt,cmd) then
			func(ply)
			break
		end
		
	end

end
hook.Add("PlayerSay","sv_easyskins_PlayerSay",PlayerSay)