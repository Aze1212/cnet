AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local Speed, ShieldHealth, ShipScale

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self.currentWaypoint = nil
	self.ShieldHealth = ShieldHealth or 0
	if not self.currentWaypoint and #self.waypoints > 1 then
		self.currentWaypoint = self.waypoints[1]
		local angles = (self.waypoints[2] - self:GetPos()):Angle()
		self:SetPos(self.currentWaypoint)
		self:SetAngles(Angle(0, angles.y, 0))
	end

	self.ShadowParams = {}
	self.BaseMaterial = self.BaseMaterial or self:GetMaterial()
	self:StartMotionController()
end

function ENT:SetShieldHealth(health)
	-- Conver to number
	ShieldHealth = tonumber(health)
end

function ENT:PhysicsSimulate(phys, deltatime)
	if not self.currentWaypoint then return end
	local pos = self:GetPos()
	local vel = self:GetVelocity()
	local dir = (self.currentWaypoint - pos):GetNormal()
	local speed = Speed * 100
	local accel = Speed * 100
	local deccel = Speed * 100
	-- if dist < 1 then
	-- 	speed = 0
	-- 	accel = 0
	-- 	deccel = 0
	-- end
	local targetVel = dir * speed
	local velDiff = targetVel - vel
	local velDiffN = velDiff:GetNormal()
	local velDiffL = velDiff:Length()
	local accelN = velDiffN * accel
	local accelL = accelN:Length()
	if accelL > velDiffL then
		accelN = velDiffN * velDiffL
	end

	local deccelN = velDiffN * deccel
	local deccelL = deccelN:Length()
	if deccelL > velDiffL then
		deccelN = velDiffN * velDiffL
	end

	local force = accelN
	if velDiffL < 0.1 then
		force = deccelN
	end

	-- Look towards the waypoint
	local nextWaypoint = self:GetNextWaypoint() or self.currentWaypoint
	local nextWaypointAngle = (nextWaypoint - pos):Angle()
	local currentWaypointAngle = (self.currentWaypoint - pos):Angle()
	local goalPosition = pos + vel * deltatime + 0.5 * force * deltatime * deltatime
	-- Lock the Z axis
	goalPosition.z = self.currentWaypoint.z
	self.ShadowParams.secondstoarrive = 0.1
	self.ShadowParams.pos = goalPosition
	self.ShadowParams.angle = Angle(nextWaypointAngle.x, currentWaypointAngle.y, 0)
	self.ShadowParams.maxangular = 40
	self.ShadowParams.maxangulardamp = 10000
	self.ShadowParams.maxspeed = 1000000
	self.ShadowParams.maxspeeddamp = 10000
	self.ShadowParams.dampfactor = 0.8
	self.ShadowParams.teleportdistance = 0
	self.ShadowParams.deltatime = deltatime
	phys:ComputeShadowControl(self.ShadowParams)
end

function ENT:SetWaypoints(waypoints)
	self.waypoints = waypoints
end

function ENT:GetNextWaypoint()
	local currentWaypoint = self.currentWaypoint
	if not currentWaypoint then return end
	local index = table.KeyFromValue(self.waypoints, currentWaypoint)
	if index then
		index = index + 1
		if self.waypoints[index] then return self.waypoints[index] end
	end

	return nil
end

function ENT:Think()
	self:CreateSmoke()
	if not self.currentWaypoint or #self.waypoints == 0 then return end
	local dist = self:GetPos():Distance(self.currentWaypoint)
	if dist < 30 then
		local index = table.KeyFromValue(self.waypoints, self.currentWaypoint)
		if index then
			index = index + 1
			if self.waypoints[index] then
				self.currentWaypoint = self.waypoints[index]
			else
				self.currentWaypoint = nil
			end
		end
	end
end

function ENT:OnTakeDamage(dmg)
	local damage = dmg:GetDamage()

	if self.ShieldHealth > 0 then
		self.ShieldHealth = self.ShieldHealth - damage

		local effectdata = EffectData()
			effectdata:SetOrigin( dmg:GetDamagePosition() )
			effectdata:SetEntity( self )
		util.Effect( "gob_shield_deflect", effectdata )

		if self.ShieldHealth < 0 then
			self.ShieldHealth = 0
		end
	else
		self:SetHealth(self:Health() - damage)
		if self:Health() <= 0 then
			self:Explode()
			timer.Simple(
				8,
				function()
					if IsValid(self) then
						self:Remove()
					end
				end
			)
		end
	end
end

local lastExplosionTime = 0
function ENT:Explode()
	-- Set position randomly based on the bounding box of the model
	self:StopMotionController()
	local min, max = self:GetModelBounds()
	for i = 1, 50 do
		timer.Simple(
			i * 0.1,
			function()
				if IsValid(self) and lastExplosionTime + math.random(0.2, 0.5) < CurTime() then
					local randomPos = Vector(math.random(min.x, max.x), math.random(min.y, max.y), math.random(min.z, max.z)) * 0.5 * ShipScale
					self:SpawnExplosion(self:GetPos() + randomPos)
					lastExplosionTime = CurTime()
				end
			end
		)
	end
end

function ENT:SpawnExplosion(pos)
	local explosion = ents.Create("env_explosion")
	explosion:SetPos(pos)
	explosion:SetOwner(self)
	explosion:Spawn()
	explosion:SetKeyValue("iMagnitude", "500")
	explosion:SetKeyValue("iRadiusOverride", "400")
	explosion:Fire("Explode", 0, 0)
end

function ENT:CreateSmoke()
	local tr = util.TraceLine(
		{
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0, 0, 200),
			filter = self
		}
	)

	if tr.Hit then
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetEntity(self)
		effectdata:SetMagnitude(100)
		effectdata:SetScale(300)
		util.Effect("ThumperDust", effectdata)
	end
end

function ENT:OnRemove()
	self:StopMotionController()
end

function ENT:SetKeyValues(model, scale, speed, health, shieldHealth)
	self:SetModel(model)
	ShipScale = scale
	self:SetModelScale(scale)
	self:SetHealth(health)
	self:SetShieldHealth(shieldHealth)
	Speed = speed

	self.BaseMaterial = self:GetMaterial()
end