-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local crossTextureID = surface.GetTextureID("z_easyskins/vgui/cross_remove.vmt")

function PANEL:Init()
	
	local ply = LocalPlayer()
	local iconPanelW,iconPanelH = (64+10)*7+20,scrH*0.6
	local iconSize = 64
	local materialListBtns = {}
	local removeBtns = {}
	local removeMode = false
	
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
	
	// Icon List
	
	-- bg scroll panel
	local materialPnl = vgui.Create( "DScrollPanel", self )
	materialPnl:SetSize(iconPanelW,iconPanelH)
	materialPnl:Center()
	CL_EASYSKINS.SkinScrollPanel(materialPnl)
	
	-- material img btn
	local lastX,lastY = 0,0
	local function CreateList(material)
		
		local iconX =  lastX*(iconSize + 10)
		local iconY =  lastY*(iconSize + 30)
		
		local materialIcon, materialLbl = CL_EASYSKINS.CreateMaterialIcon(iconX, iconY, iconSize, material.name, material.path, materialPnl, function()
			self:CloseList(material)
		end)
		
		if SH_EASYSKINS.IsMaterialSpecial(material) then
			materialLbl:SetColor(SH_EASYSKINS.COL.GOLD)
		elseif material.isAnimated then
			materialLbl:SetColor(SH_EASYSKINS.COL.PURPLEHAZE)
		end
		
		lastX = lastX + 1
		
		if lastX % 7 == 0 then
			lastX = 0
			lastY = lastY + 1
		end
		
		-- link material and btn for remove functionality
		materialIcon.material = material
		
		return materialIcon
	
	end
	
	-- predefine func so we can reference it before it is registered
	local HookRemoveButtons = nil
	
	-- refresh material list and fill up the icon list
	local function InvalidateList()
		
		lastX,lastY = 0,0
		local materialList = SH_EASYSKINS.GetSortedMaterialList()
		
		-- db didn't load materials -> connection error
		if #materialList == 0 then
			
			-- show warning
			notification.AddLegacy( "[Easy Skins] Connection to database failed!", NOTIFY_ERROR, 10 )
			
			-- play sound
			CL_EASYSKINS.PlaySound( "deny" )
		
			self:Remove()
			
			return
		end
		
		-- remove old btns if they exist
		if #materialListBtns > 0 then
		
			for i=1,#materialListBtns do
				if materialListBtns[i].DoRemove ~= nil then
					materialListBtns[i]:DoRemove()
				end
			end
			
		end
		
		for i=1,#materialList do
			materialListBtns[i] = CreateList(materialList[i])
		end
		
		-- re-hook remove buttons
		if removeMode then
			HookRemoveButtons()
		end
		
	end
	InvalidateList()
	
	-- hook remove buttons to the material icons
	function HookRemoveButtons()

		for index, materialIcon in pairs(materialListBtns) do
			
			local material = materialIcon.material
			
			if material ~= nil then
			
				local canRemove = SH_EASYSKINS.CanRemoveMaterial(material)
			
				-- create a remove overlay button
				local removeBtn = vgui.Create("DImageButton",materialIcon)
				removeBtn:SetSize(iconSize,iconSize)
				removeBtn:Center()
				removeBtn.Paint = function(self, w, h)
					
					if canRemove then
						surface.SetDrawColor(color_white)
						surface.SetTexture(crossTextureID)
						surface.DrawTexturedRect( w/4, h/4, w/2, h/2 )
					else
						surface.SetDrawColor(100,100,100,150)
						surface.DrawRect( 0, 0, w, h )
					end
					
				end
				
				if canRemove then
					removeBtn.DoClick = function()
						
						CL_EASYSKINS.RemoveMaterial(material.id)
						InvalidateList()
						
					end
				end
				
				-- add to list
				removeBtns[index] = removeBtn
				
			end
		end
	end
	
	-- add btn
	local materialPnlX,materialPnlY = materialPnl:GetPos()
	local skinBtnY = materialPnlY+materialPnl:GetTall()+40
	local skinBtnOffset = materialPnl:GetWide()*0.1
	
	local addSkinBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("addSkin"),color_white,self,function()
		
		local materialBrowser = vgui.Create("p_easyskins_material_browser")
		
		-- pass the function so when we create the new open list panel we can hook it ( i know, little hacky )
		materialBrowser.openListPnl_CloseList = self.CloseList
		
		self:Remove()
		
	end)
	addSkinBtn.BGAlpha = 255
	addSkinBtn.BGCol = SH_EASYSKINS.COL.GREEN
	addSkinBtn.UseHoverCol = false
	addSkinBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	addSkinBtn:SetPos(scrW/2 + addSkinBtn:GetWide() - skinBtnOffset,skinBtnY)
	
	-- remove btn
	local toggleModeBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("toggleMode"),color_white,self,function()
		
		if !removeMode then
		
			removeMode = true
			
			HookRemoveButtons()
			
		else
			
			removeMode = false
			
			for i=1,#removeBtns do
				removeBtns[i]:Remove()
			end
		
		end
		
	end)
	toggleModeBtn.BGAlpha = 255
	toggleModeBtn.BGCol = SH_EASYSKINS.COL.RED
	toggleModeBtn.UseHoverCol = false
	toggleModeBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	toggleModeBtn:SetPos(scrW/2 - toggleModeBtn:GetWide() - skinBtnOffset,skinBtnY)
	
end
vgui.Register('p_easyskins_admin_material_list',PANEL,'DFrame')
