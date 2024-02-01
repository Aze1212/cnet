-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/*
	A simple queued notification system
*/

local notificationQueue = {}
local startY = 40
local ttl = 5
local id = 1

local function AddNotificationToQueue(notificationPnl)
	
	id = id + 1
	
	-- link id
	notificationPnl.id = id
	
	-- add to queue
	table.insert(notificationQueue,notificationPnl)
	
	-- remove from queue
	notificationPnl.OnRemove = function(self)
		
		for i=1, #notificationQueue do
			
			local pnl = notificationQueue[i]
			
			if (pnl ~= nil and pnl.id == self.id) or pnl == nil then
				table.remove(notificationQueue, i)
			end
			
		end
	
	end
	
	-- auto reposition
	notificationPnl.isMoving = true
	notificationPnl.Think = function(self)
		  
		for i=1, #notificationQueue do
			
			local pnl = notificationQueue[i]
			
			if pnl.id == self.id and !self.isMoving then
				
				local currX,currY = self:GetPos()
				local panelY = startY + (85*(i-1))
				
				if panelY ~= currY then
					self.isMoving = true
					self:MoveTo( currX, panelY, 0.25, 0, -1, function()
						
						self.isMoving = false
						
						if self.waitingForSlideBack then
							self:SlideBack()
						end
						
					end)
				end		
			
			end
			
		end
		  
	end
	
	return id
	
end

local function AddSkinNotification(text, skin, class)
	
	local skinNotification = vgui.Create("p_easyskins_skin_notification")
	local notificationID = AddNotificationToQueue(skinNotification)
	
	local skinPnlTall = 80
	local panelY = startY + ((5+skinPnlTall)*(#notificationQueue-1))
	
	skinNotification:Init(true, text, skin, class,ttl,panelY)
	
end

function CL_EASYSKINS.ReceiveSkinNotification(skin,class,amount)

	if !SH_EASYSKINS.SETTINGS.ENABLENOTIFICATIONS then return end
	
	local txt = CL_EASYSKINS.Translate("received")
	local amountStr = ''
	
	if amount ~= nil and amount > 1 then
		amountStr = 'x'..amount
	end

	AddSkinNotification(txt..' '..skin.dispName..' '..amountStr, skin, class)
	
end

local function ReceiveSkinNotification()
	
	local skinID = net.ReadInt(16)
	local class = net.ReadString()
	local amount = net.ReadInt(16)
	local skin = SH_EASYSKINS.GetSkin(skinID)
	
	if !skin then return end
	
	CL_EASYSKINS.ReceiveSkinNotification(skin,class,amount)

end
net.Receive("cl_easyskins_ReceiveSkinNotification",ReceiveSkinNotification)