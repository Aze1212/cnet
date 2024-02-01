-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	This file loads the implementation for the detected currency system
	
	- to add your own implementation create a new file in the 'shopsystems' folder
	-> define an object with these methods and return that object
	
	local customShopSystem = {}
	customShopSystem.name = "display name"
	customShopSystem.priority = 10 -- higher is better
	
	function customShopSystem.GetPoints(ply)
		return <points>
	end

	if SERVER then

		function customShopSystem.TakePoints(ply,amount)
			-- take points
		end

		function customShopSystem.GivePoints(ply,amount)
			-- add points
		end
		
	end
	
	return customShopSystem

*/

SH_EASYSKINS.ShopSystems = {}
SH_EASYSKINS.ShopSystems.all = {}
SH_EASYSKINS.ShopSystems.nameref = {}
SH_EASYSKINS.ShopSystems.default = {}
SH_EASYSKINS.ShopSystems.default.name = "No Currency Detected!"
SH_EASYSKINS.ShopSystems.default.priority = 0
SH_EASYSKINS.ShopSystems.loaded = false

local function LoadCurrencySystem()

	local shopSystems = file.Find( "z_easyskins/shopsystems/*.lua", "LUA" )

	-- detect shop systems
	for i=1, #shopSystems do

		local shopSystem = shopSystems[i]
		local f = "z_easyskins/shopsystems/"..shopSystem
		local shopSystemFuncs = include( f )
	
		if shopSystemFuncs ~= nil then
			
			shopSystemFuncs.priority = shopSystemFuncs.priority or 1
		
			-- save in loopable table
			table.insert(SH_EASYSKINS.ShopSystems.all,shopSystemFuncs)
			
			-- save with name ref for quick retrieve
			SH_EASYSKINS.ShopSystems.nameref[shopSystemFuncs.name] = shopSystemFuncs
			
		end
		
	end
	
	-- select default shop system
	for i=1, #SH_EASYSKINS.ShopSystems.all do
		
		local shopSystem = SH_EASYSKINS.ShopSystems.all[i]
		
		if shopSystem.priority > SH_EASYSKINS.ShopSystems.default.priority then
			SH_EASYSKINS.ShopSystems.default = shopSystem
		end
		
	end
	
	-- load shop functions or throw error if not found
	if #SH_EASYSKINS.ShopSystems.all > 0 then
		
		SH_EASYSKINS.GetPoints = SH_EASYSKINS.ShopSystems.default.GetPoints

		if SERVER then

			SV_EASYSKINS.TakePoints = SH_EASYSKINS.ShopSystems.default.TakePoints
			SV_EASYSKINS.GivePoints = SH_EASYSKINS.ShopSystems.default.GivePoints
	
		end
	
	else
		
		local noShopMsg = "No supported shop system detected!\n %s will not work!"
		local noShopError = [[ 
		Easy Skins: Currency Error!
		-----------------------------------
		NO supported shop system detected!
		-> Easy Skins is dependant on a currency system
		1. Create your own implementation by going to z_easyskins/shared/sh_currency.lua
		2. Open a support ticket if you would like me to add support for the selected shop
		-----------------------------------
		]]
		
		function SH_EASYSKINS.GetPoints() return 0 end

		if SERVER then
			function SV_EASYSKINS.TakePoints() 
				print(string.format( noShopMsg, "SV_EASYSKINS.TakePoints()" )) 
				ErrorNoHalt(noShopError)
			end
			function SV_EASYSKINS.GivePoints() 
				print(string.format( noShopMsg, "SV_EASYSKINS.GivePoints()" ))
				ErrorNoHalt(noShopError)
			end
		end
		
	end
	
	-- trying to determine this weird currency GetPoints() error origin
	if SH_EASYSKINS.GetPoints == nil then
		Error("Something went wrong while loading the currency systems! "..#shopSystems.." currency systems found.")
		debug.Trace()
		return
	end
	
	-- mark as loaded
	SH_EASYSKINS.ShopSystems.loaded = true
	
end
hook.Add("Initialize","sh_easyskins_LoadCurrencySystem",LoadCurrencySystem)