-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init()

	local ply = LocalPlayer()
	
	self:SetSize(300,53)
	self:SetDrawBackground(false)
	
end

function PANEL:UpdateInfo(skin,weaponClass)
	
	local ply = LocalPlayer()
	local realPrice = SH_EASYSKINS.GetRealPrice(ply,skin)
	local plyIsDonator = SH_EASYSKINS.IsDonator(ply)
	local canBuy = SH_EASYSKINS.CanBuySkin(ply,skin.id,weaponClass)
	local isAnimated = SH_EASYSKINS.IsMaterialAnimated(skin.material)
	
	local spaceY = 1
	local function AddSpace(num)
		num = num or 25
		spaceY = spaceY + num + 1
	end
	
	-- remove children if prev updated
	for _,child in pairs(self:GetChildren()) do
		child:Remove()
	end
	
	-- background
	self.Paint = function(self,w,h)
	
		surface.SetDrawColor( SH_EASYSKINS.COL.DARKGREY )
		surface.DrawRect( 0, 0, w, h )
		
		if skin.donatorOnly then
			surface.SetDrawColor( SH_EASYSKINS.COL.GOLD )
			surface.DrawOutlinedRect( 0, 0, w, h )
		elseif skin.steamgroupOnly then
			surface.SetDrawColor( SH_EASYSKINS.COL.STEAM )
			surface.DrawOutlinedRect( 0, 0, w, h )
		elseif skin.nameTagOnly then
			surface.SetDrawColor( SH_EASYSKINS.COL.NAMETAG )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
			
	end
	
	-- special statusses
	local groupOnlyLbl
	if skin.donatorOnly then
		groupOnlyLbl = CL_EASYSKINS.CreateLbl(1, spaceY, "VIP", "z_easyskins_menu_cat_sub_btn_bold", SH_EASYSKINS.COL.GOLD, self, true)
	elseif skin.steamgroupOnly then
		groupOnlyLbl = CL_EASYSKINS.CreateLbl(1, spaceY, "STEAM GROUP", "z_easyskins_menu_cat_sub_btn_bold", SH_EASYSKINS.COL.STEAM, self, true)
	elseif skin.nameTagOnly then
		groupOnlyLbl = CL_EASYSKINS.CreateLbl(1, spaceY, "TAG", "z_easyskins_menu_cat_sub_btn_bold", SH_EASYSKINS.COL.NAMETAG, self, true)
	end
	
	if groupOnlyLbl ~= nil then
		AddSpace(20)
	end
	
	-- animated
	local animatedLbl
	if isAnimated then
		animatedLbl = CL_EASYSKINS.CreateLbl(1, spaceY, "Animated", "z_easyskins_menu_cat_sub_btn_bold",SH_EASYSKINS.COL.PURPLEHAZE, self, true)
		AddSpace(20)
	end
	
	-- title
	local titleLbl = CL_EASYSKINS.CreateLbl(1, spaceY, skin.dispName, "z_easyskins_menu_cat_btn", color_white, self, true)
	AddSpace()
	
	-- price
	local priceLblCol = canBuy and SH_EASYSKINS.COL.GREEN or SH_EASYSKINS.COL.RED
	local usesCustomCurrency = #skin.currency > 0 and SH_EASYSKINS.ShopSystems.nameref[skin.currency] ~= nil
	
	-- if there is a discount on the skin
	local donatorOldPriceLbl
	if skin.price ~= realPrice then
	
		-- custom currency uses 'Credits'
		local donatorOldPriceLblTxt
		local formattedPrice = SH_EASYSKINS.FormatMoney(skin.price)
		if usesCustomCurrency then
			donatorOldPriceLblTxt = formattedPrice:sub(2).." Credits"
		else
			donatorOldPriceLblTxt = formattedPrice
		end

		donatorOldPriceLbl = CL_EASYSKINS.CreateLbl(1, spaceY, donatorOldPriceLblTxt, "z_easyskins_menu_cat_btn_strike",  SH_EASYSKINS.COL.LIGHTGREY, self, true)
		AddSpace()
		
	end
	
	-- custom currency uses 'Credits'
	local priceLblTxt
	
	if realPrice > 0 then
	
		local formattedRealPrice = SH_EASYSKINS.FormatMoney(realPrice)
		if usesCustomCurrency then
			priceLblTxt = formattedRealPrice:sub(2).." Credits"
		else
			priceLblTxt = formattedRealPrice
		end
		
	else
		priceLblTxt = CL_EASYSKINS.Translate("free")
	end
	
	local priceLbl = CL_EASYSKINS.CreateLbl(1, spaceY, priceLblTxt, "z_easyskins_menu_cat_btn",  priceLblCol, self, true)
	
	AddSpace()
	
	local groupOnlyLblW = groupOnlyLbl and groupOnlyLbl:GetWide() + 2 or 0
	local animatedLblW = animatedLbl and animatedLbl:GetWide() + 2 or 0
	local titleLblWide = titleLbl:GetWide() + 2
	local priceLblW = priceLbl:GetWide() + 2
	local oldPriceLblW = donatorOldPriceLbl and donatorOldPriceLbl:GetWide() + 2 or 0
	local pnlWide = math.Max(titleLblWide,priceLblW,animatedLblW,oldPriceLblW,groupOnlyLblW)
	local lblWide = pnlWide-2

	priceLbl:SetWide(lblWide)
	titleLbl:SetWide(lblWide)
	if donatorOldPriceLbl ~= nil then
		donatorOldPriceLbl:SetWide(lblWide)
	end
	if animatedLbl ~= nil then
		animatedLbl:SetWide(lblWide)
	end
	if groupOnlyLbl ~= nil then
		groupOnlyLbl:SetWide(lblWide)
	end

	self:SetSize(pnlWide,spaceY)
	self:SetVisible(true)

end

function PANEL:Think()

	local parent = self:GetParent()
	local cursorOffset = 25
	
	local cursorX,cursorY = parent:CursorPos()
	local infoPosX,infoPosY = cursorX+cursorOffset, cursorY-cursorOffset
	
	-- if it doesn't fit the screen on the right position it on the left
	if (infoPosX + self:GetWide()) > parent:GetWide() then
		infoPosX = cursorX - self:GetWide() - cursorOffset
	end
	
	self:SetPos(infoPosX,infoPosY)

end
vgui.Register('p_easyskins_hover_skin_info',PANEL,'DPanel')