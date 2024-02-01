-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

// add active skin name to weapon printname
function CL_EASYSKINS.OverloadWeaponPrintName(wep,try)

	if !SH_EASYSKINS.SETTINGS.ADDSKINTOWEAPONAME then return end
	
	try = try or 1
	
	-- give up after 5 tries
	if try == 5 then return end
	
	timer.Simple(0.05*try,function()
	
		-- weapon became invalid
		if !IsValid(wep) then return end
		
		if wep.PrintName ~= nil then
	
			-- store reference to old printname
			wep.__PrintName = wep.__PrintName or wep.PrintName
	
			local class = wep:GetClass()
			local purchasedSkin = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(LocalPlayer(),class)
			
			if purchasedSkin == nil then
				wep.PrintName = wep.__PrintName
				return
			end
			
			local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
			
			if skin == nil then
				wep.PrintName = wep.__PrintName
				return
			end
			
			-- get the translated name
			local name = SH_EASYSKINS.GetWeaponInfo(class).name
			
			-- overload printname
			wep.PrintName = name..' | '..skin.dispName
			
		else
			
			-- try again
			CL_EASYSKINS.OverloadWeaponPrintName(wep,try+1)

		end
		
	end)
	
end
hook.Add("cl_easyskins_WeaponEquip","cl_easyskins_OverloadWeaponPrintName",CL_EASYSKINS.OverloadWeaponPrintName)

/* Testing around with the weapon object
concommand.Add( "koekkoek", function( ply, cmd, args )
	
	-- local wep = ply:GetActiveWeapon()
	local wep = ply:GetWeapon("gmod_tool")
	local class = wep:GetClass()
	local realWep = weapons.GetStored(class) -- changes name perma
	
	local function changeKanker(wepEnt)
	
		wepEnt.__Counter = (wepEnt.__Counter or 0) +1
		wepEnt.PrintName = "Kanker ("..wepEnt.__Counter..")"
	
	end	
	
	-- local metaTable = getmetatable( wep )
	-- metaTable.GetPrintName = function()
		-- return 'not the printname'
	-- end
	
	-- changeKanker(wep)
	-- changeKanker(realWep)
	
end )

concommand.Add("koekkoek_check", function( ply, cmd, args )

	print('>>>> Weapon Info:')

	for _, wep in pairs (ply:GetWeapons()) do
		print(wep.PrintName, wep:GetPrintName())
	end
	
	print('---')

end)

local SWEP = FindMetaTable("Weapon")
-- local oldVersion = SWEP.Equip
SWEP.Deploy = function(self)
	print(self)
end

SWEP.Test = function(self)
	print(self)
end
*/