--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































local SWEP = {}

SWEP.Vars = {}

SWEP.PrintName = "Lightsaber Base"
SWEP.Author = "Robotboy655 + King David"
SWEP.Category = "Robotboy655's Weapons"
SWEP.Contact = "robotboy655@gmail.com"
SWEP.Purpose = "To slice off each others limbs and heads."
SWEP.Instructions = "Use the force, Luke."
SWEP.RenderGroup = RENDERGROUP_BOTH

SWEP.LoadDelay = 0
SWEP.RegendSpeed = 1
SWEP.MaxForce = 100
SWEP.ForcePowerList = {}
SWEP.DevestatorList = {}

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
SWEP.ViewModelFOV = 55

SWEP.AlwaysRaised = true

SWEP.BlockInvincibility = false
SWEP.Stance = 1
SWEP.Enabled = false
SWEP.PlayerStances = {}
SWEP.IsLightsaber = true
SWEP.CurStance = 1
SWEP.FPCamTime = 0
SWEP.BlockDrainRate = 0.1
SWEP.DevestatorTime = 0
SWEP.UltimateCooldown = 0
SWEP.StaminaRegenSpeed = 1
SWEP.Cooldowns = {}
SWEP.CLastUpdate = 0

killicon.Add( "weapon_lightsaber_wos", "lightsaber/lightsaber_killicon", color_white )

local WepSelectIcon = Material( "lightsaber/selection.png" )
local Size = 96

local function VecToColor( vec )
	if not vec then return color_white end
	return Color( vec.x, vec.y, vec.z )
end

function SWEP:DataDesc( desc, typ )
	wOS.ALCS.DataDesc:Install( self, desc, typ )
end

function SWEP:RemoveDataDesc( desc )
	wOS.ALCS.DataDesc:Delete( self, desc )
end

function SWEP:SetupDataDescs()
	self:DataDesc( "UseColor", WOS_ALCS.DATADESC.TBLCOLOR )
	self:DataDesc( "UseLength", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseWidth", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseDarkInner", WOS_ALCS.DATADESC.TBLBOOL )
	self:DataDesc( "UseInnerColor", WOS_ALCS.DATADESC.TBLCOLOR )

	self:DataDesc( "UseSecColor", WOS_ALCS.DATADESC.TBLCOLOR )
	self:DataDesc( "UseSecLength", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseSecWidth", WOS_ALCS.DATADESC.TBLFLOAT )
	self:DataDesc( "UseSecDarkInner", WOS_ALCS.DATADESC.TBLBOOL )
	self:DataDesc( "UseSecInnerColor", WOS_ALCS.DATADESC.TBLCOLOR )

	self:DataDesc( "CustomSettings", WOS_ALCS.DATADESC.VARARG )
	self:DataDesc( "SecCustomSettings", WOS_ALCS.DATADESC.VARARG )

	hook.Call( "wOS.ALCS.Lightsaber.RegisterDataDesc", nil, self )
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "Force" )
	self:NetworkVar( "Float", 1, "DevEnergy" )
	self:NetworkVar( "Float", 2, "FPCamTime" )
	self:NetworkVar( "Float", 3, "Delay" )
	self:NetworkVar( "Float", 4, "BlockDrain" )
	self:NetworkVar( "Float", 5, "ForceCooldown" )
	self:NetworkVar( "Float", 6, "Stamina" )	
	self:NetworkVar( "Float", 7, "AttackDelay" )	
	self:NetworkVar( "Float", 8, "LastUpdate" )

	self:NetworkVar( "Bool", 0, "Enabled" )
	self:NetworkVar( "Bool", 1, "OffhandOnly" )
	self:NetworkVar( "Bool", 2, "WorksUnderwater" )
	self:NetworkVar( "Bool", 3, "AnimEnabled" )
	self:NetworkVar( "Bool", 4, "Cloaking" )
	self:NetworkVar( "Bool", 5, "DualMode" )
	self:NetworkVar( "Bool", 6, "Blocking" )
	self:NetworkVar( "Bool", 7, "HonorBound" )

	self:NetworkVar( "Int", 0, "ForceType" )
	self:NetworkVar( "Int", 1, "DevestatorType" )
	self:NetworkVar( "Int", 3, "Stance" )
	self:NetworkVar( "Int", 4, "Form" )
	self:NetworkVar( "Int", 5, "MaxForce" )
	self:NetworkVar( "Int", 6, "MaxStamina" )
	self:NetworkVar( "Int", 7, "HiltHoldtype" )
	self:NetworkVar( "Int", 8, "MeditateMode" )
	
	self:NetworkVar( "String", 0, "WorldModel" )
	self:NetworkVar( "String", 1, "SecWorldModel" )
	self:NetworkVar( "String", 2, "OnSound" )
	self:NetworkVar( "String", 3, "OffSound" )

	self:NetworkVar( "Entity", 0, "ForceTarget" )
	self:SetupDataDescs()
	
