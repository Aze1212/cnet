-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local lastOpenedCat = SH_EASYSKINS.VAR.UNCATEGORIZED

function PANEL:Init(realInit)

	if !realInit then return end
	
	self:SetDrawBackground(false)
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local ply = LocalPlayer()
	local categories = SH_EASYSKINS.GetCategories()
	local skins = SH_EASYSKINS.GetSkins()
	
	local catPanels = {}
	local prevCatPnl = nil
	local lastCatOpened = false
	
	local catW,catH = self:GetWide()-10,35
	
	-- weapon selection edit btn (global)
	local weaponSelectionEditBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("weaponSelection"),color_white,self,function()
		
		-- open weapon selection panel
		local openWeaponMethodsPnl = vgui.Create("p_easyskins_admin_weapon_list")
		openWeaponMethodsPnl:Init(true)
		openWeaponMethodsPnl.CloseAddWeapons = function( realSelf, chosenItems )
			
			-- loading indication
			local loadingOverlay = vgui.Create("p_easyskins_loading",self)
			loadingOverlay:Init(true,5,35,catW,self:GetTall()-35, nil, SH_EASYSKINS.COL.LIGHTBLACK_200)
			loadingOverlay:SetZPos(2)
			
			-- update skins
			for i=1, #skins do
				
				local skin = skins[i]
				
				-- change clientside
				skin.weaponTbl = chosenItems
				
				-- update on server
				timer.Simple(0.1*i, function()
					CL_EASYSKINS.UpdateSkin(skin)
				end)
				
			end
			
			-- close
			realSelf:Close()
			
			-- close loadingOverlay
			timer.Simple(#skins*0.1,function()
				
				if IsValid(self,self:GetParent()) then
				
					-- refresh category
					self:GetParent():RefreshCategory()
				
				end
				
			end)
			
		end
	
	end)
	weaponSelectionEditBtn.BGCol = SH_EASYSKINS.COL.BLUE
	weaponSelectionEditBtn.BGAlpha = 255
	weaponSelectionEditBtn.UseHoverCol = false
	weaponSelectionEditBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	weaponSelectionEditBtn:SetSize(catW,28)
	weaponSelectionEditBtn:SetPos(5,1)
	
	local prevCatY = weaponSelectionEditBtn:GetBottomY()+5
	
	local function CreateCatPnl(cat)
		
		local removeIconSize = catH/2
		local skinIconSize = 64
		local maxExpandedH = 540
		local expandedH = maxExpandedH
		local isExpanded = false
		local prevCatPnlRef = prevCatPnl
		local OpenSkinList = nil
	
		local catPanel = vgui.Create("DPanel",self)
		catPanel:SetPos(5,prevCatY)
		catPanel:SetSize(catW,catH)
		catPanel:SetDrawBackground(false)
		catPanel.skins = {}
		catPanel.Think = function(self)
			if prevCatPnlRef ~= nil then
				self:SetPos(5,2+prevCatPnlRef:GetBottomY())
			end
		end
		
		-- for external referencing
		catPanels[cat.name] = catPanel
		prevCatPnl = catPanel
		prevCatY = prevCatY + catH + 2
		
		local titleBtn = vgui.Create ("DButton",catPanel)
		titleBtn:SetPos(0,0)
		titleBtn:SetFont("z_easyskins_cat_title")
		titleBtn:SetSize(catW,catH)
		titleBtn:SetTextColor(color_white)
		titleBtn.Paint = function(self, w, h)
			surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY_150)
			surface.DrawRect(0,0,w,h)
		end
		titleBtn.Think = function()
			titleBtn:SetText(cat.name.." ("..#catPanel.skins..")")
			
			-- open the uncategorized when panel is initialized
			if !lastCatOpened and lastOpenedCat == cat.name and #catPanel.skins > 0 then
				lastCatOpened = true
				titleBtn:DoClick()
			end 
			
		end
		titleBtn.DoClick = function()
		
			isExpanded = !isExpanded
			local newH = catH
			if isExpanded then
				
				local skinAmount = #catPanel.skins
				local skinRows = math.ceil(skinAmount/9)
				
				-- calc height based on the amount of skins
				if skinRows < 5 then
					newH = catH+((skinIconSize+20)*skinRows)
				else
					newH = maxExpandedH
				end
				
			end
			
			-- resize panel
			catPanel:SizeTo( catW, newH, 0.25 )
			
			-- create skin icons
			OpenSkinList()
			
			-- mark as last opened
			lastOpenedCat = cat.name
			
		end
		
		if SH_EASYSKINS.CanRemoveCategory(cat) then
			
			local removeBtn = vgui.Create ("DImageButton",catPanel)
			removeBtn:SetPos(catW-removeIconSize-5,catH/2-removeIconSize/2)
			removeBtn:SetSize(removeIconSize,removeIconSize)
			removeBtn:SetImage("z_easyskins/vgui/cross_remove.vmt")
			
			local rmMsg = string.format(CL_EASYSKINS.Translate("removeCat"), cat.name)
			removeBtn.DoClick = function()
					
				local confirmation =  vgui.Create("p_easyskins_confirmation")
				confirmation:Init(true, rmMsg, function()
				
					if catPanel.skins == nil then
						catPanel.skins = {}
					end
					
					-- loop skins and reset category for each skin
					for i=1,#catPanel.skins do
					
						local skin = catPanel.skins[i]
						skin.category = { id = 1, name = SH_EASYSKINS.VAR.UNCATEGORIZED }
						
						-- update on server
						CL_EASYSKINS.UpdateSkin(skin)
						
					end
					
					-- remove category
					CL_EASYSKINS.RemoveCategory(cat.id)
					
					-- reset last opened cat
					lastOpenedCat = SH_EASYSKINS.VAR.UNCATEGORIZED
					
					-- refresh category
					self:GetParent():RefreshCategory()
					
				end)

			end
			
		end
		
		-- panel containing the material icon btns
		local skinPanel = vgui.Create("DScrollPanel",catPanel)
		skinPanel:SetSize(catW, expandedH-catH)
		skinPanel:SetPos(0, catH)
		skinPanel.hasSkins = false
		skinPanel.Paint = function(self,w,h)
			surface.SetDrawColor(SH_EASYSKINS.COL.LIGHTBLACK_150)
			surface.DrawRect(0, 0, w, h)
		end
		CL_EASYSKINS.SkinScrollPanel(skinPanel)
		local vBar = skinPanel:GetVBar()
		vBar:SetWide(1)
		
		-- adds icons to the skin panel
		function OpenSkinList()

			if !skinPanel.hasSkins then
			
				local lastX, lastY = 2,2
				
				for i=1,#catPanel.skins do
					local skin = catPanel.skins[i]

					local skinIconBtn = CL_EASYSKINS.CreateMaterialIcon(lastX, lastY, skinIconSize, skin.dispName, skin.material.path, skinPanel, function()
						
						local skinEditPnl = vgui.Create("p_easyskins_admin_skin_edit")
						skinEditPnl.UpdateManagePnl = function()
							-- refresh category
							self:GetParent():RefreshCategory()
						end
						skinEditPnl:Init(true, skin)
						
					end)
					
					skinIconBtn.DoRightClick = function()
					
						local rmMsg = string.format(CL_EASYSKINS.Translate("removeSkin"), skin.dispName)
						local confirmation = vgui.Create("p_easyskins_confirmation")
						confirmation:Init(true, rmMsg, function()

							-- remove skin
							CL_EASYSKINS.RemoveSkin(skin,function()
							
								-- reset last opened cat if there was only 1 skin in the category
								if #catPanel.skins == 1 then
									lastOpenedCat = SH_EASYSKINS.VAR.UNCATEGORIZED
								end

								-- refresh category
								self:GetParent():RefreshCategory()
							
							end)

						end)

					end
					
					lastX = lastX + skinIconSize + 5
					
					if i%9 == 0 then
						lastX = 2
						lastY = lastY + skinIconSize + 20
					end
					
				end
				
				skinPanel.hasSkins = true
	
			end
			
		end
	
	end
	
	-- create all the categories
	CreateCatPnl({ id = 1, name = SH_EASYSKINS.VAR.UNCATEGORIZED})
	for i=1, #categories do
		CreateCatPnl(categories[i])
	end
	
	-- fill categories with skins
	for k, skin in pairs(skins) do
	
		if catPanels[skin.category.name] ~= nil then
			local skinPnlTbl = catPanels[skin.category.name].skins
			table.insert(skinPnlTbl,skin)
		end
		
	end
	
end
vgui.Register('p_easyskins_admin_manage',PANEL,'DScrollPanel')
