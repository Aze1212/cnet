AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local HOVER_TIME = 10
local FLY_TIME = 25

local spawnTable = {
	Vector(90, 90, 1),
	Vector(-90, 90, 1),
	Vector(-90, -90, 1),
	Vector(90, -90, 1),
	Vector(-45, 90, 1),
	Vector(59, 90, 1),
	Vector(73, 75, 1),
	Vector(34, -85, 1),
	Vector(-130, 85, 1),
	Vector(-177, -95, 1),
	Vector(90, 85, 1),
	Vector(90, -85, 1),
	Vector(120, 45, 1),
	Vector(155, 120, 1),
	Vector(-120, 45, 1),
	Vector(155, -120, 1),
	Vector(60, -140, 1),
	Vector(-60, 140, 1),
	Vector(-60, -140, 1),
	Vector(195, -70, 1)
}

local NPCClass, NPCModel, NPCWeapon, NPCHealth, NPCAmount, MinSpawn, MaxSpawn, WepDiff, NPCRelations, ShipScale, ShieldHealth

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_NONE)

	self:SetSolidFlags(FSOLID_TRIGGER)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:SetMass(1000)
		phys:Wake()
	end

	self.ShadowParams = {}
	self.InitalAngles = self:GetAngles()
	self.ShieldHealth = ShieldHealth or 0
	self:SetState("idle")
end

function ENT:TestCollision( startpos, delta, isbox, extents )
	print(startpos, delta, isbox, extents)
	if ( isbox ) then return end
	if ( !widgets.Tracing ) then return end

	-- TODO. Actually trace against our cube!

	return
	{
		HitPos		= self:GetPos(),
		Fraction	= 0.5 * self:GetPriority()
	}

end

function ENT:Think()
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0, 0, 600),
		filter = self
	})

	if tr.Hit then
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetEntity(self)
		-- Set scale depending on height to the floor 1000 being the max
		local scale = math.Clamp(1000 - tr.Fraction * 1000, 0, 1000)
		effectdata:SetScale(scale)

		util.Effect("ThumperDust", effectdata)
	end
end

