-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

function CL_EASYSKINS.CreateLbl(x, y, txt, font, col, parent, hasBG)
	
	local lbl = vgui.Create( "DLabel", parent )
	lbl:SetFont(font)
	lbl:SetContentAlignment( 5 )
	lbl:SetTextColor(col)
	lbl:SetText(txt)
	lbl.UpdateSize = function(self)
		self:SetSize(self:GetContentSize()+10)
		self:SizeToContentsY()
		self:SetPos(x,y)
	end
	lbl:UpdateSize()
	
	if hasBG then
		lbl.Paint = function(self,w,h)
			surface.SetDrawColor(SH_EASYSKINS.COL.GREY_150)
			surface.DrawRect(0,0,w,h)
		end
	end
	
	return lbl
	
end

function CL_EASYSKINS.CreateNumInput(x, y, w, h, defaultVal, font, col, parent)
	
	local numInput = vgui.Create( "DNumberWang", parent ) 
	numInput:SetPos(x, y)
	numInput:SetSize(w, h)
	numInput:SetFont(font)
	numInput:SetTextColor(col)
	numInput:SetDecimals( 0 )
	numInput:SetMinMax( 0, SH_EASYSKINS.VAR.MAXPRICE )
	numInput:SetValue(defaultVal)
	numInput:SetDrawBackground(false)
	numInput.m_colCursor = col
	
	local __oldOnChange = numInput.OnChange
	numInput.OnChange = function(self)
		if self:GetValue() > self:GetMax() then
			self:SetTextColor(SH_EASYSKINS.COL.RED)
		else 
			self:SetTextColor(color_white)
		end
		
		__oldOnChange(self)
	end
	
	local __oldPaint = numInput.Paint
	numInput.Paint = function(self, w, h)
		-- draw background
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY_150)
		surface.DrawRect(0,0,w,h)
		
		-- draw numbers and wangs from base method
		__oldPaint(self,w,h)
	end
	
	return numInput
	
end

function CL_EASYSKINS.CreateTextInput(x, y, w, h, defaultVal, font, col, parent)

	local textInput = vgui.Create( "DTextEntry", parent )
	textInput:SetPos( x, y )
	textInput:SetSize( w, h )
	textInput:SetFont( font )
	textInput:SetTextColor(col)
	textInput:SetText( defaultVal )
	textInput:SetDrawBackground(false)
	textInput.m_colCursor = col
	textInput.m_colPlaceholder = col
	textInput.bgCol = SH_EASYSKINS.COL.GREY_150
	
	local oldPaint = textInput.Paint
	textInput.Paint = function(self, w, h)
	
		-- background
		surface.SetDrawColor(self.bgCol)
		surface.DrawRect(0,0,w,h)
		
		-- input box
		oldPaint(self,w,h)
		
	end
	
	return textInput
	
end

function CL_EASYSKINS.CreateCheckBox(x, y, text, font, col, parent, hasBG)

	hasBG = hasBG == nil and true or hasBG

	local checkBox = vgui.Create("DCheckBoxLabel", parent)
	checkBox:SetPos(x,y)
	checkBox:SetFont(font)
	checkBox:SetText(text)
	checkBox:SetTextColor(col)
	
	-- block func from restoring old pos
	checkBox.PerformLayout = function() end
	
	-- position lbl first
	checkBox.Label:SetPos( 5, 0 )
	
	-- fix checkbox btn pos
	local _,btnY = checkBox.Button:GetPos()
	local btnSize = checkBox:GetTall()*0.8
	checkBox.Button:SetSize(btnSize,btnSize)
	checkBox.Button:SetPos( checkBox.Label:GetWide(), btnY )
	
	checkBox.Paint = function(self, w, h)
		
		if hasBG then
			surface.SetDrawColor(SH_EASYSKINS.COL.GREY_150)
			surface.DrawRect(0,0,w,h)	
		end
		
	end
	
	return checkBox
	
end

