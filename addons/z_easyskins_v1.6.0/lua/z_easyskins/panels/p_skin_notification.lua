-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit,text,skin,class,ttl,startY)
	
	if !realInit then return end
	
	local ply = LocalPlayer()
	local pTall = 80
	local weaponModelPnlSize = pTall*1.8
	local animTime = 0.5
	
	self:SetPos(-500,startY)
	self:MoveToFront()
	self.Paint = function(self, w, h)
	
		-- blur
		CL_EASYSKINS.DrawBlur(self)
	
		-- bg
		surface.SetDrawColor( SH_EASYSKINS.COL.DARKGREY_150 )
		surface.DrawRect( 0, 0, w, h )
		
	end
	
	self.SlideBack = function(self)
		
		if self.isMoving then
			self.waitingForSlideBack = true
		else
			
			self.isSlidingBack = true 
			
			local _, currY = self:GetPos()
		
			self:MoveTo( -self:GetWide(), currY, animTime, 0, -1, function()
				self:Remove()
			end)
		end
		
	end
	
	-- hide notification after time
	timer.Simple(ttl,function()
		
		if IsValid(self) then
			self:SlideBack()
		end
		
	end)
	
	-- txt
	local txtLbl = CL_EASYSKINS.CreateLbl(5, 0, text, "z_easyskins_cat_title", color_white, self)
	
	-- set size based on txt size
	local pWide = txtLbl:GetWide() + weaponModelPnlSize + 10
	self:SetSize(pWide,pTall)
	self:MoveTo( 5, startY, animTime, 0, -1, function()
		self.isMoving = false
	end)
	
	txtLbl:CenterVertical()
	
	-- skin preview
	local _, wmPath = SH_EASYSKINS.GetWeaponModels(class)
	local weaponModelOffset = pTall/2-weaponModelPnlSize/2
	local previewPnl, previewLbl = CL_EASYSKINS.CreateWeaponModelPnl(pWide-weaponModelPnlSize,weaponModelOffset,weaponModelPnlSize,wmPath,true,self,false,true)
	previewLbl:SetVisible(false)
	previewPnl:SetAmbientLight(color_white)
	
	local oldPaint = previewPnl.Paint
	previewPnl.Paint = function(self, w, h)
	
		-- bg
		surface.SetDrawColor( SH_EASYSKINS.COL.GREY_150 )
		surface.DrawRect( 0, 0, w, h )
		
		-- draw weapon
		oldPaint(self, w, h)
		
	end

	-- apply skin to preview model
	SH_EASYSKINS.ApplySkinToModel(previewPnl.Entity, skin.material.path)
	
end
vgui.Register('p_easyskins_skin_notification',PANEL,'DPanel')
