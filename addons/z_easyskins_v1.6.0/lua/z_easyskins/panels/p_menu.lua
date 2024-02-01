-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

local selectedBtn = nil
local lastPos = 0
local activeCategory = nil
local lastChosenCat = "inventory"
local catBtnOffset = math.floor(scrH*0.003)
local catBtnAnimtime = 0.15

local categoryBtns = {
	{"settings","p_easyskins_admin_settings","z_easyskins/vgui/settings",true,true},
	{"createSkins","p_easyskins_admin_create","z_easyskins/vgui/create",true,true},
	{"manageSkins","p_easyskins_admin_manage","z_easyskins/vgui/manage",true},
	{"blacklist","p_easyskins_admin_blacklist","z_easyskins/vgui/blacklist",true},
	{"users","p_easyskins_admin_users","z_easyskins/vgui/users",true},
	{"shop","p_easyskins_shop","z_easyskins/vgui/shop"},
	{"inventory","p_easyskins_inventory","z_easyskins/vgui/inventory"}
}

local function CreateCatButton(str,targPnl,parent,targetPnlParent,icon,isAdminBtn,noBlurBG,i)
	
	local btnTxtCol = isAdminBtn and SH_EASYSKINS.COL.RED or color_white
	local mouseIsIn = false
	
	local catBtnW, catBtnH = 170, 50
	local iconSize = 30

	-- bg panel
	local catPnl = vgui.Create("DPanel", parent )
	catPnl:SetSize(catBtnW,catBtnH)
	catPnl:SetPos(0, lastPos)
	catPnl.__oldY = lastPos
	catPnl.Paint = function(self, w, h)
	
		-- bg
		surface.SetDrawColor( SH_EASYSKINS.COL.GREY )
		surface.DrawRect( 0, 0, w, h )
	
	end
	
	local delay = catBtnAnimtime*(i-1)
	catPnl:SetPos(-400, lastPos)
	catPnl:MoveTo( 0, lastPos, catBtnAnimtime, delay)

	-- icon
	local catIcon = vgui.Create( "DImage", catPnl )
	catIcon:SetPos(8, catBtnH/2-iconSize/2)
	catIcon:SetSize(iconSize, iconSize)
	catIcon:SetZPos(1)
	catIcon:SetImageColor(btnTxtCol)
	catIcon:SetImage(icon)
	
	-- btn
	local catBtn = vgui.Create( "DButton", catPnl )
	catBtn:SetPos(0,0)
	catBtn:SetFont("z_easyskins_menu_cat_sub_btn_bold")
	catBtn:SetText("")
	catBtn:SetSize(catBtnW,catBtnH)
	catBtn:SetTextColor(btnTxtCol)
	catBtn:SetContentAlignment(4)
	
	local btnTxt = CL_EASYSKINS.Translate(str)
	catBtn.Paint = function(self,w,h)

		-- txt
		surface.SetFont( self:GetFont() )
		surface.SetTextColor( self:GetTextColor() )
		surface.SetTextPos( iconSize+15, h/2-10 )
		surface.DrawText( btnTxt )
		
		-- right edge (incase the text is longer then the button)
		surface.SetDrawColor( SH_EASYSKINS.COL.GREY )
		surface.DrawRect( w-10, 0, 10, h )
		
		-- when selected
		if self == selectedBtn then
			
			-- line
			surface.SetDrawColor(color_white)
			surface.DrawRect( w-2, 0, 2, h )
			
		end
			
		if mouseIsIn then
			catBtn:SetTextColor(SH_EASYSKINS.COL.BLUE)
			catIcon:SetImageColor(SH_EASYSKINS.COL.BLUE)
		else
			catBtn:SetTextColor(btnTxtCol)
			catIcon:SetImageColor(btnTxtCol)
		end
		
	end
	
	catBtn.DoClick = function(self,force)
	
		-- no action if trying to reopen the same panel
		if IsValid(activeCategory) and activeCategory:GetName() == targPnl and !force then 
			return
		end
	
		selectedBtn = catBtn
		lastChosenCat = str
		
		-- change cat
		if activeCategory ~= nil then
			activeCategory:Remove()
		end
		
		local catPnlW,catPnlH = parent:GetSize()
		local catPnlX,catPnlY = parent:GetPos()

		activeCategory = vgui.Create(targPnl,targetPnlParent)
		activeCategory.noBlurBG = noBlurBG
		
		if activeCategory ~= nil then
			activeCategory:SetPos(catPnlX+catPnlW,catPnlY+5)
			activeCategory:SetSize(targetPnlParent:GetWide()-catPnlW,catPnlH-5)
			activeCategory:Init(true)
		else
			error("Panel <"..targPnl.."> does not exist!")
		end
		
		-- play sound
		CL_EASYSKINS.PlaySound("press")
		
	end
	
	catBtn.OnCursorEntered = function(self)
		mouseIsIn = true
	end
	
	catBtn.OnCursorExited = function(self)
		mouseIsIn = false
	end
	
	lastPos = lastPos + catBtn:GetTall() + catBtnOffset
	
	-- remember which cat was opened last
	if lastChosenCat == str then
		catBtn:DoClick()
	end
	
end