function CL_EASYSKINS.CreateComboBox(x, y, w, h, defaultVal, selectedVal, options, extraOptions, font, col, parent)
	
	local comboBox = vgui.Create( "DComboBox", parent )
	comboBox:SetPos( x, y )
	comboBox:SetSize( w, h )
	comboBox:SetTextColor(col)
	comboBox:SetFont(font)
	comboBox:SetValue(selectedVal)
	comboBox:SetSortItems( false )
	
	local choices = {}
	local function InitChoices()
		choices = table.Copy(options)
		table.insert(choices,1,defaultVal)
		table.Add(choices,extraOptions)
	end
	
	local function RefreshOptions()
		
		local selectedOption = comboBox:GetValue() || selectedVal
		comboBox:Clear()
		comboBox:SetValue(selectedOption)
		
		for _, option in SortedPairs(choices) do
			
			local val, func
			if istable(option) then
				if isfunction(option[2]) then
					val, func = option[1],option[2]
				elseif option.name ~= nil then
					val = option.name
				end
			else
				val = option
			end
			
			if selectedOption ~= val or val == defaultVal then
				comboBox:AddChoice(val,func)
			end
			
		end
		
	end
	RefreshOptions()
	
	comboBox.OnSelect = function( self, index, value, func )
		
		if func ~= nil then
			self:SetValue(selectedVal)
			func()
		end
		
		RefreshOptions()
		
	end
	
	comboBox.Paint = function(self, w, h)
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY_150)
		surface.DrawRect(0,0,w,h)
	end
	
	-- make sure we always have the latest version of the options
	comboBox.Think = function(self)
		if #choices < #options+#extraOptions+1 then
			InitChoices()
			RefreshOptions()
		end
	end
	
	local oldOpenMenu = comboBox.OpenMenu
	comboBox.OpenMenu = function( self, pControlOpener )
	
		-- create & open menu
		oldOpenMenu(self,pControlOpener)
		
		-- style menu
		if self.Menu ~= nil then
		
			-- restyle the background
			self.Menu.Paint = function(self, w, h)
				surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(color_white)
				surface.DrawOutlinedRect(0,0,w,h)
			end
			
			local basePanel = self.Menu:GetChildren()[1]
			local menuOptionPanels = self.Menu:GetChildren()
			
			for _, child in pairs(menuOptionPanels) do
			
				if child:GetClassName() == "Panel" then
				
					for _, subChild in pairs(child:GetChildren()) do
						
						local class = subChild:GetClassName()
						
						-- change the text color of the label
						if class == "Label" then
							subChild:SetTextColor(color_white)
						end
						
					end
					
				end
				
			end
		end
	end

	return comboBox
	
end

function CL_EASYSKINS.CreateMaterialButton(str,btnTxtCol,parent,doClickFunc)
	
	local mouseIsIn = false
	
	local materialBtn = vgui.Create("DButton",parent)
	materialBtn:SetPos(0,0)
	materialBtn:SetFont("z_easyskins_menu_cat_sub_btn")
	materialBtn:SetText(str)
	materialBtn:SetSize(110,27)
	materialBtn:SetTextColor(btnTxtCol)
	materialBtn.BGAlpha = 150
	materialBtn.BGCol = SH_EASYSKINS.COL.GREY
	materialBtn.UseHoverCol = false
	materialBtn.ChangeFont = function(self,font)
	
		surface.SetFont( font )
		local fontW,fontH = surface.GetTextSize(self:GetText())
		
		self:SetFont(font)
		self:SetSize(math.max(110,fontW+10),fontH+7)
		
	end
	
	materialBtn.Paint = function(self,w,h)
		
		-- bg
		surface.SetDrawColor(self.BGCol.r, self.BGCol.g, self.BGCol.b, self.BGAlpha)
		surface.DrawRect(0,0,w,h)
		
		if !self:IsEnabled() then return end
		
		-- when selected
		if self == selectedBtn then
		
			materialBtn:SetTextColor(SH_EASYSKINS.COL.GREEN)
			
			surface.SetDrawColor(SH_EASYSKINS.COL.GREEN)
			surface.DrawOutlinedRect(0,0,w,h)
			
		elseif !mouseIsIn then
			materialBtn:SetTextColor(btnTxtCol)
		end
		
	end
	
	materialBtn.DoClick = doClickFunc
	
	materialBtn.OnCursorEntered = function(self)
		if self.UseHoverCol then
			mouseIsIn = true
			materialBtn:SetTextColor(SH_EASYSKINS.COL.GREEN)
		end
	end
	
	materialBtn.OnCursorExited = function(self)
		if self.UseHoverCol then
			mouseIsIn = false
		end
	end
	
	return materialBtn
	
