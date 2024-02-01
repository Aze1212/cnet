-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local loadingDots = {
	"",
	".",
	"..",
	"...",
	"..",
	".",
}

function PANEL:Init(realInit,x,y,w,h,font,col)
	
	if !realInit then return end
	
	local ply = LocalPlayer()
	local col = col or SH_EASYSKINS.COL.LIGHTBLACK_150
	local font = font or "z_easyskins_menu_cat_btn"

	self:SetPos(x,y)
	self:SetSize(w,h)
	self.Paint = function(self, w, h)
		surface.SetDrawColor(col)
		surface.DrawRect(0,0,w,h)
	end

	self.loadingLbl = vgui.Create("DLabel",self)
	self.loadingLbl:SetText("")
	self.loadingLbl:SetFont(font)
	self.loadingLbl:SetTextColor(color_white)
	self.loadingLbl.nextThink = 0
	self.loadingLbl.dotCount = 1
	self.loadingLbl.txt = CL_EASYSKINS.Translate("loading")
	self.loadingLbl.Think = function(self)
		
		if self.nextThink < CurTime() then
					
			local dots = loadingDots[self.dotCount]
			
			self:SetText(dots..self.txt..dots)
			self:SizeToContents()
			self:Center()
	 
			self.dotCount = self.dotCount + 1
			
			if self.dotCount > #loadingDots then
				self.dotCount = 1
			end
			
			self.nextThink = CurTime() + 0.3
		
		end
		
	end
	
end
vgui.Register('p_easyskins_loading',PANEL,'DPanel')