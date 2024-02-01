-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init()
	
	local ply = LocalPlayer()
	local iconPanelW,iconPanelH = (64+10)*7+20,scrH*0.6
	local iconSize = 64
	local skins = SH_EASYSKINS.GetSkins()
	
	-- close if there are no skins to give
	if #skins == 0 then
		self:Remove()
		return
	end
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	
	self.startTime = SysTime()
	
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end
	
	-- bg scroll panel
	local materialPnl = vgui.Create( "DScrollPanel", self )
	materialPnl:SetSize(iconPanelW,iconPanelH)
	materialPnl:Center()
	CL_EASYSKINS.SkinScrollPanel(materialPnl)
	
	-- material img btn
	local lastX,lastY = 0,0
	local function CreateList(skin)
		
		local material = skin.material
		local iconX =  lastX*(iconSize + 10)
		local iconY =  lastY*(iconSize + 30)
		
		local materialIcon = CL_EASYSKINS.CreateMaterialIcon(iconX, iconY, iconSize, skin.dispName, material.path, materialPnl, function()
			self:CloseList(skin)
		end)
		
		lastX = lastX + 1
		
		if lastX % 7 == 0 then
			lastX = 0
			lastY = lastY + 1
		end
	
	end
	
	for i=1, #skins do
		
		local skin = skins[i]

		CreateList(skin)
	
	end
	
end
vgui.Register('p_easyskins_admin_skin_list',PANEL,'DFrame')
