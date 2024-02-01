wOS = wOS or {}

hook.Add( "PlayerCanJoinTeam", "wOS.Lightsaber.StopTheChoke", function( ply )
    if ply:GetNW2Float( "wOS.ChokeTime", 0 ) >= CurTime() then return false end
end )

wOS.ForcePowers:RegisterNewPower({
		name = "Force Blind",
		icon = "FB",
		image = "wos/forceicons/icefuse/blind.png",
		cooldown = 0,
		manualaim = false,
		description = "Make your escape or final blow.",
		help = "Momentarily blind any enemies nearby",
		action = function( self )
			if ( self:GetForce() < 75 ) then return end
			for _, ply in pairs( ents.FindInSphere( self.Owner:GetPos(), 200 ) ) do
				if not IsValid( ply ) then continue end
				if not ply:IsPlayer() then continue end
				if not ply:Alive() then continue end
				if ply == self.Owner then continue end
				ply:SetNW2Float( "wOS.BlindTime", CurTime() + 15 )
			end
			
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetForce( self:GetForce() - 75 )
			self:SetNextAttack( 1 )
			return true
		end
})



wOS.ForcePowers:RegisterNewPower({

		name = "Adrenaline",
		icon = "ADR",
		description = "Be quick to the draw",
		image = "wos/forceicons/icefuse/adrenaline.png",
		help = "Attack and move faster for a short amount of time",
		cooldown = 20,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if not self.Owner.SpeedTime then
				self.Owner.SpeedTime = 0
			end
			if self.Owner.SpeedTime >= CurTime() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner.SpeedTime = CurTime() + 10
			return true
		end,
})



wOS.ForcePowers:RegisterNewPower({
		name = "Force Slow",
		icon = "FS",
		target = 1,
		description = "Cloud your victim's mind",
		help = "Slow down your targeted enemy for a brief moment",
		image = "wos/forceicons/icefuse/slow.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			if not ent:IsPlayer() then return end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetForce( self:GetForce() - 50 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			if not ent.SlowTime then ent.SlowTime = 0 end
			ent.SlowTime = CurTime() + 10
			return true
		end,
})



