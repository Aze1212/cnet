-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

local function CreateSettingTitleLbl(x, y, txt, parent)
	
	local settingTitleLbl = CL_EASYSKINS.CreateLbl(x, y, txt, "z_easyskins_menu_settings_title", color_white, parent, false)
	settingTitleLbl:SetSize(parent:GetWide(), 32)
	settingTitleLbl:SetTextInset(5,2)
	settingTitleLbl:SetContentAlignment(4)
	
	settingTitleLbl.Paint = function(self,w,h)
		surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
		surface.DrawRect(0,0,w,h)
	end
	
	return settingTitleLbl
	
end

local function CreateSettingDecimalNumberInput(x, y, w, h, value, parent, settingKey)
	
	local decimalNumberInput = CL_EASYSKINS.CreateNumInput(x, y, w, h, 0, "z_easyskins_menu_cat_btn", color_white, parent)
	decimalNumberInput:SetDecimals(2)
	decimalNumberInput:SetMinMax(0.01,0.99)
	decimalNumberInput:SetValue(value)
	decimalNumberInput:SetInterval(0.05)
	decimalNumberInput.OnValueChanged = function(self, num)
	
		SH_EASYSKINS.SETTINGS[settingKey] = num
	
		CL_EASYSKINS.SaveSettings()
	
	end
	
end

