-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

local buyableSkins = {} -- cache
local gradientTextID = surface.GetTextureID("gui/gradient")

function CL_EASYSKINS.InvalidateShopCache()
	
	local skins = SH_EASYSKINS.GetSkins()
	buyableSkins = {}
		
	-- fill the table with all buyable skins for each weapon
	for i=1,#skins do
	
		local skin = skins[i]
		
		for classI=1, #skin.weaponTbl do
			
			local class = skin.weaponTbl[classI]
			local wepInfo = SH_EASYSKINS.GetWeaponInfo(class)
			
			-- if the weapon was in the shop but then the weapon pack was removed
			if wepInfo == nil then continue end
			
			local name = wepInfo.name
			
			-- checks for duplicate name
			if SH_EASYSKINS.IsDuplicateWeaponName(name) then
				name = name .." ("..class..")"
			end
		
			if buyableSkins[name] == nil then
				buyableSkins[name] = {
					class = class,
					skins = {}
				}
			end
			
			table.insert(buyableSkins[name].skins,skin)
			
		end
	
	end
	
end

-- on file refresh
if SH_EASYSKINS.GetSkins then
	CL_EASYSKINS.InvalidateShopCache()
end

local function SortSkins(skinTbl)

	-- sort skins by price and buyability
	table.sort(skinTbl, function(a,b)
				
		-- sort by category
		if SH_EASYSKINS.SETTINGS.SHOWSHOPCATEGORIES and a.category.name ~= b.category.name then
			
			-- UNCATEGORIZED should always be the first category
			if a.category.name == SH_EASYSKINS.VAR.UNCATEGORIZED or b.category.name == SH_EASYSKINS.VAR.UNCATEGORIZED then
				return a.category.id < b.category.id
			end
			
			-- sort the other categories by name
			return a.category.name < b.category.name
			
		end
		
		local ply = LocalPlayer()
		local realPriceA = SH_EASYSKINS.GetRealPrice(ply,a)
		local realPriceB = SH_EASYSKINS.GetRealPrice(ply,b)
		local canBuyA = SH_EASYSKINS.CanBuySkin(ply,a.id,a.weaponClass)
		local canBuyB = SH_EASYSKINS.CanBuySkin(ply,b.id,b.weaponClass)
		
		-- sort by price
		if canBuyA == canBuyB then
			return realPriceA < realPriceB
		end
		
		-- sort by buyability
		return SH_EASYSKINS.BoolToInt(canBuyA) > SH_EASYSKINS.BoolToInt(canBuyB)
		
	end)

end

-- counts then amount of distinct categories in skin list
local function GetCategoryCount(skins)
	
	local categories = {}
	
	for i=1, #skins do
		
		local skin = skins[i]
		local tableID = skin.category.id
		
		categories[tableID] = categories[tableID] or {}
	
		-- create a table with structure: categoryID - skins
		table.insert(categories[tableID],skin)
		
	end
	
	return table.Count(categories), categories
	
end