end

function CL_EASYSKINS.CreateMaterialIcon( x, y, size, iconTxt, iconImg, parent, doClickFunc, center )
	
	local imgElement = doClickFunc ~= nil and "DImageButton" or "DImage"

	local materialImgBtn = vgui.Create( imgElement, parent )
	materialImgBtn:SetSize( size, size )
	materialImgBtn:SetPos( x, y )
	
	local function SetIcon(icon)
			
		if icon == nil or #icon == 0 then return end
		
		-- replace path for materials with a custom icon path
		if SH_EASYSKINS.EXTRAMATERIALS[icon] ~= nil then
			icon = SH_EASYSKINS.EXTRAMATERIALS[icon].icon
		end

		-- non default materials can use their ingame icons
		if SH_EASYSKINS.EXTRADEFAULTMATERIALS[icon] or !string.StartWith(icon,"z_easyskins") then
		
			materialImgBtn:SetImage(icon)
			
			-- DImage doesn't show image when overriding paint func
			if imgElement == "DImage" then return end
			
			-- some bug with materials always visible even when behind another panel
			materialImgBtn.Paint = function(self)
				
				if CL_EASYSKINS.ShopPreviewIsOpen() then
					-- change the material to one that doesn't clip
					self:SetImage("brick/brick_model")
					
				else
					if self:GetImage() ~= icon then
						self:SetImage(icon)
					end
				end

			end
			
			return
		end
		
		local iconIsAnimated = SH_EASYSKINS.IsMaterialAnimated(icon)
		local unlitMat
		
		if iconIsAnimated then
			unlitMat = CL_EASYSKINS.AnimatedVMTToUnlitGeneric(icon)
		else
			unlitMat = CL_EASYSKINS.VMTToUnlitGeneric(icon)
		end
		
		materialImgBtn.Paint = function(self, w, h)	
			surface.SetDrawColor( color_white )
			surface.SetMaterial( unlitMat )
			surface.DrawTexturedRect( 0, 0, w, h )
		end
		
	end
	
	-- expose for external icon changing
	materialImgBtn.SetIcon = function(self, icon)
		
		if !string.StartWith( icon, "z_easyskins/vgui" ) then
			SetIcon(icon)
		else
			materialImgBtn:SetImage(icon)
		end
		
	end
	
	if iconImg ~= nil then
		materialImgBtn:SetIcon(iconImg)
	end
	
	if doClickFunc ~= nil then
		materialImgBtn.DoClick = doClickFunc
	end
	
	local materialLbl = vgui.Create( "DLabel", parent )
	materialLbl:SetFont("z_easyskins_material_lbl")
	materialLbl:SetText(iconTxt or "")
	materialLbl:SetTextColor(color_white)
	materialLbl:SetSize(size,0)
	
	local oldSetColor = materialImgBtn.SetColor
	materialImgBtn.SetColor = function(self,col)
		oldSetColor(self,col)
		materialLbl:SetTextColor(col)
	end
	
	local function autoSizeLabel()
	
		local materialLblX = x
		if (doClickFunc ~= nil and !center) or (doClickFunc == nil and !center) then
			materialLbl:SizeToContentsY()
		else
			materialLbl:SizeToContents()
			materialLblX = x + size/2 - materialLbl:GetWide()/2
		end
		
		materialLbl:SetPos(materialLblX, y+materialImgBtn:GetTall())
	end
	autoSizeLabel()

	materialImgBtn.DoRemove = function(self)
		materialLbl:Remove()
		self:Remove()
	end
	
	materialImgBtn.UpdateMaterial = function(self, material)
		materialImgBtn:SetImage( material.path )
		materialLbl:SetText( material.name )
		autoSizeLabel()
	end
	
	-- for external referencing
	materialImgBtn.materialLbl = materialLbl
	
	return materialImgBtn, materialLbl

