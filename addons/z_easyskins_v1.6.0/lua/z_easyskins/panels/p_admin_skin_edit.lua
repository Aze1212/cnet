-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit,skin)
	
	if !realInit then return end

	-- we don't want to directly edit the clientside skin
	skin = table.Copy(skin)	

	local ply = LocalPlayer()
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self.startTime = SysTime()
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end
	
	local skinIconSize = 64
	local contentPnlH = math.min(scrH*0.8,850)
	local checkboxWidth = 200
	local categories = SH_EASYSKINS.GetCategories()
	
	-- content pnl
	local contentPnl = vgui.Create("DScrollPanel",self)
	contentPnl:SetSize(300,contentPnlH)
	contentPnl:Center()
	contentPnl.Paint = function(self, w, h)
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,0,w,h)
	end
	CL_EASYSKINS.SkinScrollPanel(contentPnl)
	
	local spaceY = 5
	local function addSpace(num)
		num = num or 35
		spaceY = spaceY + num
	end
	
	-- title lbl
	local titleLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("editSkin"), "z_easyskins_menu_title", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(titleLbl, contentPnl)
	addSpace(50)
	
	-- icon lbl
	local iconLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("material"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(iconLbl, contentPnl)
	addSpace()
	
	-- icon
	CL_EASYSKINS.CreateMaterialIcon(contentPnl:GetWide()/2-skinIconSize/2, spaceY, skinIconSize, skin.material.name, skin.material.path, contentPnl, nil, true)
	addSpace(skinIconSize+25)
	
	-- wep lbl
	local wepsLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("weapons"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(wepsLbl, contentPnl)
	addSpace()
	
	local wepSelectedLblY = spaceY
	local updateWeaponBtn
	local function UpdateWepSelectedLbl()
		if #skin.weaponTbl == 1 then
			local weaponInfo = SH_EASYSKINS.GetWeaponInfo(skin.weaponTbl[1])
			updateWeaponBtn:SetText(weaponInfo.name)
		elseif #skin.weaponTbl > 1 then
			updateWeaponBtn:SetText(#skin.weaponTbl.." Weapons Selected")
		end
		-- calls btn resize
		updateWeaponBtn:ChangeFont("z_easyskins_menu_cat_sub_btn")
		updateWeaponBtn:SetPos(0,wepSelectedLblY)
		CL_EASYSKINS.CenterInElement(updateWeaponBtn, contentPnl)
	end
	
	-- wep
	updateWeaponBtn = CL_EASYSKINS.CreateMaterialButton("999 Weapons Selected",color_white,contentPnl,function()
	
		local openWeaponMethodsPnl = vgui.Create("p_easyskins_admin_weapon_list")
		openWeaponMethodsPnl:Init(true, skin.weaponTbl)
		
		openWeaponMethodsPnl.CloseAddWeapons = function( realSelf, chosenItems )
			
			skin.weaponTbl = chosenItems
		
			-- update lbl
			UpdateWepSelectedLbl()
			
			-- remove the weapon methods panel
			realSelf:Remove()
			
		end

	end)
	updateWeaponBtn.BGAlpha = 0
	UpdateWepSelectedLbl()
	addSpace(40)
	
	-- disp name lbl
	local varLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("name"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(varLbl, contentPnl)
	addSpace()
	
	-- disp name
	dispNameInput = CL_EASYSKINS.CreateTextInput(0, spaceY, 200, 25, skin.dispName, "z_easyskins_menu_cat_sub_btn", color_white, contentPnl)
	dispNameInput.OnChange = function(self)
		skin.dispName = self:GetText()
	end
	CL_EASYSKINS.CenterInElement(dispNameInput, contentPnl)
	addSpace()
	
	-- cat lbl
	local catLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("category"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(catLbl, contentPnl)
	addSpace()
	
	-- cat
	local extraOptions = {
		{"Add Category",function() 
		
			local catInput = vgui.Create("p_easyskins_input_text")
			local titleTxt = CL_EASYSKINS.Translate("enterNewCat")
			local placeholderTxt = CL_EASYSKINS.Translate("catName")
			catInput:Init(true,titleTxt,placeholderTxt,CL_EASYSKINS.AddCategory)
		
		end}
	}
	
	local catComboBox = CL_EASYSKINS.CreateComboBox(0, spaceY, 200, 25, SH_EASYSKINS.VAR.UNCATEGORIZED, skin.category.name, categories, extraOptions, "z_easyskins_menu_cat_sub_btn", color_white, contentPnl)
	local oldOnSelect = catComboBox.OnSelect
	catComboBox.OnSelect = function( self, index, value, func )
		
		oldOnSelect(self,index,value,func)
		
		if value == "Add Category" then return end
		
		-- remember choice
		skin.category = value
	
	end
	CL_EASYSKINS.CenterInElement(catComboBox, contentPnl)
	addSpace()
	
	-- currency select lbl
	local currencyLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("currency"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(currencyLbl, contentPnl)
	addSpace()
	
	-- currency select
	local currency = #skin.currency > 0 and skin.currency or SH_EASYSKINS.ShopSystems.default.name
	local currencies = SH_EASYSKINS.ShopSystems.all
	local currencyComboBox = CL_EASYSKINS.CreateComboBox(0, spaceY, 200, 25, nil, currency, currencies, {}, "z_easyskins_menu_cat_sub_btn", color_white, contentPnl)
	local oldOnSelect = currencyComboBox.OnSelect
	currencyComboBox.OnSelect = function( self, index, value, func )
			
		oldOnSelect(self,index,value,func)
		
		-- remember choice
		if value == SH_EASYSKINS.ShopSystems.default.name then
			skin.currency = ''
		else
			skin.currency = value
		end
	
	end
	CL_EASYSKINS.CenterInElement(currencyComboBox, contentPnl)
	addSpace()
	
	-- price lbl
	local priceLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("price"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(priceLbl, contentPnl)
	addSpace()
	
	-- price
	local priceInput = CL_EASYSKINS.CreateNumInput(0, spaceY, 200, 25, skin.price, "z_easyskins_menu_cat_sub_btn", color_white, contentPnl)
	priceInput.OnValueChanged = function( self, num )
		skin.price = num
	end
	CL_EASYSKINS.CenterInElement(priceInput, contentPnl)
	addSpace()
	
	-- donator price lbl
	local dPriceLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("donatorPrice"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	CL_EASYSKINS.CenterInElement(dPriceLbl, contentPnl)
	addSpace()
	
	-- donator price
	local priceDInput = CL_EASYSKINS.CreateNumInput(0, spaceY, 200, 25, skin.donatorPrice, "z_easyskins_menu_cat_sub_btn",color_white, contentPnl)
	priceDInput.OnValueChanged = function( self, num )
		skin.donatorPrice = num
	end
	CL_EASYSKINS.CenterInElement(priceDInput, contentPnl)
	addSpace(50)
	
	local steamgOnlyCheckBox, nameTOnlyCheckBox
	
	-- donator only
	local dOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(0, spaceY, CL_EASYSKINS.Translate("donatorOnly"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	dOnlyCheckBox:SetChecked(skin.donatorOnly)
	dOnlyCheckBox:SetWide(checkboxWidth)
	dOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	dOnlyCheckBox.OnChange = function(self, val)
		skin.donatorOnly = val
		
		skin.steamgroupOnly = false
		steamgOnlyCheckBox:SetChecked(false)
		skin.nameTagOnly = false
		nameTOnlyCheckBox:SetChecked(false)
		
	end
	CL_EASYSKINS.CenterInElement(dOnlyCheckBox, contentPnl)
	
	addSpace()
	
	-- steamgroup only
	steamgOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(0, spaceY, CL_EASYSKINS.Translate("steamgroupOnly"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	steamgOnlyCheckBox:SetChecked(skin.steamgroupOnly)
	steamgOnlyCheckBox:SetWide(checkboxWidth)
	steamgOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	steamgOnlyCheckBox.OnChange = function(self, val)
		skin.steamgroupOnly = val
		
		skin.donatorOnly = false
		dOnlyCheckBox:SetChecked(false)
		skin.nameTagOnly = false
		nameTOnlyCheckBox:SetChecked(false)
	end
	CL_EASYSKINS.CenterInElement(steamgOnlyCheckBox, contentPnl)
	
	addSpace()
	
	-- name tag only
	nameTOnlyCheckBox = CL_EASYSKINS.CreateCheckBox(0, spaceY, CL_EASYSKINS.Translate("nameTagOnly"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	nameTOnlyCheckBox:SetChecked(skin.nameTagOnly)
	nameTOnlyCheckBox:SetWide(checkboxWidth)
	nameTOnlyCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	nameTOnlyCheckBox.OnChange = function(self, val)
		skin.nameTagOnly = val
		
		skin.donatorOnly = false
		dOnlyCheckBox:SetChecked(false)
		skin.steamgroupOnly = false
		steamgOnlyCheckBox:SetChecked(false)
	end
	CL_EASYSKINS.CenterInElement(nameTOnlyCheckBox, contentPnl)
	
	addSpace()
	
	-- purchasable
	local purchasableCheckBox = CL_EASYSKINS.CreateCheckBox(0, spaceY, CL_EASYSKINS.Translate("purchasable"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, contentPnl)
	purchasableCheckBox:SetChecked(skin.purchasable)
	purchasableCheckBox:SetWide(checkboxWidth)
	purchasableCheckBox.Button:SetPos( checkboxWidth-25, 4 )
	purchasableCheckBox.OnChange = function(self, val)
		skin.purchasable = val
	end
	CL_EASYSKINS.CenterInElement(purchasableCheckBox, contentPnl)
		
	addSpace(50)
	
	-- update btn
	local createBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("update"),color_white,contentPnl,function()
		
		-- set correct cat tbl value
		local catName = isstring(skin.category) and skin.category or skin.category.name
		skin.category = SH_EASYSKINS.GetCategoryByName(catName)
		
		-- update skin 
		CL_EASYSKINS.UpdateSkin(skin,function()
			self:Remove()
			self:UpdateManagePnl()
		end)
		
	end)
	createBtn.BGCol = SH_EASYSKINS.COL.GREEN
	createBtn.UseHoverCol = false
	createBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	createBtn:SetTall(30)
	createBtn:SetPos(contentPnl:GetWide()*0.5+10,spaceY)
	
	-- cancel btn
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,contentPnl,function()
		self:Remove()
	end)
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	cancelBtn:SetTall(30)
	cancelBtn:SetPos(contentPnl:GetWide()*0.5-cancelBtn:GetWide()-10,spaceY)
	addSpace(20)
	
	-- emtpy label
	CL_EASYSKINS.CreateLbl(0, spaceY, "", "z_easyskins_menu_cat_btn", color_white, contentPnl)
	
	addSpace(30)
	
	
	-- resize pnl to contents
	contentPnl:SetHeight(math.Min(spaceY,contentPnlH))
	contentPnl:Center()
	
end
vgui.Register('p_easyskins_admin_skin_edit',PANEL,'DFrame')
