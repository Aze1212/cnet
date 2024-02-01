-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init()
	
	local ply = LocalPlayer()
	local fileBrowserW,fileBrowserH = 500,scrH*0.5
	local iconSize = 64
	local wmPnl,wmLbl
	local selectedMaterialIcon
	local selectedMaterial = nil
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	
	self.startTime = SysTime()
	
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end

	local function CloseFileBrowser()
		-- reopen the list panel
		local openListPnl = vgui.Create("p_easyskins_admin_material_list")
		
		-- rehook the closelist func
		openListPnl.CloseList = self.openListPnl_CloseList
		
		-- close file browser
		self:Remove()
	end
		
	-- material file browser
	local fileBrowser = vgui.Create( "DFileBrowser", self )
	fileBrowser:SetSize(fileBrowserW, fileBrowserH)
	fileBrowser:SetPos(0,scrH/2-fileBrowserH/2)
	fileBrowser:CenterHorizontal()

	fileBrowser:SetPath( "GAME" )
	fileBrowser:SetBaseFolder( "materials" )
	fileBrowser:SetName( "Materials" )
	fileBrowser:SetFileTypes( "*.vmt" )
	fileBrowser:SetOpen( true )
	
	fileBrowser.OnSelect = function( _, path, pnl )

		local material = {
			name = SH_EASYSKINS.GetMaterialNameFromPath(path),
			path = string.Split(path,"materials/")[2],
			isRemovable = true
		}
		
		wmPnl:SetVisible(true)
		SH_EASYSKINS.ApplySkinToModel(wmPnl.Entity, material.path)
		
		selectedMaterialIcon:UpdateMaterial(material)
		
		selectedMaterial = material
		
	end
	
	-- filter input
	local searchInputX, searchInputY = fileBrowser:GetPos()
	local searchInput = CL_EASYSKINS.CreateTextInput(searchInputX, searchInputY-45, fileBrowserW, 45, "", "z_easyskins_menu_cat_btn", color_white, self)
	searchInput.bgCol = SH_EASYSKINS.COL.GREY
	searchInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	searchInput:SetPlaceholderText(CL_EASYSKINS.Translate("enterName"))
	searchInput:SetZPos(2)
	searchInput.OnChange = function(self)

		local filter = string.Trim( self:GetText():lower() )
		fileBrowser:SetSearch( filter )
		
	end

	local fileBrowserX, fileBrowserY = fileBrowser:GetPos()
	
	-- model preview
	local modelSize = fileBrowserX/3
	local wmPnlX = fileBrowserX
	local wmPnlY = fileBrowserY/2 - modelSize/2
	local modelPnlSize = modelSize
	local exampleModel = SH_EASYSKINS.NONLINKEDMODELS.weapon_ar2.WorldModel
	wmPnl, wmLbl = CL_EASYSKINS.CreateWeaponModelPnl(wmPnlX,wmPnlY,modelPnlSize,exampleModel,false,self)
	wmPnl:SetVisible(false)
	wmLbl:SetVisible(false)
	
	-- do the same as when pressing the icon
	wmPnl.DoClick = function()
		selectedMaterialIcon:DoClick()
	end
	
	-- icon btn
	local iconPosX = fileBrowserX + fileBrowserW*0.66
	local iconPosY = fileBrowserY/2 - iconSize/2
	
	selectedMaterialIcon = CL_EASYSKINS.CreateMaterialIcon(iconPosX, iconPosY, iconSize, '', nil, self,function()
		if selectedMaterial ~= nil then
			
			-- add material
			CL_EASYSKINS.AddMaterial(selectedMaterial,function()
				-- on success
				CloseFileBrowser()
			end)
			
			-- just incase it's stuck
			self:Remove()
			
		end
	end,true)
	
	-- cancel btn
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,self,function()
		CloseFileBrowser()
	end)
	cancelBtn.BGAlpha = 255
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	
	local cancelBtnPos = fileBrowserX + fileBrowser:GetWide()/2 -  cancelBtn:GetWide()/2
	cancelBtn:SetPos(cancelBtnPos, fileBrowserY + fileBrowser:GetTall() + 30)
	
end
vgui.Register('p_easyskins_material_browser',PANEL,'DFrame')