end

function CL_EASYSKINS.CreateWeaponModelPnl(x,y,size,model,isViewModel,parent,canDrag,center)

	-- model panel
	local modelPnl = vgui.Create( "DModelPanel", parent )
	modelPnl:SetSize( size, size )
	modelPnl:SetPos( x, y )
	modelPnl:NoClipping(false)
	
	-- label under panel
	local modelLbl = vgui.Create( "DLabel", parent )
	modelLbl:SetFont("z_easyskins_material_lbl")
	modelLbl:SetContentAlignment( 5 )
	modelLbl:SetTextColor(color_white)
	
	/* debug
	local RenderSpawnzoneMat = Material("editor/wireframe")
	modelPnl.PostDrawModel = function( self, ent )
		
		if ent then
			
			local pos = self.Entity:GetPos()
			local ang = self.Entity:GetAngles()
			local mn, mx = self.Entity:GetRenderBounds()
	
			render.SetMaterial(RenderSpawnzoneMat)
			render.DrawBox( pos, ang, mn, mx )
		
		end
		
		-- draw axis
		render.DrawLine( Vector(0,0,0), Vector(1000,0,0), SH_EASYSKINS.COL.RED )
		render.DrawLine( Vector(0,0,0), Vector(0,1000,0), SH_EASYSKINS.COL.GREEN )
		render.DrawLine( Vector(0,0,0), Vector(0,0,1000), SH_EASYSKINS.COL.BLUE )
		
	end
	*/
	
	-- future
	-- old wiki: https://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/indexd0aa.html
	-- halo stencils: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/modules/halo.lua
	-- stencil tut: https://github.com/Lexicality/stencil-tutorial/tree/master/lua/stencil_tutorial
	
	modelPnl.UpdateModel = function(self, model)
		
		if #model > 0 then
		
			-- update mdl pnl
			modelPnl:SetModel( model )
			modelPnl.Entity:SetModelScale( 2 )
			modelPnl:SetDirectionalLight( BOX_TOP, color_white )
			modelPnl:SetDirectionalLight( BOX_FRONT, color_white )
			
			-- debug
			-- mn, mx = modelPnl.Entity:GetRenderBounds()
			-- modelLbl:SetText(math.Round(mn.x)..","..math.Round(mn.y)..","..math.Round(mn.z).." <==> "..math.Round(mx.x)..","..math.Round(mx.y)..","..math.Round(mx.z))
			
			-- update lbl
			modelLbl:SetText(isViewModel and CL_EASYSKINS.Translate("viewmodel") or CL_EASYSKINS.Translate("worldmodel"))
			modelLbl:SetSize( modelLbl:GetContentSize()+10 )
			modelLbl:SizeToContentsY()
			modelLbl:SetPos( x+size/2-modelLbl:GetWide()/2, y+size-modelLbl:GetTall()*2)
			
			-- thank you gmod wiki :)
			local mn, mx = modelPnl.Entity:GetRenderBounds()
			local modelSize = 0
			modelSize = math.max( modelSize, math.abs( mn.x ) + math.abs( mx.x ) )
			modelSize = math.max( modelSize, math.abs( mn.y ) + math.abs( mx.y ) )
			modelSize = math.max( modelSize, math.abs( mn.z ) + math.abs( mx.z ) )
			
			
			if center then
			
				modelPnl:SetCamPos((mn:Distance(mx) * Vector(1, 1, 0)))
				modelPnl:SetLookAt((( mn + mx ) / 2 ))
				
				local lookAng = ((modelPnl:GetLookAt()-modelPnl:GetCamPos())):Angle()
				modelPnl:SetLookAng( lookAng )
		
			else
				
				modelPnl:SetFOV( 45 )
				modelPnl:SetCamPos( Vector( modelSize, modelSize, modelSize ) )
				modelPnl:SetLookAt( ( mn + mx ) * 0.5 )
				
			end
			
			if isViewModel and canDrag then
				modelPnl.Entity:SetPos(Vector(modelSize/4,modelSize/4,0))
			end
			
		else
			modelPnl:SetModel("")
			modelLbl:SetText("")
		end 
		
	end
	
	modelPnl:UpdateModel(model)
	
	modelPnl.DragMousePress = function(self)
		self.mouseX, self.mouseY = gui.MousePos()
		self.pressed = true 
	end 
		
	modelPnl.DragMouseRelease = function (self)
		self.pressed = false 
	end
	
	if canDrag then
		modelPnl.OnMouseWheeled = function(self, scrollDelta)
			
			scrollDelta = -scrollDelta/2
			
			local modelScale = self.Entity:GetModelScale()
			self.Entity:SetModelScale( math.max(modelScale+scrollDelta,1), 0 )
			
		end
	end
	
	-- disables default rotation
	modelPnl.angles = Angle( 0, 0, 0 )
	modelPnl.LayoutEntity = function(self, ent)
		
		if canDrag and self.pressed then
			-- manual rotation
			local mx, my = gui.MousePos()
			self.angles = self.angles - Angle( ( self.mouseY or my ) - my, ( self.mouseX or mx ) - mx, 0 )
			self.mouseX, self.mouseY = gui.MousePos()
			
			ent:SetAngles( self.angles )
				
		end
		
	end
	
	return modelPnl, modelLbl
	
