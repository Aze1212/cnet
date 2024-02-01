
--[[

Editing the Lightsabers.

Once you unpack the lightsaber addon, you are voided of any support as to why it doesn't work.
I can't possibly provide support for all the edits and I can't know what your edits broke or whatever.

 /////////////////////////////// DO NOT REUPLOAD THIS ADDON IN ANY SHAPE OF FORM. ///////////////////////////////
 /////////////////////////////// DO NOT REUPLOAD THIS ADDON IN ANY SHAPE OF FORM. ///////////////////////////////
 /////////////////////////////// DO NOT REUPLOAD THIS ADDON IN ANY SHAPE OF FORM. ///////////////////////////////
 /////////////////////////////// DO NOT REUPLOAD THIS ADDON IN ANY SHAPE OF FORM. ///////////////////////////////
 /////////////////////////////// DO NOT REUPLOAD THIS ADDON IN ANY SHAPE OF FORM. ///////////////////////////////

////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////
////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////
////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////
////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////
////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////
////////////////////////// DO NOT EDIT ANYTHING DOWN BELOW OR YOU LOSE SUPPORT FROM ME //////////////////////////

]]

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Lightsaber"
ENT.Category = "Robotboy655's Entities"

ENT.Editable = true
ENT.Spawnable = true

ENT.ThrowTime = 0
ENT.IsLightsaber = true
ENT.IsThrownLightsaber = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.CustomSettings = {}
ENT.CLastUpdate = 0
ENT.NoBlade = false //Change this if you want to make throwable lightsabers not have the blade

function ENT:SoundInit()
	self.SoundSwing = CreateSound( self, self.SwingSound )
	if ( self.SoundSwing ) then self.SoundSwing:Play() self.SoundSwing:ChangeVolume( 0, 0 ) end

	self.SoundHit = CreateSound( self, "lightsaber/saber_hit.wav" )
	if ( self.SoundHit ) then self.SoundHit:Play() self.SoundHit:ChangeVolume( 0, 0 ) end

	self.SoundLoop = CreateSound( self, self.LoopSound )
	if ( self.SoundLoop ) then self.SoundLoop:Play() end
end

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "LastUpdate" )
	self:NetworkVar( "Bool", 0, "Enabled" )
	self:NetworkVar( "Vector", 0 , "EndPos" )
	self:NetworkVar( "String", 0, "WorldModel" )
	self:NetworkVar( "Int", 0, "Stage" )

	self:SetupDataDescs()
	self:SetBladeLength( 0 ) //This is clientside only now but this is a good place to initialize this

	if ( SERVER ) then
		self:SetStage( 0 )
		self:SetLastUpdate( 0 )
		self:SetDarkInner( false )
		self:SetEnabled( true )
	end
end


function ENT:Initialize()

	self.CLastUpdate = 0
	self.BladeLength = 0
	if ( SERVER ) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_NONE )

		self.LoopSound = self.LoopSound || "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
		self.SwingSound = self.SwingSound || "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"
		self.OnSound = self.OnSound || "lightsaber/saber_on" .. math.random( 1, 2 ) .. ".wav"
		self.OffSound = self.OffSound || "lightsaber/saber_off" .. math.random( 1, 2 ) .. ".wav"

		self:SoundInit()

		self:GetPhysicsObject():EnableGravity(false)
		self:GetPhysicsObject():Wake()
	else
		self:SetRenderBounds( Vector( -200, -128, -128 ), Vector( 200, 128, 128 ) )

		language.Add( self.ClassName, self.PrintName )
		killicon.AddAlias( "ent_lightsaber", "weapon_lightsaber" )
	end
	self:StartMotionController()
end

function ENT:OnRemove()
	if ( CLIENT ) then rb655_SaberClean_wos( self:EntIndex() ) return end

	if ( self.SoundLoop ) then self.SoundLoop:Stop() self.SoundLoop = nil end
	if ( self.SoundSwing ) then self.SoundSwing:Stop() self.SoundSwing = nil end
	if ( self.SoundHit ) then self.SoundHit:Stop() self.SoundHit = nil end

end

function ENT:GetSaberPosAng( num, q )
	num = num || 1

	local att = "blade" .. num
	if q then
		att = "quillon" .. num
	end
	local attachment = self:LookupAttachment( att )
	if ( attachment > 0 ) then
		local PosAng = self:GetAttachment( attachment )
		return PosAng.Pos, PosAng.Ang:Forward()
	end

	return self:LocalToWorld( Vector( 1, -0.58, -0.25 ) ), -self:GetAngles():Forward()

end

function ENT:CheckUpdates()
	if self.CLastUpdate != self:GetLastUpdate() then
		net.Start( "wOS.ALCS.DataDesc.Sync")
			net.WriteUInt( self:EntIndex(), 16 )
			net.WriteFloat( self.CLastUpdate )
		net.SendToServer()
		self.CLastUpdate = self:GetLastUpdate()
	end
end


