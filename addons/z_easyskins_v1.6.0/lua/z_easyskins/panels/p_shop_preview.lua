-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()
local previewIsOpen = false

function CL_EASYSKINS.ShopPreviewIsOpen()
	return previewIsOpen
end

function PANEL:Init(realInit,class,matPath,msg,yesCallback,noCallBack)
	
	if !realInit then return end

	local ply = LocalPlayer()
	previewIsOpen = true
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self.startTime = SysTime()
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end
	
	-- content pnl
	local contentPnl = vgui.Create("DPanel",self)
	contentPnl:SetSize(math.max(550,scrW*0.5),500)
	contentPnl:Center()
	contentPnl.Paint = function(self, w, h)
		-- bg
		surface.SetDrawColor(SH_EASYSKINS.COL.DARKGREY)
		surface.DrawRect(0,0,w,h)
	end
	
	-- purchase msg
	local msgLbl = CL_EASYSKINS.CreateLbl(0, 0, msg, "z_easyskins_preview_title", color_white, contentPnl)
	local contentW,contentH = msgLbl:GetContentSize()
	local msgLblH = contentPnl:GetWide() > contentW and contentH or contentH*2
	msgLbl:SetSize(math.min(contentPnl:GetWide(),contentW+10),msgLblH)
	msgLbl:SetPos(0,25)
	msgLbl:SetTextInset(8,0)
	msgLbl:SetWrap(true)
	msgLbl:SetZPos(1)
	CL_EASYSKINS.CenterInElement(msgLbl, contentPnl)
		
	-- model preview
	local _, wmPath = SH_EASYSKINS.GetWeaponModels(class)
	local previewPnl, previewLbl = CL_EASYSKINS.CreateWeaponModelPnl(0,0,contentPnl:GetWide(),'',true,contentPnl,true,true)
	previewLbl:SetVisible(false)
	previewPnl:UpdateModel(wmPath)
	
	local offset = 0
	
	local allResSize, largeResSize = contentPnl:GetTall()*0.32, contentPnl:GetWide()*0.24
	
	if largeResSize > allResSize then
		offset = (contentPnl:GetWide()-contentPnl:GetTall())/2
	end
	
	previewPnl:SetPos(0,-offset)
	
	CL_EASYSKINS.CenterInElement(previewPnl, contentPnl)
	
	-- apply skin
	SH_EASYSKINS.ApplySkinToModel(previewPnl.Entity, matPath)
	
	-- yes btn
	local yesBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("yes"),color_white,contentPnl,function()
		previewIsOpen = false
		self:Remove()
		yesCallback()
	end)
	yesBtn.BGCol = SH_EASYSKINS.COL.GREEN
	yesBtn.UseHoverCol = false
	yesBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	yesBtn:SetSize(150, 30)
	
	local btnY = contentPnl:GetTall() - 60
	yesBtn:SetPos(contentPnl:GetWide()*0.7-yesBtn:GetWide()/2,btnY)
	
	-- no btn
	local noBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("no"),color_white,contentPnl,function()
		previewIsOpen = false
		self:Remove()
		if noCallBack ~= nil then
			noCallBack()
		end
		
	end)
	noBtn.BGCol = SH_EASYSKINS.COL.RED
	noBtn.UseHoverCol = false
	noBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	noBtn:SetSize(150, 30)
	noBtn:SetPos(contentPnl:GetWide()*0.3-noBtn:GetWide()/2,btnY)
	
end
vgui.Register('p_easyskins_shop_preview',PANEL,'DFrame')


