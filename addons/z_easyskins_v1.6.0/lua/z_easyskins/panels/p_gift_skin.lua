-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

function PANEL:Init(realInit,skin,weaponClass)
	
	local ply = LocalPlayer()
	local playerListW,playerListH = 500,scrH*0.5
	local selectedPlayer, selectedPlayerSteamID64
	
	self:SetSize(scrW,scrH)
	self:MoveToFront()
	self:MakePopup()
	
	self:SetTitle("")
	self:ShowCloseButton(false)
	
	self.startTime = SysTime()
	
	self.Paint = function(self,w,h)
		Derma_DrawBackgroundBlur( self, self.startTime )
	end
		
	-- player list
	local playerList = vgui.Create( "DListView", self )
	playerList:SetSize(playerListW,playerListH)
	playerList:AddColumn( "SteamID" )
	playerList:AddColumn( CL_EASYSKINS.Translate("name") )
	playerList:Center()
	CL_EASYSKINS.SkinListView(playerList)
	
	playerList.OnRowSelected = function( panel, rowIndex, row )
		
		local steamID, name = row:GetValue(1), row:GetValue(2)

		if #name == 0 then return end
		
		selectedPlayer = player.GetBySteamID(steamID)
		selectedPlayerSteamID64 = selectedPlayer:SteamID64()
		
	end

	local filter = ""
	local function FillPlayerList()
		
		playerList:Clear()
	
		-- fill player list
		for _, ply in pairs(player.GetHumans()) do
		
			if ply == LocalPlayer() then continue end
			
			local nick = ply:Nick()
			local followsFilter = string.match( nick:lower(), filter ) ~= nil
			
			if followsFilter then
				playerList:AddLine( ply:SteamID(), nick )
			end
			
		end
	
	end
	FillPlayerList()

	
	if #playerList:GetLines() == 0 then
		local line = playerList:AddLine( CL_EASYSKINS.Translate("noPlayersFound"),'' )
		line:SetSelectable(false)
	end
	
	local playerListX, playerListY = playerList:GetPos()
	local playerListBottomY = playerList:GetBottomY() + 10
	
	-- search filter
	local searchInput = CL_EASYSKINS.CreateTextInput(playerListX, playerListY-45, playerListW, 45, "", "z_easyskins_menu_cat_btn", color_white, self)
	searchInput.bgCol = SH_EASYSKINS.COL.DARKGREY
	searchInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	searchInput:SetPlaceholderText(CL_EASYSKINS.Translate("enterName"))
	
	searchInput.OnChange = function(self)
	
		filter = string.Trim( self:GetText():lower() )
		
		-- refill list
		FillPlayerList()
		
	end
	
	-- gift btn
	local giftBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("gift"),color_white,self,function()
		
		if selectedPlayer == nil then return end
		
		-- confirmation
		local giftMsg = string.format(CL_EASYSKINS.Translate("giftSkin"), skin.dispName, selectedPlayer:Nick())
		local confirmation =  vgui.Create("p_easyskins_confirmation")
		confirmation:Init(true, giftMsg, function()
		
			-- play sound
			CL_EASYSKINS.PlaySound("sell")
				
			-- gift skin
			CL_EASYSKINS.GiftSkin(skin.id,weaponClass,selectedPlayerSteamID64)
			
			-- remove the gift panel from the inventory
			self.CloseGiftSkinPnl(self)
			
		end)
	
	end)
	giftBtn.BGAlpha = 255
	giftBtn.BGCol = SH_EASYSKINS.COL.GREEN
	giftBtn.UseHoverCol = false
	giftBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	giftBtn:SetPos(playerListX+((playerListW/4)*3)-giftBtn:GetWide()/2,playerListBottomY)
	
	-- cancel btn
	local cancelBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("cancel"),color_white,self,function()
		self:Remove()
	end)
	cancelBtn.BGAlpha = 255
	cancelBtn.BGCol = SH_EASYSKINS.COL.RED
	cancelBtn.UseHoverCol = false
	cancelBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	cancelBtn:SetPos(playerListX+playerListW/4-cancelBtn:GetWide()/2,playerListBottomY)
	
end
vgui.Register('p_easyskins_gift_skin',PANEL,'DFrame')