function ENT:Draw()

	self:CheckUpdates()
	self:DrawModel()

	if ( halo.RenderedEntity && IsValid( halo.RenderedEntity() ) && halo.RenderedEntity() == self ) then return end
	
	self:DrawModel()

	if self.NoBlade then return end

	local blades = 0

	for id, t in pairs( self:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum )
			local clr = self:GetUseColor( bladeNum )
			local clr_inner = self:GetUseInnerColor( bladeNum )
			local maxlen = self:GetUseLength( bladeNum )
			local width = self:GetUseWidth( bladeNum )
			local darkinner = self:GetUseDarkInner( bladeNum )
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, self.CustomSettings )
		end

		if ( quillonNum && self:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true )
			local clr = self:GetUseColor()
			local clr_inner = self:GetUseInnerColor()
			local maxlen = self:GetUseLength()
			local width = self:GetUseWidth()
			local darkinner = self:GetUseDarkInner()
			rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, self.CustomSettings )
		end

	end

end

local params = {}
params.secondstoarrive = 0.0001 --this is probably cheating.
params.dampfactor = 0.9999
params.teleportdistance = 0
params.maxangular = 800000
params.maxangulardamp = 9000
params.maxspeed = 100000
params.maxspeeddamp = params.maxangulardamp

function ENT:PhysicsSimulate( phys, time )

	local ply = self.Owner or self:GetOwner()
	if not IsValid(ply) then return end

	phys:Wake()
	
	local pos = ply:EyePos() - Vector( 0, 0, 8 )
	local newpos = Vector( pos.x + 50*math.cos( CurTime()*10 ), pos.y + 50*math.sin( CurTime()*10 ), pos.z )		
	if self.Second then
		newpos = Vector( pos.x + 50*math.cos( CurTime()*10 + 180 ), pos.y + 50*math.sin( CurTime()*10 + 180 ), pos.z )		
	end


	params.deltatime = time
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 300 )
	params.angle = ang
	params.pos = newpos
	phys:ComputeShadowControl(params)
	
end

/////////// Data Desc Stuff


function ENT:DataDesc( desc, typ )
	wOS.ALCS.DataDesc:Install( self, desc, typ )
end

function ENT:RemoveDataDesc( desc )
	wOS.ALCS.DataDesc:Delete( self, desc )
end

function ENT:SetupDataDescs()
	self:DataDesc( "UseColor", WOS_ALCS.DATADESC.TBLCOLOR )
	self:DataDesc( "UseLength", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseWidth", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseDarkInner", WOS_ALCS.DATADESC.TBLBOOL )
	self:DataDesc( "UseInnerColor", WOS_ALCS.DATADESC.TBLCOLOR )

	self:DataDesc( "CustomSettings", WOS_ALCS.DATADESC.VARARG )

	hook.Call( "wOS.ALCS.Lightsaber.RegisterDataDesc", nil, self )
end


////////////////////////////// Fixing some old func names right

/// Crystal Colors (CrystalColor and SecCrystalColor)
/// Inner Colors (InnerColor and SecInnerColor)
/// Max Length ( MaxLength and SecMaxLength )
/// Max Width ( MaxWidth and SecMaxWidth )
/// Dark Inner ( DarkInner and SecDarkInner )

/// Crystal Colors

function ENT:SetCrystalColor( vec_col, key )
	if not SERVER then return end
	if not vec_col then return end
	self:SetUseColor( Color( vec_col.x, vec_col.y, vec_col.z ), key )
end

function ENT:GetCrystalColor(key)
	return self:GetUseColor( key ) or ColorRand()
end

/// Inner Colors

function ENT:SetInnerColor( vec_col, key )
	if not SERVER then return end
	if not vec_col then return end
	self:SetUseInnerColor( Color( vec_col.x, vec_col.y, vec_col.z ), key )
end

function ENT:GetInnerColor( key )
	return self:GetUseInnerColor( key ) or ColorRand()
end

/// Max Length ( MaxLength and SecMaxLength )

function ENT:SetMaxLength( len, key )
	if not SERVER then return end
	if not len then return end
	if len < 0 then return end
	self:SetUseLength( len, key )
end

function ENT:GetMaxLength( key )
	return self:GetUseLength( key ) or 64
end

/// Max Width ( MaxWidth and SecMaxWidth )

function ENT:SetBladeWidth( len, key )
	if not SERVER then return end
	if not len then return end
	if len < 0 then return end
	self:SetUseWidth( len, key )
end

function ENT:GetBladeWidth( key )
	return self:GetUseWidth( key ) or 8
end
 
/// Dark Inner ( DarkInner and SecDarkInner )

function ENT:SetDarkInner( bool, key )
	if not SERVER then return end
	if not bool then return end
	self:SetUseDarkInner( bool, key )
end

function ENT:GetDarkInner( key )
	return self:GetUseDarkInner( key ) or false
end

function ENT:GetBladeLength()
	if self:GetEnabled() then return self:GetMaxLength() end
	return 0
end

function ENT:GetBladeLength()
	if SERVER then
		if self:GetEnabled() then 
			return self:GetMaxLength() 
		else 
			return 0
		end
	end
	return self.BladeLength or 0
