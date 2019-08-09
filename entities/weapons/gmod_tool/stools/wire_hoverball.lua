TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Hoverball"
TOOL.Command		= nil
TOOL.ConfigName		= ""


if ( CLIENT ) then
    language.Add( "Tool_wire_hoverball_name", "Wired Hoverball Tool" )
    language.Add( "Tool_wire_hoverball_desc", "Spawns a hoverball for use with the wire system." )
    language.Add( "Tool_wire_hoverball_0", "Primary: Create/Update Hoverball" )
    language.Add( "WireHoverballTool_starton", "Create with hover mode on:" )
	language.Add( "undone_wirehoverball", "Undone Wire Hoverball" )
	language.Add( "sboxlimit_wire_hoverballs", "You've hit wired hover balls limit!" )
end

if (SERVER) then
    CreateConVar('sbox_maxwire_hoverballs', 30)
end 

TOOL.ClientConVar[ "speed" ] = "1"
TOOL.ClientConVar[ "resistance" ] = "0"
TOOL.ClientConVar[ "strength" ] = "1"
TOOL.ClientConVar[ "starton" ] = "1"

cleanup.Register( "wire_hoverballs" )

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local speed 		= self:GetClientNumber( "speed" ) 
	local resistance 	= self:GetClientNumber( "resistance" ) 
	local strength	 	= self:GetClientNumber( "strength" ) / 2
	local starton	 	= self:GetClientNumber( "starton" ) == 1
	
	resistance 	= math.Clamp( resistance, 0, 20 )
	strength	= math.Clamp( strength, 0.1, 20 )
	
	// We shot an existing hoverball - just change its values
--	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_wire_hoverball" && trace.Entity.pl == ply ) then
	
--		trace.Entity:SetSpeed( speed )
--		trace.Entity:SetAirResistance( resistance )
--		trace.Entity:SetStrength( strength )
		
--		trace.Entity.speed		= speed
--		trace.Entity.strength	= strength
--		trace.Entity.resistance	= resistance
--		
--		if (!starton) then trace.Entity:DisableHover() else trace.Entity:EnableHover() end
--	
--		return true
--	
--	end
	
	if ( !self:GetSWEP():CheckLimit( "wire_hoverballs" ) ) then return false end
	
	// If we hit the world then offset the spawn position
	if ( trace.Entity:IsWorld() ) then
		trace.HitPos = trace.HitPos + trace.HitNormal * 8
	end
	
	local wire_ball = MakeWireHoverBallFix( ply, trace.HitPos, Angle(0,0,0), "models/dav0r/hoverball.mdl", speed, resistance, strength )
	
	local const = WireLib.Weld(wire_ball, trace.Entity, trace.PhysicsBone, true)
	
	local nocollide
	if ( !trace.Entity:IsWorld() ) then
		nocollide = constraint.NoCollide( trace.Entity, wire_ball, 0, trace.PhysicsBone )
	end
	
	if (!starton) then wire_ball:DisableHover() end
	
	undo.Create("WireHoverBall")
		undo.AddEntity( wire_ball )
		undo.AddEntity( const )
		undo.AddEntity( nocollide )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "wire_hoverballs", wire_ball )
	ply:AddCleanup( "wire_hoverballs", const )
	ply:AddCleanup( "wire_hoverballs", nocollide )
	
	return true

end