function ENT:MoveToGoal()
	self:SetState("moving_to_goal")
	self:StartMotionController()

	local goal = self:GetGoal()
	local goalAngles = (goal - self:GetPos()):Angle()

	self.ShadowParams = {
		secondstoarrive = 2,
		pos = goal,
		angle = Angle(-16, goalAngles.y, 0),
		maxangular = 50000,
		maxangulardamp = 10000,
		maxspeed = 1000000,
		maxspeeddamp = 10000,
		dampfactor = 0.8,
		teleportdistance = 0,
		deltatime = 0
	}

	timer.Create("ShipHover" .. self:EntIndex(), HOVER_TIME, 1, function()
		self.InitalAngles = self:GetAngles()
		self:SetState("hovering")
		self:SummonNPC(NPCClass)

		self.ShadowParams.angle = Angle(0, goalAngles.y, 0)
	end)

	timer.Create("ShipFly" .. self:EntIndex(), FLY_TIME, 1, function()
		self:SetState("flying_away")

		local flyGoal = Vector(goal.x, goal.y, goal.z + 5000) + self.InitalAngles:Forward() * 30000
		local skyAngle = Angle(-25, self.InitalAngles.y, 0)

		self.ShadowParams = {
			secondstoarrive = 1,
			pos = flyGoal,
			angle = skyAngle,
			maxangular = 10,
			maxangulardamp = 100,
			maxspeed = 100,
			maxspeeddamp = 10000,
			dampfactor = 0.8,
			teleportdistance = 0,
			deltatime = 0
		}

		timer.Simple(6, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end)
end

function ENT:PhysicsSimulate(phys, deltatime)
	local state = self:GetState()

	if state == "flying_away" then
		self.ShadowParams.secondstoarrive = self.ShadowParams.secondstoarrive - 0.2
		self.ShadowParams.maxspeed = self.ShadowParams.maxspeed + 6

		-- We want a hover effect but we want to keep the ship looking upwards
	elseif state == "hovering" then
		local angles = self:GetAngles()

		angles.x = angles.x + math.sin(CurTime() * 3) * 0.04
		angles.z = angles.z + math.sin(CurTime() * 3) * 0.04

		self:SetAngles(angles)
	elseif state == "moving_to_goal" then
		if self.ShadowParams.angle.x < 0 and self.ShadowParams.pos:Distance(self:GetPos()) < 300 then
			self.ShadowParams.angle = Angle(self.ShadowParams.angle.x + 0.5, self.ShadowParams.angle.y, 0)
		end

		-- We're coming in, so give it a bit of a hover effect, but have it tilt downwards more for landing effect
		local angles = self:GetAngles()

		angles.x = angles.x + math.sin(CurTime() * 3) * 0.04
		angles.z = angles.z + math.sin(CurTime() * 3) * 0.04

		self:SetAngles(angles)
	end

	self.ShadowParams.deltatime = deltatime
	phys:ComputeShadowControl(self.ShadowParams)
end

function ENT:KeyValue(TKey, TValue)
	if TKey == "NPCClass" then NPCClass = TValue end
	if TKey == "NPCModel" then NPCModel = TValue end
	if TKey == "NPCWeapon" then NPCWeapon = TValue end
	if TKey == "NPCHealth" then NPCHealth = TValue end
	if TKey == "MinSpawnTime" then MinSpawn = TValue end
	if TKey == "MaxSpawnTime" then MaxSpawn = TValue end
	if TKey == "ShipHealth" then self:SetHealth(TValue) self:SetMaxHealth(TValue) end
	if TKey == "NPCAmount" then NPCAmount = TValue end
	if TKey == "NPCWepDiff" then WepDiff = TValue end
	if TKey == "NPCRelations" then NPCRelations = TValue end
	if TKey == "ShipModel" then self:SetModel(TValue) end
	if TKey == "ShipScale" then ShipScale = TValue self:SetModelScale(TValue) end
	if TKey == "ShipShield" then ShieldHealth = tonumber(TValue) self:SetShieldHealth(tonumber(TValue)) end
end

function ENT:SummonNPC(Class)
	local AllNPCs = list.Get("NPC")
	local CheckClass = AllNPCs[Class]
	if not CheckClass then return end

	for i = 1, NPCAmount do
		timer.Simple(math.random(MinSpawn, MaxSpawn), function()
			if not IsValid(self) then return end

			local SpawnNPC = ents.Create(CheckClass.Class)
			if not IsValid(SpawnNPC) then return end

			local spawnPosition = self:GetPos() + spawnTable[i]
			SpawnNPC:SetPos(spawnPosition)

			if NPCModel ~= "" then
				SpawnNPC:SetModel(NPCModel)
			elseif CheckClass.Model then
				SpawnNPC:SetModel(CheckClass.Model)
			end

			timer.Simple(0.1, function()
				SpawnNPC:SetHealth(NPCHealth)
				SpawnNPC:SetMaxHealth(NPCHealth)
			end)

			SpawnNPC:Give(NPCWeapon)
			SpawnNPC:SetCurrentWeaponProficiency(WepDiff)

			for _, ply in ipairs(player.GetAll()) do
				local relation = NPCRelations == "1" and D_HT or D_LI
				SpawnNPC:AddEntityRelationship(ply, relation, 99)

				for _, ent in ipairs(ents.FindByClass("npc_*")) do
					if ent:GetEnemy() == ply and ent:GetEnemy() ~= SpawnNPC then
						local entRelation = NPCRelations == "1" and D_LI or D_HT
						SpawnNPC:AddEntityRelationship(ent, entRelation, 99)
						ent:AddEntityRelationship(SpawnNPC, entRelation, 99)
					end
				end
			end

			SpawnNPC:Spawn()
			SpawnNPC:Activate()
		end)
	end

	return SpawnNPC
end

function ENT:OnTakeDamage(dmg)
	local damage = dmg:GetDamage()

	local dmgNormal = -dmg:GetDamageForce():GetNormalized()
	local dmgPos = dmg:GetDamagePosition()

	if self.ShieldHealth > 0 then
		self.ShieldHealth = self.ShieldHealth - damage

		local effectdata = EffectData()
			effectdata:SetOrigin( dmgPos )
			effectdata:SetEntity( self )
		util.Effect( "gob_shield_deflect", effectdata )

		if self.ShieldHealth < 0 then
			self.ShieldHealth = 0
		end
	else
		local effectdata = EffectData()
			effectdata:SetOrigin( dmgPos )
			effectdata:SetNormal( dmgNormal )
		util.Effect( "MetalSpark", effectdata )

		self:SetHealth(self:Health() - damage)
		if self:Health() <= 0 then
			self:SetSolid(SOLID_VPHYSICS)
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
	local phys = self:GetPhysicsObject()
	phys:SetMass(10000)

	self:StopMotionController()


	local min, max = self:GetModelBounds()

	for i = 1, 50 do
		timer.Simple(i * 0.1, function()
			if IsValid(self) and lastExplosionTime + math.random(0.5, 1) < CurTime() then
				local randomPos = Vector(math.random(min.x, max.x), math.random(min.y, max.y), math.random(min.z, max.z)) * 0.5 * ShipScale

				self:SpawnExplosion(self:GetPos() + randomPos)

				lastExplosionTime = CurTime()
			end
		end)
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

function ENT:SetState(state)
	self.state = state
end

function ENT:GetState()
	return self.state
end

function ENT:SetShieldHealth(health)
	self.ShieldHealth = health
end

function ENT:IsState(state)
	return self.state == state
end

function ENT:SetGoal(goal)
	self.goal = Vector(goal.x, goal.y, goal.z + 100)
end

function ENT:GetGoal()
	return self.goal
end

function ENT:OnRemove()
	self:StopMotionController()

	-- Clear all timers
	timer.Remove("ShipHover" .. self:EntIndex())
	timer.Remove("ShipFly" .. self:EntIndex())
end