end

function ENT:SetBladeLength( num )
	if SERVER then return end
	self.BladeLength = num
end

function ENT:ApplyDataDesc( desc, data )
	//Super simple for now, build on this after testing
	if not desc then return end
	self[ desc ] = data
end

function ENT:Think()
	local max_single = self.UseLength
	if istable( max_single ) then
		local copy = table.Copy( max_single )
		table.sort( copy )
		max_single = copy[#copy]
	end
	if max_single then
		self:SetBladeLength( max_single )
	end
end

if ( CLIENT ) then return end


function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )

end

function ENT:Think()

	if not IsValid( self:GetOwner() ) then self:Remove() return end
	if not self:GetOwner():Alive() then self:GetOwner():SetNW2Bool( "wOS.BarrierStuff", false ) self:Remove() return end
	local ply = self:GetOwner()
	local wep = ply:GetActiveWeapon()
	if not IsValid( wep ) then ply:SetNW2Bool( "wOS.BarrierStuff", false ) self:Remove() return end
	if not wep.IsLightsaber then ply:SetNW2Bool( "wOS.BarrierStuff", false ) self:Remove() return end

	if not self.WardTime then self.WardTime = CurTime() + 3 end

	if self.WardTime < CurTime() then
		if not self.Second then
			ply:DrawWorldModel(true)
			wep:SetNextAttack(0.25)
			wep:SetEnabled(true)
			wep:SetBladeLength( self:GetMaxLength() )
			self.Owner:SetNW2Bool( "wOS.BarrierStuff", false )
		end
		self:Remove()
	end

	local pos, ang = self:GetSaberPosAng()
	local hit = self:BladeThink( pos, ang )
	if ( self:LookupAttachment( "blade2" ) > 0 ) then
		local pos2, ang2 = self:GetSaberPosAng( 2 )
		local hit_2 = self:BladeThink( pos2, ang2 )
		hit = hit || hit_2
	end

	if ( self.SoundHit ) then
		if ( hit ) then self.SoundHit:ChangeVolume( math.Rand( 0.1, 0.5 ), 0 ) else self.SoundHit:ChangeVolume( 0, 0 ) end
	end

	if ( self.SoundSwing ) then
		--local ang = self:GetAngles()
		if ( self.LastAng != ang ) then
			self.LastAng = self.LastAng or ang
			self.SoundSwing:ChangeVolume( math.Clamp( ang:Distance( self.LastAng ) / 2, 0, 1 ), 0 )
		end
		self.LastAng = ang
	end

	if ( self.SoundLoop ) then
		local spos = pos + ang * self:GetBladeLength()
		if ( self.LastPos != spos ) then
			self.LastPos = self.LastPos or spos
			self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( spos:Distance( self.LastPos ) / 128, 0, 0.9 ), 0 )
		end
		self.LastPos = spos
	end

	self:NextThink( CurTime() + 0.1 )
	return true	
end

function ENT:BladeThink( startpos, dir )
	local trace = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * self:GetBladeLength(),
		filter = { self, self.Owner },
		--[[mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 2,
		maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 2]]
	} )

	if ( trace.Hit ) then
		rb655_DrawHit_wos( trace.HitPos, trace.HitNormal, self )
		rb655_LS_DoDamage( trace, self )
	end

	return trace.Hit
end

function ENT:Use( activator, caller, useType, value )
	if ( !IsValid( activator ) || !activator:KeyPressed( IN_USE ) ) then return end
	
	if ( self:GetEnabled() ) then
		self:EmitSound( self.OffSound )
	else
		self:EmitSound( self.OnSound )
	end

	self:SetEnabled( !self:GetEnabled() )
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit || !ply:CheckLimit( "ent_lightsabers" ) ) then return end
	ent.PreventDescTransmit = true
	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 2 )

	local ang = ply:EyeAngles()
	ang.p = 0
	ang:RotateAroundAxis( ang:Right(), 180 )
	ent:SetAngles( ang )

	-- Sync values from the tool
	ent:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 32, 64 ) )
	ent:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) / 255 )
	ent:SetDarkInner( ply:GetInfo( "rb655_lightsaber_dark" ) == "1" )
	ent:SetModel( ply:GetInfo( "rb655_lightsaber_model" ) )
	ent:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 2, 4 ) )

	ent.LoopSound = ply:GetInfo( "rb655_lightsaber_humsound" )
	ent.SwingSound = ply:GetInfo( "rb655_lightsaber_swingsound" )
	ent.OnSound = ply:GetInfo( "rb655_lightsaber_onsound" )
	ent.OffSound = ply:GetInfo( "rb655_lightsaber_offsound" )

	ent:Spawn()
	ent:Activate()

	ent.Owner = ply
	ent.Color = ent:GetColor()

	local phys = ent:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

	if ( IsValid( ply ) ) then
		ply:AddCount( "ent_lightsabers", ent )
		ply:AddCleanup( "ent_lightsabers", ent )
	end
	ent.PreventDescTransmit = false
	return ent
end