if (SERVER) then

	function MakeWireHoverBallFix( ply, Pos, Ang, model, speed, resistance, strength, nocollide )
		Msg("It was the right makewirehoverball function\n")
		if ( !ply:CheckLimit( "wire_hoverballs" ) ) then return nil end
		local cost = math.abs(math.floor(((strength * 2500) + (speed * 1000)) * GetConVarNumber( "WM_HoverCost", 1 )))
	    if !InOutpostRange(ply, Pos)  then return false end
	  --  if ply:GetTool().Name ~= "Hoverball" then
	    if !NRGCheck(ply, cost)  then return false end
	  --  end
		local wire_ball = ents.Create( "gmod_wire_hoverball" )
		if (!wire_ball:IsValid()) then return false end

		wire_ball:SetPos( Pos )
		wire_ball.Cost = cost
		wire_ball:Spawn()
		wire_ball:SetSpeed( speed )
		wire_ball:SetPlayer( ply )
		wire_ball:SetAirResistance( resistance )
		wire_ball:SetStrength( strength )
		wire_ball.strength = strength
		wire_ball.MaxStrength = strength
		wire_ball.PaidFor = true
		wire_ball.HitPoints = 50 + (strength * 25)
		wire_ball.MaxHitPoints = 50 + (strength * 25)
		wire_ball.Dead = false
		wire_ball.Grav = false
		wire_ball.Burning = true
		wire_ball.Team = ply:Team()
		wire_ball.Warmelon = true
		wire_ball:SetPlayer( ply )
		if (wire_ball.Team == 1) then
		wire_ball:SetColor (Color(255, 0, 0, 255));
		end
		if (wire_ball.Team == 2) then
		wire_ball:SetColor (Color(0, 0, 255, 255));
		end
		if (wire_ball.Team == 3) then
		wire_ball:SetColor (Color(0, 255, 0, 255));
		end
		if (wire_ball.Team == 4) then
		wire_ball:SetColor (Color(255, 255, 0, 255));
		end
		if (wire_ball.Team == 5) then
		wire_ball:SetColor (Color(255, 0, 255, 255));
		end
		if (wire_ball.Team == 6) then
		wire_ball:SetColor (Color(0, 255, 255, 255));
		end
		
				        function wire_ball:Think()
							local phys = self.Entity:GetPhysicsObject()
							if self.strength < self.MaxStrength then
								self:SetStrength( self.strength + 0.033)
								self.strength = self.strength + 0.033
							end
							self.Entity:NextThink( CurTime() + 1 ) 
							self.Entity:SetNWInt( "TargetZ", self:GetTargetZ() )  
							return true 
		                end
						function wire_ball:OnTakeDamage(dmginfo)
                        	self.Entity:TakePhysicsDamage (dmginfo);
                        	self.HitPoints = self.HitPoints - dmginfo:GetDamage();
                        	if (self.HitPoints < 1 && !self.Dead) then
								local expl=ents.Create("env_explosion")
									expl:SetPos(self.Entity:GetPos());
									expl:SetOwner(self.Entity);
									expl:SetKeyValue("iMagnitude", (self.MaxStrength / 300));
									expl:SetKeyValue("iRadiusOverride", (self.MaxStrength / 200));
									expl:Spawn();
									expl:Activate();
									expl:Fire("explode", "", 0);
									expl:Fire("kill","",0);
                        		self.Dead = true;
                        		constraint.RemoveAll (self.Entity);
                        		self.Entity:SetColor(Color(0, 0, 0, 255));
                        		self.Entity:Fire ("kill", "", 3);
                        	end
                        	if self.HitPoints < self.MaxHitPoints/5 && self.Burning then
                        		self.trail = ents.Create("env_fire_trail");
									self.trail:SetPos (self.Entity:GetPos());
									self.trail:Spawn();
									self.trail:Activate();
									self.Entity:DeleteOnRemove(self.trail);
									self.trail:SetParent(self.Entity);
									self.Burning = false;
                        	end
                        end

		local ttable = 
		{
			ply	= ply,
			nocollide = nocollide,
			speed = speed,
			strength = strength,
			resistance = resistance
		}
		table.Merge( wire_ball, ttable )
		
		ply:AddCount( "wire_hoverballs", wire_ball )
		
		return wire_ball
		
	end
	
	local function OverrideWireHoverBall()
		MakeWireHoverBall = MakeWireHoverBallFix
		duplicator.RegisterEntityClass("gmod_wire_hoverball", MakeWireHoverBall, "Pos", "Ang", "Model", "speed", "resistance", "strength", "nocollide") --wont work anyway
	end
	hook.Add( "InitPostEntity", "OverrideWireHoverBall", OverrideWireHoverBall )
	
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Text = "#Tool_wire_hoverball_name", Description = "#Tool_wire_hoverball_desc" })

	panel:AddControl("ComboBox", {
		Label = "#Presets",
		MenuButton = "1",
		Folder = "wire_hoverball",

		Options = {
			Default = {
				wire_hoverball_speed = "1",
				wire_hoverball_resistance = "0",
				wire_hoverball_strength = "1",
				wire_hoverball_starton = "1"
			}
		},

		CVars = {
			[0] = "wire_hoverball_speed",
			[1] = "wire_hoverball_strength",
			[2] = "wire_hoverball_resistance",
			[3] = "wire_hoverball_starton"
		}
	})

	panel:AddControl("Slider", {
		Label = "#Movement Speed",
		Type = "Float",
		Min = "1",
		Max = "10",
		Command = "wire_hoverball_speed"
	})
	
	panel:AddControl("Slider", {
		Label = "#Air Resistance",
		Type = "Float",
		Min = "1",
		Max = "10",
		Command = "wire_hoverball_resistance"
	})
	
	panel:AddControl("Slider", {
		Label = "#Strength",
		Type = "Float",
		Min = "0.1",
		Max = "10",
		Command = "wire_hoverball_strength"
	})
	
	panel:AddControl("CheckBox", {
		Label = "#WireHoverballTool_starton",
		Command = "wire_hoverball_starton"
	})

end