end

function CL_EASYSKINS.CreateWeaponMaterialList(x,y,w,h,materials,parent)
	
	local wepMatListView = vgui.Create( "DListView", parent )
	wepMatListView:SetPos(x,y)
	wepMatListView:SetSize(w,h)
	wepMatListView:SetMultiSelect( true )
	wepMatListView:SetHideHeaders( true )
	wepMatListView:AddColumn( CL_EASYSKINS.Translate("name") )
	wepMatListView.GetVBar = function(self)
		return self.VBar
	end
	
	-- override default behaviour
	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/vgui/dlistview.lua
	wepMatListView.lastClick = 0
	wepMatListView.OnClickLine = function( self, Line, bClear )
			
		if self.lastClick > CurTime() then return end
			
		self.lastClick = CurTime() + 0.1
	
		self:OnRowSelected( Line:GetID(), Line )
		
	end
	
	wepMatListView.UpdateMaterials = function( self, materials )
		
		self:Clear()
		
		-- fill weapon list
		for index,name in pairs(materials) do
			
			name = SH_EASYSKINS.GetNameFromMat(name)
			
			self:AddLine( name )
			
			-- mark line as default blacklisted
			local rowPnl = self:GetLine(index) 
			local isDefaultBlacklisted = SH_EASYSKINS.IsDefaultBlacklistMat(name)
	
			if SH_EASYSKINS.IsBlackListMat(name) or isDefaultBlacklisted then
				
				self:MarkDefaultPart(index,rowPnl)
			
				if isDefaultBlacklisted then
				
					rowPnl.isDefaultBlacklisted = true
					
					-- give default blacklisted lines a custom color
					rowPnl.Paint = function(self,w,h)
						surface.SetDrawColor(SH_EASYSKINS.COL.LIGHTBLACK_150)
						surface.DrawRect(0,0,w,h)
					end
				end
				
			end
			
		end
		
	end
	
	wepMatListView:UpdateMaterials(materials)

	return wepMatListView

end

