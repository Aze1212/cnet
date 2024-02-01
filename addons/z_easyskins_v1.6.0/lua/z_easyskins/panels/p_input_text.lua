-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit,title,placeholderTxt,addFunc)
	
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
	
	-- name input
	local txtInput = CL_EASYSKINS.CreateTextInput(0, 0, 250, 25, placeholderTxt, "z_easyskins_menu_cat_btn", color_white, self)
	txtInput:Center()
	
	local txtInputX,txtInputY = txtInput:GetPos()
	
	-- title lbl
	local titleLbl = CL_EASYSKINS.CreateLbl(0, txtInputY-80, title, "z_easyskins_cat_title", SH_EASYSKINS.COL.BLUE, self)
	titleLbl.Paint = function(self,w,h)
		surface.SetDrawColor(SH_EASYSKINS.COL.GREY)
		surface.DrawRect(0,0,w,h)
	end
	titleLbl:CenterHorizontal()
	
	-- add btn
	local addBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("add"),color_white,self,function()
		addFunc(txtInput:GetText())
		self:Remove()
	end)
	addBtn.BGAlpha = 255
	addBtn.BGCol = SH_EASYSKINS.COL.GREEN
	addBtn.UseHoverCol = false
	addBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	
	local addBtnPos = txtInputX + txtInput:GetWide()/2 + 25
	addBtn:SetPos(addBtnPos, txtInputY+80)
	
	-- cancel btn
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,self,function()
		self:Remove()
	end)
	cancelBtn.BGAlpha = 255
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	local cancelBtnPos = txtInputX + txtInput:GetWide()/2 - cancelBtn:GetWide() - 25
	cancelBtn:SetPos(cancelBtnPos, txtInputY+80)
	
end
vgui.Register('p_easyskins_input_text',PANEL,'DFrame')