wOS.ForcePowers:RegisterNewPower({
		name = "Force Stasis",
		icon = "STS",
		description = "Let their fear stop them",
		target = 1,
		image = "wos/forceicons/icefuse/stasis.png",
		help = "Stun your enemy, preventing all movements and attacks for a short time",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 80 || !self.Owner:IsOnGround() ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			if not ent:IsPlayer() then return end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetForce( self:GetForce() - 80 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			ent.StasisTime = CurTime() + 10
			self:SetNextAttack( 1 )
			return true
		end,
})



wOS.ForcePowers:RegisterNewPower({
		name = "Group Pull",
		icon = "GPL",
		target = 50,
		description = "Get over here!",
		help = "Pull up to 10 enemies directly in front of you",
		image = "wos/forceicons/icefuse/group_pull.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local foundents = self:SelectTargets( 10 )
			if #foundents < 1 then return end
			for id, ent in pairs( foundents ) do
				local newpos = ( self.Owner:GetPos() - ent:GetPos() )
				newpos = newpos / newpos:Length()
				ent:SetVelocity( newpos*100 + Vector( 0, 0, 300 ) )		
			end
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetForce( self:GetForce() - 20 )	
			self:SetNextAttack( 1.5 )
			return true
		end,
})



wOS.ForcePowers:RegisterNewPower({
		name = "Group Push",
		icon = "GPH",
		target = 50,
		distance = 650,
		description = "They are no harm at a distance",
		help = "Pull up to 10 enemies directly in front of you",
		image = "wos/forceicons/icefuse/group_push.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local foundents = self:SelectTargets( 50, 650 )
			if #foundents < 1 then return end
			for id, ent in pairs( foundents ) do
				local newpos = ( self.Owner:GetPos() - ent:GetPos() )
				newpos = newpos / newpos:Length()
				ent:SetVelocity( newpos*-850 + Vector( 0, 0, 300 ) )
			end
			self:SetForce( self:GetForce() - 20 )	
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetNextAttack( 1.5 )
			return true
		end,
})



wOS.ForcePowers:RegisterNewPower({
		name = "Group Lightning",
		icon = "GL",
		target = 10,
		description = "Send a jolt to wake up groups of victims.",
		image = "wos/forceicons/icefuse/group_lightning.png",
		help = "Unleash a blockable lightning stream onto up to 10 players ahead of you",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 1 ) then return end
			local foundents = 0
			for id, ent in pairs( self:SelectTargets( 10 ) ) do
				if ( !IsValid( ent ) ) then continue end
				foundents = foundents + 1
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ent )
				util.Effect( "wos_group_lightning", ed, true, true )
				
				local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner || self )
				dmg:SetInflictor( self.Owner || self )
				dmg:SetDamage( 4 )
				
				local wep = ent:GetActiveWeapon()
				if IsValid( wep ) and wep.IsLightsaber and wep:GetBlocking() then
					ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
					if wOS.ALCS.Config.EnableStamina then
						wep:AddStamina( -5 )
					else
						wep:SetForce( wep:GetForce() - 1 )
					end
					ent:SetSequenceOverride( "h_block", 0.5 )
				else
					if ent:IsNPC() then dmg:SetDamage( 1.6 ) end
					ent:TakeDamageInfo( dmg )
				end	
				
			end

			if ( foundents > 0 ) then
				self:SetForce( self:GetForce() - foundents )
				if ( !self.SoundLightning ) then
					self.SoundLightning = CreateSound( self.Owner, "lightsaber/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
					self.SoundLightning:Play()
				else
					self.SoundLightning:Play()
				end
				self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
				timer.Create( "test" .. self.Owner:SteamID64(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			end
			
			self:SetNextAttack( 0.1 )
			return true
		end,

})



wOS.ForcePowers:RegisterNewPower({
		name = "Electric Judgement",
		icon = "EJ",
		description = "The truth can blind us all.",
		image = "wos/forceicons/icefuse/electric_judgement.png",
		help = "Unleash a disorienting lightning stream on your target",
		cooldown = 60,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 5 ) then return end
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			local ent = tr.Entity
			if not ent then return end
			if not ent:IsPlayer() then return end
			if self.Owner:GetPos():Distance( ent:GetPos() ) > 300 then return end
			local ed = EffectData()
			ed:SetOrigin( self:GetSaberPosAng() )
			ed:SetEntity( ent )
			util.Effect( "wos_emerald_lightning", ed, true, true )			

			local wep = ent:GetActiveWeapon()
			if IsValid( wep ) and wep.IsLightsaber and wep:GetBlocking() then
				ent:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
				if wOS.ALCS.Config.EnableStamina then
					wep:AddStamina( -5 )
				else
					wep:SetForce( wep:GetForce() - 1 )
				end
				ent:SetSequenceOverride( "h_block", 0.5 )
			else
				ent:SetNW2Float( "wOS.DisorientTime", CurTime() + 3 )
				ent:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 3 )	
			end	

			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetForce( self:GetForce() - 5 )
			if ( !self.SoundLightning ) then
				self.SoundLightning = CreateSound( self.Owner, "wos/icefuse/electric_judgement_loop.wav" )
				self.SoundLightning:PlayEx( 0.5, 100 )
			else
				self.SoundLightning:PlayEx( 0.5, 100 )
			end
			
			timer.Create( "test" .. self.Owner:SteamID64(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			-- self:SetNextAttack( 0.1 )

			return true
		end,
})
wOS.ForcePowers:RegisterNewPower({
		name = "Force Whirlwind",
		icon = "WW",
		description = "That which you harness is all around you",
		image = "wos/forceicons/icefuse/whirlwind.png",
		help = "Lift, control, and throw a targeted prop or player",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if self:GetForce() < 1 then return end
			if IsValid( self.WindTarget ) then return end
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			local dist = tr.HitPos:Distance( self.Owner:GetPos() )
			if not tr.Entity then return end
			if dist >= 400 then return end
			self.WindTarget = tr.Entity
			self.WindDistance = dist
		end,

		think = function( self )
			if not IsValid( self.WindTarget ) then return end
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 ) then return end
			if self.WindTarget:IsPlayer() and not self.WindTarget:Alive() then self.WindTarget = nil return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				local vec = ( ( self.Owner:EyePos() + self.Owner:GetAimVector()*self.WindDistance  ) - self.WindTarget:GetPos() )
				local vec2 = ( ( self.Owner:EyePos() + self.Owner:GetAimVector()*2*self.WindDistance  ) - self.WindTarget:GetPos() )
				
				if self.WindTarget:IsPlayer() or self.WindTarget:IsNPC() then
					self.WindTarget:SetLocalVelocity( vec*10 )
					self.WindTarget:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 0.2 )
				else
					local phys = self.WindTarget:GetPhysicsObject()
					phys:SetVelocity( vec*10 )
				end

				self:SetForce( self:GetForce() - 0.25 )

				if ( self:GetForce() < 1 ) then 
					local ed = EffectData()
					ed:SetOrigin( self.WindTarget:GetPos() + Vector( 0, 0, 36 ) )
					ed:SetRadius( 128 )
					util.Effect( "rb655_force_repulse_out", ed, true, true )
					self.WindTarget = nil
					self:SetNextAttack( 1 )
					self:PlayWeaponSound( "lightsaber/force_repulse.wav" )				
				end
				if self.Owner:KeyReleased( IN_ATTACK ) then
					local ed = EffectData()
					ed:SetOrigin( self.WindTarget:GetPos() + Vector( 0, 0, 36 ) )
					ed:SetRadius( 128 )
					util.Effect( "rb655_force_repulse_out", ed, true, true )
					self:PlayWeaponSound( "lightsaber/force_repulse.wav" )	
					if self.WindTarget:IsPlayer() or self.WindTarget:IsNPC() then
						self.WindTarget:SetLocalVelocity( vec2*10 )
					else
						local phys = self.WindTarget:GetPhysicsObject()
						phys:SetVelocity( vec2*10 )
					end	

					self.WindTarget = nil
					self:SetNextAttack( 1 )					
				end
			else
				if not IsValid( self.WindTarget ) then return end
				local ed = EffectData()
				ed:SetOrigin( self.WindTarget:GetPos() + Vector( 0, 0, 36 ) )
				ed:SetRadius( 128 )
				util.Effect( "rb655_force_repulse_out", ed, true, true )
				self.WindTarget = nil
				self:SetNextAttack( 1 )
				self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
				return true
			end
		end
})
wOS.ForcePowers:RegisterNewPower({
		name = "Force Breach",
		icon = "BR",
		description = "Make a path",
		image = "wos/forceicons/icefuse/breach.png",
		help = "Open a door from a distance, unlocked or otherwise",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if self:GetForce() < 35 then return end
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			if not IsValid( tr.Entity ) then return end
			if not tr.Entity:GetClass()=="func_door" or not tr.Entity:GetClass()=="prop_door_rotating" or not tr.Entity:GetClass()=="func_door_rotating" then return end
			self:SetForce( self:GetForce() - 35 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			tr.Entity:Fire("unlock","",0)
            tr.Entity:Fire("Open","",0)
			self:SetNextAttack( 1 )
			return true
		end,
})

wOS.ForcePowers:RegisterNewPower({
		name = "Teleport",
		icon = "TP",
		description = "Phase through to a new location.",
		image = "wos/forceicons/icefuse/teleport.png",
		help = "Instantly teleport to a ledge or position a distance away",
		cooldown = 0,
		manualaim = false,
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 75 ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if self.Owner:KeyReleased( IN_ATTACK2 ) and self.groundTrace then
				local speed = 4000;
				local bFoundEdge = false;

				self.Owner:SetNW2Float("wOS.ShowBlink", 0 );

				local hullTrace = util.TraceHull({
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 2400,
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 9)
				});

				local groundTrace = util.TraceEntity({
					start = hullTrace.HitPos + Vector(0, 0, 1),
					endpos = hullTrace.HitPos - (self.Owner:EyePos() - self.Owner:GetPos()),
					filter = self.Owner
				}, self.Owner);

				local edgeTrace;

				if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
					local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward();
					edgeTrace = util.TraceEntity({
						start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
						endpos = hullTrace.HitPos - ledgeForward * 33,
						filter = self.Owner
					}, self.Owner);

					if (edgeTrace.Hit and !edgeTrace.AllSolid) then
						local clearTrace = util.TraceHull({
							start = hullTrace.HitPos,
							endpos = hullTrace.HitPos + Vector(0, 0, 35),
							mins = Vector(-16, -16, 0),
							maxs = Vector(16, 16, 1),
							filter = self.Owner
						});

						bFoundEdge = !clearTrace.Hit;
					end;
				end;

				if (!bFoundEdge and groundTrace.AllSolid) then
					self.groundTrace = nil		
					self:SetNextSecondaryFire( CurTime() + 1 )						
					return;
				end;

				local endPos = ( bFoundEdge and edgeTrace.HitPos ) or groundTrace.HitPos;

				self.Owner:SetPos( endPos )
				self.Owner:EmitSound("blink/exit" .. math.random(1, 2) .. ".wav");

				self.groundTrace = nil
				self:SetForce( self:GetForce() - 75 )
				self:SetNextSecondaryFire( CurTime() + 1 )	
				return true
			end;

			if self.Owner:KeyDown( IN_ATTACK2 ) then
				local bFoundEdge = false;
				self.Owner:SetNW2Float( "wOS.ShowBlink", CurTime() + 0.5 )
				local hullTrace = util.TraceHull({
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 2400,
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 9)
				});

				self.groundTrace = util.TraceHull({
					start = hullTrace.HitPos + Vector(0, 0, 1),
					endpos = hullTrace.HitPos - Vector(0, 0, 1000),
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 1)
				});

				local edgeTrace;

				if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
					local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward();
					edgeTrace = util.TraceEntity({
						start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
						endpos = hullTrace.HitPos - ledgeForward * 33,
						filter = self.Owner
					}, self.Owner);

					if (edgeTrace.Hit and !edgeTrace.AllSolid) then
						local clearTrace = util.TraceHull({
							start = hullTrace.HitPos,
							endpos = hullTrace.HitPos + Vector(0, 0, 35),
							mins = Vector(-16, -16, 0),
							maxs = Vector(16, 16, 1),
							filter = self.Owner
						});

						if (!clearTrace.Hit) then
							self.groundTrace.HitPos = edgeTrace.HitPos;
							bFoundEdge = true;
						end;
					end;
				end;
			end	
		end,
})