function CL_EASYSKINS.CreateAccessLists(x,y,shSettingsKey,inListTitle,inListCol,outListTitle,outListCol,parent)

	local parentW,parentH = parent:GetSize()
	local listViewWidth = parentW*0.49
	local columnWidth = 115
	local FillLists
	local SortByColumn
	
	-- in list lbl
	local inListLbl = CL_EASYSKINS.CreateLbl(x, y, inListTitle, "z_easyskins_material_lbl", inListCol, parent, true)
	inListLbl:SetWide(listViewWidth-1)
	local inListLblY = inListLbl:GetBottomY()

	-- in list
	local inListView = vgui.Create( "DListView", parent )
	inListView:SetPos(x,inListLblY)
	inListView:SetSize(listViewWidth,parentH*0.4)
	inListView:SetMultiSelect( false )
	inListView:AddColumn( "ID" ):SetMaxWidth(columnWidth)
	inListView:AddColumn( "Team|Name|Group" )
	inListView.SortByColumn = function() end
	inListView.OnRowSelected = function( lst, index, pnl )
	
		local id = pnl:GetColumnText(1)
		local inListTbl = SH_EASYSKINS.SETTINGS[shSettingsKey]
		local _, index = SH_EASYSKINS.IsInTable(inListTbl, id)
		
		table.remove(inListTbl,index)
		
		-- update lists
		FillLists()
		
		-- save settings
		CL_EASYSKINS.SaveSettings()
		
	end
	
	-- out list lbl
	local outListLbl = CL_EASYSKINS.CreateLbl(inListView:GetWide() + x + 1, y, outListTitle, "z_easyskins_material_lbl", outListCol, parent, true)
	outListLbl:SetWide(listViewWidth-1)
	local outListLblY = outListLbl:GetBottomY()
	
	-- out list
	local outListView = vgui.Create( "DListView", parent )
	outListView:SetPos(inListView:GetWide() + x + 1,outListLblY)
	outListView:SetSize(inListView:GetSize())
	outListView:SetMultiSelect( false )
	outListView:AddColumn( "ID" ):SetMaxWidth(columnWidth)
	outListView:AddColumn( "Team|Name|Group" )
	outListView.SortByColumn = function() end
	outListView.OnRowSelected = function( lst, index, pnl )
	
		local id, name = pnl:GetColumnText(1), pnl:GetColumnText(2)
		local inListTbl = SH_EASYSKINS.SETTINGS[shSettingsKey]
		
		table.insert( inListTbl, { id, name })
		
		-- update lists
		FillLists()
	
		-- save settings
		CL_EASYSKINS.SaveSettings()
		
	end

	-- find all users/teams/groups and add to the outListView
	function FillLists()
	
		inListView:Clear()
		outListView:Clear()
		
		local playersAndGroups = SH_EASYSKINS.GetAllPlayersAndGroups()
		local inListTbl = SH_EASYSKINS.SETTINGS[shSettingsKey]
		
		-- inListView
		for i=1, #inListTbl do
			inListView:AddLine(inListTbl[i][1],inListTbl[i][2])
		end
		
		-- outListView
		for i=1, #playersAndGroups do
		
			local id, name = playersAndGroups[i][1], playersAndGroups[i][2]
			
			if SH_EASYSKINS.VAR.ADMINMODS[id] ~= nil then
				if !SH_EASYSKINS.IsInTable(inListTbl, name) then
					outListView:AddLine(id,name)
				end
				continue
			end
			
			if !SH_EASYSKINS.IsInTable(inListTbl, id) then
				outListView:AddLine(id,name)
			end
			
		end
		
	end
	
	-- skin listview
	CL_EASYSKINS.SkinListView(inListView)
	CL_EASYSKINS.SkinListView(outListView)
	
	-- fill lists
	FillLists()
	
	return inListView, outListView

end

