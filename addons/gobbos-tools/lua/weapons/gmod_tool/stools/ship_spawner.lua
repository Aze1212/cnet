TOOL.Category = "Gobbo's Tools"
TOOL.Name = "Reinforcements"
TOOL.Command = nil
TOOL.ConfigName = ""

local AllVars = {
	NPCClass = "npc_b1base",
	ShipModel = "models/syphadias/starwars/gunship.mdl",
	ShipScale = "1",
	NPCWeapon = "arccw_e5",
	NPCModel = "",
	MinSpawnTime = "3",
	MaxSpawnTime = "8",
	NPCHealth = "300",
	ShipHealth = "500",
	ShipShield = "5000",
	NPCAmount = "5",
	NPCWepDiff = "1",
	NPCRelations = "1",
}

table.Merge(TOOL.ClientConVar, AllVars)

local currentIndicator = nil

function TOOL:LeftClick(trace)
	if SERVER or not IsFirstTimePredicted() then return end

	net.Start("ixSpawnShip")
		net.WriteVector(currentIndicator:GetPos() - Vector(0, 0, 100))
		net.WriteEntity(self:GetOwner())

		local vars = {}

		for k, v in pairs(AllVars) do
			vars[k] = self:GetClientInfo(k)
		end

		net.WriteTable(vars)

	net.SendToServer()
end

function TOOL:RightClick()
	return false
end

function TOOL:AssignVars(ent)
	for k, v in pairs(AllVars) do
		ent:SetKeyValue(k, self:GetClientInfo(k))
	end
end

function TOOL:Think()
	if SERVER then return end

	if not IsValid(currentIndicator) then
		local model = self:GetClientInfo("ShipModel")

		util.PrecacheModel(model)

		currentIndicator = ents.CreateClientProp(model)
		currentIndicator:SetModelScale(self:GetClientInfo("ShipScale"))
		currentIndicator:SetMaterial("models/wireframe")

		currentIndicator:SetMoveType(MOVETYPE_NONE)
		currentIndicator:SetSolid(SOLID_NONE)
		currentIndicator:SetCollisionGroup(COLLISION_GROUP_NONE)

		currentIndicator:Spawn()
	end

	local trace = LocalPlayer():GetEyeTrace()

	if not trace.HitPos then return end

	currentIndicator:SetPos(trace.HitPos + Vector(0, 0, 300))
	-- If model is different then delete current indicator and create a new one
	if currentIndicator:GetModel() ~= self:GetClientInfo("ShipModel") then
		currentIndicator:Remove()
	end
end

function TOOL:Holster()
	if SERVER then return end

	if IsValid(currentIndicator) then
		currentIndicator:Remove()
	end
end

local FindCVars = TOOL:BuildConVarList()