wOS.ForcePowers:RegisterNewPower({
		name = "Destruction",
		icon = "DES",
		description = "Hold to unleash true power on your enemies",
		image = "wos/forceicons/icefuse/destruction.png",
		help = "Cast a large spiral of lightning bolts from the sky down to your target",
		cooldown = 0,
		manualaim = false,
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if ( !self._ForceDestruction && self:GetForce() < 50 ) then return end

			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				if ( !self._ForceDestruction ) then self:SetForce( self:GetForce() - 50 ) self._ForceDestruction = 5 end
				self._ForceDestruction = self._ForceDestruction + 1
				self:SetForce( self:GetForce() - 2 )
				if ( self:GetForce() > 0.99 ) then return end
			else
				if ( !self._ForceDestruction ) then return end
			end
			self.Owner:EmitSound( Sound( "npc/strider/charging.wav" ) )	
			self:SetAttackDelay( CurTime() + 2 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 2 )
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			local pos = tr.HitPos + Vector( 0, 0, 600 )		
			local pi = math.pi
			local max = self._ForceDestruction
			local bullet = {}
			bullet.Num 		= 1
			bullet.Spread 	= 0		
			bullet.Tracer	= 1
			bullet.Force	= 0						
			bullet.Damage	= 500
			bullet.AmmoType = "Pistol"
			bullet.Entity = self.Owner
			bullet.TracerName = "thor_storm"
			bullet.Callback = function( ply, tr, dmginfo )
				sound.Play( "npc/strider/fire.wav", tr.HitPos )
			end
			timer.Simple( 2, function()
				if not IsValid( self ) then return end
				bullet.Src 		= pos
				bullet.Dir 		= Vector( 0, 0, -1 )
				self.Owner:FireBullets( bullet )

				for i=1, max do
					timer.Simple( 0.1*i, function()
						if not IsValid( self ) then return end
						local dis = i + i*30
						if not IsValid( self.Owner ) then return end
						bullet.Src 		= pos + Vector( dis*math.sin( i*pi*1/8 ), dis*math.cos( i*pi*1/8 ), 0 )
						bullet.Dir 		= Vector( 0, 0, -1 )
						self.Owner:FireBullets( bullet )
						bullet.Src 		= pos + Vector( dis*math.sin( i*pi*3/8 ), dis*math.cos( i*pi*3/8 ), 0 )
						bullet.Dir 		= Vector( 0, 0, -1 )
						self.Owner:FireBullets( bullet )
						bullet.Src 		= pos + Vector( dis*math.sin( i*pi*5/8 ), dis*math.cos( i*pi*5/8 ), 0 )
						bullet.Dir 		= Vector( 0, 0, -1 )
						self.Owner:FireBullets( bullet )
						bullet.Src 		= pos + Vector( dis*math.sin( i*pi*7/8 ), dis*math.cos( i*pi*7/8 ), 0 )
						bullet.Dir 		= Vector( 0, 0, -1 )
						self.Owner:FireBullets( bullet )						
					end )
				end
			end ) 
			self._ForceDestruction = nil
			self:SetNextAttack( 3 )
			return true
		end,
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Choke",
		icon = "CH",
		description = "I find your lack of faith disturbing",
		image = "wos/forceicons/icefuse/choke.png",
		help = "Choke an enemy in place, however they may break free from it",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if self:GetForce() < 1 then return end
			if IsValid( self.ChokeTarget ) then return end
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			if not IsValid( tr.Entity ) then return end
			if not tr.Entity:IsPlayer() and not tr.Entity:IsNPC() then return end
			if self.Owner:GetPos():Distance( tr.Entity:GetPos() ) >= 400 then return end
		
			self.ChokeTarget = tr.Entity
			self.ChokeTarget:EmitSound( "wos/icefuse/choke_start.wav" )
			self.ChokePos = tr.Entity:GetPos()
		end,
		think = function( self )
			if not IsValid( self.ChokeTarget ) then return end
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 ) then return end
			if not self.ChokeTarget:Alive() then self.ChokeTarget = nil return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				local dmg = DamageInfo()
				dmg:SetDamage( 0.4 ) --0.21
				dmg:SetDamageType( DMG_CRUSH )
				dmg:SetAttacker( self.Owner )
				dmg:SetInflictor( self )
				self.ChokeTarget:TakeDamageInfo( dmg )
				self.ChokeTarget:SetLocalVelocity( ( self.ChokePos - self.ChokeTarget:GetPos() + Vector( 0, 0, 55 ) )*5 )
				self.ChokeTarget:SetNW2Float( "wOS.ChokeTime", CurTime() + 0.5 )
				self.ChokeTarget:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 0.5 )
				self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.1 )
			
				self:SetForce( self:GetForce() - 0.02 )
				if ( !self.SoundChoking ) then
					self.SoundChoking = CreateSound( self.Owner, "wos/icefuse/choke_active.wav" )
					self.SoundChoking:PlayEx( 0.25, 100 )
				else
					self.SoundChoking:PlayEx( 0.25, 100 )
				end
				timer.Create( "test" .. self.Owner:SteamID64() .. "_choke", 0.2, 1, function() if ( self.SoundChoking ) then self.SoundChoking:Stop() self.SoundChoking = nil end end )
				
				if ( !self.SoundGagging ) then
					self.SoundGagging = CreateSound( self.ChokeTarget, "wos/icefuse/choke_gagging.wav" )
					self.SoundGagging:Play()
				else
					self.SoundGagging:Play()
				end
				timer.Create( "test" .. self.Owner:SteamID64(), 0.2, 1, function() if ( self.SoundGagging ) then self.SoundGagging:Stop() self.SoundGagging = nil end end )

				if ( self:GetForce() < 1 ) then 
					local ed = EffectData()
					self.ChokeTarget = nil
					self:SetNextAttack( 1 )		
				end
			else
				if not IsValid( self.ChokeTarget ) then return end
				local ed = EffectData()
				self.ChokeTarget = nil
				self:SetNextAttack( 1 )
				return true
			end
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Group Choke",
		icon = "GCH",
		description = "Choke them all",
		image = "wos/forceicons/icefuse/choke.png",
		help = "Choke up to 10 enemies in place, however they may break free from it",
		cooldown = 0,
		manualaim = false,
		distance = 400,
		target = 10,
		action = function( self )
			if self:GetForce() < 1 then return end
			if self.IsGroupChoking then return end
			local foundents = self:SelectTargets( 10, 400 )
			if #foundents < 1 then return end
			self.ChokeTargets = {}
			self.ChokePoss = {}
			for id, ent in pairs( foundents ) do
				if not ent:IsPlayer() then continue end
				self.ChokeTargets[ id ] = ent
				ent:EmitSound( "wos/icefuse/choke_start.wav" )
				self.ChokePoss[ id ] = ent:GetPos()
			end
		end,
		think = function( self )
			if not self.ChokeTargets then self.IsGroupChoking = false return end
			if ( self:GetNextSecondaryFire() > CurTime() ) then self.IsGroupChoking = false return end
			if ( self:GetForce() < 1 ) then self.IsGroupChoking = false return end
			if #self.ChokeTargets < 1 then self.IsGroupChoking = false return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			self.Owner:SetNW2Float( "wOS.IceForceAnim", CurTime() + 0.5 )
			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
			self:SetForce( self:GetForce() - 0.02 )
			if ( !self.SoundChoking ) then
				self.SoundChoking = CreateSound( self.Owner, "wos/icefuse/choke_active.wav" )
				self.SoundChoking:PlayEx( 0.25, 100 )
			else
				self.SoundChoking:PlayEx( 0.25, 100 )
			end
			timer.Create( "test" .. self.Owner:SteamID64() .. "_choke", 0.2, 1, function() if ( self.SoundChoking ) then self.SoundChoking:Stop() self.SoundChoking = nil end end )	
			self.IsGroupChoking = true
				for id, ply in pairs( self.ChokeTargets ) do
					if not IsValid( ply ) then self.ChokeTargets[ id ] = nil continue end
					if not ply:Alive() then self.ChokeTargets[ id ] = nil continue end
					local dmg = DamageInfo()
					dmg:SetDamage( 0.4 ) --0.21
					dmg:SetDamageType( DMG_CRUSH )
					dmg:SetAttacker( self.Owner )
					dmg:SetInflictor( self )
					ply:TakeDamageInfo( dmg )
					ply:SetLocalVelocity( ( self.ChokePoss[ id ] - ply:GetPos() + Vector( 0, 0, 55 ) )*5 )
					ply:SetNW2Float( "wOS.ChokeTime", CurTime() + 0.5 )
					ply:SetNW2Float( "wOS.SaberAttackDelay", CurTime() + 0.5 )
				
					self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.1 )
				
					if ( !ply.SoundGagging ) then
						ply.SoundGagging = CreateSound( ply, "wos/icefuse/choke_gagging.wav" )
						ply.SoundGagging:Play()
					else
						ply.SoundGagging:Play()
					end
					timer.Create( "test" .. ply:SteamID64(), 0.2, 1, function() if ( ply.SoundGagging ) then ply.SoundGagging:Stop() ply.SoundGagging = nil end end )

					if ( self:GetForce() < 1 ) then 
						self.ChokeTargets = {}
						self:SetNextAttack( 1 )		
						self.IsGroupChoking = false
						return
					end
				end
			else
				self.ChokeTargets = {}
				self:SetNextAttack( 1 )
				self.IsGroupChoking = false
				return true
			end
		end
})

