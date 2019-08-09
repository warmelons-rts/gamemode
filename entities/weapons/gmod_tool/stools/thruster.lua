
TOOL.Category		= "Construction"
TOOL.Name			= "#Thruster"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "force" ] = "1500"
TOOL.ClientConVar[ "model" ] = "models/props_c17/lampShade001a.mdl"
TOOL.ClientConVar[ "keygroup" ] = "7"
TOOL.ClientConVar[ "keygroup_back" ] = "4"
TOOL.ClientConVar[ "toggle" ] = "0"
TOOL.ClientConVar[ "collision" ] = "0"
TOOL.ClientConVar[ "effect" ] = "fire"
TOOL.ClientConVar[ "damageable" ] = "0"
TOOL.ClientConVar[ "sound" ] = "1"

cleanup.Register( "thrusters" )

function TOOL:LeftClick( trace )

	if ( trace.Entity && trace.Entity:IsPlayer() ) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local force			= self:GetClientNumber( "force" )
	local model			= self:GetClientInfo( "model" )
	local key 			= self:GetClientNumber( "keygroup" ) 
	local key_bk 		= self:GetClientNumber( "keygroup_back" ) 
	local toggle		= self:GetClientNumber( "toggle" ) 
	local collision		= self:GetClientNumber( "collision" ) 
	local effect		= self:GetClientInfo( "effect" ) 
	local damageable	= self:GetClientNumber( "damageable" ) 
	local sound			= self:GetClientNumber( "sound" ) 
	
	// If we shot a thruster change its force
--	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_thruster" && trace.Entity.pl == ply ) then
--
--		trace.Entity:SetForce( force )
--		trace.Entity:SetEffect( effect )
--		trace.Entity:SetToggle( toggle == 1 )
--		trace.Entity.ActivateOnDamage = ( damageable == 1 )
--
--		trace.Entity.force	= force
--		trace.Entity.toggle	= toggle
--		trace.Entity.effect	= effect
--		trace.Entity.damageable = damageable
--
--		return true
--	end
	
	if ( !self:GetSWEP():CheckLimit( "thrusters" ) ) then return false end

	if (!util.IsValidModel(model)) then return false end
	if (!util.IsValidProp(model)) then return false end		// Allow ragdolls to be used?

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local thruster = MakeThruster( ply, model, Ang, trace.HitPos, key, key_bk, force, toggle, effect, sound, damageable )
	if (!thruster) then return false end
	local min = thruster:OBBMins()
	thruster:SetPos( trace.HitPos - trace.HitNormal * min.z )
	
	local const, nocollide
	
	// Don't weld to world
	if ( trace.Entity:IsValid() ) then
	
		const = constraint.Weld( thruster, trace.Entity, 0, trace.PhysicsBone, 0, collision == 0, true )
		
		// Don't disable collision if it's not attached to anything
		if ( collision == 0 ) then 
		
			thruster:GetPhysicsObject():EnableCollisions( false )
			thruster.nocollide = true
			
		end
		
	end
	
	undo.Create("Thruster")
		undo.AddEntity( thruster )
		undo.AddEntity( const )
		undo.SetPlayer( ply )
	undo.Finish()
		
	ply:AddCleanup( "thrusters", thruster )
	ply:AddCleanup( "thrusters", const )
	ply:AddCleanup( "thrusters", nocollide )
	
	return true

end

if (SERVER) then

