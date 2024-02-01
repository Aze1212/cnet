--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}

wOS.ForcePowers:RegisterNewPower({
		name = "Force Leap",
		icon = "L",
		image = "wos/forceicons/leap.png",
		cooldown = 2,
		manualaim = false,
		description = "Jump longer and higher. Aim higher to jump higher/further.",
		help = "Take a huge leap in the direction you're aiming",
		action = function( self )
			if ( self:GetForce() < 10 || !self.Owner:IsOnGround() ) then return end
			self:SetForce( self:GetForce() - 10 )

			self:SetNextAttack( 0.5 )

			self.Owner:SetVelocity( self.Owner:GetAimVector() * 512 + Vector( 0, 0, 512 ) )

			self:PlayWeaponSound( "lightsaber/force_leap.wav" )

			// Trigger the jump animation, yay
			self:CallOnClient( "ForceJumpAnim", "" )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
			name = "Charge",
			icon = "CH",
			distance = 600,
			image = "wos/forceicons/charge.png",
			target = 1,
			cooldown = 0,
			manualaim = false,
			description = "Lunge at your enemy",
			help = "Target an enemy and leap at them in an offensive stance",
			action = function( self )
				local ent = self:SelectTargets( 1, 600 )[ 1 ]
				if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
				if ( self:GetForce() < 20 ) then self:SetNextAttack( 0.2 ) return end
				local newpos = ( ent:GetPos() - self.Owner:GetPos() )
				newpos = newpos / newpos:Length()
				self.Owner:SetLocalVelocity( newpos*700 + Vector( 0, 0, 300 ) )
				self:SetForce( self:GetForce() - 20 )
				self:PlayWeaponSound( "lightsaber/force_leap.wav" )
				self.Owner:SetSequenceOverride( "phalanx_a_s2_t1", 5 )		
				self:SetNextAttack( 1 )
				self.AerialLand = true
				return true
			end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Absorb",
		icon = "A",
		image = "wos/forceicons/absorb.png",
		cooldown = 0,
		description = "Hold Mouse 2 to protect yourself from harm",
		help = "Incoming damage is reduced and removed from your force instead",
		action = function( self )
			if ( self:GetForce() < 1 ) then return end
			self:SetForce( self:GetForce() - 0.1 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.6 )
			self:SetNextAttack( 0.6 )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Saber Throw",
		icon = "T",
		image = "wos/forceicons/throw.png",
		cooldown = 0,
		manualaim = false,
		description = "Throws your lightsaber. It will return to you.",
		help = "Aim and throw your lightsaber. You will not be able to attack during it's travel",
		action = function(self)
			if self:GetForce() < 20 then return end
			self:SetForce( self:GetForce() - 20 )
			self:SetEnabled(false)
			self:SetBladeLength(0)
			self:SetNextAttack( 1 )
			self:GetOwner():DrawWorldModel(false)

			local ent = ents.Create("ent_lightsaber_thrown")
			ent:SetModel(self:GetWorldModel())
			ent.CustomSettings = table.Copy( self:GetCustomSettings() )
			ent:SetUseLength( self.UseLength )
			ent:SetUseWidth( self.UseWidth )
			ent:SetUseColor( self.UseColor )
			ent:SetUseInnerColor( self.UseInnerColor )
			ent:SetUseDarkInner( self.UseDarkInner )
			ent:SetWorldModel( self:GetWorldModel() )
			ent.SaberThrowDamage = self.SaberThrowDamage	
			ent.LoopSound = self.LoopSound
			ent.SwingSound = self.SwingSound
			ent.OnSound = self.OnSound
			ent.OffSound = self.OffSound
			ent:SetLastUpdate( CurTime() )

			local pos = self:GetSaberPosAng()
			ent:SetPos(pos)
			pos = pos + self.Owner:GetAimVector() * 750
			ent:SetEndPos(pos)
			ent:SetOwner(self.Owner)


			ent:Spawn()
			ent:Activate()

			return true
		end
}) 

