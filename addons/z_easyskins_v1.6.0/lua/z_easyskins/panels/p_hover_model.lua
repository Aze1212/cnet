-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local animSpeed = 0.15

function PANEL:Init()

	local ply = LocalPlayer()
	
	self.Paint = function(self, w, h)
		surface.SetDrawColor( SH_EASYSKINS.COL.DARKGREY )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( SH_EASYSKINS.COL.BLUE )
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	
end

function PANEL:UpdateInfo(class)

	-- remove children if prev updated
	for _,child in pairs(self:GetChildren()) do
		child:Remove()
	end
	
	-- spawnicon
	local _, wModel = SH_EASYSKINS.GetWeaponModels(class)
	
	if wModel == nil or wModel == '' then return end
	
	local spawnIcon = vgui.Create("ModelImage", self)
	spawnIcon:SetPos(0,0)
	spawnIcon:SetSize(self:GetWide(),self:GetTall())		
	spawnIcon:SetModel(wModel)
	
	self.spawnIcon = spawnIcon

end

function PANEL:Show()
	self:AlphaTo(255, animSpeed)
end

function PANEL:Hide()
	self:AlphaTo(0, animSpeed)
end
vgui.Register('p_easyskins_hover_model',PANEL,'DPanel')