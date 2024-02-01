-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit,msg,yesCallback,noCallBack)
	
	if !realInit then return end

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
	
	-- content pnl
	local contentPnl = vgui.Create("DPanel",self)
	contentPnl:SetSize(math.max(550,scrW*0.5),300)
	contentPnl:Center()
	contentPnl:SetDrawBackground(false)
	
	local msgLbl = CL_EASYSKINS.CreateLbl(0, 0, msg, "z_easyskins_menu_cat_btn", color_white, contentPnl, true)
	local contentW,contentH = msgLbl:GetContentSize()
	local msgLblH = contentPnl:GetWide() > contentW and contentH or contentH*2
	msgLbl:SetSize(math.min(contentPnl:GetWide(),contentW+10),msgLblH)
	msgLbl:CenterVertical()
	msgLbl:SetTextInset( 8 , 0 )
	msgLbl:SetWrap(true)
	msgLbl.Paint = function(self,w,h)
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
		surface.DrawRect(0,0,w,h)
	end
	CL_EASYSKINS.CenterInElement(msgLbl, contentPnl)
	
	local msgLblX,msgLblY = msgLbl:GetPos()
	local btnX = msgLblX+(msgLbl:GetWide()/2)
	local btnY = msgLblY + msgLbl:GetTall() + 25

	-- yes btn
	local yesBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("yes"),color_white,contentPnl,function()
		self:Remove()
		yesCallback()
	end)
	yesBtn.BGAlpha = 255
	yesBtn.BGCol = SH_EASYSKINS.COL.GREEN
	yesBtn.UseHoverCol = false
	yesBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	yesBtn:SetPos(btnX+25,btnY)
	
	-- no btn
	local noBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("no"),color_white,contentPnl,function()
		self:Remove()
		
		if noCallBack ~= nil then
			noCallBack()
		end
		
	end)
	noBtn.BGAlpha = 255
	noBtn.BGCol = SH_EASYSKINS.COL.RED
	noBtn.UseHoverCol = false
	noBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	noBtn:SetPos(btnX-noBtn:GetWide()-25,btnY)
	
end
vgui.Register('p_easyskins_confirmation',PANEL,'DFrame')