function PANEL:Init(realInit)

	if !realInit then return end
	
	self:SetDrawBackground(false)
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local parent = self:GetParent()
	local ply = LocalPlayer()
	local categories = SH_EASYSKINS.GetCategories()
	
	self:SetTall(self:GetTall()-5)
	local pTall,pWide = self:GetTall(),self:GetWide()
	local wepPanels = {}
	
	-- item info pnl
	local itemInfoPnl = vgui.Create("p_easyskins_hover_skin_info",self)
	itemInfoPnl:SetZPos(2)
	
	local modelInfoW = scrW*0.13
	local modelInfoX = parent:GetPos() + parent:GetWide() + 5
	local modelInfoPnl
	
	-- create only when enough screen width
	if modelInfoX + modelInfoW < scrW then
		-- model pnl
		modelInfoPnl = vgui.Create("p_easyskins_hover_model")
		modelInfoPnl:SetSize(modelInfoW,modelInfoW)
		modelInfoPnl:SetPos(modelInfoX,scrH/2-modelInfoPnl:GetTall()/2)
		modelInfoPnl:SetAlpha(0)
		modelInfoPnl:SetZPos(2)
		
		self.OnRemove = function()
			modelInfoPnl:Remove()
		end
	end
	
	-- filter input
	local searchInput = CL_EASYSKINS.CreateTextInput(5, 0, pWide-10, 45, "", "z_easyskins_menu_cat_btn", color_white, self)
	searchInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	searchInput:SetPlaceholderText(CL_EASYSKINS.Translate("enterName"))
		
	-- filter functionality
	CL_EASYSKINS.HookWepPanelFilter(searchInput,wepPanels)
	
	local prevWepPnl = nil
	local prevWepY = searchInput:GetBottomY()+5
	local lastWepOpened = false
	
	local function CreateWepPnl(class, name)
		
		local wepW,wepH = self:GetWide()-10,35
		local skinIconSize = 64
		local skinYOffset = skinIconSize + 20
		local catHeaderH = 30
		local expandedH = 400
		local isExpanded = false
		local OpenSkinList = nil
		local wepInfo = SH_EASYSKINS.GetWeaponInfo(class)
		local CreateSkinPanel, skinPanel
	
		-- create the parent panel
		local wepPanel = vgui.Create("DPanel",self)
		wepPanel:SetPos(5,prevWepY)
		wepPanel:SetSize(wepW,wepH)
		wepPanel:SetDrawBackground(false)
		wepPanel.skins = {}
		wepPanel.wepInfo = wepInfo
		wepPanel.prevWepPnlRef = prevWepPnl
		wepPanel.Think = function(self)
			if self.prevWepPnlRef ~= nil then
				self:SetPos(5,2+self.prevWepPnlRef:GetBottomY())
			end
		end
		
		-- for external referencing
		wepPanels[name] = wepPanel
		prevWepPnl = wepPanel
		prevWepY = prevWepY + wepH + 2
		
		-- title btn
		local titleBtn = vgui.Create ("DButton",wepPanel)
		titleBtn:SetPos(0,0)
		titleBtn:SetFont("z_easyskins_cat_title")
		titleBtn:SetSize(wepW,wepH)
		titleBtn:SetTextColor(color_white)
		titleBtn:SetText(name)
		titleBtn.Paint = function(self, w, h)
			surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY_150)
			surface.DrawRect(0,0,w,h)
		end
		titleBtn.DoClick = function()
		
			-- create panel for the skins
			if skinPanel == nil then
				CreateSkinPanel()
			end
		
			isExpanded = !isExpanded
			local newH = wepH
			if isExpanded then
				
				local skinAmount = #wepPanel.skins
				local skinsPerRow = 9
				local skinRows = math.ceil(skinAmount/skinsPerRow)
				
				-- calc skin rows based on categories
				if skinPanel.showCategories then
					
					skinRows = 0
				
					for _, skins in pairs(skinPanel.categories) do
						skinRows = skinRows + math.ceil(#skins/skinsPerRow)
					end
				
				end
				
				-- calc height based on the amount of skins
				newH = wepH+((skinYOffset)*skinRows)
				
				-- add height from categories
				if skinPanel.showCategories then
					
					-- cat header height + offset
					newH = newH + ((catHeaderH+5)*skinPanel.catCount)
					
				end
				
				-- resize skin panel
				skinPanel:SetTall( newH )
				
			end
			
			-- resize panels
			wepPanel:SizeTo( wepW, newH, 0.25 )
			
			-- sort skins
			SortSkins(wepPanel.skins)
			
			-- create skin icons
			OpenSkinList()
			
			-- mark as last opened
			lastOpenedWep = class
			
		end
		titleBtn.OnCursorEntered = function()
			if IsValid(modelInfoPnl) then
				modelInfoPnl:Show()
				modelInfoPnl:UpdateInfo(class)
			end
		end
		titleBtn.OnCursorExited = function()
			if IsValid(modelInfoPnl) then
				modelInfoPnl:Hide()
			end
		end
		
		function CreateSkinPanel()
			
			-- panel containing the material icon btns
			skinPanel = vgui.Create("DScrollPanel",wepPanel)
			skinPanel:SetSize(wepW,expandedH-wepH)
			skinPanel:SetPos(0,wepH)
			skinPanel.hasSkins = false
			skinPanel.Paint = function(self,w,h)
				surface.SetDrawColor(SH_EASYSKINS.COL.LIGHTBLACK_150)
				surface.DrawRect(0, 0, w, h)
			end
					
			CL_EASYSKINS.SkinScrollPanel(skinPanel)
			local vBar = skinPanel:GetVBar()
			vBar:SetWide(1)
			
			-- get the amount of distinct categories
			skinPanel.catCount, skinPanel.categories = GetCategoryCount(wepPanel.skins)
			skinPanel.showCategories = SH_EASYSKINS.SETTINGS.SHOWSHOPCATEGORIES and skinPanel.catCount > 1
			
		end
		
		-- adds icons to the skin panel
		function OpenSkinList()

			if !skinPanel.hasSkins then
			
				local lastCat = -1
				local lastX, lastY = 2,2
				local skinWI = 0
				
				for i=1,#wepPanel.skins do
				
					skinWI = skinWI + 1
				
					local skin = wepPanel.skins[i]
					local canBuySkin, hasSkin, hasSkinOverride
					-- local shouldDrawBorder = skin.donatorOnly or skin.nameTagOnly or skin.steamgroupOnly
					
					if skinPanel.showCategories and lastCat ~= skin.category.id then
						
						lastCat = skin.category.id
						
						if lastX ~= 2 then
							lastX, lastY = 2, lastY + skinYOffset
							skinWI = 1
						end
						
						local catPnl =  vgui.Create("DPanel",skinPanel)
						catPnl:SetPos(2,lastY) 
						catPnl:SetSize(wepW,catHeaderH)
						
						local catFont = "z_easyskins_shop_category_title"
						local catTxt = skin.category.name:upper()
						
						surface.SetFont(catFont)
						local catTxtW, catTxtH = surface.GetTextSize(catTxt)
						local skinsForCatCount = #skinPanel.categories[skin.category.id]
						local lineW = skinsForCatCount * (skinIconSize) + (skinsForCatCount-1) * 5
						
						catPnl.Paint = function(self, w, h)
							
							-- draw cat title
							surface.SetFont(catFont)
							surface.SetTextColor(SH_EASYSKINS.COL.BLUE)
							surface.SetTextPos(0, catHeaderH/2-catTxtH/2) 
							surface.DrawText(catTxt)
							
							-- draw line
							surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
							surface.SetTexture(gradientTextID)
							surface.DrawTexturedRect(0,h-1,lineW,1)
							-- surface.DrawRect(0,h-1,lineW,1)
							
						end
						
						lastY = lastY + catHeaderH + 5
						
					end

					local skinIconBtn = CL_EASYSKINS.CreateMaterialIcon(lastX, lastY, skinIconSize, skin.dispName, skin.material.path, skinPanel, function()
						
						if !canBuySkin or hasSkin then 
							CL_EASYSKINS.PlaySound("deny")
							return 
						end
												
						local buyMsg = string.format(CL_EASYSKINS.Translate("buySkin"), skin.dispName, wepInfo.name)
						local confirmation =  vgui.Create("p_easyskins_shop_preview")
						confirmation:Init(true, class, skin.material.path, buyMsg, function()
						
							-- play sound
							CL_EASYSKINS.PlaySound("buy")
							
							-- buy skin
							CL_EASYSKINS.BuySkin(skin.id,class)
							
							-- don't wait for server
							hasSkinOverride = true
							hasSkin = true
							
						end)
						
					end)
					
					skinIconBtn.DoRightClick = skinIconBtn.DoClick
									
					skinIconBtn.OnCursorEntered = function()
						
						if hasSkin then return end
						
						itemInfoPnl:UpdateInfo(skin,class)
						
					end
				
					skinIconBtn.OnCursorExited = function()
						if IsValid(itemInfoPnl) then
							itemInfoPnl:Hide()
						end
					end
					
					skinIconBtn.Think = function()
					
						if !hasSkinOverride then
							-- keep checking incase some stats change
							canBuySkin = SH_EASYSKINS.CanBuySkin(ply,skin.id,class)
							hasSkin = SH_EASYSKINS.HasPurchasedSkin(ply,skin.id,class)
						end
						
						if hasSkin then
							skinIconBtn.materialLbl:SetColor(SH_EASYSKINS.COL.GREEN)
						elseif !canBuySkin then
							skinIconBtn.materialLbl:SetColor(SH_EASYSKINS.COL.RED)
						else
							skinIconBtn.materialLbl:SetColor(color_white)
						end
						
					end
					
					/*
					if shouldDrawBorder then
						
						local borderCol = SH_EASYSKINS.COL.GOLD
						
						-- draw border if needed
						if skin.steamgroupOnly then
							borderCol = SH_EASYSKINS.COL.STEAM
						elseif skin.nameTagOnly  then
							borderCol = SH_EASYSKINS.COL.NAMETAG
						end
							
						local __oldPaint = skinIconBtn.Paint
						skinIconBtn.Paint = function(self,w,h)
						
							-- old paint
							__oldPaint(self,w,h)
							

							-- draw border
							surface.SetDrawColor(borderCol)
							-- surface.DrawRect(0,h-1,w,1)
							
							surface.SetTexture(surface.GetTextureID("vgui/gradient-d"))
							surface.DrawTexturedRect(0,h-10,w,15)
							
						end
						
					end
					*/
					
					lastX = lastX + skinIconSize + 5
					
					if skinWI%9 == 0 then
						lastX = 2
						lastY = lastY + skinYOffset
					end
					
				end
				
				skinPanel.hasSkins = true
	
			end
			
		end
	
	end
	
	-- loading overlay
	local loadingOverlay = vgui.Create("p_easyskins_loading",self)
	loadingOverlayY = searchInput:GetBottomY()+1
	loadingOverlay:Init(true,5,loadingOverlayY,pWide,pTall,"z_easyskins_cat_title")
	loadingOverlay:SetZPos(3)
	loadingOverlay.Think = function()
		-- disable scrolling while loading
		self.VBar:SetScroll(0)
	end
	
	local counter = 0
	local sortedBuyableSkins = {}
	
	-- sort alphabetically in a numeric table
	for name, skinInfo in SortedPairs(buyableSkins) do
		table.insert(sortedBuyableSkins,{ name = name, skinInfo = skinInfo })
	end
	
	local i = 1
	local function CreateNextWeaponPanel()
		
		-- player closes the menu before it's fully filled
		if !IsValid(self) then return end
		
		local sortedBuyableSkin = sortedBuyableSkins[i]
		
		-- if there are no more skins to add
		if !sortedBuyableSkin then 
		
			-- remove loadingOverlay
			loadingOverlay:Remove()
			
			return 
			
		end
		
		local name = sortedBuyableSkin.name
		local skinInfo = sortedBuyableSkin.skinInfo
		
		i = i + 1
	
		for i=1, #skinInfo.skins do
		
			local skin = skinInfo.skins[i]
			
			if !skin.purchasable then continue end
			
			local hasSkin = SH_EASYSKINS.HasPurchasedSkin(ply,skin.id,skinInfo.class)
			
			if hasSkin then continue end

			-- create the wep pnl if it didn't exist before
			if wepPanels[name] == nil then
				CreateWepPnl(skinInfo.class, name) 
			end
			
			-- add skin in weapon pnl skin table
			local skinPnlTbl = wepPanels[name].skins
			table.insert(skinPnlTbl,skin)
		
		end
		
		-- small delay to prevent lag
		local delay = 0
		
		if i%50 == 0 then
			delay = 0.005
		end
		
		timer.Simple(delay,CreateNextWeaponPanel)
	
	end
	CreateNextWeaponPanel()
	
	-- empty lbl
	if table.Count(buyableSkins) == 0 then
	
		-- remove loadingOverlay
		loadingOverlay:Remove()

		local emptyLbl = CL_EASYSKINS.CreateLbl(0, pTall/2-15, CL_EASYSKINS.Translate("emptyShop"), "z_easyskins_cat_title", SH_EASYSKINS.COL.LIGHTGREY, self, false)
		CL_EASYSKINS.CenterInElement(emptyLbl, self)
		
	end
	
end
vgui.Register('p_easyskins_shop',PANEL,'DScrollPanel')