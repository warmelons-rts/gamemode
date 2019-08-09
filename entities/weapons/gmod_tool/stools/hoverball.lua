
TOOL.Category		= "Construction"
TOOL.Name			= "#Hoverball"

TOOL.ClientConVar[ "keyup" ] = "46"
TOOL.ClientConVar[ "keydn" ] = "43"
TOOL.ClientConVar[ "speed" ] = "1"
TOOL.ClientConVar[ "resistance" ] = "0"
TOOL.ClientConVar[ "strength" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/dav0r/hoverball.mdl"

cleanup.Register( "hoverballs" )

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	-- If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if ( CLIENT ) then return true end
	
	local ply = self:GetOwner()
	
	local model = self:GetClientInfo( "model" )
	local key_d = self:GetClientNumber( "keydn" )
	local key_u = self:GetClientNumber( "keyup" )
	local speed = self:GetClientNumber( "speed" )
	local strength = math.Clamp( self:GetClientNumber( "strength" ), 0.1, 20 )
	local resistance = math.Clamp( self:GetClientNumber( "resistance" ), 0, 20 )

	if ( !util.IsValidModel( model ) ) then return false end
	if ( !util.IsValidProp( model ) ) then return false end
	
	-- We shot an existing hoverball - just change its values
	if ( IsValid( trace.Entity ) && trace.Entity:GetClass() == "gmod_hoverball" && trace.Entity.pl == ply ) then
	
		trace.Entity:SetSpeed( speed )
		trace.Entity:SetAirResistance( resistance )
		trace.Entity:SetStrength( strength )

		numpad.Remove( trace.Entity.NumDown )
		numpad.Remove( trace.Entity.NumUp )
		numpad.Remove( trace.Entity.NumBackDown )
		numpad.Remove( trace.Entity.NumBackUp )
		
		trace.Entity.NumDown = numpad.OnDown( ply, key_u, "Hoverball_Up", trace.Entity, true )
		trace.Entity.NumUp = numpad.OnUp( ply, key_u, "Hoverball_Up", trace.Entity, false )
		
		trace.Entity.NumBackDown = numpad.OnDown( ply, key_d, "Hoverball_Down", trace.Entity, true )
		trace.Entity.NumBackUp = numpad.OnUp( ply, key_d, "Hoverball_Down", trace.Entity, false )

		trace.Entity.key_u = key_u
		trace.Entity.key_d = key_d
		trace.Entity.speed = speed
		trace.Entity.strength = strength
		trace.Entity.resistance	= resistance
	
		return true
	
	end
	
	if ( !self:GetSWEP():CheckLimit( "hoverballs" ) ) then return false end

	local ball = MakeHoverBall( ply, trace.HitPos, key_d, key_u, speed, resistance, strength, model )
	if(ball == nil) then return end
	local CurPos = ball:GetPos()
	local NearestPoint = ball:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	ball:SetPos( trace.HitPos + Offset )
	
	local const, nocollide
	
	-- Don't weld to world
	if ( trace.Entity != NULL && !trace.Entity:IsWorld() ) then

		const = constraint.Weld( ball, trace.Entity, 0, trace.PhysicsBone, 0, 0, true ) -- Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide, deleteonbreak

		ball:GetPhysicsObject():EnableCollisions( false )
		ball.nocollide = true

	end

	undo.Create( "HoverBall" )
	undo.AddEntity( ball )
	undo.AddEntity( const )
	undo.SetPlayer( ply )
	undo.Finish()

	ply:AddCleanup( "hoverballs", ball )
	ply:AddCleanup( "hoverballs", const )
	ply:AddCleanup( "hoverballs", nocollide )

	return true

end

function TOOL:RightClick( trace )
	if ( SERVER ) then
		local cost = math.floor(((self:GetClientNumber( "strength" )  * 2500) + (self:GetClientNumber( "speed" )  * 1000)) * GetConVarNumber( "WM_HoverCost", 1 ))
		WMSendCost(self:GetOwner(), cost, 2)
	end
end

if (SERVER) then

	function MakeHoverBall( ply, Pos, key_d, key_u, speed, resistance, strength, model, Vel, aVel, frozen, nocollide )
	
		if ( IsValid( ply ) ) then
			if ( !ply:CheckLimit( "hoverballs" ) ) then return end
		end
		local cost = math.floor(((strength * 2500) + (speed * 1000)) * GetConVarNumber( "WM_HoverCost", 1 ))
	    if !InOutpostRange(ply, Pos)  then return end
	    if !NRGCheck(ply, cost)  then return end
		
		local ball = ents.Create( "gmod_hoverball" )
		if ( !IsValid( ball ) ) then return false end

		ball:SetPos( Pos )
		ball:SetModel( Model( model ) )
		ball:Spawn()
		ball:SetSpeed( speed )
		ball:SetAirResistance( resistance )
		ball:SetStrength( strength )
		
		if ( IsValid( ply ) ) then
			ball:SetPlayer( ply )
		end
		
		--ball:SetOwner(ply)
	 	ball.Cost = cost
		ball.Warmelon = true
		--ball.PaidFor = 1
		ball.HitPoints = 50 + (strength * 25)
		ball.MaxHitPoints = 50 + (strength * 25)
		ball.Dead = false
		ball.Burning = true
		ball.Team = ply:Team()
		ball.Grav = false
		ball.PaidFor = true
		ball.MaxStrength = strength * 150
		if (ball.team == 1) then
			ball:SetColor(Color(255, 0, 0, 255));
		end
		if (ball.team == 2) then
			ball:SetColor(Color(0, 0, 255, 255));
		end
		if (ball.team == 3) then
			ball:SetColor(Color(0, 255, 0, 255));
		end
		if (ball.team == 4) then
			ball:SetColor(Color(255, 255, 0, 255));
		end
		if (ball.team == 5) then
			ball:SetColor(Color(255, 0, 255, 255));
		end
		if (ball.team == 6) then
			ball:SetColor(Color(0, 255, 255, 255));
		end
		
		ball.NumDown = numpad.OnDown( ply, key_u, "Hoverball_Up", ball, true )
		ball.NumUp = numpad.OnUp( ply, key_u, "Hoverball_Up", ball, false )

		ball.NumBackDown = numpad.OnDown( ply, key_d, "Hoverball_Down", ball, true )
		ball.NumBackUp = numpad.OnUp( ply, key_d, "Hoverball_Down", ball, false )
		
		function ball:Think()
			local phys = self:GetPhysicsObject()
			if IsValid(phys) && phys:GetMass() < self.MaxStrength then
				--Msg(phys:GetMass() .. "/n\n")
				phys:SetMass(phys:GetMass() + 5)
			end
			self.Entity:NextThink( CurTime() + 1 ) 
			--self.Entity:SetNWInt( "TargetZ", self:GetTargetZ() )  
			return true 
		end
		
		function ball:OnTakeDamage(dmginfo)
            self.Entity:TakePhysicsDamage (dmginfo);
            self.HitPoints = self.HitPoints - dmginfo:GetDamage();
            if (self.HitPoints < 1 && !self.Dead) then
                local expl=ents.Create("env_explosion")
                expl:SetPos(self.Entity:GetPos());
                expl:SetOwner(self.Entity);
                expl:SetKeyValue("iMagnitude", 10 + (self.strength * 2.5));
                expl:SetKeyValue("iRadiusOverride", 50 + (self.strength * 50));
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


		if ( nocollide == true ) then ball:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = {
			key_d = key_d,
			key_u = key_u,
			pl = ply,
			nocollide = nocollide,
			speed = speed,
			strength = strength,
			resistance = resistance,
			model = model
		}

		table.Merge( ball:GetTable(), ttable )
		
		if ( IsValid( ply ) ) then
			ply:AddCount( "hoverballs", ball )
		end
		
		DoPropSpawnedEffect( ball )

		return ball
		
	end
	
	duplicator.RegisterEntityClass( "gmod_hoverball", MakeHoverBall, "Pos", "key_d", "key_u", "speed", "resistance", "strength", "Vel", "aVel", "frozen", "nocollide" )
end
	
function TOOL:UpdateGhostHoverball( ent, pl )

	if ( !IsValid( ent ) ) then return end
	
	local tr = util.GetPlayerTrace( pl )
	local trace	= util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	
	if ( trace.Entity:IsPlayer() || trace.Entity:GetClass() == "gmod_hoverball" ) then
	
		ent:SetNoDraw( true )
		return
		
	end

	local CurPos = ent:GetPos()
	local NearestPoint = ent:NearestPoint( CurPos - ( trace.HitNormal * 512 ) )
	local Offset = CurPos - NearestPoint

	ent:SetPos( trace.HitPos + Offset )

	ent:SetNoDraw( false )
	
end

function TOOL:Think()

	if ( !IsValid( self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo( "model" ) ) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end
	
	self:UpdateGhostHoverball( self.GhostEntity, self:GetOwner() )
	
end

local ConVarsDefault = TOOL:BuildConVarList()

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.hoverball.help" } )
	
	CPanel:AddControl( "ComboBox", { MenuButton = 1, Folder = "hoverball", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys( ConVarsDefault ) } )

	CPanel:AddControl( "Numpad", { Label = "#tool.hoverball.up", Command = "hoverball_keyup", Label2 = "#tool.hoverball.down", Command2 = "hoverball_keydn" } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.speed", Command = "hoverball_speed", Type = "Float", Min = 0, Max = 20, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.resistance", Command = "hoverball_resistance", Type = "Float", Min = 0, Max = 10, Help = true } )
	CPanel:AddControl( "Slider", { Label = "#tool.hoverball.strength", Command = "hoverball_strength", Type = "Float", Min = 0.1, Max = 10, Help = true } )
	CPanel:AddControl( "PropSelect", { Label = "#tool.hoverball.model", ConVar = "hoverball_model", Models = list.Get( "HoverballModels" ), Height = 4 } )

end

-- This list is getting populated from right to left for some reason!

list.Set( "HoverballModels", "models/MaxOfS2D/hover_propeller.mdl", {} )
list.Set( "HoverballModels", "models/dav0r/hoverball.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_rings.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_classic.mdl", {} )
list.Set( "HoverballModels", "models/MaxOfS2D/hover_basic.mdl", {} )