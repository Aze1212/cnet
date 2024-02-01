-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local PANEL = {}
local scrW,scrH = ScrW(),ScrH()

local function SortPlayerTable(a,b)

	local onlineA = SH_EASYSKINS.BoolToInt(a.online)
	local onlineB = SH_EASYSKINS.BoolToInt(b.online)
	
	if onlineA == onlineB then
		return a.name:lower() > b.name:lower()
	end

	return onlineA > onlineB
	
end

function PANEL:Init(realInit)

	if !realInit then return end
	
	CL_EASYSKINS.SkinScrollPanel(self)
	
	local ply = LocalPlayer()
	
	self:SetTall(self:GetTall()-5)
	local pWide,pTall = self:GetWide(), self:GetTall()
	
	local waitingForNetworkedResponse = false
	local CreatePlayerPanels
	local skinOwners = {}
	local userPanels = {}

	-- filter input
	local searchInput = CL_EASYSKINS.CreateTextInput(5, 0, pWide-215, 45, "", "z_easyskins_menu_cat_btn", color_white, self)
	searchInput:SetPlaceholderColor(SH_EASYSKINS.COL.LIGHTGREY)
	searchInput:SetPlaceholderText(CL_EASYSKINS.Translate("enterName"))
	local searchInputBottomY = searchInput:GetBottomY() 
	
	local prevUserPnlY = searchInputBottomY+5
	local prevUserPnl = nil
	
	local function ResetPlayerRows()
		for k,v in pairs(userPanels) do
			if v:IsValid() then
				v:Remove()
			end 
		end 
		table.Empty(userPanels)
		prevUserPnlY = searchInputBottomY+5
		prevUserPnl = nil
	end
	
	-- filter functionality
	CL_EASYSKINS.HookWepPanelFilter(searchInput,userPanels)
	
	-- modify filter behaviour to list online players first when not filtering
	local __oldOnChange = searchInput.OnChange
	searchInput.OnChange = function(self)
		
		-- normal filter behaviour
		__oldOnChange(self)
		
		-- sort the panels back to the online/offline sorted table
		if #string.Trim(self:GetText()) == 0 then
		
			local prevOwnerPnl = nil
		
			for i=1, #skinOwners do
				
				local skinOwner = skinOwners[i]
				local skinOwnerPanel = userPanels[skinOwner.name]
				
				if prevOwnerPnl ~= nil then
					skinOwnerPanel.prevWepPnlRef = prevOwnerPnl
				else
					-- make sure the first filtered result is on the start position
					skinOwnerPanel.prevWepPnlRef = nil
					skinOwnerPanel:SetPos(5,searchInput:GetBottomY()+5)
				end
				
				prevOwnerPnl = skinOwnerPanel
				
			end
			
		end
		
	end
	
	-- load players btn
	local loadPlayersBtn = CL_EASYSKINS.CreateMaterialButton(CL_EASYSKINS.Translate("loadPlayers").." (offline)",color_white,self,function(loadPlayersBtn)
		
		-- load players
		net.Start("sv_easyskins_GetSkinOwners")
		net.SendToServer()
		
		-- set overlay to loading
		local loadingOverlay = vgui.Create("p_easyskins_loading",self)
		loadingOverlay:Init(true,5,searchInputBottomY+5,pWide-10,pTall-searchInputBottomY-5)
		loadingOverlay.Think = function(self)
			
			local response = CL_EASYSKINS.RetrieveNetworkedResponse("GetSkinOwnersResponse")
			
			if response and response.received then 
			
				-- clear old panels
				ResetPlayerRows()
			
				-- set the data
				skinOwners = response.players
				
				-- add online players who might not have purchased any skins
				for _, p in pairs(player.GetHumans()) do
					
					local pSteamID64 = SH_EASYSKINS.GetSteamID64(p)
					local pFound = false
					
					for i=1, #skinOwners do
										
						local skinOwner = skinOwners[i]
							
						-- mark player as online
						if skinOwner.steamID64 == pSteamID64 then
							skinOwner.online = true
							pFound = true
						end
					
					end
				
					-- add the online player who hasn't bought any skins yet
					if !pFound then
					
						local skinOwner = {
							name = p:Nick(),
							skinCount =	0,
							steamID64 =	pSteamID64,
							online = true
						}
						
						table.insert(skinOwners,skinOwner)
						
					end
					
				end
				
				-- sort the table by name
				table.sort( skinOwners, SortPlayerTable )
				
				-- create the panels
				CreatePlayerPanels()
				
				self:Remove()
				
			end
			
		end	
		
		-- remove the button
		loadPlayersBtn:Remove()
		
	end)
	
	loadPlayersBtn.BGAlpha = 255
	loadPlayersBtn.BGCol = SH_EASYSKINS.COL.BLUE
	loadPlayersBtn.UseHoverCol = false
	loadPlayersBtn:ChangeFont("z_easyskins_menu_cat_sub_btn_bold")
	
	loadPlayersBtn:SetSize(200,45)
	loadPlayersBtn:SetPos(self:GetWide()-loadPlayersBtn:GetWide()-5,0)
	
	-- player panels
	function CreatePlayerPanels()
	
		for i=1, #skinOwners do
			
			local p = skinOwners[i]
			local userPnlW,userPnlH = self:GetWide()-10,35
			local skinPnlW,skinPnlH = userPnlW, userPnlH
			local skinIconSize = 26
			local removeIconSize = skinPnlH/2
			local userInfo = { name = p.name }
			local isExpanded = false
			local receivedPurchases = p.skinCount == 0
			local cachedPurchases = {}
			local giveSkinBtn
			local DisplaySkins
			local skinPanels = {}
			
			-- entire panel
			local userPnl = vgui.Create("DPanel",self)
			userPnl:SetPos(5,prevUserPnlY)
			userPnl:SetSize(userPnlW,userPnlH)
			userPnl.wepInfo = userInfo
			userPnl.prevWepPnlRef = prevUserPnl
			userPnl.Paint = function(self, w, h)
				surface.SetDrawColor(SH_EASYSKINS.COL.LIGHTBLACK_150)
				surface.DrawRect(0,userPnlH,w,h)
			end
			userPnl.Think = function(self)
				if self.prevWepPnlRef ~= nil then
					self:SetPos(5,2+self.prevWepPnlRef:GetBottomY())
				end
			end
	
			prevUserPnl = userPnl	
			userPanels[p.name] = userPnl
			prevUserPnlY = prevUserPnlY + userPnlH + 2
		
			-- player name + skin count
			local nameBtn = vgui.Create ("DButton",userPnl)
			nameBtn:SetFont("z_easyskins_menu_cat_sub_btn")
			nameBtn:SetPos(0,0)
			nameBtn:SetSize(userPnlW,userPnlH)
			nameBtn:SetTextColor(color_white)
			nameBtn:SetContentAlignment(4)
			nameBtn:SetTextInset(5, 0)
			nameBtn:SetText(p.name)
			nameBtn.Think = function()
			
				if p.skinCount ~= nil then
					nameBtn:SetText(p.name..' ('..p.skinCount..')')
				end
				
				-- show the + button only when a user has been loaded, or if the user has no skins
				if giveSkinBtn ~= nil then
					giveSkinBtn:SetVisible(receivedPurchases)
				end
				
			end
			nameBtn.Paint = function(self, w, h)
				surface.SetDrawColor(SH_EASYSKINS.COL.GREY_150)
				surface.DrawRect(0, 0, w, h)
			end
			nameBtn.GetAutoSize = function(self)
			
				if isnumber(p.skinCount) then
					return userPnlH + 2 + ((skinPnlH+2)*p.skinCount)
				end
			 
			end
			
			nameBtn.DoClick = function(self)
				
				if waitingForNetworkedResponse or p.skinCount == 0 then return end
			
				isExpanded = !isExpanded
				
				if isExpanded then
					
					local newH = self:GetAutoSize()
					
					-- don't request again if we already have the results stored
					if #cachedPurchases > 0 then
						userPnl:SizeTo( userPnlW, newH, 0.5 )
						return
					end
					
					waitingForNetworkedResponse = true
					
					-- request purchases
					net.Start("sv_easyskins_GetPlayerPurchases")
						net.WriteString(p.steamID64)
					net.SendToServer()
					
					-- create loading overlay
					local loadingOverlay = vgui.Create("p_easyskins_loading",userPnl)
					loadingOverlay:Init(true,0,0,userPnlW,userPnlH)
					loadingOverlay.Think = function(self)
						
						-- wait for response
						local response = CL_EASYSKINS.RetrieveNetworkedResponse("GetPlayerPurchasesResponse")
						
						if response and response.received then
							
							-- cache the result
							cachedPurchases = response.purchases
						
							-- create the skin panels
							DisplaySkins(response.purchases)
							
							-- update skin count
							p.skinCount = #cachedPurchases
							
							-- remove overlay 
							self:Remove()
							
							waitingForNetworkedResponse = false
							receivedPurchases = true
							
							-- resize panel
							userPnl:SizeTo( userPnlW, nameBtn:GetAutoSize(), 0.5 )
							
						end
						
					end
					
				else
					-- resize panel
					userPnl:SizeTo( userPnlW, userPnlH, 0.5 )
				end
			
			end
			
			-- connected status
			local connectedLbl = CL_EASYSKINS.CreateLbl( 0, 0, "", "z_easyskins_menu_cat_sub_btn", color_white, userPnl )

			if p.online then
				connectedLbl:SetText(CL_EASYSKINS.Translate("online"))
				connectedLbl:SetTextColor(SH_EASYSKINS.COL.GREEN)
			else
				connectedLbl:SetText(CL_EASYSKINS.Translate("offline"))
				connectedLbl:SetTextColor(SH_EASYSKINS.COL.LIGHTGREY)
			end
			
			connectedLbl:UpdateSize()
			connectedLbl:SetPos(userPnlW-connectedLbl:GetWide())
			connectedLbl:CenterVertical()
			
			-- give skin btn
			giveSkinBtn = CL_EASYSKINS.CreateMaterialButton("+",SH_EASYSKINS.COL.GREEN,userPnl,function()
				
				local giveSkinPnl = vgui.Create("p_easyskins_admin_give")
				giveSkinPnl.CloseAdminGivePnl = function(self, skin, weps)

					local filteredWeps = table.Copy(weps)
					
					-- add to local cache and filter out weapons that the player aleady owns
					for i=1, #weps do
				
						local class = weps[i]
						local plyAlreadyOwnsSkin = false
						
						for purchaseI=1,#cachedPurchases do
							
							local purchase = cachedPurchases[purchaseI]
							
							-- check if player already owns the skin
							if purchase.weaponClass == class and purchase.skinID == skin.id then
								table.RemoveByValue(filteredWeps,class)
								plyAlreadyOwnsSkin = true
								break
							end
							
						end
						
						if plyAlreadyOwnsSkin then continue end
					
						-- create a new purchase
						local purchase = {
							skinID = skin.id,
							weaponClass = class
						}
						
						table.insert(cachedPurchases,purchase)

					end
					
					-- no unowned weapons found
					if #filteredWeps == 0 then
					
						-- close the pnl
						self:Remove()
						
						return
						
					end
					
					-- request server to give skin
					net.Start("sv_easyskins_GiveSkinToPlayer")
						net.WriteString(p.steamID64)
						net.WriteInt(skin.id,16)
						net.WriteTable(filteredWeps)
					net.SendToServer()
					
					-- clear all skins
					for _, skinPnl in pairs(skinPanels) do
						skinPnl:Remove()
					end
					
					-- refill the list
					DisplaySkins(cachedPurchases)
					
					-- resize panel
					isExpanded = true
					p.skinCount = #cachedPurchases
					userPnl:SizeTo( userPnlW, nameBtn:GetAutoSize(), 0.5 )
					
					-- close the pnl
					self:Remove()
	
				end

			end)
			giveSkinBtn.BGAlpha = 0
			giveSkinBtn:SetFont("z_easyskins_cat_title")
			giveSkinBtn:SetSize(25,userPnlH)
			giveSkinBtn:SetPos(pWide-connectedLbl:GetWide()-giveSkinBtn:GetWide()-20,0)
			giveSkinBtn:CenterVertical()
			
			function DisplaySkins(purchasedSkins)
				
				local skinPnlY = userPnlH+2
			
				for i=1, #purchasedSkins do
				
					local purchasedSkin = purchasedSkins[i]
					local skin = SH_EASYSKINS.GetSkin(purchasedSkin.skinID)
					local wepInfo = SH_EASYSKINS.GetWeaponInfo(purchasedSkin.weaponClass)
					
					-- skin was removed from server
					if skin == nil then
						skin = {}
					end
					
					-- material was removed from server
					if skin.material == nil then
						skin.material = {}
						skin.material.path = "debug/debugempty"
					end
					
					-- weapon was removed from server
					if wepInfo == nil then
						wepInfo = {}
						wepInfo.class = purchasedSkin.weaponClass
						wepInfo.name = wepInfo.class
					end
					
					local wepName = wepInfo.name
					
					-- checks for duplicate name
					if SH_EASYSKINS.IsDuplicateWeaponName(wepName) then
						wepName = wepName .." ("..wepInfo.class..")"
					end
					
					-- panel for the skins
					local skinPnl = vgui.Create( "DPanel", userPnl )
					skinPnl:SetPos(2,skinPnlY)
					skinPnl:SetSize(skinPnlW-4,skinPnlH)
					skinPnl.Paint = function(self, w, h)
						surface.SetDrawColor(100, 100, 100, 50)
						surface.DrawRect(0,0,w,h)
					end
					
					skinPanels[i] = skinPnl
					skinPnlY = skinPnlY + userPnlH + 2
					
					-- skin icon
					local weaponSkin = vgui.Create( "DImage", skinPnl )
					weaponSkin:SetPos( 2.5, 4.5 )
					weaponSkin:SetImage(skin.material.path)
					weaponSkin:SetSize( skinIconSize, skinIconSize )
			
					-- wep name
					local skinNameLbl = CL_EASYSKINS.CreateLbl( skinIconSize + 5, 0, wepName, "z_easyskins_menu_cat_sub_btn", color_white, skinPnl )
					skinNameLbl:CenterVertical()
					
					-- remove btn
					local removeBtn = vgui.Create ("DImageButton",skinPnl)
					removeBtn:SetPos(skinPnlW-removeIconSize-10,skinPnlH/2-removeIconSize/2)
					removeBtn:SetSize(removeIconSize,removeIconSize)
					removeBtn:SetImage("z_easyskins/vgui/cross_remove.vmt")
					
					local rmMsg = string.format(CL_EASYSKINS.Translate("removeSkinFromUser"),skin.dispName,wepName,p.name)
					removeBtn.DoClick = function()
							
						local confirmation = vgui.Create("p_easyskins_confirmation")
						confirmation:Init(true, rmMsg, function()
							
							net.Start("sv_easyskins_RemovePurchaseFromPlayer")
								net.WriteTable(purchasedSkin)
							net.SendToServer()
							
							-- remove from local list
							table.remove(purchasedSkins,i)
							
							-- clear all skins
							for _, skinPnl in pairs(skinPanels) do
								skinPnl:Remove()
							end
							
							-- refill the list
							DisplaySkins(purchasedSkins)
							
							-- resize panel
							p.skinCount = #purchasedSkins
							userPnl:SizeTo( userPnlW, nameBtn:GetAutoSize(), 0.5 )
							
						end)

					end
				
				end
				
			end
		
		end
	
	end
	
	------------ always load online players
	for _, p in pairs(player.GetHumans()) do
		
		local pSteamID64 = SH_EASYSKINS.GetSteamID64(p)
	
		if !pFound then
		
			local skinOwner = {
				name = p:Nick(),
				skinCount =	nil,
				steamID64 =	pSteamID64,
				online = true
			}
			
			table.insert(skinOwners,skinOwner)
			
		end
		
	end
	
	-- sort the table by name
	table.sort( skinOwners, SortPlayerTable )
	
	-- create the panels
	CreatePlayerPanels()
	------------
	
end
vgui.Register('p_easyskins_admin_users',PANEL,'DScrollPanel')