end

function SWEP:GenerateThinkFunctions()
	self.ThinkFunctions = {}

end

function SWEP:GenerateAttackFunctions()
	self.AttackFunctions = {}

end

function SWEP:PrimaryAttack()
	if ( !IsValid( self.Owner ) ) then return end
	if self:GetBlocking() then return end
	if self.HeavyCharge then 
		if self.HeavyCharge >= CurTime() then return end
	end
	if ( prone and self.Owner:IsProne() ) then self.Owner:SetAnimation( PLAYER_ATTACK1 ); return end
	
	if not self:GetAnimEnabled() then self.Owner:SetAnimation( PLAYER_ATTACK1 ); return end
end

function SWEP:SecondaryAttack()

end

function SWEP:Reload()

end

function SWEP:GetSaberPosAng( num, side, model )

	num = num or 1
	model = model or self
	local dual = false
	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if self.LeftHilt then
			if model == self.LeftHilt then
				bone = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
				dual = true
			end
		end
		local attachment = model:LookupAttachment( "blade" .. num )
		if ( side ) then
			attachment = model:LookupAttachment( "quillon" .. num )
		end

		if ( !bone ) then

		end

		if ( attachment && attachment > 0 ) then
			local PosAng = model:GetAttachment( attachment )

			if ( !bone ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if ( IsValid( self.Owner ) && self.Owner:IsPlayer() && self.Owner:Crouching() ) then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
		
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				end
			end
		
			if !dual then
				ang:RotateAroundAxis( ang:Forward(), 180 )
				ang:RotateAroundAxis( ang:Up(), 30 )
				ang:RotateAroundAxis( ang:Forward(), -5.7 )
				ang:RotateAroundAxis( ang:Right(), 92 )

				pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
				
			else
				ang:RotateAroundAxis( ang:Forward(), -180 )
				ang:RotateAroundAxis( ang:Up(), 0 )
				ang:RotateAroundAxis( ang:Forward(), -5 )
				ang:RotateAroundAxis( ang:Right(), -86 )

				pos = pos - ang:Up() * -3.6 - ang:Right() * 1.1 + ang:Forward() * 6.2			
			end
			
			return pos, ang:Forward()
		end
	end

	local defAng = model:GetAngles()
	defAng.p = 0

	local defPos = model:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	defPos = defPos + Vector( 0, 0, 36 )
	if ( IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
	
end

function SWEP:GetTargetEntity( dist, num )

	local dsqr = dist*dist
	local t = {}
	local group = player.GetAll()
	table.Add( group, ents.FindByClass( "npc_*" ) )
	local p = {}
	for id, ply in pairs( group ) do
		if ( !ply:GetModel() or ply:GetModel() == "" or ply == self.Owner or ply:Health() < 1 ) then continue end
		
		local wep = ply:GetActiveWeapon()
		if IsValid( wep ) then
			if wep.IsLightsaber then
				if wep:GetCloaking() then continue end
			end
		end
		
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = (ply.GetShootPos && ply:GetShootPos() or ply:GetPos()),
			filter = self.Owner,
		} )

		if ( tr.Entity != ply && IsValid( tr.Entity ) or tr.Entity == game.GetWorld() ) then continue end

		local pos1 = self.Owner:GetPos() + self.Owner:GetAimVector() * dist
		local pos2 = ply:GetPos()

		if ( pos1:DistToSqr( pos2 ) <= dsqr && ply:EntIndex() > 0 ) then
			table.insert( p, { ply = ply, dist = tr.HitPos:DistToSqr( pos2 ) } )
		end
	end

	for id, ply in SortedPairsByMemberValue( p, "dist" ) do
		table.insert( t, ply.ply )
		if ( #t >= num ) then return t end
	end

	return t
	
end

function SWEP:TargetThoughts()

	local target = self:GetForceTarget()
	if not IsValid( target ) then return end
	
	local diff = target:GetPos() - self.Owner:GetPos()
	local ang = ( diff ):Angle()
	local tang = LocalPlayer():EyeAngles()
	tang.y = ang.y
	
	LocalPlayer():SetEyeAngles( tang )
	
end

function SWEP:Holster()

	if self:GetEnabled() then return false end
	if self:GetHonorBound() then return false end
	
	self.BladeLength = 0
	self.SecBladeLength = 0
	if IsValid( self.LeftHilt ) then
		self.LeftHilt:Remove()
		self.LeftHilt = nil
	end
	
	return true
end

function SWEP:OnRemove()
	if IsValid( self.LeftHilt ) then
		self.LeftHilt:Remove()
		self.LeftHilt = nil
	end	
	return true
end

function SWEP:Deploy()

end

function SWEP:GetBladeLength()
	return self.BladeLength or 0
end

function SWEP:SetBladeLength( num )
	self.BladeLength = num
end

function SWEP:GetSecBladeLength()
	return self.SecBladeLength or 0
end

function SWEP:SetSecBladeLength( num )
	self.SecBladeLength = num
end

function SWEP:Think()

	for _, think in ipairs( self.ThinkFunctions ) do
		think( self )
	end

end

----OTHER STUFF

function SWEP:ApplyDataDesc( desc, data )
	//Super simple for now, build on this after testing
	if not desc then return end
	self[ desc ] = data
end

function SWEP:GetTargetHoldType()
	--if ( !self:GetEnabled() ) then return "normal" end
	if ( self:GetWorldModel() == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" ) then return "knife" end
	if ( self:LookupAttachment( "blade2" ) && self:LookupAttachment( "blade2" ) > 0 ) then return "knife" end

	return ( self:GetDualMode() and "knife" ) or "melee2"
end

function SWEP:GetActiveForcePowerType( id )
	local ForcePowers = self.ForcePowers
	return ForcePowers[ id ]
end

function SWEP:GetActiveForcePowers()
	return self.ForcePowers
end

function SWEP:Initialize()
	self.CLastUpdate = 0
	self.IsLightsaber = true
	self.LoopSound = self.LoopSound or "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
	self.SwingSound = self.SwingSound or "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"
	self:SetWeaponHoldType( "normal" )
	
	
	self.ForcePowers = {}
	self.AvailablePowers = table.Copy( wOS.AvailablePowers )
	local breakoff = wOS.ALCS.Config.LightsaberHUD == WOS_ALCS.HUD.HYBRID
	for _, force in pairs( self.ForcePowerList ) do
		if not self.AvailablePowers[ force ] then continue end
		self.ForcePowers[ #self.ForcePowers + 1 ] = self.AvailablePowers[ force ]
		if not breakoff then continue end
		if #self.ForcePowers >= wOS.ALCS.Config.MaximumForceSlots then break end
	end
	
	self.Devestators = {}
	self.AvailableDevestators = table.Copy( wOS.AvailableDevestators )
	for _, dev in pairs( self.DevestatorList ) do
		if not self.AvailableDevestators[ dev ] then continue end
		self.Devestators[ #self.Devestators + 1 ] = self.AvailableDevestators[ dev ]
	end
	
	self:GenerateThinkFunctions()
	
	hook.Call( "wOS.ALCS.Lightsaber.OnInitialize", nil, self )
end

function SWEP:GetActiveDevestators()
	local Devestators = {}
	for id, t in pairs( self.Devestators ) do
		table.insert( Devestators, t )
	end
	return Devestators
end

function SWEP:GetActiveDevestatorType( id )
	local Devestators = self:GetActiveDevestators()
	return Devestators[ id ]
end

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( WepSelectIcon )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.DrawTexturedRect( x + ( ( w - Size ) / 2 ), y + ( ( h - Size ) / 2.5 ), Size, Size )

	render.PopFilterMag()
	render.PopFilterMin()
end

function SWEP:CheckUpdates()
	if self.CLastUpdate != self:GetLastUpdate() then
		net.Start( "wOS.ALCS.DataDesc.Sync")
			net.WriteUInt( self:EntIndex(), 16 )
			net.WriteFloat( self.CLastUpdate )
		net.SendToServer()
		self.CLastUpdate = self:GetLastUpdate()
	end
end


function SWEP:DrawWorldModel()
	// Why not do this in Think? Because this is PVS/NET restricted
	self:CheckUpdates()

	local factor = 18
	local max_single = self.UseLength
	if istable( max_single ) then
		local copy = table.Copy( max_single )
		table.sort( copy )
		max_single = copy[#copy]
	end
	if max_single then
		if ( !self:GetEnabled() && self:GetBladeLength() != 0 ) then
			self:SetBladeLength( math.Approach( self:GetBladeLength(), 0, 6*FrameTime()*factor ) )
		elseif ( self:GetEnabled() && self:GetBladeLength() != max_single ) then
			self:SetBladeLength( math.Approach( self:GetBladeLength(), max_single, 8*FrameTime()*factor ) )
		end
	end
		

	local max_double = self.UseSecLength
	if istable( max_double ) then
		local copy = table.Copy( max_double )
		table.sort( copy )
		max_double = copy[#copy]
	end
	if max_double then
		if ( !self:GetEnabled() && self:GetSecBladeLength() != 0 ) then
			self:SetSecBladeLength( math.Approach( self:GetSecBladeLength(), 0, 6*FrameTime()*factor ) )
		elseif ( self:GetEnabled() && self:GetSecBladeLength() != max_double ) then
			self:SetSecBladeLength( math.Approach( self:GetSecBladeLength(), max_double, 8*FrameTime()*factor ) )
		end
	end
	
end

function SWEP:DrawWorldModelTranslucent()
	
	--Prevents flickering!!
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )
	
	if !self:GetOffhandOnly() then
		self:DrawPrimarySaber()
	end

	if self:GetDualMode() or self:GetOffhandOnly() then
		self:DrawSecondarySaber()
	end
	
end

function SWEP:DrawPrimarySaber()
	if ( !IsValid( self:GetOwner() ) or halo.RenderedEntity() == self ) then return end
	
	if self:GetCloaking() then 
		local vel = self.Owner:GetVelocity():Length()
		if vel < 130 then return end
		self:SetMaterial("models/shadertest/shader3")
		self:DrawModel()
		return
	end
	
	self:SetMaterial( "" )
	self:DrawModel()

	if self.NoBlade then return end

	local bladesFound = false
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
			bladesFound = true
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

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng()
		local clr = self:GetUseColor()
		local clr_inner = self:GetUseInnerColor()
		local maxlen = self:GetUseLength()
		local width = self:GetUseWidth()
		local darkinner = self:GetUseDarkInner()
		rb655_RenderBlade_wos( pos, dir, self:GetBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, self.CustomSettings )
	end
	
end

function SWEP:DrawSecondarySaber()


	if !IsValid( self.LeftHilt ) and ( self:GetDualMode() or self:GetOffhandOnly() ) then
		self.LeftHilt = ents.CreateClientProp()
		self.LeftHilt:SetModel( self:GetSecWorldModel() )
		self.LeftHilt:Spawn()
		self.LeftHilt:SetNoDraw( true )
	end
	
	local bone = self.Owner:LookupBone( "ValveBiped.Bip01_L_Hand" )
	local pos, ang = self.Owner:GetBonePosition( bone )
	if ( pos == self.Owner:GetPos() ) then
		local matrix = self.Owner:GetBoneMatrix( 16 )
		if ( matrix ) then
			pos = matrix:GetTranslation()
			ang = matrix:GetAngles()
		end
	end
	
	if self.LeftHilt:GetModel() == "models/donation gauntlet/donation gauntlet.mdl" then	

		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), -92 )
		pos = pos + ang:Up() * 3.3 + ang:Right() * 0.4 + ang:Forward() * -7

	else
	
		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), 92 )
		if not self:GetAnimEnabled() then
			ang:RotateAroundAxis( ang:Up(), 180 )
			pos = pos + ang:Up() * -5 + ang:Right() * -1 + ang:Forward() * -7	
		else
			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.4 + ang:Forward() * -7	
		end
	end

	self.LeftHilt:SetPos( pos )
	self.LeftHilt:SetAngles( ang )

	if self:GetCloaking() then
		if self.Owner:GetVelocity():Length() < 130 then
			self.LeftHilt:SetMaterial("models/effects/vol_light001")
			self.LeftHilt:SetColor( Color( 0, 0, 0, 0 ) )
		else
			self.LeftHilt:SetMaterial("models/shadertest/shader3")
			self.LeftHilt:SetColor( Color( 255, 255, 255, 255 ) )
		end	
		return
	end

	self.LeftHilt:DrawModel()
	self.LeftHilt:SetMaterial( "" )
	self.LeftHilt:SetColor( Color( 255, 255, 255, 255 ) )

	if self.SecNoBlade then return end
	
	local bladesFound = false -- true if the model is OLD and does not have blade attachments
	local blades = 0

	for id, t in pairs( self.LeftHilt:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self.LeftHilt:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum, false, self.LeftHilt )

			local clr = self:GetUseSecColor( bladeNum )
			local clr_inner = self:GetUseSecInnerColor( bladeNum )
			local maxlen = self:GetUseSecLength( bladeNum )
			local width = self:GetUseSecWidth( bladeNum )
			local darkinner = self:GetUseSecDarkInner( bladeNum )

			rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, self.SecCustomSettings, true )

			bladesFound = true
		end

		if ( quillonNum && self.LeftHilt:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true, self.LeftHilt )

			local clr = self:GetUseSecColor()
			local clr_inner = self:GetUseSecInnerColor()
			local maxlen = self:GetUseSecLength()
			local width = self:GetUseSecWidth()
			local darkinner = self:GetUseSecDarkInner()

			rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, self.SecCustomSettings, true )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng( nil, nil, self.LeftHilt )
		if not self:GetAnimEnabled() then
			dir = dir*-1
			pos = pos + dir*12 - dir:Angle():Right()*0.8 - dir:Angle():Up()*1.5
		end

		local clr = self:GetUseSecColor()
		local clr_inner = self:GetUseSecInnerColor()
		local maxlen = self:GetUseSecLength()
		local width = self:GetUseSecWidth()
		local darkinner = self:GetUseSecDarkInner()

		rb655_RenderBlade_wos( pos, dir, self:GetSecBladeLength(), maxlen, width, clr, darkinner, clr_inner, self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, self.SecCustomSettings, true )
	end
	
