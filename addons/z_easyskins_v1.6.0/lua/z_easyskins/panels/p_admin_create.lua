-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

local function CreateSkinTitleLbl(x, y, txt, parent)
	
	local createTitleLbl = CL_EASYSKINS.CreateLbl(x, y, txt, "z_easyskins_menu_create_step", color_white, parent, false)
	createTitleLbl:SetSize(parent:GetWide(), 32)
	createTitleLbl:SetTextInset(5,2)
	createTitleLbl:SetContentAlignment(5)
	
	createTitleLbl.Paint = function(self,w,h)
		surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
		surface.DrawRect(0,0,w,h)
	end
	
	return createTitleLbl
	
end

function PANEL:Init(realInit)
	
	if !realInit then return end
	
	local ply = LocalPlayer()
	local pWide,pTall = self:GetWide(), self:GetTall()-5
	self:SetTall(pTall)
	
	local iconSize = 64
	local selectedMaterial = nil
	local selectedMaterialIcon = nil
	
	local applicableItems = nil
	
	local standardPrice = SH_EASYSKINS.VAR.DEFAULTPRICE
	local donatorPrice = SH_EASYSKINS.VAR.DEFAULTPRICE
	local donatorOnly = false
	local category = SH_EASYSKINS.VAR.UNCATEGORIZED
	local currency = SH_EASYSKINS.ShopSystems.default.name
	local categories = SH_EASYSKINS.GetCategories()
	local dispName = "X"
	local dispNameInput = nil
	local steamgroupOnly = false
	local nameTagOnly = false
	local purchasable = true
	
	self:SetDrawBackground(false)
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local weaponList = SH_EASYSKINS.GetWeaponList()
	
	// Step 1
	
	-- title
	local step1Lbl = CreateSkinTitleLbl(0, 0, CL_EASYSKINS.Translate("step1"), self)
	
	-- no material selected
	local noMatSelectedLbl = CL_EASYSKINS.CreateLbl(0, 80, '<'..CL_EASYSKINS.Translate("noMaterialSelected")..'>', "z_easyskins_menu_cat_sub_btn", SH_EASYSKINS.COL.RED, self)
	CL_EASYSKINS.CenterInElement(noMatSelectedLbl, self)
	
	-- choose material
	local openListBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("choose"),color_white,self,function()
	
		local openListPnl = vgui.Create("p_easyskins_admin_material_list")
		
		openListPnl.CloseList = function( realSelf, material)
			
			selectedMaterial = material
		
			-- remove the no material selected lbl
			noMatSelectedLbl:Remove()
			
			-- remove previous icon if any
			if selectedMaterialIcon ~= nil then
				selectedMaterialIcon:DoRemove()
			end
			
			-- create icon to display selected material
			selectedMaterialIcon = CL_EASYSKINS.CreateMaterialIcon(pWide/2-iconSize/2, 50, 64, material.name, material.path, self, nil, true)
			
			-- remove the material select list
			realSelf:Remove()
			
			-- update the name input
			local disName = string.Replace(material.name, '_', ' ')
			disName = disName:gsub( "%s%l", string.upper )
			
			dispNameInput:SetText(disName)
			dispName = disName
			
		end

	end)
	openListBtn.BGCol = SH_EASYSKINS.COL.BLUE
	openListBtn.UseHoverCol = false
	openListBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	openListBtn:SetPos(pWide/2 - openListBtn:GetWide()/2 ,140)
	
	// Step 2
	local step2Lbl = CreateSkinTitleLbl(0, 210, CL_EASYSKINS.Translate("step2"), self)
	
	-- no weapon selected
	local noWepSelectedLbl = CL_EASYSKINS.CreateLbl(0, 290, '<'..CL_EASYSKINS.Translate("noWeaponsAdded")..'>', "z_easyskins_menu_cat_sub_btn", SH_EASYSKINS.COL.RED, self)
	CL_EASYSKINS.CenterInElement(noWepSelectedLbl, self)
	
	-- select weapon
	local addWeaponBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("add"),color_white,self,function()
	
		local openWeaponMethodsPnl = vgui.Create("p_easyskins_admin_weapon_list")
		openWeaponMethodsPnl:Init(true, applicableItems)
		
		openWeaponMethodsPnl.CloseAddWeapons = function( realSelf, chosenItems )
			
			applicableItems = chosenItems
		
			-- update the no material selected lbl
			if #applicableItems == 1 then
				local weaponInfo = SH_EASYSKINS.GetWeaponInfo(applicableItems[1])
				noWepSelectedLbl:SetText(weaponInfo.name)
			elseif #applicableItems > 1 then
				noWepSelectedLbl:SetText(#applicableItems.." "..CL_EASYSKINS.Translate("weaponsSelected"))
			end
			noWepSelectedLbl:SetColor(color_white)
			noWepSelectedLbl:UpdateSize()
			CL_EASYSKINS.CenterInElement(noWepSelectedLbl, self)
			
			-- remove the weapon methods panel
			realSelf:Remove()
			
		end

	end)
	addWeaponBtn.BGCol = SH_EASYSKINS.COL.BLUE
	addWeaponBtn.UseHoverCol = false
	addWeaponBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	addWeaponBtn:SetPos(pWide/2 - addWeaponBtn:GetWide()/2 ,350)
	
	// Step 3
	local step3Lbl = CreateSkinTitleLbl(0, 415, CL_EASYSKINS.Translate("step3"), self)
	
	local settingsY = 480
	local function NewLine()
		settingsY = settingsY+30
	end
	
	local itemWidth = 300
	local checkboxWidth = 300
	local settingsX = pWide/2 - itemWidth - 10
	
	-- display name
	local dispNameLbl = CL_EASYSKINS.CreateLbl(settingsX, settingsY, CL_EASYSKINS.Translate("name")..':', "z_easyskins_menu_cat_btn", color_white, self, true)
	local dispNameInputX = dispNameLbl:GetPos() + dispNameLbl:GetWide()
	dispNameInput = CL_EASYSKINS.CreateTextInput(dispNameInputX, settingsY, itemWidth-dispNameLbl:GetWide(), 25, dispName, "z_easyskins_menu_cat_btn", color_white, self)
	dispNameInput.OnChange = function(self)
		dispName = self:GetText()
	end
	
	NewLine()
	
	-- category
	local categoryLbl = CL_EASYSKINS.CreateLbl(settingsX, settingsY, CL_EASYSKINS.Translate("category")..':', "z_easyskins_menu_cat_btn", color_white, self, true)
	local catComboBoxX = categoryLbl:GetPos() + categoryLbl:GetWide()
	
	local extraOptions = {
		{"Add Category",function() 
		
			local catInput = vgui.Create("p_easyskins_input_text")
			local titleTxt = CL_EASYSKINS.Translate("enterNewCat")
			local placeholderTxt = CL_EASYSKINS.Translate("catName")
			catInput:Init(true,titleTxt,placeholderTxt,CL_EASYSKINS.AddCategory)
		
		end}
	}
	
	local catComboBox = CL_EASYSKINS.CreateComboBox(catComboBoxX, settingsY, itemWidth-categoryLbl:GetWide(), 25, SH_EASYSKINS.VAR.UNCATEGORIZED, category, categories, extraOptions, "z_easyskins_menu_cat_sub_btn", color_white, self)
	
	local oldOnSelect = catComboBox.OnSelect
	catComboBox.OnSelect = function( self, index, value, func )
			
		oldOnSelect(self,index,value,func)
		
		if value == "Add Category" then return end
		
		-- remember choice
		category = value
	
	end
	
	NewLine()
	
	-- currency
	local currencyLbl = CL_EASYSKINS.CreateLbl(settingsX, settingsY, CL_EASYSKINS.Translate("currency")..':', "z_easyskins_menu_cat_btn", color_white, self, true)
	local currencyBoxX = currencyLbl:GetPos() + currencyLbl:GetWide()
	
	local currencies = SH_EASYSKINS.ShopSystems.all
	local currencyComboBox = CL_EASYSKINS.CreateComboBox(currencyBoxX, settingsY, itemWidth-currencyLbl:GetWide(), 25, nil, currency, currencies, {}, "z_easyskins_menu_cat_sub_btn", color_white, self)
	
	local oldOnSelect = currencyComboBox.OnSelect
	currencyComboBox.OnSelect = function( self, index, value, func )
			
		oldOnSelect(self,index,value,func)
		
		-- remember choice
		currency = value
	
	end
	
	NewLine()
	
	-- price
	local priceLbl = CL_EASYSKINS.CreateLbl(settingsX, settingsY, CL_EASYSKINS.Translate("price")..':', "z_easyskins_menu_cat_btn", color_white, self, true)
	local priceInputX = priceLbl:GetPos() + priceLbl:GetWide()
	local priceInput = CL_EASYSKINS.CreateNumInput(priceInputX, settingsY, itemWidth-priceLbl:GetWide(), 25, standardPrice, "z_easyskins_menu_cat_btn", color_white, self)
	
	NewLine()
	
	-- donator price
	local priceDonatorLbl = CL_EASYSKINS.CreateLbl(settingsX, settingsY, CL_EASYSKINS.Translate("donatorPrice")..':', "z_easyskins_menu_cat_btn", color_white, self, true)
	local priceDonatorInputX = priceDonatorLbl:GetPos() + priceDonatorLbl:GetWide()
	local priceDonatorInput = CL_EASYSKINS.CreateNumInput(priceDonatorInputX, settingsY, itemWidth-priceDonatorLbl:GetWide(), 25, donatorPrice, "z_easyskins_menu_cat_btn", color_white, self)
	
	local function SanitizeNum()
	end

	priceInput.OnValueChanged = function(self, num)
		
		num = math.min(num,self:GetMax())

		-- update the donator lbl for convenience
		priceDonatorInput:SetValue(num)
		
		-- update the price
		standardPrice = num
		donatorPrice = num
		
	end
	
	priceDonatorInput.OnValueChanged = function( self, num )
		num = math.min(num,self:GetMax())
		donatorPrice = num
	end
	
	NewLine()
	settingsX = pWide*0.75 - checkboxWidth/2
	settingsY = 480
	
	local steamgroupOnlyCheckBox, nameTagOnlyCheckBox
	
	-- donator only
	local donatorOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(settingsX, settingsY, CL_EASYSKINS.Translate("donatorOnly")..": ", "z_easyskins_menu_cat_btn", color_white, self)
	donatorOnlyCheckBox:SetWide(checkboxWidth)
	donatorOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )	
	donatorOnlyCheckBox.OnChange = function(self, val)
			
		donatorOnly = val
		
		nameTagOnly = false
		nameTagOnlyCheckBox:SetChecked(false)
		steamgroupOnly = false
		steamgroupOnlyCheckBox:SetChecked(false)
		
	end
	
	NewLine()
	
	-- steamgroup only
	steamgroupOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(settingsX, settingsY, CL_EASYSKINS.Translate("steamgroupOnly")..": ", "z_easyskins_menu_cat_btn", color_white, self)
	steamgroupOnlyCheckBox:SetWide(checkboxWidth)
	steamgroupOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	steamgroupOnlyCheckBox.OnChange = function(self, val)
		
		steamgroupOnly = val
		
		nameTagOnly = false
		nameTagOnlyCheckBox:SetChecked(false)
		donatorOnly = false
		donatorOnlyCheckBox:SetChecked(false)
		
	end
	
	NewLine()
	
	-- name tag only
	nameTagOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(settingsX, settingsY, CL_EASYSKINS.Translate("nameTagOnly")..": ", "z_easyskins_menu_cat_btn", color_white, self)
	nameTagOnlyCheckBox:SetWide(checkboxWidth)
	nameTagOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	nameTagOnlyCheckBox.OnChange = function(self, val)
		
		nameTagOnly = val
		
		steamgroupOnly = false
		steamgroupOnlyCheckBox:SetChecked(false)
		donatorOnly = false
		donatorOnlyCheckBox:SetChecked(false)
		
	end
	
	NewLine()
	
	-- purchasable
	local purchasableCheckBox = CL_EASYSKINS.CreateCheckBox(settingsX, settingsY, CL_EASYSKINS.Translate("purchasable")..": ", "z_easyskins_menu_cat_btn", color_white, self)
	purchasableCheckBox:SetWide(checkboxWidth)
	purchasableCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	purchasableCheckBox:SetChecked(purchasable)
	purchasableCheckBox.OnChange = function(self, val)
		purchasable = val
	end
	
	NewLine()
	NewLine()
	
	// Create Skin
	local createBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("createSkin"),color_white,self,function()
		
		-- get category table
		local catTbl = SH_EASYSKINS.GetCategoryByName(category)
		
		if currency == SH_EASYSKINS.ShopSystems.default.name then
			currency = ''
		end	

		-- request server to create skin
		CL_EASYSKINS.CreateSkin(selectedMaterial,applicableItems,dispName,catTbl,currency,standardPrice,donatorPrice,donatorOnly,steamgroupOnly,nameTagOnly,purchasable)
		
		-- refresh category
		self:GetParent():RefreshCategory()
		
	end)
	createBtn.UseHoverCol = false
	createBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	createBtn:SetSize( pWide*0.5,createBtn:GetTall())
	createBtn:SetPos(pWide/2 - createBtn:GetWide()/2 ,settingsY+100)
	createBtn.Think = function(self)
		
		local hasMaterial = selectedMaterial ~= nil
		local hasWeapon = applicableItems ~= nil and #applicableItems > 0
		
		if hasMaterial and hasWeapon then
			
			self.BGCol = SH_EASYSKINS.COL.GREEN
			self:SetEnabled(true)
			self:SetTextColor(color_white)
			
		else
			self:SetEnabled(false)
			self:SetTextColor(SH_EASYSKINS.COL.LIGHTGREY)
		end
	
	end
	
	-- objective labels
	local chooseMatTxt = CL_EASYSKINS.Translate("chooseMaterial")
	local chooseApplicableWepsTxt = CL_EASYSKINS.Translate("applicableWeapons")
	self.Paint = function(self, w, h)
		
		local chooseMatFont = "z_easyskins_obj_lbl"
		local chooseWepFont = chooseMatFont
		
		if selectedMaterial ~= nil then
			chooseMatFont = "z_easyskins_obj_lbl_strike"
		end
		
		if applicableItems ~= nil and #applicableItems > 0 then
			chooseWepFont = "z_easyskins_obj_lbl_strike"
		end
	
		local _,createBtnY = createBtn:GetPos()
		-- reposition the labels when we scroll
		local scrollLvl = self.VBar:GetScroll()
		createBtnY = createBtnY - scrollLvl
		
		draw.SimpleText( '- '..chooseMatTxt..' -', chooseMatFont, w/2, createBtnY-40, color_white, TEXT_ALIGN_CENTER )
		draw.SimpleText( '- '..chooseApplicableWepsTxt..' -', chooseWepFont, w/2, createBtnY-20, color_white, TEXT_ALIGN_CENTER )
		
	end
	
	-- empty label for space
	CL_EASYSKINS.CreateLbl(0, settingsY+125, " ", "z_easyskins_menu_cat_btn", color_white, self)
	
end
vgui.Register('p_easyskins_admin_create',PANEL,'DScrollPanel')
