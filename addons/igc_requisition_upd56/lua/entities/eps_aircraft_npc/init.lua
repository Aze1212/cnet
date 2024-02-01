AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(NCS_REQUISITION.CFG.NPC_MODEL)

    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_BBOX)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end

        timer.Simple(0, function()
            if IsValid(self) and NCS_REQUISITION.CFG.VENDOR_RANDOMIZE then
                local COUNT = self:SkinCount()
                local SKIN = math.random(1, COUNT)

                self:SetSkin(SKIN)
                self:ResetSequence(table.Random(NCS_REQUISITION.CFG.Stances))

                for k, v in ipairs(self:GetBodyGroups()) do
                    local STACK = v.submodels
                    local _, key = table.Random(STACK)

                    self:SetBodygroup(k, key)
                end
            end
        end)
end

function ENT:Use(activator)
	net.Start("NCS_REQUISITION.MENU")
	net.Send(activator)
end

function ENT:OnTakeDamage()
    return 0
end