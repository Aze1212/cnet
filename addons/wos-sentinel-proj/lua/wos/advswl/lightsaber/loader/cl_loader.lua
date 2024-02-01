--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.LightsaberBase = wOS.ALCS.LightsaberBase or {}

local dir = "wos/advswl/lightsaber"

include( dir .. "/datadesc/sh_hooks.lua" )

include( dir .. "/datadesc/cl_core.lua" )
include( dir .. "/datadesc/cl_net.lua" )
include( dir .. "/core/cl_create_register.lua" )
include( dir .. "/core/cl_hud.lua" )
include( dir .. "/core/cl_core.lua" )