wOS.ForcePowers:RegisterNewPower({
	name = "Saber Barrier",
	icon = "SB",
	description = "The ultimate defense.",
	image = "wos/forceicons/icefuse/barrier.png",
	help = "Send your lightsabers around you, dealing damage to nearby enemies and blocking all incoming fire",
	cooldown = 0,
	manualaim = false,
	action = function( self )
		if self:GetForce() < 50 then return end
		local time = self.Owner:SetSequenceOverride( "phalanx_r_s2_charge", 3.5 )	
		self:SetAttackDelay( CurTime() + time )

		if not self:GetOffhandOnly() then
			local ent_lightsaber = ents.Create( "ent_lightsaber_barrier" )
			ent_lightsaber:SetPos( self.Owner:EyePos() - Vector( 0, 0, 8 ) )
			ent_lightsaber:SetAngles( Angle( 0, 0, 0 ) )
			ent_lightsaber:SetModel( self:GetWorldModel() )
			ent_lightsaber.CustomSettings = table.Copy( self:GetCustomSettings() )
			ent_lightsaber:SetUseLength( self.UseLength )
			ent_lightsaber:SetUseWidth( self.UseWidth )
			ent_lightsaber:SetUseColor( self.UseColor )
			ent_lightsaber:SetUseInnerColor( self.UseInnerColor )
			ent_lightsaber:SetUseDarkInner( self.UseDarkInner )
			ent_lightsaber:SetWorldModel( self:GetWorldModel() )
			ent_lightsaber.SaberThrowDamage = self.SaberThrowDamage	
			ent_lightsaber.LoopSound = self.LoopSound
			ent_lightsaber.SwingSound = self.SwingSound
			ent_lightsaber.OnSound = self.OnSound
			ent_lightsaber.OffSound = self.OffSound
			ent_lightsaber:SetLastUpdate( CurTime() )
			ent_lightsaber:SetEnabled( true )
			ent_lightsaber.WardTime = CurTime() + 4
			ent_lightsaber:SetOwner( self.Owner )
			ent_lightsaber:Spawn()
			ent_lightsaber:Activate()
		end

		if self:GetDualMode() || self:GetOffhandOnly() then
			local ent_lightsaber = ents.Create( "ent_lightsaber_barrier" )
			ent_lightsaber:SetPos( self.Owner:EyePos() - Vector( 0, 0, 8 ) )
			ent_lightsaber:SetAngles( Angle( 0, 0, 0 ) )
			ent_lightsaber:SetModel( self:GetSecWorldModel() )
			ent_lightsaber.CustomSettings = table.Copy( self:GetSecCustomSettings() )
			ent_lightsaber:SetUseLength( self.UseSecLength )
			ent_lightsaber:SetUseWidth( self.UseSecWidth )
			ent_lightsaber:SetUseColor( self.UseSecColor )
			ent_lightsaber:SetUseInnerColor( self.UseSecInnerColor )
			ent_lightsaber:SetUseDarkInner( self.UseSecDarkInner )
			ent_lightsaber:SetWorldModel( self:GetSecWorldModel() )
			ent_lightsaber.SaberThrowDamage = self.SaberThrowDamage	
			ent_lightsaber.LoopSound = self.LoopSound
			ent_lightsaber.SwingSound = self.SwingSound
			ent_lightsaber.OnSound = self.OnSound
			ent_lightsaber.OffSound = self.OffSound
			ent_lightsaber:SetLastUpdate( CurTime() )
			ent_lightsaber:SetEnabled( true )
			ent_lightsaber.WardTime = CurTime() + 4
			ent_lightsaber.Second = true
			ent_lightsaber:SetOwner( self.Owner )
			ent_lightsaber:Spawn()
			ent_lightsaber:Activate()
		end

		self:SetForce( self:GetForce() - 50 )
		self:SetEnabled( false )
		self:SetBladeLength( 0 )
		self:SetNextAttack( 4 )
		self.Owner:DrawWorldModel( false )
		self.Owner:SetNW2Bool( "wOS.BarrierStuff", true )
		
		return true
	end,
})
-- Monarchs custom
wOS.ForcePowers:RegisterNewPower({
		name = "Sisters Apparitions",
		icon = "SA",
		description = "Phase through to a new location.",
		image = "wos/forceicons/icefuse/teleport.png",
		help = "Instantly teleport to a ledge or position a distance away",
		cooldown = 0,
		manualaim = false,
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 5 ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if self.Owner:KeyReleased( IN_ATTACK2 ) and self.groundTrace then
				local speed = 4000;
				local bFoundEdge = false;

				self.Owner:SetNW2Float("wOS.ShowBlink", 0 );

				local hullTrace = util.TraceHull({
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 2400,
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 9)
				});

				local groundTrace = util.TraceEntity({
					start = hullTrace.HitPos + Vector(0, 0, 1),
					endpos = hullTrace.HitPos - (self.Owner:EyePos() - self.Owner:GetPos()),
					filter = self.Owner
				}, self.Owner);

				local edgeTrace;

				if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
					local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward();
					edgeTrace = util.TraceEntity({
						start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
						endpos = hullTrace.HitPos - ledgeForward * 33,
						filter = self.Owner
					}, self.Owner);

					if (edgeTrace.Hit and !edgeTrace.AllSolid) then
						local clearTrace = util.TraceHull({
							start = hullTrace.HitPos,
							endpos = hullTrace.HitPos + Vector(0, 0, 35),
							mins = Vector(-16, -16, 0),
							maxs = Vector(16, 16, 1),
							filter = self.Owner
						});

						bFoundEdge = !clearTrace.Hit;
					end;
				end;

				if (!bFoundEdge and groundTrace.AllSolid) then
					self.groundTrace = nil		
					self:SetNextSecondaryFire( CurTime() + 0.2 )						
					return;
				end;

				local endPos = ( bFoundEdge and edgeTrace.HitPos ) or groundTrace.HitPos;

				self.Owner:SetPos( endPos )
				self.Owner:EmitSound("blink/exit" .. math.random(1, 2) .. ".wav");

				self.groundTrace = nil
				self:SetForce( self:GetForce() - 5 )
				self:SetNextSecondaryFire( CurTime() + 0.1 )	
				return true
			end;

			if self.Owner:KeyDown( IN_ATTACK2 ) then
				local bFoundEdge = false;
				self.Owner:SetNW2Float( "wOS.ShowBlink", CurTime() + 0.5 )
				local hullTrace = util.TraceHull({
					start = self.Owner:EyePos(),
					endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * 2400,
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 9)
				});

				self.groundTrace = util.TraceHull({
					start = hullTrace.HitPos + Vector(0, 0, 1),
					endpos = hullTrace.HitPos - Vector(0, 0, 1000),
					filter = self.Owner,
					mins = Vector(-16, -16, 0),
					maxs = Vector(16, 16, 1)
				});

				local edgeTrace;

				if (hullTrace.Hit and hullTrace.HitNormal.z <= 0) then
					local ledgeForward = Angle(0, hullTrace.HitNormal:Angle().y, 0):Forward();
					edgeTrace = util.TraceEntity({
						start = hullTrace.HitPos - ledgeForward * 33 + Vector(0, 0, 40),
						endpos = hullTrace.HitPos - ledgeForward * 33,
						filter = self.Owner
					}, self.Owner);

					if (edgeTrace.Hit and !edgeTrace.AllSolid) then
						local clearTrace = util.TraceHull({
							start = hullTrace.HitPos,
							endpos = hullTrace.HitPos + Vector(0, 0, 35),
							mins = Vector(-16, -16, 0),
							maxs = Vector(16, 16, 1),
							filter = self.Owner
						});

						if (!clearTrace.Hit) then
							self.groundTrace.HitPos = edgeTrace.HitPos;
							bFoundEdge = true;
						end;
					end;
				end;
			end	
		end,
})