wOS.ForcePowers:RegisterNewPower({
		name = "Force Heal",
		icon = "H",
		image = "wos/forceicons/heal.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "Heals your target.",
		help = "Target something and heal them for 250 HP",
		action = function( self )
			if ( self:GetForce() < 10 ) then return end
			local foundents = 0

			for k, v in pairs( self:SelectTargets( 1 ) ) do
				if ( !IsValid( v ) ) then continue end
				foundents = foundents + 1
			local ed = EffectData()
			ed:SetOrigin( self:GetSaberPosAng() )
			ed:SetEntity( v )
			util.Effect( "rb655_force_heal", ed, true, true )
				v:SetHealth( math.Clamp( v:Health() + 250, 0, v:GetMaxHealth() ) )
			end

			if ( foundents > 0 ) then
				self:SetForce( self:GetForce() - 3 )
				local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
				if not tbl then 
					tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].XPPerHeal 
				else 
					tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].XPPerHeal
				end
				self.Owner:AddSkillXP( tbl )
			end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.5 )
			self:SetNextAttack( 0.5 )
			return true
		end
}) 

wOS.ForcePowers:RegisterNewPower({
		name = "Group Heal",
		icon = "GH",
		image = "wos/forceicons/group_heal.png",
		cooldown = 0,
		manualaim = false,
		description = "Heals all around you.",
		help = "Heal all targets around you for 2000 HP",
		action = function( self )
			if ( self:GetForce() < 75 ) then return end
			local players = 0
			for _, ply in pairs( ents.FindInSphere( self.Owner:GetPos(), 200 ) ) do
				if not IsValid( ply ) then continue end
				if not ply:IsPlayer() then continue end
				if not ply:Alive() then continue end
				if players >= 8 then break end
				ply:SetHealth( math.Clamp( ply:Health() + 2000, 0, ply:GetMaxHealth() ) )
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ply )
				util.Effect( "rb655_force_heal", ed, true, true )		
				players = players + 1				
			end
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.6 )
			self:SetNextAttack( 0.6 )
			self:SetForce( self:GetForce() - 75 )
			local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
			if not tbl then 
				tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].XPPerHeal 
			else 
				tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].XPPerHeal
			end
			self.Owner:AddSkillXP( tbl )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Cloak",
		icon = "C",
		image = "wos/forceicons/cloak.png",
		cooldown = 0,
		description = "Shrowd yourself with the force for 10 seconds",
		help = "Become invisible to NPCs and players, with higher efficiency the slower you move",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self:GetCloaking() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.CloakTime = CurTime() + 10

			self.Owner:SetNoTarget( true )
			local stean = self.Owner:SteamID64()
			local ply = self.Owner
			if timer.Exists( "ALCS_CLOAK_" .. stean ) then
				timer.Destroy( "ALCS_CLOAK_" .. stean )
			end
			timer.Create( "ALCS_CLOAK_" .. stean, 0.5, 21, function()
				if not IsValid( ply ) then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					return
				end
				if not IsValid( self ) or not ply:Alive() or self.CloakTime <= CurTime() then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					ply:SetNoTarget( false )
					return
				end

				ply:SetNoTarget( ply:GetActiveWeapon() == self )
			end )

			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Reflect",
		icon = "FR",
		image = "wos/forceicons/reflect.png",
		cooldown = 10,
		description = "An eye for an eye",
		help = "Reflect 100% of damage taken back to the inflictor",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self.Owner:GetNW2Float( "ReflectTime", 0 ) >= CurTime() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetNW2Float( "ReflectTime", CurTime() + 2 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Rage",
		icon = "RA",
		image = "wos/forceicons/rage.png",
		cooldown = 0,
		description = "Unleash your anger",
		help = "Increased damage and stamina drain to opponents",
		action = function( self )
		if ( self:GetForce() < 50 || !self.Owner:IsOnGround() ) then return end
			if self.Owner:GetNW2Float( "RageTime", 0 ) >= CurTime() then return end
			self:SetForce( self:GetForce() - 50 )
			self:SetNextAttack( 0.7 )
			self:PlayWeaponSound( "lightsaber/force_leap.wav" )
			self.Owner:SetNW2Float( "RageTime", CurTime() + 10 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Shadow Strike",
		icon = "SS",
		distance = 30,
		image = "wos/forceicons/shadow_strike.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "From the darkness it preys",
		help = "While cloaked, reveal yourself to inflict a large amount of damage to a target",
		action = function( self )
			if !self:GetCloaking() then return end
			local ent = self:SelectTargets( 1, 30 )[ 1 ]
			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
			if ( self:GetForce() < 50 ) then self:SetNextAttack( 0.2 ) return end
			self.Owner:SetSequenceOverride("b_c3_t2", 1)
			self:SetForce( self:GetForce() - 50 )
			self.Owner:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
			self.Owner:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			ent:TakeDamage( 1500, self.Owner, self )
			self.CloakTime = CurTime() + 0.5
			self:SetNextAttack( 0.7 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Pull",
		icon = "PL",
		target = 1,
		description = "Get over here!",
		image = "wos/forceicons/pull.png",
		cooldown = 0,
		manualaim = false,
		help = "Pulls a target to you, retaining it's momentum",
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			local newpos = ( self.Owner:GetPos() - ent:GetPos() )
			newpos = newpos / newpos:Length()
			ent:SetVelocity( newpos*700 + Vector( 0, 0, 300 ) )
			self:SetForce( self:GetForce() - 20 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.3 )
			self:SetNextAttack( 1 )
			return true
		end		
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Push",
		icon = "PH",
		target = 1,
		distance = 150,
		description = "They are no harm at a distance",
		help = "Pushes a target away from you, retaining it's momentum",
		image = "wos/forceicons/push.png",
		cooldown = 0,
		manualaim = false,
		action = function( self )
			if ( self:GetForce() < 20 ) then return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if not IsValid( ent ) then return end
			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
			local newpos = ( self.Owner:GetPos() - ent:GetPos() )
			newpos = newpos / newpos:Length()
			ent:SetVelocity( newpos*-700 + Vector( 0, 0, 300 ) )
			self:SetForce( self:GetForce() - 20 )
			self.Owner:SetNW2Float( "wOS.ForceAnim", CurTime() + 0.3 )
			self:SetNextAttack( 1 )
			return true
		end			
})

wOS.ForcePowers:RegisterNewPower({
		name = "Lightning Strike",
		icon = "LS",
		distance = 600,
		image = "wos/forceicons/lightning_strike.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "A focused charge of lightning",
		help = "Channel a single concentrated lightning beam towards a target",
		action = function( self )
			local ent = self:SelectTargets( 1, 600 )[ 1 ]
			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
			if ( self:GetForce() < 20 ) then self:SetNextAttack( 0.2 ) return end
			self:SetForce( self:GetForce() - 20 )
			
			local ed = EffectData()
			ed:SetOrigin( self:GetSaberPosAng() )
			ed:SetEntity( ent )
			util.Effect( "rb655_force_lighting", ed, true, true )

			local dmg = DamageInfo()
			dmg:SetAttacker( self.Owner || self )
			dmg:SetInflictor( self.Owner || self )
			dmg:SetDamage( 150 )
			ent:TakeDamageInfo( dmg )
			self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
			self.Owner:EmitSound( Sound( "ambient/atmosphere/thunder1.wav" ) )
			if ( !self.SoundLightning ) then
				self.SoundLightning = CreateSound( self.Owner, "lightsaber/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
				self.SoundLightning:Play()
			else
				self.SoundLightning:Play()
			end
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetPos() + Vector( 0, 0, 10 )	
			bullet.Dir 		= ( ent:GetPos() - ( self.Owner:GetPos() + Vector( 0, 0, 10 ) ) )
			bullet.Spread 	= 0		
			bullet.Tracer	= 1
			bullet.Force	= 0						
			bullet.Damage	= 0
			bullet.AmmoType = "Pistol"
			bullet.Entity = self.Owner
			bullet.TracerName = "thor_thunder"
			self:SetNextAttack( 2 )
			self.Owner:FireBullets( bullet )
			timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			return true
		end
})
wOS.ForcePowers:RegisterNewPower({
		name = "Advanced Cloak",
		icon = "AC",
		image = "wos/forceicons/advanced_cloak.png",
		cooldown = 0,
		manualaim = false,
		description = "Shrowd yourself with the force for 25 seconds",
		help = "Become invisible to NPCs and players, with higher efficiency the slower you move",
		action = function( self )
		if ( self:GetForce() < 20 || !self.Owner:IsOnGround() ) then return end
			if self:GetCloaking() then return end
			self:SetForce( self:GetForce() - 20 )
			self:SetNextAttack( 0.7 )
			self.CloakTime = CurTime() + 60

			self.Owner:SetNoTarget( true )
			local stean = self.Owner:SteamID64()
			local ply = self.Owner
			if timer.Exists( "ALCS_CLOAK_" .. stean ) then
				timer.Destroy( "ALCS_CLOAK_" .. stean )
			end
			timer.Create( "ALCS_CLOAK_" .. stean, 0.5, 51, function()
				if not IsValid( ply ) then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					return
				end
				if not IsValid( self ) or not ply:Alive() or self.CloakTime <= CurTime() then
					timer.Destroy( "ALCS_CLOAK_" .. stean )
					ply:SetNoTarget( false )
					return
				end

				ply:SetNoTarget( ply:GetActiveWeapon() == self )
			end )

			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Lightning",
		icon = "L",
		target = 1,
		image = "wos/forceicons/lightning.png",
		cooldown = 0,
		manualaim = false,
		description = "Torture people ( and monsters ) at will.",
		help = "Continuously channel a stream of lightning towards a target, but it can be blocked",
		action = function( self )
			if ( self:GetForce() < 1 ) then return end

			local foundents = 0
			for id, ent in pairs( self:SelectTargets( 1 ) ) do
				if ( !IsValid( ent ) ) then continue end

				foundents = foundents + 1
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ent )
				util.Effect( "rb655_force_lighting", ed, true, true )

				local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner || self )
				dmg:SetInflictor( self.Owner || self )
				dmg:SetDamage( 8 )
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

				timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			end
			self:SetNextAttack( 0.1 )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Force Combust",
		icon = "C",
		target = 1,
		description = "Ignite stuff infront of you.",
		image = "wos/forceicons/combust.png",
		help = "Inflict flame damage over time on a single target",
		cooldown = 0,
		manualaim = false,
		action = function( self )

			local ent = self:SelectTargets( 1 )[ 1 ]

			if ( !IsValid( ent ) or ent:IsOnFire() ) then self:SetNextAttack( 0.2 ) return end

			local time = math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 1, 16 )
			local neededForce = math.ceil( math.Clamp( time * 2, 10, 32 ) )

			if ( self:GetForce() < neededForce ) then self:SetNextAttack( 0.2 ) return end

			ent:Ignite( time, 0 )
			self:SetForce( self:GetForce() - neededForce )

			self:SetNextAttack( 1 )
			return true
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Force Repulse",
		icon = "R",
		image = "wos/forceicons/repulse.png",
		description = "Hold to charge for greater distance/damage. Push back everything near you.",
		help = "Charge a repulsive wave with higher push strength the longer it's charged",		
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if ( !self._ForceRepulse && self:GetForce() < 16 ) then return end

			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				if ( !self._ForceRepulse ) then self:SetForce( self:GetForce() - 16 ) self._ForceRepulse = 1 end

				if ( !self.NextForceEffect or self.NextForceEffect < CurTime() ) then
					local ed = EffectData()
					ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
					ed:SetRadius( 256 * self._ForceRepulse )
					util.Effect( "rb655_force_repulse_in", ed, true, true )

					self.NextForceEffect = CurTime() + math.Clamp( self._ForceRepulse / 20, 0.1, 0.5 )
				end

				self._ForceRepulse = self._ForceRepulse + 0.025
				self:SetForce( self:GetForce() - 0.5 )
				if ( self:GetForce() > 0.99 ) then return end
			else
				if ( !self._ForceRepulse ) then return end
			end

			local maxdist = 256 * self._ForceRepulse

			for i, e in pairs( ents.FindInSphere( self.Owner:GetPos(), maxdist ) ) do
				if ( e == self.Owner ) then continue end

				local dist = self.Owner:GetPos():Distance( e:GetPos() )
				local mul = ( maxdist - dist ) / 256

				local v = ( self.Owner:GetPos() - e:GetPos() ):GetNormalized()
				v.z = 0

				if ( e:IsNPC() && util.IsValidRagdoll( e:GetModel() or "" ) ) then

					local dmg = DamageInfo()
					dmg:SetDamagePosition( e:GetPos() + e:OBBCenter() )
					dmg:SetDamage( 75 * mul )
					dmg:SetDamageType( DMG_GENERIC )
					if ( ( 1 - dist / maxdist ) > 0.8 ) then
						dmg:SetDamageType( DMG_DISSOLVE )
						dmg:SetDamage( e:Health() * 5 )
					end
					dmg:SetDamageForce( -v * math.min( mul * 40000, 80000 ) )
					dmg:SetInflictor( self.Owner )
					dmg:SetAttacker( self.Owner )
					e:TakeDamageInfo( dmg )

					if ( e:IsOnGround() ) then
						e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
					elseif ( !e:IsOnGround() ) then
						e:SetVelocity( v * mul * -1024 + Vector( 0, 0, 64 ) )
					end

				elseif ( e:IsPlayer() && e:IsOnGround() ) then
					e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
				elseif ( e:IsPlayer() && !e:IsOnGround() ) then
					e:SetVelocity( v * mul * -384 + Vector( 0, 0, 64 ) )
				elseif ( e:GetPhysicsObjectCount() > 0 ) then
					for i = 0, e:GetPhysicsObjectCount() - 1 do
						e:GetPhysicsObjectNum( i ):ApplyForceCenter( v * mul * -512 * math.min( e:GetPhysicsObject():GetMass(), 256 ) + Vector( 0, 0, 64 ) )
					end
				end
			end

			local ed = EffectData()
			ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
			ed:SetRadius( maxdist )
			util.Effect( "rb655_force_repulse_out", ed, true, true )

			self._ForceRepulse = nil

			self:SetNextAttack( 1 )

			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Storm",
		icon = "STR",
		image = "wos/forceicons/storm.png",
		cooldown = 0,
		description = "Charge for 2 seconds, unleash a storm on your enemies",
		help = "Create a wave of lightning strikes frpm above your target in a circular pattern",		
		action = function( self )
			if ( self:GetForce() < 100 ) then self:SetNextAttack( 0.2 ) return end
			if self:GetAttackDelay() >= CurTime() then return end
			self:SetForce( self:GetForce() - 100 )
			self.Owner:EmitSound( Sound( "npc/strider/charging.wav" ) )	
			self:SetAttackDelay( CurTime() + 2 )
			local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
			local pos = tr.HitPos + Vector( 0, 0, 600 )		
			local pi = math.pi
			local bullet = {}
			bullet.Num 		= 1
			bullet.Spread 	= 0		
			bullet.Tracer	= 1
			bullet.Force	= 0						
			bullet.Damage	= 500
			bullet.AmmoType = "Pistol"
			bullet.Entity = self.Owner
			bullet.TracerName = "thor_storm"
			timer.Simple( 2, function()
				if not IsValid( self.Owner ) then return end
				self.Owner:EmitSound( Sound( "ambient/atmosphere/thunder1.wav" ) )
				bullet.Src 		= pos
				bullet.Dir 		= Vector( 0, 0, -1 )
				self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
				self.Owner:FireBullets( bullet )
				timer.Simple( 0.1, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*2/5 ), 65*math.cos( pi*2/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )			
				end )
				timer.Simple( 0.2, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*4/5 ), 65*math.cos( pi*4/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )				
				end )
				timer.Simple( 0.3, function()
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*6/5 ), 65*math.cos( pi*6/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
				timer.Simple( 0.4, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( pi*8/5 ), 65*math.cos( pi*8/5 ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
				timer.Simple( 0.5, function() 
					if not IsValid( self.Owner ) then return end
					bullet.Src 		= pos + Vector( 65*math.sin( 2*pi ), 65*math.cos( 2*pi ), 0 )
					bullet.Dir 		= Vector( 0, 0, -1 )
					self.Owner:EmitSound( Sound( "npc/strider/fire.wav" ) )
					self.Owner:FireBullets( bullet )					
				end )
			end )
			return true
		end
})
	