function CL_EASYSKINS.CreateVectorListView(x,y,shSettingsKey,parent)

	local parentW,parentH = parent:GetSize()
	local FillVectorList

	local vectorListView = vgui.Create( "DListView", parent )
	vectorListView:SetPos(x,y)
	vectorListView:SetSize(parentW*0.5,parentH*0.2)
	vectorListView:SetMultiSelect( false )
	vectorListView:AddColumn( "Name" )
	vectorListView:AddColumn( "Vector" )
	vectorListView.OnRowSelected = function( lst, index, pnl )
		
		local name = pnl:GetColumnText(1)
		local rmMsg = string.format(CL_EASYSKINS.Translate("removePosition"),name)
		local confirmation =  vgui.Create("p_easyskins_confirmation")
		confirmation:Init(true, rmMsg, function()
			
			local vectorTbl = SH_EASYSKINS.SETTINGS[shSettingsKey][SH_EASYSKINS.VAR.MAP]
			
			-- remove from table
			table.remove(vectorTbl,index)
			
			-- refresh vectorListView
			FillVectorList()
			
			-- save settings
			CL_EASYSKINS.SaveSettings()
			
			-- respawn npcs
			timer.Simple(2,function()
				net.Start("sv_easyskins_SpawnShopNpcs")
				net.SendToServer()
			end)
			
		end)
	
	end
	
	local addVectorBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("addCurrPosition"),color_white,parent,function()
		
		local nameInput = vgui.Create("p_easyskins_input_text") 
		nameInput:Init(true,CL_EASYSKINS.Translate("nameThePosition"),CL_EASYSKINS.Translate("name"),function(name)
			
			local ply = LocalPlayer()
			local pos = ply:GetPos()
			local ang = ply:GetAngles()
			
			if SH_EASYSKINS.SETTINGS[shSettingsKey][SH_EASYSKINS.VAR.MAP] == nil then
				SH_EASYSKINS.SETTINGS[shSettingsKey][SH_EASYSKINS.VAR.MAP] = {}
			end
			
			local vectorTbl = SH_EASYSKINS.SETTINGS[shSettingsKey][SH_EASYSKINS.VAR.MAP]
			
			-- add pos to table
			table.insert(vectorTbl,{
				name = name,
				pos = pos,
				ang = Angle(0,ang.y,ang.z)
			})
			
			-- refresh vectorListView
			FillVectorList()
			
			-- save settings
			CL_EASYSKINS.SaveSettings()
			
			-- respawn npcs
			timer.Simple(2,function()
				net.Start("sv_easyskins_SpawnShopNpcs")
				net.SendToServer()
			end)
			
		end)
		
	end)
	addVectorBtn.BGCol = SH_EASYSKINS.COL.BLUE
	addVectorBtn.UseHoverCol = false
	addVectorBtn:SetFont("z_easyskins_menu_cat_sub_btn_bold")
	addVectorBtn:SetSize(250,40)
	local addVectorBtnX = parentW/2 + parentW/4 - addVectorBtn:GetWide()/2
	local addVectorBtnY = y + vectorListView:GetTall()/2 - addVectorBtn:GetTall()/2
	addVectorBtn:SetPos(addVectorBtnX, addVectorBtnY)
	
	-- fill vectorListView with data
	function FillVectorList()
	
		vectorListView:Clear()
		
		local vectorTbl = SH_EASYSKINS.SETTINGS[shSettingsKey][SH_EASYSKINS.VAR.MAP] or {}
		
		-- inListView
		for i=1, #vectorTbl do
			vectorListView:AddLine(vectorTbl[i].name,vectorTbl[i].pos)
		end
		
	end
	
	-- skin list
	CL_EASYSKINS.SkinListView(vectorListView)
	
	-- fill list
	FillVectorList()
	
	return vectorListView
	
end

function CL_EASYSKINS.HookWepPanelFilter(searchInput,wepPanels)
	
	searchInput.OnChange = function(self)
		
		local filter = string.Trim( self:GetText():lower() ) 
		
		local prevWepPnl = nil
		
		-- filter content
		for class, wepPanel in SortedPairs(wepPanels) do
			
			-- show panel if there is no filter or the filter matches
			if #filter == 0 or string.find( wepPanel.wepInfo.name:lower(), filter, 1, true ) ~= nil then
			
				-- set filtered wepPanel to auto adjust position
				if prevWepPnl ~= nil then
					wepPanel.prevWepPnlRef = prevWepPnl
				else
					-- make sure the first filtered result is on the start position
					wepPanel.prevWepPnlRef = nil
					wepPanel:SetPos(5,searchInput:GetBottomY()+5)
				end
			
				wepPanel:SetVisible(true)
				
				prevWepPnl = wepPanel
				
				continue
			end
			
			wepPanel:Hide()
			
		end
		
	end
	
