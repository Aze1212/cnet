--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		
----------------------------------------]]--

local meta = FindMetaTable( "Player" )

function meta:GetExecuted()
	return self:GetNW2Bool( "wOS.ALCS.ExecSys.Executed", false )
end

