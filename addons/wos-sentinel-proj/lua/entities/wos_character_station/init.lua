AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/wos/alcs/stations/skill.mdl" )
	self:DrawShadow(true)
	self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	self.BuildingSound:Play()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:SetUseType( SIMPLE_USE )
	//self:SetSolid( SOLID_VPHYSICS )
	//self:PhysWake()

end

function ENT:Use( ply )

	net.Start( "wOS.Crafting.GetInventory" )
		net.WriteTable( ply.SaberInventory )
		net.WriteTable( ply.SaberMiscItems )
	net.Send( ply )
	ply:SendLua( [[wOS.ALCS.Skills:OpenSkillsMenu()]] )

	if ConVarExists("simple_thirdperson_maxdistance") then
        ply:ConCommand("simple_thirdperson_enabled 0")
    end
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos - tr.HitNormal * 2

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS

end