function PANEL:Init(canOpenShop)

	if canOpenShop == nil then return end
	
	if !SH_EASYSKINS.ShopSystems.loaded then
		
		notification.AddLegacy( "[Easy Skins] Loading currencies...", NOTIFY_UNDO, 10 )
		
		self:Remove()
		
		return
		
	end
	
	local ply = LocalPlayer()
	local menuIsDraggable = SH_EASYSKINS.HasAccess()
	local menuWidth,menuHeight = math.Min(scrW,800),math.Max(scrH*0.80,550)
	local closeBtnSize = 22
	local lblOffset = 5
	local menuAnimSpeed = 0.2
	lastPos = catBtnOffset
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(menuIsDraggable)
	self:SetSize(menuWidth,menuHeight)
	self:Center()
	
	-- animate alpha
	self:SetAlpha(0)
	self:AlphaTo(255, menuAnimSpeed)
	
	self:MoveToFront()
	self:MakePopup()
	
	-- custom func so children can reopen themselves
	self.RefreshCategory = function ( self )
		-- create new verion of currently selected category
		selectedBtn:DoClick(true)
	end
	
	-- title lbl
	local titleLbl = CL_EASYSKINS.CreateLbl(0, lblOffset, CL_EASYSKINS.Translate("menuTitle"), "z_easyskins_menu_title", color_white, self)
	local titleLblOffsetX = 170+(menuWidth-170)/2
	titleLbl:SetPos(titleLblOffsetX-titleLbl:GetWide()/2,lblOffset)
	
	-- points lbl
	local pointsLbl = CL_EASYSKINS.CreateLbl(0, 8, "$0", "z_easyskins_cat_title", SH_EASYSKINS.COL.GREEN, self)
	local pointsLblOffsetX = 170/2
	pointsLbl.Think = function(self)
	
		local points = SH_EASYSKINS.GetPoints(ply)
		local pointsFormat = SH_EASYSKINS.FormatMoney(points)
		
		self:SetText(pointsFormat)
		self:UpdateSize()
		
		self:SetPos(pointsLblOffsetX-pointsLbl:GetWide()/2,8)
		
	end
	
	-- close btn
	local closeBtn = CL_EASYSKINS.CreateMaterialIcon(menuWidth-closeBtnSize*1.5, closeBtnSize/2, closeBtnSize, '', "z_easyskins/vgui/cross_remove.vmt", self, function()
		CL_EASYSKINS.ToggleMenu(true)
	end)
	
	-- cat panel
	local catPnl = vgui.Create("DPanel",self)
	local titleHeight = titleLbl:GetTall()+10
	catPnl:SetSize(170,menuHeight-titleHeight)
	catPnl:SetPos(0,titleHeight)
	catPnl:SetDrawBackground(false)
	
	-- content blur pnl
	local contentBlurPnl = vgui.Create("DPanel",self)
	contentBlurPnl:SetSize(menuWidth-catPnl:GetWide(),menuHeight-titleHeight)
	contentBlurPnl:SetPos(catPnl:GetWide(),titleHeight)
	contentBlurPnl.Paint = function(self, w, h)
		
		if activeCategory and activeCategory.noBlurBG then
		
			-- solid bg
			surface.SetDrawColor( SH_EASYSKINS.COL.DARKGREY )
			surface.DrawRect( 0, 0, w, h )
			
			-- title separator line		
			surface.SetDrawColor( color_white )
			surface.DrawLine( 0, 0, w, 0 )
		
		else
			CL_EASYSKINS.DrawBlur(contentBlurPnl)
		end
		
	end
	
	-- side buttons
	local realI = 0
	for k, catBtn in pairs(categoryBtns) do
	
		if catBtn[4] and !SH_EASYSKINS.HasAccess() then continue end
		if catBtn[2] == "p_easyskins_shop" and !canOpenShop then 
			
			-- if the last chosen category was shop, and shop is disabled, then reset to inventory
			if lastChosenCat == "shop" then
				lastChosenCat = "inventory"
			end
			
			continue
		end
		
		realI = realI + 1
		
		CreateCatButton(catBtn[1],catBtn[2],catPnl,self,catBtn[3],catBtn[4],catBtn[5],realI)
	
	end
	
	-- language selection combobox
	local languages = CL_EASYSKINS.GetLanguages()
	local playerLang = CL_EASYSKINS.GetPlayerLanguage()
	
	local languageComboBox = CL_EASYSKINS.CreateComboBox(5, menuHeight-30, catPnl:GetWide()-10, 25, nil, playerLang, languages, {}, "z_easyskins_menu_cat_sub_btn", SH_EASYSKINS.COL.BLUE, self)
	
	local oldOnSelect = languageComboBox.OnSelect
	languageComboBox.OnSelect = function( self, index, value, func )
		
		CL_EASYSKINS.SetPlayerLanguage(value)
		
		-- reopen the menu after the language has changed
		timer.Simple(0, function()
			CL_EASYSKINS.ToggleMenu(true)
			CL_EASYSKINS.ToggleMenu(false, canOpenShop)
		end)
		
	end
	
	
	self.Paint = function(self,w,h)
	
		-- cat bg
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,titleHeight,catPnl:GetWide(),h-titleHeight)
		
		-- title bar bg
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,0,w,titleHeight)
		
		-- title line
		local titleX, titleY = titleLbl:GetPos()
		local titleH = titleLbl:GetTall()+titleY+lblOffset
		
		surface.SetDrawColor(color_white)
		surface.DrawLine( 0, titleH, w, titleH )
		
	end
	
end
vgui.Register('p_easyskins_menu',PANEL,'DFrame')