function MakeThruster( pl, Model, Ang, Pos, key, key_bck, force, toggle, effect, sound, damageable, nocollide, Vel, aVel, frozen )
	
		if ( !pl:CheckLimit( "thrusters" ) ) then return false end
	    local cost = math.floor(500 + force * GetConVarNumber( "WM_WheelandThrusterCost", 4 ))
	    if !InOutpostRange(pl, Pos)  then return false end
	    if pl:GetNWInt("chosenone", 0) ~= 1 then
	    if !NRGCheck(pl, cost)  then return false end
	    end
		local thruster = ents.Create( "gmod_thruster" )
		if (!thruster:IsValid()) then return false end
		thruster:SetModel( Model )

		thruster:SetAngles( Ang )
		thruster:SetPos( Pos )
		thruster.Cost = cost
		thruster.PaidFor = 1
		thruster:Spawn()
		thruster.Warmelon = true
		thruster.Grav = false --So flaks fire at them
		thruster.MaxForce = force
		thruster.Healthlol = 35 + (force / 100)
		thruster.Maxlol = 35 + (force / 100)
		thruster.asploded = false
		thruster.notflaming = true
		thruster.Team = pl:Team()
		thruster:SetEffect( effect )
		thruster:SetForce( force )
		thruster:SetToggle( toggle == 1 )
		thruster.ActivateOnDamage = ( damageable == 1 )
		--thruster:SetSound( sound ) --Do you really want to let them use thruster sounds?
		thruster:SetPlayer( pl )
		if (thruster.Team == 1) then
		thruster:SetColor (Color(255, 0, 0, 255));
		end
		if (thruster.Team == 2) then
		thruster:SetColor (Color(0, 0, 255, 255));
		end
		if (thruster.Team == 3) then
		thruster:SetColor (Color(0, 255, 0, 255));
		end
		if (thruster.Team == 4) then
		thruster:SetColor (Color(255, 255, 0, 255));
		end
		if (thruster.Team == 5) then
		thruster:SetColor (Color(255, 0, 255, 255));
		end
		if (thruster.Team == 6) then
		thruster:SetColor (Color(0, 255, 255, 255));
		end
		--if pl:Team() ~= 0 then
		
						function thruster:Think()
							local phys = self.Entity:GetPhysicsObject()
							if (self.MaxForce ~= 0) then
								if (math.abs(self.force) < math.abs(self.MaxForce)) then
									local force = self.force + (self.MaxForce/math.abs(self.MaxForce)) * self.force * 0.01
									self:SetForce( force )
								else
									local force = self.MaxForce
									self:SetForce( force )
								end
							end
							
							self.Entity:NextThink( CurTime() + 1 )
							return true
						end
						function thruster:OnTakeDamage(dmginfo)
                        	self.Entity:TakePhysicsDamage (dmginfo);
                        	self.Healthlol = self.Healthlol - dmginfo:GetDamage();
                        	if (self.Healthlol < 1 && !self.asploded) then
                        	local expl=ents.Create("env_explosion")
                        		expl:SetPos(self.Entity:GetPos());
                        		expl:SetOwner(self.Entity);
                        		expl:SetKeyValue("iMagnitude", (self.force / 175));
                        		expl:SetKeyValue("iRadiusOverride", (self.force / 100));
                        		expl:Spawn();
                        		expl:Activate();
                        		expl:Fire("explode", "", 0);
                        		expl:Fire("kill","",0);
                        		self.asploded = true;
                        		constraint.RemoveAll (self.Entity);
                        		self.Entity:SetColor(Color(0, 0, 0, 255));
                        		self.Entity:Fire ("kill", "", 3);
                        	end
                        	if self.Healthlol < self.Maxlol/5 && self.notflaming then
                        		self.trail = ents.Create("env_fire_trail");
                        		self.trail:SetPos (self.Entity:GetPos());
                        		self.trail:Spawn();
                        		self.trail:Activate();
                        		self.Entity:DeleteOnRemove(self.trail);
                        		self.trail:SetParent(self.Entity);
                        		self.notflaming = false;
                        	end
                        end
        --end
		numpad.OnDown( 	 pl, 	key, 	"Thruster_On", 		thruster, 1 )
		numpad.OnUp( 	 pl, 	key, 	"Thruster_Off", 	thruster, 1 )
		
		numpad.OnDown( 	 pl, 	key_bck, 	"Thruster_On", 		thruster, -1 )
		numpad.OnUp( 	 pl, 	key_bck, 	"Thruster_Off", 	thruster, -1 )

		if ( nocollide == true ) then thruster:GetPhysicsObject():EnableCollisions( false ) end

		local ttable = {
			key	= key,
			key_bck = key_bck,
			force	= force,
			toggle	= toggle,
			pl	= pl,
			effect	= effect,
			nocollide = nocollide,
			damageable = damageable,
			sound = sound
			}

		table.Merge(thruster, ttable )
		
		pl:AddCount( "thrusters", thruster )
		
		DoPropSpawnedEffect( thruster )

		return thruster
		
	end
	
	duplicator.RegisterEntityClass( "gmod_thruster", MakeThruster, "Model", "Ang", "Pos", "key", "key_bck", "MaxForce", "toggle", "effect", "sound", "damageable", "nocollide", "Vel", "aVel", "frozen" )

