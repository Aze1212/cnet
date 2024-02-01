-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init()

	local ply = LocalPlayer()
	
	self:SetSize(scrW,400)
	self:MoveToFront()
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:Center()
	self.startTime = SysTime()

	local pWide,pTall = self:GetWide(), self:GetTall()
	local iconSize = 64
	local selectedSkin = nil
	local selectedWeps = {}
	local selectedMaterialIcon = nil

	local spaceY = 5
	local function addSpace(num)
		num = num or 40
		spaceY = spaceY + num
	end
	
	-- title lbl
	local categoryLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("giveSkin"), "z_easyskins_menu_title", SH_EASYSKINS.COL.BLUE, self)
	CL_EASYSKINS.CenterInElement(categoryLbl, self)
	addSpace(60)
	
	-- icon lbl
	local iconLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("skin"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, self)
	CL_EASYSKINS.CenterInElement(iconLbl, self)
	addSpace(80)
	
	-- wep selection 
	local chooseSkinBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("chooseSkin"),color_white,self,function()
		
		local giveSkinPnl = vgui.Create("p_easyskins_admin_skin_list")
		giveSkinPnl.CloseList = function(realSelf, skin)
			
			-- save the choice
			selectedSkin = skin
			
			if selectedMaterialIcon ~= nil then
				selectedMaterialIcon:DoRemove()
			end
			
			-- create icon to display selected skin
			selectedMaterialIcon = CL_EASYSKINS.CreateMaterialIcon(pWide/2-iconSize/2, 60, iconSize, skin.dispName, skin.material.path, self, nil, true)
			
			-- remove the list
			realSelf:Remove()
			
		end
		
		
	end)
	chooseSkinBtn:SetPos(0,spaceY)
	CL_EASYSKINS.CenterInElement(chooseSkinBtn, self)
	addSpace(60)
	
	
	-- wep lbl
	local wepsLbl = CL_EASYSKINS.CreateLbl(0, spaceY, CL_EASYSKINS.Translate("weapons"), "z_easyskins_menu_cat_btn", SH_EASYSKINS.COL.BLUE, self)
	CL_EASYSKINS.CenterInElement(wepsLbl, self)
	addSpace()
	
	local wepSelectedLblY = spaceY
	local updateWeaponBtn
	local function UpdateWepSelectedLbl()
		if #selectedWeps == 1 then
			local weaponInfo = SH_EASYSKINS.GetWeaponInfo(selectedWeps[1])
			updateWeaponBtn:SetText(weaponInfo.name)
		elseif #selectedWeps > 1 then
			updateWeaponBtn:SetText(#selectedWeps.." "..CL_EASYSKINS.Translate("weaponsSelected"))
		end
		-- calls btn resize
		updateWeaponBtn:ChangeFont("z_easyskins_menu_cat_sub_btn")
		updateWeaponBtn:SetPos(0,wepSelectedLblY)
		CL_EASYSKINS.CenterInElement(updateWeaponBtn, self)
	end
	
	-- wep selection                             
	updateWeaponBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("chooseWeapons"),color_white,self,function()
	
		local openWeaponMethodsPnl = vgui.Create("p_easyskins_admin_weapon_list")
		openWeaponMethodsPnl:Init(true, chosenItems)
		
		openWeaponMethodsPnl.CloseAddWeapons = function( realSelf, chosenItems )
			
			selectedWeps = chosenItems
		
			-- update lbl
			UpdateWepSelectedLbl()
			
			-- remove the weapon methods panel
			realSelf:Remove()
			
		end
 
	end)
	updateWeaponBtn:SetWide(110)
	UpdateWepSelectedLbl()
	addSpace(80)
	
	-- give skin btn
	local giveSkinBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("give"),color_white,self,function()
	
		if selectedSkin ~= nil and #selectedWeps > 0 then
			self:CloseAdminGivePnl(selectedSkin,selectedWeps)
		end
		
	end)
	giveSkinBtn.BGCol = SH_EASYSKINS.COL.GREEN
	giveSkinBtn.UseHoverCol = false
	giveSkinBtn:SetPos(pWide/2 + 10,spaceY)

	-- cancel btn
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,self,function()
		self:Remove()
	end)
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:SetPos(pWide/2 - cancelBtn:GetWide() - 10,spaceY)
	
	local bgWidth = cancelBtn:GetWide()*2 + 40
	
	self.Paint = function(self,w,h)
	
		Derma_DrawBackgroundBlur( self, self.startTime )
		
		-- solid bg
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(w/2-bgWidth/2,0,bgWidth,h-40)
		
	end
	
	
end
vgui.Register('p_easyskins_admin_give',PANEL,'DFrame')