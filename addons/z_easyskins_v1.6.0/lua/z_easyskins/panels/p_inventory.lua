-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit)

	if !realInit then return end
	
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local ply = LocalPlayer()
	
	self:SetTall(self:GetTall()-5)
	local pWide,pTall = self:GetWide(), self:GetTall()
	local wepPanels = {}
	local activeSkinSelection = nil
	
	local purchasedSkins = SH_EASYSKINS.GetPurchasedSkins(ply)
	purchasedSkins = table.Copy(purchasedSkins)
	
	-- sort table by weapon name
	table.sort( purchasedSkins, function(a,b)
		
		local aWepInfo = SH_EASYSKINS.GetWeaponInfo(a.weaponClass)
		local bWepInfo = SH_EASYSKINS.GetWeaponInfo(b.weaponClass)
		
		if !aWepInfo and !bWepInfo then
			return a.weaponClass < b.weaponClass
		end
		
		if aWepInfo ~= nil and bWepInfo == nil then
			return true
		elseif aWepInfo == nil and bWepInfo ~= nil then
			return false
		end
		
		local aName = aWepInfo.name:lower()
		local bName = bWepInfo.name:lower()
		
		return aName < bName
	
	end)

	-- filter input
	local searchInput = CL_EASYSKINS.CreateTextInput(5, 0, pWide-10, 45, "", "z_easyskins_menu_cat_btn", color_white, self)
	searchInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	searchInput:SetPlaceholderText(CL_EASYSKINS.Translate("enterName"))
	
	-- filter functionality
	CL_EASYSKINS.HookWepPanelFilter(searchInput,wepPanels)
	
	local __oldOnChange = searchInput.OnChange
	searchInput.OnChange = function(self)
		
		-- normal filter
		__oldOnChange(self)
		
		-- force close the weapon selection if open
		if IsValid(activeSkinSelection) then
			activeSkinSelection:Remove()
			activeSkinSelection = nil
		end
	
	end
	
	local prevWepPnl = nil
	local panelsPerRow = 3
	local wepPanelXOffset = 5
	local wepPanelSize = math.Round(((pWide-(wepPanelXOffset*(panelsPerRow+1)))/panelsPerRow) + 2)
	local miniSkinIconSize = 24
	local wepPanelCount, prevWepX, prevWepY = 0,5,searchInput:GetBottomY()+5
	local skinIconSize = 50

	local function CreateWepPnl(class, name)
		
		local OpenSkinSelection
		local enabledPurchasedSkinForClass = SH_EASYSKINS.GetEnabledPurchasedSkinByClass(ply,class)
		local enabledSkin = enabledPurchasedSkinForClass and SH_EASYSKINS.GetSkin(enabledPurchasedSkinForClass.skinID)
		
		wepPanelCount = wepPanelCount + 1
		
		local wepPanel = vgui.Create("DPanel",self)
		wepPanel:SetPos(prevWepX,prevWepY)
		wepPanel:SetSize(wepPanelSize,wepPanelSize)
		wepPanel.prevWepPnlRef = prevWepPnl
		wepPanel.Paint = function(self, w, h)
			surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY_150)
			surface.DrawRect(0,0,w,h)
		end
		wepPanel.Think = function(self)
		
			-- relative pos to prev pnl
			if self.prevWepPnlRef ~= nil then
				self.count = self.prevWepPnlRef.count + 1
				
				if self.count%3 == 0 then
					local yPos = self.prevWepPnlRef:GetBottomY() + 2
					self:SetPos(5,yPos)
				else
					local prevPosX, prevPosY = self.prevWepPnlRef:GetPos()
					local xPos = prevPosX+self.prevWepPnlRef:GetWide()+2
					self:SetPos(xPos,prevPosY)
				end
				
			else
				self.count = 0
			end
			
		end
		
		-- for external referencing
		wepPanels[name] = wepPanel
		wepPanel.wepInfo = { name = name } 
		prevWepPnl = wepPanel
		
		if wepPanelCount%3 == 0 then
			prevWepX = 5
			prevWepY = prevWepY + wepPanelSize + wepPanelXOffset 
		else
			prevWepX = prevWepX + wepPanelSize + wepPanelXOffset
		end
		
		-- weapon name
		local weaponName = string.sub( name, 1, 22 )
		local wepLbl = CL_EASYSKINS.CreateLbl(0, 0, weaponName, "z_easyskins_menu_cat_sub_btn_bold", color_white, wepPanel, true)
		wepLbl:SetSize(wepPanelSize,30)
		wepLbl:SetTextInset(3,0)
		wepLbl:SetContentAlignment(4)
		wepLbl:SetZPos(2)
		wepLbl.Paint = function(self, w, h)
		
			-- bg
			surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
			surface.DrawRect(0,0,w,h)
			
			-- white line
			surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
			surface.DrawRect(0,h-1,w,1)	
			
		end
		
		-- weapon enabled skin
		local wepEnabledSkinIcon = CL_EASYSKINS.CreateMaterialIcon(wepPanelSize-miniSkinIconSize-3, 3, 0, '', '', wepLbl)
		wepEnabledSkinIcon.Think = function(self)
			
			if enabledSkin ~= nil then
				self:SetIcon( enabledSkin.material.path )
				self:SetSize( miniSkinIconSize, miniSkinIconSize )
			else
				self:SetIcon("")
				self:SetSize(0,0)
			end
			
		end
		
		-- weapon model preview (worldmodel)
		local _, wmPath = SH_EASYSKINS.GetWeaponModels(class)
		local weaponModelPnlSize = wepPanelSize*1.8
		local weaponModelOffset = wepPanelSize/2-weaponModelPnlSize/2
		local previewPnl, previewLbl = CL_EASYSKINS.CreateWeaponModelPnl(weaponModelOffset,weaponModelOffset,weaponModelPnlSize,'',true,wepPanel,false,true)
		previewLbl:SetVisible(false)
		previewPnl:UpdateModel(wmPath)
		previewPnl:SetAmbientLight(color_white)
		previewPnl.Think = function(self)
			
			if enabledSkin and self.appliedMatName ~= enabledSkin.material.name then

				self.appliedMatName = enabledSkin.material.name
				
				-- apply skin to preview model
				if IsValid(previewPnl.Entity) then
					SH_EASYSKINS.ApplySkinToModel(previewPnl.Entity, enabledSkin.material.path)
				end
				
			elseif !enabledSkin then
			
				-- apply base skin if set
				if #SH_EASYSKINS.SETTINGS.BASESKINMATERIAL > 0 then
					
					if SH_EASYSKINS.SETTINGS.BASESKINMATERIAL ~= self.appliedMatName then
				
						self.appliedMatName = SH_EASYSKINS.SETTINGS.BASESKINMATERIAL
						
						if IsValid(previewPnl.Entity) then
							SH_EASYSKINS.ApplySkinToModel(previewPnl.Entity, SH_EASYSKINS.SETTINGS.BASESKINMATERIAL)
						end
						
					end
					
				else
				
					self.appliedMatName = nil
					
					if IsValid(previewPnl.Entity) then
						previewPnl.Entity:SetSubMaterial()
					end
				
				end
				
			end
			
		end
		previewPnl.DoClick = function()
			
			-- open new selection
			if activeSkinSelection == nil or (activeSkinSelection ~= nil and activeSkinSelection.class ~= class) then
				OpenSkinSelection()
			else
				activeSkinSelection:Remove()
				activeSkinSelection = nil
			end
			
		end
		
		function OpenSkinSelection()
					
			-- remove prev created version
			if activeSkinSelection ~= nil then
				activeSkinSelection:Remove()
			end
					
			-- get purchasedSkins for weapon
			local purchasedSkins = table.Copy(SH_EASYSKINS.GetPurchasedSkinsByClass(ply,class))
			
			if #purchasedSkins == 0 then return end
			
			local isNotLastRow = (wepPanel.count+1)%3 ~= 0
			local triangleSize = 24
			local maxRows = 6
			local activeSkinSelectionPanelType = "DPanel"
			local activeSkinSelectionW = math.min(#purchasedSkins,3) * (skinIconSize+2) + 2 + triangleSize
			local activeSkinSelectionH = math.ceil((skinIconSize+2)*math.min(math.ceil(#purchasedSkins/3),maxRows))+1
			
			if #purchasedSkins/3 > maxRows then
				-- add space for scrollbar
				activeSkinSelectionW = activeSkinSelectionW + 2
				activeSkinSelectionPanelType = "DScrollPanel"
			end
		
			local wepPanelX, wepPanelY = wepPanel:GetPos()
			local widthOffset = wepPanelSize*0.05 + triangleSize
			local activeSkinSelectionX = isNotLastRow and wepPanelX + wepPanelSize - widthOffset or wepPanelX - activeSkinSelectionW + widthOffset
			local activeSkinSelectionY = wepPanelY + wepLbl:GetTall() + (wepPanelSize-wepLbl:GetTall())/2 - activeSkinSelectionH/2
							
			activeSkinSelection = vgui.Create(activeSkinSelectionPanelType,self)
			activeSkinSelection.class = class
			activeSkinSelection:SetPos(activeSkinSelectionX,activeSkinSelectionY)
			activeSkinSelection:SetSize(activeSkinSelectionW, activeSkinSelectionH)
			
			if activeSkinSelectionPanelType == "DScrollPanel" then
				CL_EASYSKINS.SkinScrollPanel(activeSkinSelection)
			end
			
			local triangle, lastIconXOffset = {}, 0
			
			if isNotLastRow then
				lastIconXOffset = triangleSize
				triangle = CL_EASYSKINS.ConstructLeftArrowPoly(triangleSize,activeSkinSelectionH/2,triangleSize)
			else
				triangle = CL_EASYSKINS.ConstructRightArrowPoly(activeSkinSelectionW-triangleSize,activeSkinSelectionH/2,triangleSize)
			end
			
			activeSkinSelection.Paint = function(self, w, h)
				
				surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
				
				-- triangle
				draw.NoTexture()
				surface.DrawPoly(triangle)
			
				-- selection bg
				if lastIconXOffset == 0 then				
					surface.DrawRect(0,0,w-triangleSize,h)
				else
					surface.DrawRect(triangleSize,0,w,h)
				end
				
			end
			
			local skinIconBtns = {}
			local lastIconX, lastIconY = lastIconXOffset+2,2
			
			-- add skins to the selection panel
			for i=1, #purchasedSkins do
				
				local purchasedSkin = purchasedSkins[i]
				local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
				local materialLbl
				
				-- if the skin was removed ( should not happen )
				if !skin or table.IsEmpty(skin.material) then
					
					skin = {}
					skin.skinID = -1
					skin.dispName = "{Removed}"
					skin.disabled = true
					skin.material = {}
					skin.material.path = "debug/debugempty"
				
				end
			
				skinIconBtns[i], materialLbl = CL_EASYSKINS.CreateMaterialIcon(lastIconX, lastIconY, skinIconSize, '', skin.material.path, activeSkinSelection, function()
					
					-- skin was removed
					if skin.disabled then return end
					
					-- play sound
					CL_EASYSKINS.PlaySound("equip")
					
					-- toggle skin status
					CL_EASYSKINS.SetPurchasedSkinEnabled(purchasedSkin,!purchasedSkin.enabled)
					
					-- update preview
					if purchasedSkin.enabled then
						enabledSkin = skin
					else
						enabledSkin = nil
					end
					
					-- close skin selection
					activeSkinSelection:Remove()
					activeSkinSelection = nil
					
				end)
				
				-- remove label
				materialLbl:Remove()
				
				local __oldPaint = skinIconBtns[i].Paint
				skinIconBtns[i].Paint = function(self, w, h)
				
					__oldPaint(self,w,h)
					
					-- draw border on enabled skin
					if purchasedSkin.enabled then
						
						for i=0,1 do
							surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
							surface.DrawOutlinedRect(i,i,w-i*2,h-i*2)
						end
						
					end
					
				end
				
				skinIconBtns[i].DoRightClick = function()
				
					local function OptionGift()
					
						local giftSkinPnl = vgui.Create("p_easyskins_gift_skin")
						giftSkinPnl:Init(true,skin,class)
						giftSkinPnl.CloseGiftSkinPnl = function(realSelf)
							
							-- if skin was enabled update preview
							if purchasedSkin.enabled then
								enabledSkin = nil
							end
							
							-- close skin selection
							activeSkinSelection:Remove()
							activeSkinSelection = nil
							
							-- remove the gift panel
							realSelf:Close()
							
						end
						
					end
					
					local function OptionSell()
					
						-- skin was removed
						if skin.disabled then return end
						
						local sellPrice = SH_EASYSKINS.GetSellPrice(ply,skin)
						sellPrice = SH_EASYSKINS.FormatMoney(sellPrice)
						
						local sellMsg = string.format(CL_EASYSKINS.Translate("sellSkin"), skin.dispName, sellPrice)
						local confirmation =  vgui.Create("p_easyskins_confirmation")
						confirmation:Init(true, sellMsg, function()
							
							-- if skin was enabled update preview
							if purchasedSkin.enabled then
								enabledSkin = nil
							end
							
							-- play sound
							CL_EASYSKINS.PlaySound("sell")
							
							-- sell skin
							CL_EASYSKINS.SellSkin(skin.id,class)
							
							-- close skin selection
							activeSkinSelection:Remove()
							activeSkinSelection = nil
							
						end)
						
					end
					
					local dMenu = DermaMenu(skinIconBtns)
					
					if SH_EASYSKINS.SETTINGS.ALLOWSKINGIFTING then
						CL_EASYSKINS.AddDMenuOption(dMenu,CL_EASYSKINS.Translate("gift"), OptionGift)
					end
					
					CL_EASYSKINS.AddDMenuOption(dMenu,CL_EASYSKINS.Translate("sell"), OptionSell)
					
					dMenu:Open()
					
				end
				
				if i%3 == 0 then
					lastIconX = lastIconXOffset + 2
					lastIconY = lastIconY + skinIconSize + 2
				else
					lastIconX = lastIconX + skinIconSize + 2
				end
				
			end

		end
		
	end

	-- create weapon panels
	for i=1,#purchasedSkins do
		
		local purchasedSkin = purchasedSkins[i]
		local wepInfo = SH_EASYSKINS.GetWeaponInfo(purchasedSkin.weaponClass)
		
		-- weapon was removed from server
		if wepInfo == nil then continue end

		local name  = wepInfo.name
		
		-- checks for duplicate name
		if SH_EASYSKINS.IsDuplicateWeaponName(name) then
			name = name .." ("..wepInfo.class..")"
		end
		
		-- create the wep pnl if it didn't exist before
		if wepPanels[name] == nil then
			CreateWepPnl(purchasedSkin.weaponClass,name)
		end
		
	end
	
	-- empty lbl
	if #purchasedSkins == 0 then
		local emptyLbl = CL_EASYSKINS.CreateLbl(0, pTall/2-15, CL_EASYSKINS.Translate("emptyInventory"), "z_easyskins_cat_title", SH_EASYSKINS.COL.LIGHTGREY, self, false)
		CL_EASYSKINS.CenterInElement(emptyLbl, self)
	end
	
end
vgui.Register('p_easyskins_inventory',PANEL,'DScrollPanel')