end

function CL_EASYSKINS.CenterInElement(panel, element)

	local _,y = panel:GetPos()
	panel:SetPos(element:GetWide()/2 - panel:GetWide()/2,y)
	
end

function CL_EASYSKINS.SkinScrollPanel(scrollP)
	
	local sbar = scrollP:GetVBar()
	local sbarCol = Color( 0, 0, 0, 100 )
	
	sbar:SetWide(4)
	sbar:SetHideButtons( true )
	
	function sbar:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, sbarCol )
	end
	
	function sbar.btnGrip:Paint( w, h )
		draw.RoundedBox( 0, 0, 0, w, h, color_white )
	end

end

function CL_EASYSKINS.AddDMenuOption(dMenu,str,func)
	
	local option = vgui.Create( "DMenuOption", self )
	option:SetMenu( dMenu )
	option:SetText( str )
	option:SetTextColor( color_white )
	option.DoClick = func
	
	local __oldPaint = option.Paint
	option.Paint = function(self, w, h)
		
		-- bg
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
		surface.DrawRect(0,0,w,h)
		
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,0,w,1)
		
		__oldPaint(self,w,h)
		
	end

	dMenu:AddPanel( option )
	
end

function CL_EASYSKINS.SkinListView(listView)
 
	-- skin scrollbar
	listView.GetVBar = function(self) 
		return self.VBar 
	end
	
	-- block default behaviour from overriding size
	local __OldSetSize = listView.VBar.SetSize
	listView.VBar.SetSize = function(self, w, h)
		__OldSetSize(self, 4, h)
		self:SetPos(listView:GetWide()-4)
	end
	
	CL_EASYSKINS.SkinScrollPanel(listView)
	
	-- resize canvas due to new scrollbar width
	local __OldSetSize = listView.pnlCanvas.SetSize
	local initialWidth = nil
	listView.pnlCanvas.SetSize = function(self, w, h)
		
		if listView.VBar.Enabled then
			__OldSetSize(self, w+16-listView.VBar:GetWide(), h)
		else
			__OldSetSize(self, w, h)
		end
		
	end
	
	-- skin headers
	for _, col in pairs(listView.Columns) do
	
		-- header btn
		col.Header.Paint = function(self, w, h)
			
			-- bg
			surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
			surface.DrawRect(0,0,w,h)
			
			-- lines
			surface.SetDrawColor(SH_EASYSKINS.COL.LIGHTGREY)
			surface.DrawRect(0,0,w,1)
			surface.DrawRect(0,h-1,w,1)
				
		end
		
		col.Header:SetTextColor(SH_EASYSKINS.COL.LIGHTGREY)
	
	end
	
	listView.Paint = function(self, w, h)
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
		surface.DrawRect(0,0,w,h)
	end
	
	local __OldAddLine = listView.AddLine
	listView.AddLine = function(self, ...)
		
		local line = __OldAddLine(self, ...)
		local isEvenLine = #self:GetLines()%2 == 0
		local lineColor = isEvenLine and SH_EASYSKINS.COL.GREY or Color(45, 45, 45)

		-- skin lines
		for k, lineCol in pairs(line.Columns) do
			
			lineCol:SetColor(color_white)
			
			lineCol.Paint = function(self, w, h)
				
				if line.mouseIsIn or line:IsSelected() then
					surface.SetDrawColor(SH_EASYSKINS.COL.BLUE)
					surface.DrawRect(0,0,w,h)
				else
					surface.SetDrawColor(lineColor)
					surface.DrawRect(0,0,w,h)
				end
			
			end
			
		end
		
		line.OnCursorEntered = function(self)
			self.mouseIsIn = true
			
			-- OnCursorExited will not always trigger when scrolling
			local lines = listView:GetLines()
			for i=1, #lines do
				
				local l =lines[i]
				
				if l == self then continue end
				
				l.mouseIsIn = false
				
			end
			
		end
		
		line.OnCursorExited = function(self)
			self.mouseIsIn = false
		end
		
		return line
		
	end
	

end