end

surface.CreateFont( "SelectedForceType", {
	font	= "Roboto Cn",
	size	= ScreenScale( 16 ),
	weight	= 600
} )

surface.CreateFont( "SelectedForceHUD", {
	font	= "Roboto Cn",
	size	= ScreenScale( 6 )
} )

SWEP.Vars.grad = Material( "gui/gradient_up" )
SWEP.Vars.matBlurScreen = Material( "pp/blurscreen" )
SWEP.Vars.matBlurScreen:SetFloat( "$blur", 3 )
SWEP.Vars.matBlurScreen:Recompute()

function SWEP.Vars:DrawHUDBox( x, y, w, h, b )

	x = math.floor( x )
	y = math.floor( y )
	w = math.floor( w )
	h = math.floor( h )
	
	surface.SetMaterial( self.matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )


	render.SetScissorRect( x, y, w + x, h + y, true )
		for i = 0.33, 1, 0.33 do
			self.matBlurScreen:SetFloat( "$blur", 5 * i )
			self.matBlurScreen:Recompute()
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		end
	render.SetScissorRect( 0, 0, 0, 0, false )


	surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
	surface.DrawRect( x, y, w, h )

	if ( b ) then
		surface.SetMaterial( self.grad )
		surface.SetDrawColor( Color( 0, 128, 255, 4 ) )
		surface.DrawTexturedRect( x, y, w, h )
	end

