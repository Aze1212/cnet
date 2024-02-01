--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
																																																																																																																																																						

local meta = FindMetaTable( "Player" )

----GET FUNCTIONS

function meta:GetSkillPoints()
	return self:GetNW2Int( "wOS.SkillPoints", 0 )
end

function meta:GetSkillLevel()
	return self:GetNW2Int( "wOS.SkillLevel", 0 )
end

function meta:GetSkillXP()
	return self:GetNW2Int( "wOS.SkillExperience", 0 )
end

function meta:GetSkillRequiredXP()
	local level = self:GetSkillLevel()
	return wOS.ALCS.Config.Skills.XPScaleFormula( level )
end

function meta:HasSkillEquipped( tree, tier, skill )

	if not self.EquippedSkills[ tree ] then return false end
	if not self.EquippedSkills[ tree ][ tier ] then return false end
	
	if istable( skill ) then
		for num, sk in ipairs( skill ) do
			if not self.EquippedSkills[ tree ][ tier ][ sk ] then return false end
		end
	else
		return self.EquippedSkills[ tree ][ tier ][ skill ]
	end

	return true
end

function meta:CanEquipSkill( tree, tier, skill )

	local skilldata = wOS.SkillTrees[ tree ]
	if not skilldata then return false end

	skilldata = skilldata.Tier
	if not skilldata then return false end
	
	skilldata = skilldata[ tier ]
	if not skilldata then return false end
	
	skilldata = skilldata[ skill ]
	if not skilldata then return false end

	if self:GetSkillPoints() < skilldata.PointsRequired then return false end
	
	if table.Count( skilldata.Requirements ) < 1 then return true end
	
	for stier, skills in pairs( skilldata.Requirements ) do
		if not self:HasSkillEquipped( tree, stier, skills ) then return false end
	end
	
	return true
	
end