wOS.ForcePowers:RegisterNewPower({
		name = "Meditate",
		icon = "M",
		image = "wos/forceicons/meditate.png",
		description = "Relax yourself and channel your energy",
		help = "Focus to heal yourself by 1% of your max health and channel energy to perform a devestator",		
		think = function( self )
			if self.MeditateCooldown and self.MeditateCooldown >= CurTime() then return end
			if ( self.Owner:KeyDown( IN_ATTACK2 ) ) and !self:GetEnabled() and self.Owner:OnGround() then
				self._ForceMeditating = true
			else
				self._ForceMeditating = false
			end
			if self._ForceMeditating then
				self:SetMeditateMode( 1 )
				if not self._NextMeditateHeal then self._NextMeditateHeal = 0 end
				if self._NextMeditateHeal < CurTime() then
					self.Owner:SetHealth( math.min( self.Owner:Health() + ( self.Owner:GetMaxHealth()*0.10 ), self.Owner:GetMaxHealth() ) )
					if #self.DevestatorList > 0 then
						self:SetDevEnergy( self:GetDevEnergy() + self.DevCharge )
					end
					local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
					if not tbl then 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].Meditation 
					else 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].Meditation 
					end
					self.Owner:AddSkillXP( tbl )
					self._NextMeditateHeal = CurTime() + 3
				end
				self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				self.Owner:SetMoveType(MOVETYPE_NONE)
			else
				self:SetMeditateMode( 0 )
				if self:GetMoveType() != MOVETYPE_WALK and self.Owner:GetNW2Float( "wOS.DevestatorTime", 0 ) < CurTime() then
					self.Owner:SetMoveType(MOVETYPE_WALK)
				end
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.MeditateCooldown = CurTime() + 3
			end
		end
})