end


function SWEP:ViewModelDrawn()

end

function SWEP:DrawHUDTargetSelection()
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( !selectedForcePower ) then return end

	local isTarget = selectedForcePower.target
	local dist = selectedForcePower.distance
	if ( isTarget ) then
		for id, ent in pairs( self:SelectTargets( isTarget, dist ) ) do
			if ( !IsValid( ent ) ) then continue end
			local maxs = ent:OBBMaxs()
			local p = ent:GetPos()
			p.z = p.z + maxs.z

			local pos = p:ToScreen()
			local x, y = pos.x, pos.y
			local size = 16

			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			surface.DrawPoly( {
				{ x = x - size, y = y - size },
				{ x = x + size, y = y - size },
				{ x = x, y = y }
			} )
		end
	end
end

SWEP.Vars.ForceBar = 100
SWEP.Vars.StaminaBar = 100
SWEP.Vars.DevBar = 0

function SWEP:DrawHUD()
	if ( !IsValid( self.Owner ) or self.Owner:GetViewEntity() != self.Owner or self.Owner:InVehicle() ) then return end
	
	wOS.ALCS.LightsaberBase:HandleHUD( self )
	self:TargetThoughts()
	//self:DrawHUDTargetSelection()

end


////////////////////////////// Fixing some old func names since they are obsolete