end

function TOOL:RightClick( trace )
if (SERVER) then
local cost = math.floor(500 + self:GetClientNumber( "force" ) * GetConVarNumber( "WM_WheelandThrusterCost", 4 ))
WMSendCost(self:GetOwner(), cost, 2)
end
end

function TOOL:UpdateGhostThruster( ent, player )

	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	if (trace.Entity && trace.Entity:GetClass() == "gmod_thruster" || trace.Entity:IsPlayer()) then
	
		ent:SetNoDraw( true )
		return
		
	end
	
	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local min = ent:OBBMins()
	 ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )
	
end


function TOOL:Think()

	if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != self:GetClientInfo( "model" )) then
		self:MakeGhostEntity( self:GetClientInfo( "model" ), Vector(0,0,0), Angle(0,0,0) )
	end
	
	self:UpdateGhostThruster( self.GhostEntity, self:GetOwner() )
	
end


function TOOL.BuildCPanel( CPanel )

	// HEADER
	CPanel:AddControl( "Header", { Text = "#Tool_thruster_name", Description	= "#Tool_thruster_desc" }  )
	
	local Options = { Default = { thruster_force = "20",
									thruster_model = "models/props_junk/plasticbucket001a.mdl",
									thruster_effect = "fire" } }
									
	local CVars = { "thruster_force", "thruster_model", "thruster_effect" }
	
	CPanel:AddControl( "ComboBox", { Label = "#Presets",
									 MenuButton = 1,
									 Folder = "thruster",
									 Options = Options,
									 CVars = CVars } )

	CPanel:AddControl( "PropSelect", { Label = "#Thruster_Model",
									 ConVar = "thruster_model",
									 Category = "Thrusters",
									 Models = list.Get( "ThrusterModels" ) } )
									 
									 
	CPanel:AddControl( "ComboBox", { Label = "#Thruster_Effects",
									 Description = "Thruster_Effects_Desc",
									 MenuButton = "0",
									 Options = list.Get( "ThrusterEffects" ) } )
									 
									 
	CPanel:AddControl( "Slider", { Label = "#Thruster_force",
									 Description = "",
									 Type = "Float",
									 Min = 1,
									 Max = 10000,
									 Command = "thruster_force" } )
									 
									 
	CPanel:AddControl( "Numpad", { 	Label = "#Thruster_group",
									 Label2 = "#Thruster_group_back",
									 Command = "thruster_keygroup",
									 Command2 = "thruster_keygroup_back",
									 ButtonSize = "22" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Thruster_toggle",
									 Description = "#Thruster_toggle_desc",
									 Command = "thruster_toggle" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Thruster_collision",
									 Command = "thruster_collision" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Thruster_damageable",
									 Command = "thruster_damageable" } )
									 
	CPanel:AddControl( "CheckBox", { Label = "#Sound",
									 Command = "thruster_sound" } )
									
end

list.Set( "ThrusterModels", "models/dav0r/thruster.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/plasticbucket001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/PropaneCanister001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/propane_tank001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/PopCan01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/MetalBucket01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_lab/jar01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/lampShade001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister_propane01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister01a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/canister02a.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trainstation_ornament002.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/TrafficCone001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/clock01.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/pottery02a.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/pottery03a.mdl", {} )
list.Set( "ThrusterModels", "models/props_junk/terracotta01.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/TrapPropeller_Engine.mdl", {} )
list.Set( "ThrusterModels", "models/props_c17/FurnitureSink001a.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trainstation_ornament001.mdl", {} )
list.Set( "ThrusterModels", "models/props_trainstation/trashcan_indoor001b.mdl", {} )

list.Set( "ThrusterEffects", "#No_Effects", { thruster_effect = "none" } )
list.Set( "ThrusterEffects", "#Flames", 	{ thruster_effect = "fire" } )
list.Set( "ThrusterEffects", "#Plasma", 	{ thruster_effect = "plasma" } )
list.Set( "ThrusterEffects", "#Rings", 		{ thruster_effect = "rings" } )
list.Set( "ThrusterEffects", "#Smoke", 		{ thruster_effect = "smoke" } )
