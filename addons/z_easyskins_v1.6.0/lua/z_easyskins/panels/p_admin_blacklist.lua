-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit)

	if !realInit then return end
	
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local ply = LocalPlayer()
	local activeWep = ply:GetActiveWeapon()
	local pWide,pTall = self:GetWide(), self:GetTall()
	
	local chooseWeaponBtnH = 35
	local weaponMatListW,weaponMatListH = pWide*0.3,(pTall-chooseWeaponBtnH-65)*0.5
	
	local allResSize, largeResSize = pTall*0.6, pWide*0.7
	local weaponMdlSize, weaponMdlYOffset
	
	if largeResSize > allResSize then
		weaponMdlSize = pTall*0.6
		weaponMdlYOffset = -weaponMdlSize*0.2
	else
		weaponMdlSize = math.min(pTall*0.7,pWide*0.7)
		weaponMdlYOffset = -weaponMdlSize*0.3
	end
	
	local vmMatList,wmMatList
	local vmModelPnl,wmModelPnl
	
	local function SelectMaterial(mdlPnl,index,rowPnl,isClick)

		if !IsValid(mdlPnl.Entity) then return end
	
		if rowPnl.isDefaultBlacklisted and rowPnl.isSelected then return end
		
		local material = rowPnl:GetValue(1)
		local matIndex = index-1
	
		rowPnl.isSelected = !rowPnl.isSelected
		
		rowPnl:SetSelected( rowPnl.isSelected )
		
		if rowPnl.isSelected then
		
			if isClick then
				-- add material to blacklist
				CL_EASYSKINS.AddBlacklistMat(material)
				
				-- debug
				-- print('["'..material..'"] = true,')
			end
			
			-- apply debug mat on target mat
			mdlPnl.Entity:SetSubMaterial(matIndex,"z_easyskins/vgui/red")
			
		else
		
			if isClick then
				-- remove material from blacklist
				CL_EASYSKINS.RemoveBlacklistMat(material)
			end
			
			-- reset submat
			mdlPnl.Entity:SetSubMaterial(matIndex)
			
		end
		
	end
	
	local function UpdateMaterials(matList,materials)
		matList:UpdateMaterials(materials)
	end
	
	local function ChangeDisplayedWeapon(weaponClass)

		local vmPath,wmPath = SH_EASYSKINS.GetWeaponModels(weaponClass)
		local vmWepMdl = ClientsideModel( vmPath )
		local wmWepMdl = ClientsideModel( wmPath )
		
		-- update model panels
		vmModelPnl:UpdateModel(vmPath)
		wmModelPnl:UpdateModel(wmPath)
		
		-- update the material lists
		if IsValid(vmWepMdl) then
			UpdateMaterials(vmMatList,SH_EASYSKINS.GetModelMaterials(vmWepMdl, weaponClass, true))
			vmWepMdl:Remove()
		else
			UpdateMaterials(vmMatList,{})
		end
		if IsValid(wmWepMdl) then
			UpdateMaterials(wmMatList,SH_EASYSKINS.GetModelMaterials(wmWepMdl, weaponClass, false))
			wmWepMdl:Remove()
		else
			UpdateMaterials(wmMatList,{})
		end
	
	end
	
	-- vm mat lbl
	local vmMatLbl = CL_EASYSKINS.CreateLbl(5, 1, CL_EASYSKINS.Translate("viewmodel"), "z_easyskins_menu_cat_btn", color_white, self, true)
	vmMatLbl:SetWide(weaponMatListW-1)
	
	-- vm mat list
	vmMatList = CL_EASYSKINS.CreateWeaponMaterialList(5,vmMatLbl:GetTall()+1,weaponMatListW,weaponMatListH,{},self)
	vmMatList.OnRowSelected = function( lst, index, pnl )
		SelectMaterial(vmModelPnl,index,pnl,true)
	end
	vmMatList.DoDoubleClick = vmMatList.OnRowSelected
	vmMatList.MarkDefaultPart = function(self, index, rowPnl)
		SelectMaterial(vmModelPnl,index,rowPnl,false)
	end
	
	-- wm mat lbl
	local wmMatLblY = vmMatList:GetBottomY()
	local wmMatLbl = CL_EASYSKINS.CreateLbl(5, wmMatLblY+5, CL_EASYSKINS.Translate("worldmodel"), "z_easyskins_menu_cat_btn", color_white, self, true)
	wmMatLbl:SetWide(weaponMatListW-1)
	
	-- wm mat list
	wmMatList = CL_EASYSKINS.CreateWeaponMaterialList(5,wmMatLblY+wmMatLbl:GetTall()+5,weaponMatListW,weaponMatListH,{},self)
	wmMatList.OnRowSelected = function( lst, index, pnl )
		SelectMaterial(wmModelPnl,index,pnl,true)
	end
	wmMatList.DoDoubleClick = wmMatList.OnRowSelected
	wmMatList.MarkDefaultPart = function(self, index, rowPnl)
		SelectMaterial(wmModelPnl,index,rowPnl,false)
	end
	
	-- select weapon btn
	local chooseWeaponBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("selectWep"),color_white,self,function()
		
		local openWeaponMethodsPnl = vgui.Create("p_easyskins_admin_weapon_list")
		openWeaponMethodsPnl:Init(true, {}, false)
		
		openWeaponMethodsPnl.CloseAddWeapons = function( realSelf, chosenItems )
			
			if #chosenItems == 0 then return end
			
			local chosenItem = chosenItems[1]
		
			-- update wep
			ChangeDisplayedWeapon(chosenItem)
			
			-- remove the weapon methods panel
			realSelf:Remove()
			
		end
		
	end)
	chooseWeaponBtn.BGAlpha = 255
	chooseWeaponBtn.BGCol = SH_EASYSKINS.COL.BLUE
	chooseWeaponBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	chooseWeaponBtn.UseHoverCol = false
	chooseWeaponBtn:SetSize(weaponMatListW,chooseWeaponBtnH)
	
	local offsetBtnSpace = pTall - wmMatList:GetBottomY()
	local chooseWeaponBtnY = pTall - (offsetBtnSpace/2) - chooseWeaponBtn:GetTall()/2
	chooseWeaponBtn:SetPos(5,chooseWeaponBtnY)
	
	
	// model display
	local mdlPnlX = weaponMatListW + ((pWide-weaponMatListW)/2) - weaponMdlSize/2

	vmModelPnl = CL_EASYSKINS.CreateWeaponModelPnl(mdlPnlX,weaponMdlYOffset,weaponMdlSize,'',true,self,true)
	wmModelPnl = CL_EASYSKINS.CreateWeaponModelPnl(mdlPnlX,pTall/2+5+weaponMdlYOffset,weaponMdlSize,'',false,self,true)
	
	if IsValid(activeWep) then
		ChangeDisplayedWeapon(activeWep:GetClass())
	end
	
end
vgui.Register('p_easyskins_admin_blacklist',PANEL,'DScrollPanel')