/// Crystal Colors (CrystalColor and SecCrystalColor)
/// Inner Colors (InnerColor and SecInnerColor)
/// Max Length ( MaxLength and SecMaxLength )
/// Max Width ( MaxWidth and SecMaxWidth )
/// Dark Inner ( DarkInner and SecDarkInner )

function SWEP:GetCrystalColor(key)
	return self:GetUseColor( key ) or ColorRand()
end

function SWEP:GetSecCrystalColor(key)
	return self:GetUseSecColor( key ) or ColorRand()
end

/// Inner Colors

function SWEP:GetInnerColor( key )
	return self:GetUseInnerColor( key ) or ColorRand()
end

function SWEP:GetSecInnerColor( key )
	return self:GetUseSecInnerColor( key ) or ColorRand()
end

/// Max Length ( MaxLength and SecMaxLength )

function SWEP:GetMaxLength( key )
	return self:GetUseLength( key ) or 64
end

function SWEP:GetSecMaxLength( key )
	return self:GetUseSecLength( key ) or 64
end

/// Max Width ( MaxWidth and SecMaxWidth )

function SWEP:GetBladeWidth( key )
	return self:GetUseWidth( key ) or 8
end

function SWEP:GetSecBladeWidth( key )
	return self:GetUseSecWidth( key ) or 8
end
 
/// Dark Inner ( DarkInner and SecDarkInner )

function SWEP:GetDarkInner( key )
	return self:GetUseDarkInner( key ) or false
end

function SWEP:GetSecDarkInner( key )
	return self:GetUseSecDarkInner( key ) or false
end


wOS.ALCS.LightsaberBase:AddClientWeapon( SWEP, "wos_adv_single_lightsaber_base" )
wOS.ALCS.LightsaberBase:AddClientWeapon( SWEP, "wos_adv_dual_lightsaber_base" )