function TOOL.BuildCPanel(pnl)
	pnl:SetName("Gobbo's Reinforcements")

	pnl:AddControl(
		"Header",
		{
			Text = "Gobbo's Reinforcements",
			Description = "Spawn in a ship that will deploy NPCs of your choice."
		}
	)

	pnl:AddControl(
		"ComboBox",
		{
			MenuButton = 1,
			Folder = "ship_spawner",
			Options = {
				["#preset.default"] = FindCVars
			},
			CVars = table.GetKeys(FindCVars)
		}
	)

	-------------------------------------------------------------------------------------------------------
	pnl:TextEntry("NPC Class", "ship_spawner_NPCClass")
	pnl:ControlHelp("Paste the class of the NPC you want to use.")
	-------------------------------------------------------------------------------------------------------
	pnl:TextEntry("NPC Model", "ship_spawner_NPCModel")
	pnl:ControlHelp("Paste the model path here to override the NPCs model. Leave blank if you want to use the NPCs default model.")
	-------------------------------------------------------------------------------------------------------
	pnl:TextEntry("Ship Model", "ship_spawner_ShipModel")
	pnl:ControlHelp("Set the model of the ship itself.")
	
	pnl:NumSlider("Ship Scale", "ship_spawner_ShipScale", 0.1, 2, 1)
	pnl:ControlHelp("Set the scale of the ship.")
	-------------------------------------------------------------------------------------------------------
	pnl:NumSlider("Ship Health", "ship_spawner_ShipHealth", 500, 10000, 0)
	pnl:ControlHelp("Set the health of the ship itself.")

	pnl:NumSlider("Ship Shield", "ship_spawner_ShipShield", 0, 10000, 0)
	pnl:ControlHelp("Set the shield of the ship itself.")
	-------------------------------------------------------------------------------------------------------
	pnl:TextEntry("NPC Weapon", "ship_spawner_NPCWeapon")
	pnl:ControlHelp("What weapon should the NPC have, this is a weapon ID/class, not a model.")
	-------------------------------------------------------------------------------------------------------
	pnl:NumSlider("Min Spawn Time", "ship_spawner_MinSpawnTime", 1, 5, 0)
	pnl:ControlHelp("How long before the NPCs start spawning in.")
	-------------------------------------------------------------------------------------------------------
	pnl:NumSlider("Max Spawn Time", "ship_spawner_MaxSpawnTime", 6, 15, 0)
	pnl:ControlHelp("How long should it take for the last NPC to spawn in.")
	-------------------------------------------------------------------------------------------------------
	pnl:NumSlider("NPC Health", "ship_spawner_NPCHealth", 1, 10000, 0)
	pnl:ControlHelp("Set the health of the NPCs that spawn.")
	-- if you increase the max value of 20 then you need to add more vectors inside the init.lua file of the entity.
	pnl:NumSlider("NPC Amount", "ship_spawner_NPCAmount", 1, 20, 0)
	pnl:ControlHelp("How many NPCs should spawn from the drop pod.")
	-------------------------------------------------------------------------------------------------------
	local WepBox = pnl:ComboBox("Weapon Difficulty", "ship_spawner_NPCWepDiff")
	WepBox:AddChoice("Poor", WEAPON_PROFICIENCY_POOR)
	WepBox:AddChoice("Average", WEAPON_PROFICIENCY_AVERAGE)
	WepBox:AddChoice("Good", WEAPON_PROFICIENCY_GOOD)
	WepBox:AddChoice("Great", WEAPON_PROFICIENCY_VERY_GOOD)
	WepBox:AddChoice("Perfect", WEAPON_PROFICIENCY_PERFECT)
	pnl:ControlHelp("How good should these NPCs be when they fire their weapons.")
	-------------------------------------------------------------------------------------------------------
	local RelationBox = pnl:ComboBox("NPC Relationship", "ship_spawner_NPCRelations")
	RelationBox:AddChoice("Enemy", "1")
	RelationBox:AddChoice("Friendly", "3")
	pnl:ControlHelp("Choose how NPCs react to all players.")
end

if CLIENT then
	language.Add("tool.ship_spawner.name", "Reinforcements")
	language.Add("tool.ship_spawner.desc", "Spawns reinforcements of NPCs of your choice")
	language.Add("tool.ship_spawner.0", "Left Click to summon reinforcements")
	language.Add("Undone_ship_spawner", "Undone Reinforcements")
else
	util.AddNetworkString("ixSpawnShip")
	net.Receive(
		"ixSpawnShip",
		function(len, ply)
			print("[Gobbo] " .. ply:GetName() .. " Has Spawned a dropship")
			
			if not ply:IsAdmin() then return end
			
			local pos = net.ReadVector()
			local owner = net.ReadEntity()
			local clientInfo = net.ReadTable()
			-- Create a random position with a minimum distance of 4000 units and a maximum of 6000 units
			local dist = VectorRand() * 9000
			local ship = ents.Create("base_ship")

			-- Assign the vars to the ship
			for k, v in pairs(clientInfo) do
				ship:SetKeyValue(k, v)
			end

			ship:SetGoal(pos)
			ship:SetPos(Vector(dist.x, dist.y, pos.z + 2000))
			ship:Spawn()
			-- Set the ship's angles to face the goal
			ship:SetAngles((pos - ship:GetPos()):Angle() - Angle(80, 0, 0))
			ship:MoveToGoal()

			undo.Create("ship_spawner")
				undo.AddEntity(ship)
				undo.SetPlayer(owner)
			undo.Finish()
		end
	)
end