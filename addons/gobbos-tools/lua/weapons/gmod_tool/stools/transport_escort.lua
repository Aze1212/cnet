TOOL.Category = "Gobbo's Tools"
TOOL.Name = "#tool.transport_escort.name"
TOOL.Command = nil
TOOL.ConfigName = ""

local currentWaypoints = {}

local zOffset = 50

local ToolVars = {
	ConvoyModel = "models/props_junk/wood_crate001a.mdl",
	ConvoyScale = 1,
	Speed = 100,
	Health = 10000,
	ShieldHealth = 10000
}

table.Merge(TOOL.ClientConVar, ToolVars)

local function CreatePoint(trace)
	table.insert(currentWaypoints, Vector(trace.HitPos.x, trace.HitPos.y, trace.HitPos.z + zOffset))
end

local function RemovePoint(trace)
	-- Get the closest point to where the user is trying to right click
	local closest = nil
	local threshold = 200

	for k, v in pairs(currentWaypoints) do
		local dist = v:Distance(trace.HitPos)

		if dist < threshold then
			closest = v
			threshold = dist
		end
	end

	-- Remove the closest point
	for k, v in pairs(currentWaypoints) do
		if v == closest then
			table.remove(currentWaypoints, k)
			break
		end
	end
end

function TOOL:LeftClick(trace)
	if not IsFirstTimePredicted() then return end

	-- If SHIFT is held, summon the convoy
	if CLIENT and input.IsKeyDown(KEY_LSHIFT) then
		net.Start("ixSummonConvoy")
			net.WriteTable(currentWaypoints)

			local vars = {}

			for k, v in pairs(ToolVars) do
				vars[k] = self:GetClientInfo(k)
			end

			net.WriteTable(vars)
		net.SendToServer()

		return true
	end

	CreatePoint(trace)

	return true
end

function TOOL:RightClick(trace)
	if not IsFirstTimePredicted() then return end

	RemovePoint(trace)

	return true
end

function TOOL:Reload()
	if not IsFirstTimePredicted() then return end

	currentWaypoints = {}

	return false
end

function TOOL:DrawPoints()
	-- Draw each point as a sphere, first point is green, last point is red, all others are white, line is white, using render
	for k, v in pairs(currentWaypoints) do
		local pos = v - Vector(0, 0, zOffset)

		render.SetMaterial(Material("models/wireframe"))
		render.DrawSphere(pos, 20, 20, 10, Color(255, 0, 0))

		if k > 1 then
			local prev = currentWaypoints[k - 1] - Vector(0, 0, zOffset)
			render.DrawLine(pos, prev, Color(255, 255, 255, 255))
		end
	end
end

function TOOL:DrawHUD()
	cam.Start3D()
		self:DrawPoints()
	cam.End3D()

	-- Draw numbers on each point
	for k, v in pairs(currentWaypoints) do
		local pos = v - Vector(0, 0, zOffset)
		local screenPos = pos:ToScreen()

		draw.SimpleTextOutlined(k, "HudDefault", screenPos.x, screenPos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1.5, Color(0, 0, 0))
	end
end

local FindCVars = TOOL:BuildConVarList()

function TOOL.BuildCPanel(pnl)
	pnl:SetName("Gobbo's Convoys")

	pnl:AddControl(
		"Header",
		{
			Text = "Convoy Waypoints",
			Description = "Create a path for a convoy to follow"
		}
	)

	pnl:AddControl(
		"ComboBox",
		{
			MenuButton = 1,
			Folder = "transport_escort",
			Options = {
				["#preset.default"] = FindCVars
			},
			CVars = table.GetKeys(FindCVars),
		}
	)

	pnl:TextEntry("Convoy Model", "transport_escort_ConvoyModel")
	pnl:ControlHelp("The model of the convey to spawn")

	pnl:NumSlider("Convoy Scale", "transport_escort_ConvoyScale", 0, 2, 1)
	pnl:ControlHelp("The scale of the convoy")

	pnl:NumSlider("Convoy Speed", "transport_escort_Speed", 50, 500, 0)
	pnl:ControlHelp("The speed in which the convoy will travel between waypoints")

	pnl:NumSlider("Convoy Health", "transport_escort_Health", 0, 10000, 0)
	pnl:ControlHelp("The health of the convoy")

	pnl:NumSlider("Convoy Shield Health", "transport_escort_ShieldHealth", 0, 10000, 0)
	pnl:ControlHelp("The shield health of the convoy")
end

if CLIENT then
		language.Add("tool.transport_escort.name", "Convoy Waypoints")
		language.Add("tool.transport_escort.desc", "Create a path for a convoy to follow")
		language.Add("tool.transport_escort.0", "Left Click: to add a waypoint. Right Click: to remove a waypoint. Reload: to clear all waypoints")
		language.Add("Undone_transport_escort", "Convoy has been removed.")
else
	util.AddNetworkString("ixSummonConvoy")

	net.Receive("ixSummonConvoy", function(len, ply)
		local waypoints = net.ReadTable()
		local vars = net.ReadTable()

		local convoy = ents.Create("base_convoy")
		convoy:SetPos(waypoints[1])
		convoy:SetKeyValues(vars.ConvoyModel, vars.ConvoyScale, vars.Speed, vars.Health, vars.ShieldHealth)
		convoy:SetWaypoints(waypoints)
		convoy:Spawn()

		-- Make undos work
		undo.Create("transport_escort")
			undo.AddEntity(convoy)
			undo.SetPlayer(ply)
		undo.Finish()
	end)
end