wOS.ForcePowers:RegisterNewPower({
		name = "Channel Hatred",
		icon = "HT",
		image = "wos/forceicons/channel_hatred.png",
		description = "I can feel your anger",
		help = "Focus to heal yourself by 1% of your max health and channel energy to perform a devestator",		
		think = function( self )
			if self.ChannelCooldown and self.ChannelCooldown >= CurTime() then return end
			if ( self.Owner:KeyDown( IN_ATTACK2 ) ) and !self:GetEnabled() and self.Owner:OnGround() then
				self._ForceChanneling = true
			else
				self._ForceChanneling = false
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.ChannelCooldown = CurTime() + 3
			end
			if self._ForceChanneling then
				if not self._NextChannelHeal then self._NextChannelHeal = 0 end
				self:SetMeditateMode( 2 )
				if self._NextChannelHeal < CurTime() then
					self.Owner:SetHealth( math.min( self.Owner:Health() + ( self.Owner:GetMaxHealth()*0.01 ), self.Owner:GetMaxHealth() ) )
					if #self.DevestatorList > 0 then
						self:SetDevEnergy( self:GetDevEnergy() + self.DevCharge )
					end
					local tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ]
					if not tbl then 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ "Default" ].Meditation 
					else 
						tbl = wOS.ALCS.Config.Skills.ExperienceTable[ self.Owner:GetUserGroup() ].Meditation 
					end
					self.Owner:AddSkillXP( tbl )
					self._NextChannelHeal = CurTime() + 3
				end
				self.Owner:SetLocalVelocity(Vector(0, 0, 0))
				self.Owner:SetMoveType(MOVETYPE_NONE)
				if ( !self.SoundChanneling ) then
					self.SoundChanneling = CreateSound( self.Owner, "ambient/levels/citadel/field_loop1.wav" )
					self.SoundChanneling:Play()
				else
					self.SoundChanneling:Play()
				end

				timer.Create( "test" .. self:EntIndex(), 0.2, 1, function() if ( self.SoundChanneling ) then self.SoundChanneling:Stop() self.SoundChanneling = nil end end )
			else
				self:SetMeditateMode( 0 )
				if self:GetMoveType() != MOVETYPE_WALK and self.Owner:GetNW2Float( "wOS.DevestatorTime", 0 ) < CurTime() then
					self.Owner:SetMoveType(MOVETYPE_WALK)
				end
			end
			if self.Owner:KeyReleased( IN_ATTACK2 ) then
				self.ChannelCooldown = CurTime() + 3
			end			
		end
})
-- Mons custom shit
wOS.ForcePowers:RegisterNewPower({
		name = "Sisters Dagger",
		icon = "SD",
		distance = 80,
		image = "wos/forceicons/shadow_strike.png",
		cooldown = 0,
		target = 1,
		manualaim = false,
		description = "From the darkness it preys",
		help = "While cloaked, reveal yourself to inflict a large amount of damage to a target",
		action = function( self )
			if !self:GetCloaking() then return end
			local ent = self:SelectTargets( 1, 30 )[ 1 ]
			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end
			if ( self:GetForce() < 20 ) then self:SetNextAttack( 0.2 ) return end
			self.Owner:SetSequenceOverride("b_c3_t2", 1)
			self:SetForce( self:GetForce() - 20 )
			self.Owner:EmitSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
			self.Owner:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )
			ent:TakeDamage( 2500, self.Owner, self )
			self.CloakTime = CurTime() + 0.5
			self:SetNextAttack( 0.7 )
			return true
		end
})