function PANEL:Init(realInit)

	if !realInit then return end
	
	self:SetDrawBackground(false)
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local ply = LocalPlayer()
	self:SetTall(self:GetTall()-5)
	local pTall,pWide = self:GetTall(),self:GetWide()
	local inputFieldWidth = 320

	-- keybind title
	local keybindTitle = CreateSettingTitleLbl(0, 0, CL_EASYSKINS.Translate("keybind"), self)
	local keybindTitleY = keybindTitle:GetBottomY() + 10
	
	-- keybind to open menu
	local keybindComboBox = CL_EASYSKINS.CreateComboBox(5, keybindTitleY, 100, 25, "None", SH_EASYSKINS.SETTINGS.MENUKEY, SH_EASYSKINS.KEYBINDS, {}, "z_easyskins_menu_cat_sub_btn", color_white, self)
	local oldOnSelect = keybindComboBox.OnSelect
	keybindComboBox.OnSelect = function( self, index, value, func )
		
		oldOnSelect(self,index,value,func)
		
		SH_EASYSKINS.SETTINGS.MENUKEY = value
		
		CL_EASYSKINS.SaveSettings()
	
	end
	
	-- remote shop title
	local remoteShopTitle = CreateSettingTitleLbl(0, keybindComboBox:GetBottomY()+15, CL_EASYSKINS.Translate("remoteShop"), self)
	local remoteShopTitleY = remoteShopTitle:GetBottomY() + 10
	
	-- allow bind access to admins
	local adminBindCheckBox = CL_EASYSKINS.CreateCheckBox(0,remoteShopTitleY, CL_EASYSKINS.Translate("admin")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	adminBindCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.ADMINREMOTESHOP)
	adminBindCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.ADMINREMOTESHOP = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- allow bind access to donators
	local donatorBindCheckBox = CL_EASYSKINS.CreateCheckBox(0,adminBindCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("donator")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	donatorBindCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.DONATORREMOTESHOP)
	donatorBindCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.DONATORREMOTESHOP = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- allow bind access to players
	local playerBindCheckBox = CL_EASYSKINS.CreateCheckBox(0,donatorBindCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("player")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	playerBindCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.PLAYERREMOTESHOP)
	playerBindCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.PLAYERREMOTESHOP = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- currency symbol title
	local currencySymbolTitle = CreateSettingTitleLbl(0, playerBindCheckBox:GetBottomY()+15, CL_EASYSKINS.Translate("currencySymbol"), self)
	local currencySymbolTitleY = currencySymbolTitle:GetBottomY() + 10
		
	-- currency symbol combobox
	local symbolComboBox = CL_EASYSKINS.CreateComboBox(5, currencySymbolTitleY, pWide/2, 25, nil, SH_EASYSKINS.SETTINGS.CURRENCYSYMBOL, SH_EASYSKINS.CURRENCYSYMBOLS, {}, "z_easyskins_menu_cat_sub_btn", color_white, self)
	local symbolComboBoxY = symbolComboBox:GetBottomY()+10
	
	symbolComboBox.OnSelect = function( self, index, value, func )
	
		SH_EASYSKINS.SETTINGS.CURRENCYSYMBOL = value
		
		CL_EASYSKINS.SaveSettings()
		
	end
	
	-- steamgroup title
	local steamgroupTitle = CreateSettingTitleLbl(0, symbolComboBoxY, CL_EASYSKINS.Translate("steamgroup"), self)
	local steamgroupTitleY = steamgroupTitle:GetBottomY() + 10
	
	-- steamgroup discount
	local steamgroupDiscountLbl = CL_EASYSKINS.CreateLbl(0, steamgroupTitleY, CL_EASYSKINS.Translate("discount")..':', "z_easyskins_menu_cat_btn", color_white, self)
	local steamgroupDiscountLblY = steamgroupDiscountLbl:GetBottomY()+5
	local steamgroupDiscountInputX = steamgroupDiscountLbl:GetPos() + steamgroupDiscountLbl:GetWide()
	local steamgroupDiscountInput = CreateSettingDecimalNumberInput(steamgroupDiscountInputX, steamgroupTitleY, inputFieldWidth-steamgroupDiscountLbl:GetWide(), 25, SH_EASYSKINS.SETTINGS.STEAMGROUPDISCOUNT, self, "STEAMGROUPDISCOUNT")
	
	-- steamgroup link
	local baseSteamGroupLink = "https://steamcommunity.com/groups/"
	local steamgroupLinkLbl = CL_EASYSKINS.CreateLbl(0, steamgroupDiscountLblY, baseSteamGroupLink, "z_easyskins_menu_cat_btn", color_white, self)
	local steamgroupLinkInputX = steamgroupLinkLbl:GetPos() + steamgroupLinkLbl:GetWide()
	local steamgroupLinkInput = CL_EASYSKINS.CreateTextInput(steamgroupLinkInputX, steamgroupDiscountLblY, pWide-steamgroupLinkLbl:GetWide(), 25, SH_EASYSKINS.SETTINGS.STEAMGROUPLINK, "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.GREEN, self)
	steamgroupLinkInput.m_colCursor = color_white
	steamgroupLinkInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	steamgroupLinkInput:SetPlaceholderText(CL_EASYSKINS.Translate("customULR"))
	steamgroupLinkInput.OnChange = function(self)
		
		local customURL = self:GetText()
		local steamgroupLink = baseSteamGroupLink..customURL
		
		-- ability to remove the steamgroup
		if #customURL == 0 then
			SH_EASYSKINS.SETTINGS.STEAMGROUPLINK = ''
			CL_EASYSKINS.SaveSettings()
			return
		end
		
		-- set text color to red
		self:SetTextColor(SH_EASYSKINS.COL.RED)
		
		-- verify if steam group exists
		http.Fetch( steamgroupLink,
			function( body, len, headers, code )
			
				local groupExists = string.match(body, "Steam Community :: Error") == nil
				
				if groupExists then
				
					-- if steam group exists set it
					SH_EASYSKINS.SETTINGS.STEAMGROUPLINK = customURL
					
					-- save to server
					CL_EASYSKINS.SaveSettings()
					
					-- update connected clients
					net.Start("sv_easyskins_CheckSteamGroupMembership")
					net.SendToServer()
				
					if IsValid(self) then
						self:SetTextColor(SH_EASYSKINS.COL.GREEN)
					end
					
				end
				
			end,
			function( error )
				if IsValid(self) then
					self:SetTextColor(SH_EASYSKINS.COL.RED)
				end
			end
		)
		
	end
	
	-- name tag title
	local nameTagTitle = CreateSettingTitleLbl(0, steamgroupLinkLbl:GetBottomY()+15, CL_EASYSKINS.Translate("nameTag"), self)
	local nameTagTitleY = nameTagTitle:GetBottomY() + 10
	
	-- tag discount
	local nameTagDiscountLbl = CL_EASYSKINS.CreateLbl(0, nameTagTitleY, CL_EASYSKINS.Translate("discount")..':', "z_easyskins_menu_cat_btn", color_white, self)
	local nameTagDiscountLblY = nameTagDiscountLbl:GetBottomY()+5
	local nameTagDiscountInputX = nameTagDiscountLbl:GetPos() + nameTagDiscountLbl:GetWide()
	local nameTagDiscountInput = CreateSettingDecimalNumberInput(nameTagDiscountInputX, nameTagTitleY, inputFieldWidth-nameTagDiscountLbl:GetWide(), 25, SH_EASYSKINS.SETTINGS.TAGDISCOUNT, self, "TAGDISCOUNT")
	
	-- tag
	local nameTagLbl = CL_EASYSKINS.CreateLbl(0, nameTagDiscountLblY, CL_EASYSKINS.Translate("tag")..':', "z_easyskins_menu_cat_btn", color_white, self)
	local nameTagInputX = nameTagLbl:GetPos() + nameTagLbl:GetWide()
	local nameTagInput = CL_EASYSKINS.CreateTextInput(nameTagInputX, nameTagDiscountLblY, inputFieldWidth-nameTagLbl:GetWide(), 25, SH_EASYSKINS.SETTINGS.TAG, "z_easyskins_menu_cat_btn", color_white, self)
	nameTagInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	nameTagInput:SetPlaceholderText("[RP]")
	nameTagInput.OnChange = function(self)
	
		SH_EASYSKINS.SETTINGS.TAG = self:GetText()
		
		CL_EASYSKINS.SaveSettings()
		
	end
	
	-- various title
	local variousTitle = CreateSettingTitleLbl(0, nameTagLbl:GetBottomY()+15, CL_EASYSKINS.Translate("various"), self)
	local variousTitleY = variousTitle:GetBottomY() + 10
	
	-- sell rate
	local sellRateLbl = CL_EASYSKINS.CreateLbl(0, variousTitleY, CL_EASYSKINS.Translate("sellRate")..':', "z_easyskins_menu_cat_btn", color_white, self)
	local sellRateLblY = sellRateLbl:GetBottomY()+5
	local sellRateInputX = sellRateLbl:GetPos() + sellRateLbl:GetWide()
	local sellRateInput = CreateSettingDecimalNumberInput(sellRateInputX, variousTitleY, inputFieldWidth-sellRateLbl:GetWide(), 25, SH_EASYSKINS.SETTINGS.SELLRATE, self, "SELLRATE")
	
	-- skin gifting
	local skinGiftingCheckBox = CL_EASYSKINS.CreateCheckBox(0,sellRateLblY, CL_EASYSKINS.Translate("allowSkinGifting")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	skinGiftingCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.ALLOWSKINGIFTING)
	skinGiftingCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.ALLOWSKINGIFTING = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- show shop categories
	local shopCategoriesCheckBox = CL_EASYSKINS.CreateCheckBox(0,skinGiftingCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("shopCategories")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	shopCategoriesCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.SHOWSHOPCATEGORIES)
	shopCategoriesCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.SHOWSHOPCATEGORIES = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- notifications
	local notificationsCheckBox = CL_EASYSKINS.CreateCheckBox(0,shopCategoriesCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("notifications")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	notificationsCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.ENABLENOTIFICATIONS)
	notificationsCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.ENABLENOTIFICATIONS = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- add skin to weapon name
	local skinWeaponNameCheckBox = CL_EASYSKINS.CreateCheckBox(0,notificationsCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("skinToWeaponName")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	skinWeaponNameCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.ADDSKINTOWEAPONAME)
	skinWeaponNameCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.ADDSKINTOWEAPONAME = val
		CL_EASYSKINS.SaveSettings()
	end
	
	-- worldmodel skins
	local worldModelSkinsCheckBox = CL_EASYSKINS.CreateCheckBox(0,skinWeaponNameCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("worldModelSkins")..": ", "z_easyskins_menu_cat_btn", color_white, self,false)
	worldModelSkinsCheckBox:SetChecked(SH_EASYSKINS.SETTINGS.WORLDMODELSKINS)
	worldModelSkinsCheckBox.OnChange = function(self, val)
		SH_EASYSKINS.SETTINGS.WORLDMODELSKINS = val
		CL_EASYSKINS.SaveSettings()
	end

	-- base skin title
	local baseSkinTitle = CreateSettingTitleLbl(0, worldModelSkinsCheckBox:GetBottomY()+5, CL_EASYSKINS.Translate("baseSkin"), self)
	local baseSkinTitleY = baseSkinTitle:GetBottomY() + 20
	local baseSkinChooseBtn, baseSkinRemoveBtn, baseSkinIcon
	
	-- base skin remove btn
	local function CreateBaseSkinRemoveBtn()
		
		baseSkinRemoveBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("clear"),color_white,self,function()
			
			-- remove skin icon
			baseSkinIcon:Remove()
			baseSkinIcon = nil
		
			-- reset base material
			SH_EASYSKINS.SETTINGS.BASESKINMATERIAL = ""
			
			-- save
			CL_EASYSKINS.SaveSettings()
			
			-- remove btn
			baseSkinRemoveBtn:Remove()
			baseSkinRemoveBtn = nil
			
		end)
		baseSkinRemoveBtn.BGCol = SH_EASYSKINS.COL.RED
		baseSkinRemoveBtn.UseHoverCol = false
		baseSkinRemoveBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
		baseSkinRemoveBtn:SetTall(30)
		baseSkinRemoveBtn:SetPos(baseSkinIcon:GetPos()+baseSkinIcon:GetWide()+20,baseSkinTitleY)
		
	end
	
	local function CreateBaseSkinIcon(baseMaterial)
		
		if baseSkinIcon then 
			baseSkinIcon:Remove()
			baseSkinIcon = nil
		end
	
		baseSkinIcon = CL_EASYSKINS.CreateMaterialIcon(baseSkinChooseBtn:GetWide()+20, baseSkinTitle:GetBottomY()+5, 64, '', baseMaterial, self, nil, true)
		
	end
	
	-- base skin choose btn
	baseSkinChooseBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("choose"),color_white,self,function()
	
		local openListPnl = vgui.Create("p_easyskins_admin_material_list")
		
		openListPnl.CloseList = function( realSelf, material)
			
			SH_EASYSKINS.SETTINGS.BASESKINMATERIAL = material.path
			CL_EASYSKINS.SaveSettings()
			
			-- create icon
			CreateBaseSkinIcon(material.path)
			
			-- create remove btn
			if !baseSkinRemoveBtn then
				CreateBaseSkinRemoveBtn()
			end
		
			-- remove the material select list
			realSelf:Remove()
			
		end

	end)
	baseSkinChooseBtn.BGCol = SH_EASYSKINS.COL.GREEN
	baseSkinChooseBtn.UseHoverCol = false
	baseSkinChooseBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	baseSkinChooseBtn:SetTall(30)
	baseSkinChooseBtn:SetPos(5,baseSkinTitleY)
	
	-- create icon if a base material was already chosen
	if #SH_EASYSKINS.SETTINGS.BASESKINMATERIAL > 0 then
		CreateBaseSkinIcon(SH_EASYSKINS.SETTINGS.BASESKINMATERIAL)
		CreateBaseSkinRemoveBtn()
	end	

	-- npc model title
	local npcModelTitle = CreateSettingTitleLbl(0, baseSkinChooseBtn:GetBottomY()+25, CL_EASYSKINS.Translate("shopModel"), self)
	local npcModelTitleY = npcModelTitle:GetBottomY() + 10
	
	-- npc model combobox
	local activeModel = table.KeyFromValue( SH_EASYSKINS.SHOPMODELS, SH_EASYSKINS.SETTINGS.SHOPMODEL )
	local modelChoices = table.GetKeys( SH_EASYSKINS.SHOPMODELS )
	local modelComboBox = CL_EASYSKINS.CreateComboBox(5, npcModelTitleY, pWide/2, 25, nil, activeModel, modelChoices, {}, "z_easyskins_menu_cat_sub_btn", color_white, self)
	local modelComboBoxY = modelComboBox:GetBottomY()+10
	
	modelComboBox.OnSelect = function( self, index, value, func )
	
		SH_EASYSKINS.SETTINGS.SHOPMODEL = SH_EASYSKINS.SHOPMODELS[value]
		
		CL_EASYSKINS.SaveSettings()
		
	end	
	
	-- npc pos title
	local npcPosTitle = CreateSettingTitleLbl(0, modelComboBoxY, CL_EASYSKINS.Translate("shopPositions"), self)
	local npcPosTitleY = npcPosTitle:GetBottomY() + 15
	
	-- npc pos tbl
	local npcPosListView = CL_EASYSKINS.CreateVectorListView(5,npcPosTitleY,"NPCPOSITIONS",self)
	
	-- admin access title
	local adminTitle = CreateSettingTitleLbl(0, npcPosListView:GetBottomY()+15, CL_EASYSKINS.Translate("menuPrivileges"), self)
	local adminTitleY = adminTitle:GetBottomY() + 15
	
	-- admin access
	local accessList = CL_EASYSKINS.CreateAccessLists(5,adminTitleY,"ADMINS",CL_EASYSKINS.Translate("adminAccess"),SH_EASYSKINS.COL.RED,CL_EASYSKINS.Translate("userAccess"),color_white,self)
	local accessListY = accessList:GetBottomY()
	
	-- donator title
	local donatorTitle = CreateSettingTitleLbl(0, accessList:GetBottomY()+15, CL_EASYSKINS.Translate("donator"), self)
	local donatorTitleY = donatorTitle:GetBottomY() + 15
	
	-- donators
	local donatorList = CL_EASYSKINS.CreateAccessLists(5,donatorTitle:GetBottomY()+15,"DONATORS",CL_EASYSKINS.Translate("donators"),SH_EASYSKINS.COL.GOLD,CL_EASYSKINS.Translate("players"),color_white,self)
	local donatorListY = donatorList:GetBottomY()+15
	
	-- reset DB title
	local restoreTitle = CreateSettingTitleLbl(0, donatorListY, CL_EASYSKINS.Translate("data"), self)
	local restoreTitleY = restoreTitle:GetBottomY() + 15
	
	-- reset DB
	local resetDBBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("resetDB"),color_white,self,function()
		
		local resetMsg = CL_EASYSKINS.Translate("resetDBConfirmation")
		local confirmation =  vgui.Create("p_easyskins_confirmation")
		confirmation:Init(true, resetMsg, function()
			
			-- reset db
			net.Start("sv_easyskins_ResetDB")
			net.SendToServer()
			
		end)
		
	end)
	resetDBBtn.BGCol = SH_EASYSKINS.COL.RED
	resetDBBtn.UseHoverCol = false
	resetDBBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	resetDBBtn:SetSize(math.Max(resetDBBtn:GetWide(),200),35)
	resetDBBtn:SetPos(5, restoreTitleY)
	
	-- empty space in bottom
	local emptyLbl = vgui.Create("DLabel",self)
	emptyLbl:SetPos(0,resetDBBtn:GetBottomY()+5)
	emptyLbl:SetText("")
	
end
vgui.Register('p_easyskins_admin_settings',PANEL,'DScrollPanel')
