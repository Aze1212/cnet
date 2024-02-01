-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	A compact console command system
*/

local CMD = {}

CMD.Tip = {
	["GiveSkin"] = {
		Info = "Give a skin to an online/offline player for a specific weapon",
		Usage = "Usage: easyskins_giveskin < name|steamID64 > < skinName|skinID|skinCategoryName > < weaponClasses|categories >"
	}
}

function CMD.IsConsole(ply)

	if ply == NULL or ply:IsWorld() then 
		return true
	end
	
	return false
	
end

function CMD.Print(ply, msg)
	
	if CMD.IsConsole(ply) then 
		print(msg)
	else
		ply:PrintMessage(HUD_PRINTCONSOLE,msg)
	end
	
end

function CMD.CanExecute(ply)
	
	if CMD.IsConsole(ply) then 
		return true
	end
	
	return SH_EASYSKINS.HasAccess(ply)
	
end

function CMD.FindPlayer(caller, name)

	local targets = {}
	name = name:lower()
	
	for _, ply in pairs(player.GetHumans()) do
		
		if string.match(ply:Nick():lower(),name) then
			table.insert(targets,ply)
		end
		
	end
	
	if #targets == 0 then
		CMD.Print(caller, "Player Not Found!")
	elseif #targets == 1 then
		return targets[1]
	else
		CMD.Print(caller, "Multiple Players Found!")
	end
	
	return false
	
end

function CMD.GiveSkin(ply, cmd, args)

	if !CMD.CanExecute(ply) then return end
	
	if #args < 3 then
		CMD.Print(ply, CMD.Tip["GiveSkin"].Usage)
		return
	end
	
	local argPly, argSkin = args[1], args[2]
	
	-- find player by name if it isn't a steamID64
	if !SH_EASYSKINS.IsSteamID64(argPly) then
		
		local target = CMD.FindPlayer(ply, argPly)
		
		if !target then
			CMD.Print(ply, "Player Not Found!")
			return
		end
		
		argPly = SH_EASYSKINS.GetSteamID64(target)
		
	end

	local categories = SH_EASYSKINS.GetCategories()
	local skin = SH_EASYSKINS.GetSkin( tonumber(argSkin) or -1 )
	local skinIDS = {}
	
	-- skin is an id
	if skin then

		table.insert(skinIDS,skin.id)
		
	-- find all skins from category
	elseif argSkin:lower() == SH_EASYSKINS.VAR.UNCATEGORIZED or SH_EASYSKINS.GetCategoryByName(argSkin).name ~= SH_EASYSKINS.VAR.UNCATEGORIZED then
	
		local skins = SH_EASYSKINS.GetSkinsByCategory(argSkin)
		
		for i=1, #skins do
			table.insert(skinIDS,skins[i].id)
		end
		
	else
	
		-- find skin by name if it isn't a skin or category
		local skin = SH_EASYSKINS.GetSkinByName(argSkin)
		
		if !skin then
			CMD.Print(ply, "Skin Not Found!")
			return
		end
		
		table.insert(skinIDS,skin.id)
	end
	
	local weaponList = SH_EASYSKINS.GetWeaponList()
	local argClasses = {}
	
	-- check if last parm is a list of parms or a category of weapons
	for i=3, #args do 
		
		local arg = args[i]
		
		-- check if arg is a category or a class
		if weaponList[arg] ~= nil then

			local cat = weaponList[arg]
			
			for catI=1, #cat do
				table.insert(argClasses, cat[catI].class)
			end
				
		else
			
			-- verify if class exists ingame
			if !SH_EASYSKINS.GetWeaponInfo(arg) then
				CMD.Print(ply, "Weapon Not Found! ("..arg..")")
				continue
			else
				table.insert(argClasses, arg)
			end
			
		end
	
	end
	
	if #argClasses == 0 then
		CMD.Print(ply, "Command Cancelled, No Weapons Found!")
		return
	end
	
	-- give skins if all arguments passed
	for i=1, #skinIDS do
		SV_EASYSKINS.GiveSkinToPlayer(argPly, skinIDS[i], argClasses)
	end
	
end
concommand.Add( "easyskins_giveskin", CMD.GiveSkin, nil, CMD.Tip["GiveSkin"].Info.."\n"..CMD.Tip["GiveSkin"].Usage)
