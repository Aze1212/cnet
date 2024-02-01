-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local lastSelection = {} 

function PANEL:Init(realInit,selectedItems,canMultiSelect)

	if !realInit then return end
	
	if canMultiSelect == nil then
		canMultiSelect = true
	end

	local ply = LocalPlayer()
	local weaponList = SH_EASYSKINS.GetWeaponList()
	local listW,listH = 600,scrH*0.5
	local modelPnlSize = scrH*0.25
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	
	self.startTime = SysTime()
	
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end
	
	// Display chosen weapons
	local weaponModelY = scrH/2-listH/2-modelPnlSize
	
	-- viewmodel
	local vmPnl = CL_EASYSKINS.CreateWeaponModelPnl(scrW/2-modelPnlSize,weaponModelY,modelPnlSize,"",true,self)
	
	-- worldmodel
	local wmPnl = CL_EASYSKINS.CreateWeaponModelPnl(scrW/2,weaponModelY,modelPnlSize,"",false,self)
	
	-- bg for worldmodel panels
	local bgOffset = scrH*0.01
	local bgPanel = vgui.Create("DPanel", self)
	bgPanel:SetPos(scrW/2-listW/2,weaponModelY+bgOffset)
	bgPanel:SetSize(listW,modelPnlSize-bgOffset)
	bgPanel:SetZPos(-1)
	bgPanel:SetVisible(false)
	bgPanel.Paint = function(self, w, h)
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,0,w,h)
	end
	
	// Dlist containing weapons
	local weaponListView = vgui.Create( "DListView", self )
	weaponListView:SetSize(listW,listH)
	weaponListView:Center()
	
	weaponListView:SetMultiSelect( canMultiSelect )
	
	weaponListView:AddColumn( CL_EASYSKINS.Translate("category") )
	weaponListView:AddColumn( CL_EASYSKINS.Translate("class") )
	weaponListView:AddColumn( CL_EASYSKINS.Translate("name") )
	
	CL_EASYSKINS.SkinListView(weaponListView)
	
	local function SetWeaponModelPanels(class)
		
		-- we don't want lag when selecting hundreds of weapons
		timer.Create("z_easyskins_LoadWeaponModels",0,1,function()
		
			-- get models for class
			local vm,wm = SH_EASYSKINS.GetWeaponModels(class)
			
			if IsValid(vmPnl,wmPnl) then
				-- update model panels
				vmPnl:UpdateModel(vm)
				wmPnl:UpdateModel(wm)
				bgPanel:SetVisible(true)
			end
			
		end)
		
	end

	-- update weapon model viewer
	weaponListView.OnRowSelected = function( self, index, pnl )
		
		local cat, class, name = pnl:GetColumnText(1), pnl:GetColumnText(2), pnl:GetColumnText(3)
		SetWeaponModelPanels(class)
		
	end
	
	-- select entire category when double clicking
	weaponListView.DoDoubleClick = function( self, index, pnl )

		if canMultiSelect then
	
			local cat = pnl:GetColumnText(1)
			local lines = self:GetLines()
			local alreadySelectedCount = 0
			local isSelected = pnl:IsSelected()
			
			for _, linePnl in pairs( lines ) do
				
				local lineCat = linePnl:GetColumnText(1)
				
				if lineCat == cat then
					linePnl:SetSelected(isSelected)
				end
				
			end
			
		end
		
	end
	
	if canMultiSelect then
	
		-- override default behaviour
		-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dlistview.lua
		weaponListView.lastClick = 0
		weaponListView.OnClickLine = function( self, Line, bClear )
		
			-- shift click
			if input.IsKeyDown( KEY_LSHIFT ) then

				local selected = self:GetSortedID( self:GetSelectedLine() )
				if ( selected ) then

					local lineID = self:GetSortedID( Line:GetID() )

					local first = math.min( selected, lineID )
					local last = math.max( selected, lineID )

					-- Fire off OnRowSelected for each non selected row
					for id = first, last do
						local line = self.Sorted[id]
						if ( !line:IsLineSelected() ) then self:OnRowSelected( line:GetID(), line ) end
						line:SetSelected( true )
					end

					-- Clear the selection and select only the required rows
					if ( bClear ) then self:ClearSelection() end

					for id = first, last do
						local line = self.Sorted[id]
						line:SetSelected( true )
					end

					return

				end

			end
		
			-- double click
			if Line.m_fClickTime then
			
				local fTimeDistance = SysTime() - Line.m_fClickTime
				local fTimeUnrealistic = 0.08
				
				if ( fTimeDistance < 0.2 and fTimeDistance > fTimeUnrealistic ) then
					self:DoDoubleClick( Line:GetID(), Line )
					return
				end

			end
			
			Line.m_fClickTime = SysTime()
			
			-- single click
			if self.lastClick > CurTime() then return end
			self.lastClick = CurTime() + 0.1
			
			self:OnRowSelected( Line:GetID(), Line )
			Line:SetSelected(!Line:IsSelected())
			
		end
		
	end
	
	-- fill weapon list
	for cat,wepTbl in pairs(weaponList) do
		
		for i=1,#wepTbl do
			
			local wep = wepTbl[i]
			weaponListView:AddLine( cat, wep.class, wep.name )
		
		end
		
	end
	
	-- reselect items previously selected in selectedItems
	local prevSelectedItems = selectedItems or lastSelection
	
	if prevSelectedItems ~= nil then
	
		local weaponListViewLines = weaponListView:GetLines()
		for i=1,#weaponListViewLines do
			
			local line = weaponListViewLines[i]
			local class = line:GetColumnText(2)
			
			if table.HasValue(prevSelectedItems, class) then
				weaponListView:SelectItem( line )
			end
			
		end
		
	end

	// Save Selection
	local saveSelectionBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("saveSelection"),color_white,self,function()
		
		local selectedItems = weaponListView:GetSelected()
		local selectedWeapons = {}
		
		-- fill selected weapons with classes
		for i=1,#selectedItems do
			local wepClass = selectedItems[i]:GetColumnText(2)
			table.insert(selectedWeapons,wepClass)
		end
		
		-- remember selection for the next time the menu is opened
		lastSelection = selectedWeapons

		self:CloseAddWeapons(selectedWeapons)
		
	end)
	saveSelectionBtn.BGAlpha = 255
	saveSelectionBtn.BGCol = SH_EASYSKINS.COL.GREEN
	saveSelectionBtn.UseHoverCol = false
	saveSelectionBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	
	local saveSelectionBtnWide = saveSelectionBtn:GetWide() + 120
	local saveSelectionBtnY = weaponListView:GetBottomY()+10
	saveSelectionBtn:SetPos(scrW/2 + 45 ,saveSelectionBtnY)
	saveSelectionBtn:SetSize( saveSelectionBtnWide,saveSelectionBtn:GetTall())
	
	// Cancel
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,self,function()
		self:Remove()
	end)
	cancelBtn.BGAlpha = 255
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	cancelBtn:SetPos(scrW/2 - saveSelectionBtnWide - 45 ,saveSelectionBtnY)
	cancelBtn:SetSize( saveSelectionBtnWide,cancelBtn:GetTall())
	
end
vgui.Register('p_easyskins_admin_weapon_list',PANEL,'DFrame')
