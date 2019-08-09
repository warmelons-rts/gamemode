TOOL.Category		= "Wire - Physics"
TOOL.Name			= "Thruster"
TOOL.ConfigName		= ""

if ( CLIENT ) then
    language.Add( "Tool_wire_thruster_name", "Thruster Tool (Wire)" )
    language.Add( "Tool_wire_thruster_desc", "Spawns a thruster for use with the wire system." )
    language.Add( "Tool_wire_thruster_0", "Primary: Create/Update Thruster" )
    language.Add( "WireThrusterTool_Model", "Model:" )
    language.Add( "WireThrusterTool_OWEffects", "Over water effects:" )
    language.Add( "WireThrusterTool_UWEffects", "Under water effects:" )
    language.Add( "WireThrusterTool_force", "Force multiplier:" )
    language.Add( "WireThrusterTool_force_min", "Force minimum:" )
    language.Add( "WireThrusterTool_force_max", "Force maximum:" )
    language.Add( "WireThrusterTool_bidir", "Bi-directional:" )
    language.Add( "WireThrusterTool_collision", "Collision:" )
    language.Add( "WireThrusterTool_sound", "Enable sound:" )
    language.Add( "WireThrusterTool_owater", "Works out of water:" )
    language.Add( "WireThrusterTool_uwater", "Works under water:" )
	language.Add( "sboxlimit_wire_thrusters", "You've hit thrusters limit!" )
	language.Add( "undone_wirethruster", "Undone Wire Thruster" )
end

if (SERVER) then
	CreateConVar('sbox_maxwire_thrusters', 10)
end

TOOL.ClientConVar[ "force" ] = "1500"
TOOL.ClientConVar[ "force_min" ] = "0"
TOOL.ClientConVar[ "force_max" ] = "10000"
TOOL.ClientConVar[ "model" ] = "models/props_c17/lampShade001a.mdl"
TOOL.ClientConVar[ "bidir" ] = "1"
TOOL.ClientConVar[ "collision" ] = "0"
TOOL.ClientConVar[ "sound" ] = "0"
TOOL.ClientConVar[ "oweffect" ] = "fire"
TOOL.ClientConVar[ "uweffect" ] = "same"
TOOL.ClientConVar[ "owater" ] = "1"
TOOL.ClientConVar[ "uwater" ] = "1"

cleanup.Register( "wire_thrusters" )

function TOOL:LeftClick( trace )
	
	if trace.Entity && trace.Entity:IsPlayer() then return false end
	if (CLIENT) then return true end
	
	local ply = self:GetOwner()
	
	local force			= self:GetClientNumber( "force" )
	local force_min		= self:GetClientNumber( "force_min" )
	local force_max		= self:GetClientNumber( "force_max" )
	local model			= self:GetClientInfo( "model" )
	local bidir			= (self:GetClientNumber( "bidir" ) ~= 0)
	local nocollide		= (self:GetClientNumber( "collision" ) == 0)
	local sound			= (self:GetClientNumber( "sound" ) ~= 0)
	local oweffect		= self:GetClientInfo( "oweffect" )
	local uweffect		= self:GetClientInfo( "uweffect" )
	local owater		= (self:GetClientNumber( "owater" ) ~= 0)
	local uwater		= (self:GetClientNumber( "uwater" ) ~= 0)
	
	if ( !trace.Entity:IsValid() ) then nocollide = false end
	
	// If we shot a wire_thruster change its force
--	if ( trace.Entity:IsValid() && trace.Entity:GetClass() == "gmod_wire_thruster" && trace.Entity.pl == ply ) then
--		trace.Entity:SetForce( force )
--		trace.Entity:SetEffect( effect )
--		trace.Entity:Setup(force, force_min, force_max, oweffect, uweffect, owater, uwater, bidir, sound)
--		
--		trace.Entity.force		= force
--		trace.Entity.force_min	= force_min
--		trace.Entity.force_max	= force_max
--		trace.Entity.bidir		= bidir
--		trace.Entity.sound		= sound
--		trace.Entity.oweffect	= oweffect
--		trace.Entity.uweffect	= uweffect
--		trace.Entity.owater		= owater
--		trace.Entity.uwater		= uwater
--		trace.Entity.nocollide	= nocollide
--		
--		if ( nocollide == true ) then trace.Entity:GetPhysicsObject():EnableCollisions( false ) end
--		
--		return true
--	end
	
	if ( !self:GetSWEP():CheckLimit( "wire_thrusters" ) ) then return false end

	if (not util.IsValidModel(model)) then return false end
	if (not util.IsValidProp(model)) then return false end		// Allow ragdolls to be used?

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90
	
	local wire_thruster = MakeWireThrusterFix( ply, trace.HitPos, Ang, model, force, force_min, force_max, oweffect, uweffect, owater, uwater, bidir, sound, nocollide )
	if (!wire_thruster) then return false end
	local min = wire_thruster:OBBMins()
	wire_thruster:SetPos( trace.HitPos - trace.HitNormal * min.z )
	
	local const = WireLib.Weld(wire_thruster, trace.Entity, trace.PhysicsBone, true, nocollide)

	undo.Create("WireThruster")
		undo.AddEntity( wire_thruster )
		undo.AddEntity( const )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "wire_thrusters", wire_thruster )
	
	return true
end

if (SERVER) then
	
	function MakeWireThrusterFix( pl, Pos, Ang, model, force, force_min, force_max, oweffect, uweffect, owater, uwater, bidir, sound, nocollide )
		if ( !pl:CheckLimit( "wire_thrusters" ) ) then return false end
		local cost = math.abs(math.floor(500 + (math.abs(force_min) + math.abs(force_max)) * 0.5 * GetConVarNumber( "WM_WheelandThrusterCost", 4 )))
	    if !InOutpostRange(pl, Pos)  then return false end
	    if !NRGCheck(pl, cost)  then return false end
		local wire_thruster = ents.Create( "gmod_wire_thruster" )
		if (!wire_thruster:IsValid()) then return false end
		wire_thruster:SetModel( model )
		
		wire_thruster:SetAngles( Ang )
		wire_thruster:SetPos( Pos )
		wire_thruster.Cost = cost
		wire_thruster:Spawn()
		wire_thruster.Healthlol = 35 + (force / 100)
		wire_thruster.Maxlol = 35 + (force / 100)
		wire_thruster.asploded = false
		wire_thruster.notflaming = true
		wire_thruster.Team = pl:Team()
		wire_thruster.Warmelon = true
		wire_thruster.Grav = false --So flaks fire at them
		wire_thruster.maxForceMax = force_max
		wire_thruster.minForceMin = force_min
		if (wire_thruster.Team == 1) then
		wire_thruster:SetColor (Color(255, 0, 0, 255));
		end
		if (wire_thruster.Team == 2) then
		wire_thruster:SetColor (Color(0, 0, 255, 255));
		end
		if (wire_thruster.Team == 3) then
		wire_thruster:SetColor (Color(0, 255, 0, 255));
		end
		if (wire_thruster.Team == 4) then
		wire_thruster:SetColor (Color(255, 255, 0, 255));
		end
		if (wire_thruster.Team == 5) then
		wire_thruster:SetColor (Color(255, 0, 255, 255));
		end
		if (wire_thruster.Team == 6) then
		wire_thruster:SetColor (Color(0, 255, 255, 255));
		end
		
					function wire_thruster:Think()
						local forceMax = 0
						if (self.maxForceMax ~= 0) then
							if (math.abs(self.ForceMax) < math.abs(self.maxForceMax)) then
								forceMax = self.ForceMax-- + (self.maxForceMax/math.abs(self.maxForceMax)) * self.ForceMax * 0.05
							else
								forceMax = self.maxForceMax
							end
						end
						
						local forceMin = 0
						if (self.minForceMin ~= 0) then
							if (math.abs(self.ForceMin) < math.abs(self.minForceMin)) then
								forceMin = self.ForceMin-- + (self.minForceMin/math.abs(self.minForceMin)) * self.ForceMin * 0.05
							else
								forceMin = self.minForceMin
							end
						end
						self:Setup(self.force, forceMin, forceMax, self.OWEffect, self.UWEffect, self.OWater, self.UWater, self.BiDir, "")
						
						self.Entity:NextThink( CurTime() + 1 ) 
						return true 
		            end
					function wire_thruster:OnTakeDamage(dmginfo)
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
		wire_thruster:Setup(force, force_min, force_max, oweffect, uweffect, owater, uwater, bidir, sound)
		wire_thruster:SetPlayer( pl )
		wire_thruster:GetPhysicsObject():EnableMotion(false)
		if ( nocollide == true ) then wire_thruster:GetPhysicsObject():EnableCollisions( false ) end
		
		local ttable = {
			force		= force,
			force_min	= force_min,
			force_max	= force_max,
			bidir       = bidir,
			sound       = sound,
			pl			= pl,
			oweffect	= oweffect,
			uweffect	= uweffect,
			owater		= owater,
			uwater		= uwater,
			nocollide	= nocollide
		}
		table.Merge(wire_thruster, ttable )
		
		pl:AddCount( "wire_thrusters", wire_thruster )
		
		return wire_thruster
	end

	local function OverrideWireHoverBall()
		MakeWireThruster = MakeWireThrusterFix
		duplicator.RegisterEntityClass("gmod_wire_thruster", MakeWireThruster, "Ang", "Pos", "Model", "force", "minForceMin", "maxForceMax", "oweffect", "uweffect", "owater", "uwater", "bidir", "sound", "nocollide")
	end
	hook.Add( "InitPostEntity", "OverrideWireHoverBall", OverrideWireHoverBall )

end

function TOOL:UpdateGhostWireThruster( ent, player )
	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= util.TraceLine( tr )
	if (!trace.Hit) then return end
	
	if (trace.Entity && trace.Entity:GetClass() == "gmod_wire_thruster" || trace.Entity:IsPlayer()) then
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
	
	self:UpdateGhostWireThruster( self.GhostEntity, self:GetOwner() )
end

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", { Text = "#Tool_wire_thruster_name", Description = "#Tool_wire_thruster_desc" })

	panel:AddControl("ComboBox", {
		Label = "#Presets",
		MenuButton = "1",
		Folder = "wire_thruster",

		Options = {
			Default = {
				wire_thruster_force = "20",
				wire_thruster_model = "models/props_junk/plasticbucket001a.mdl",
				wire_thruster_effect = "fire",
			}
		},

		CVars = {
			[0] = "wire_thruster_model",
			[1] = "wire_thruster_force",
			[2] = "wire_thruster_effect"
		}
	})
	
	panel:AddControl( "PropSelect", {
		Label = "#WireThrusterTool_Model",
		ConVar = "wire_thruster_model",
		Category = "Thrusters",
		Models = list.Get( "ThrusterModels" )
	})
	
	panel:AddControl("ComboBox", {
		Label = "#WireThrusterTool_OWEffects",
		MenuButton = "0",

		Options = {
			["#No_Effects"] = { wire_thruster_oweffect = "none" },
			["#Flames"] = { wire_thruster_oweffect = "fire" },
			["#Plasma"] = { wire_thruster_oweffect = "plasma" },
			["#Smoke"] = { wire_thruster_oweffect = "smoke" },
			["#Smoke Random"] = { wire_thruster_oweffect = "smoke_random" },
			["#Smoke Do it Youself"] = { wire_thruster_oweffect = "smoke_diy" },
			["#Rings"] = { wire_thruster_oweffect = "rings" },
			["#Rings Growing"] = { wire_thruster_oweffect = "rings_grow" },
			["#Rings Shrinking"] = { wire_thruster_oweffect = "rings_shrink" },
			["#Bubbles"] = { wire_thruster_oweffect = "bubble" },
			["#Magic"] = { wire_thruster_oweffect = "magic" },
			["#Magic Random"] = { wire_thruster_oweffect = "magic_color" },
			["#Magic Do It Yourself"] = { wire_thruster_oweffect = "magic_diy" },
			["#Colors"] = { wire_thruster_oweffect = "color" },
			["#Colors Random"] = { wire_thruster_oweffect = "color_random" },
			["#Colors Do It Yourself"] = { wire_thruster_oweffect = "color_diy" },
			["#Blood"] = { wire_thruster_oweffect = "blood" },
			["#Money"] = { wire_thruster_oweffect = "money" },
			["#Sperms"] = { wire_thruster_oweffect = "sperm" },
			["#Feathers"] = { wire_thruster_oweffect = "feather" },
			["#Candy Cane"] = { wire_thruster_oweffect = "candy_cane" },
			["#Goldstar"] = { wire_thruster_oweffect = "goldstar" },
			["#Water Small"] = { wire_thruster_oweffect = "water_small" },
			["#Water Medium"] = { wire_thruster_oweffect = "water_medium" },
			["#Water Big"] = { wire_thruster_oweffect = "water_big" },
			["#Water Huge"] = { wire_thruster_oweffect = "water_huge" },
			["#Striderblood Small"] = { wire_thruster_oweffect = "striderblood_small" },
			["#Striderblood Medium"] = { wire_thruster_oweffect = "striderblood_medium" },
			["#Striderblood Big"] = { wire_thruster_oweffect = "striderblood_big" },
			["#Striderblood Huge"] = { wire_thruster_oweffect = "striderblood_huge" },
			["#More Sparks"] = { wire_thruster_oweffect = "more_sparks" },
			["#Spark Fountain"] = { wire_thruster_oweffect = "spark_fountain" },
			["#Jetflame"] = { wire_thruster_oweffect = "jetflame" },
			["#Jetflame Advanced"] = { wire_thruster_oweffect = "jetflame_advanced" },
			["#Jetflame Blue"] = { wire_thruster_oweffect = "jetflame_blue" },
			["#Jetflame Red"] = { wire_thruster_oweffect = "jetflame_red" },
			["#Jetflame Purple"] = { wire_thruster_oweffect = "jetflame_purple" },
			["#Comic Balls"] = { wire_thruster_oweffect = "balls" },
			["#Comic Balls Random"] = { wire_thruster_oweffect = "balls_random" },
			["#Comic Balls Fire Colors"] = { wire_thruster_oweffect = "balls_firecolors" },
			["#Souls"] = { wire_thruster_oweffect = "souls" },
			["#Debugger 10 Seconds"] = { wire_thruster_oweffect = "debug_10" },
			["#Debugger 30 Seconds"] = { wire_thruster_oweffect = "debug_30" },
			["#Debugger 60 Seconds"] = { wire_thruster_oweffect = "debug_60" },
			["#Fire and Smoke"] = { wire_thruster_oweffect = "fire_smoke" },
			["#Fire and Smoke Huge"] = { wire_thruster_oweffect = "fire_smoke_big" },
			["#5 Growing Rings"] = { wire_thruster_oweffect = "rings_grow_rings" },
			["#Color and Magic"] = { wire_thruster_oweffect = "color_magic" },
		}
	})

	panel:AddControl("ComboBox", {
		Label = "#WireThrusterTool_UWEffects",
		MenuButton = "0",

		Options = {
			["#No_Effects"] = { wire_thruster_uweffect = "none" },
			["#Same as over water"] = { wire_thruster_uweffect = "same" },
			["#Flames"] = { wire_thruster_uweffect = "fire" },
			["#Plasma"] = { wire_thruster_uweffect = "plasma" },
			["#Smoke"] = { wire_thruster_uweffect = "smoke" },
			["#Smoke Random"] = { wire_thruster_uweffect = "smoke_random" },
			["#Smoke Do it Youself"] = { wire_thruster_uweffect = "smoke_diy" },
			["#Rings"] = { wire_thruster_uweffect = "rings" },
			["#Rings Growing"] = { wire_thruster_uweffect = "rings_grow" },
			["#Rings Shrinking"] = { wire_thruster_uweffect = "rings_shrink" },
			["#Bubbles"] = { wire_thruster_uweffect = "bubble" },
			["#Magic"] = { wire_thruster_uweffect = "magic" },
			["#Magic Random"] = { wire_thruster_uweffect = "magic_color" },
			["#Magic Do It Yourself"] = { wire_thruster_uweffect = "magic_diy" },
			["#Colors"] = { wire_thruster_uweffect = "color" },
			["#Colors Random"] = { wire_thruster_uweffect = "color_random" },
			["#Colors Do It Yourself"] = { wire_thruster_uweffect = "color_diy" },
			["#Blood"] = { wire_thruster_uweffect = "blood" },
			["#Money"] = { wire_thruster_uweffect = "money" },
			["#Sperms"] = { wire_thruster_uweffect = "sperm" },
			["#Feathers"] = { wire_thruster_uweffect = "feather" },
			["#Candy Cane"] = { wire_thruster_uweffect = "candy_cane" },
			["#Goldstar"] = { wire_thruster_uweffect = "goldstar" },
			["#Water Small"] = { wire_thruster_uweffect = "water_small" },
			["#Water Medium"] = { wire_thruster_uweffect = "water_medium" },
			["#Water Big"] = { wire_thruster_uweffect = "water_big" },
			["#Water Huge"] = { wire_thruster_uweffect = "water_huge" },
			["#Striderblood Small"] = { wire_thruster_uweffect = "striderblood_small" },
			["#Striderblood Medium"] = { wire_thruster_uweffect = "striderblood_medium" },
			["#Striderblood Big"] = { wire_thruster_uweffect = "striderblood_big" },
			["#Striderblood Huge"] = { wire_thruster_uweffect = "striderblood_huge" },
			["#More Sparks"] = { wire_thruster_uweffect = "more_sparks" },
			["#Spark Fountain"] = { wire_thruster_uweffect = "spark_fountain" },
			["#Jetflame"] = { wire_thruster_uweffect = "jetflame" },
			["#Jetflame Advanced"] = { wire_thruster_uweffect = "jetflame_advanced" },
			["#Jetflame Blue"] = { wire_thruster_uweffect = "jetflame_blue" },
			["#Jetflame Red"] = { wire_thruster_uweffect = "jetflame_red" },
			["#Jetflame Purple"] = { wire_thruster_uweffect = "jetflame_purple" },
			["#Comic Balls"] = { wire_thruster_uweffect = "balls" },
			["#Comic Balls Random"] = { wire_thruster_uweffect = "balls_random" },
			["#Comic Balls Fire Colors"] = { wire_thruster_uweffect = "balls_firecolors" },
			["#Souls"] = { wire_thruster_uweffect = "souls" },
			["#Debugger 10 Seconds"] = { wire_thruster_uweffect = "debug_10" },
			["#Debugger 30 Seconds"] = { wire_thruster_uweffect = "debug_30" },
			["#Debugger 60 Seconds"] = { wire_thruster_uweffect = "debug_60" },
			["#Fire and Smoke"] = { wire_thruster_uweffect = "fire_smoke" },
			["#Fire and Smoke Huge"] = { wire_thruster_uweffect = "fire_smoke_big" },
			["#5 Growing Rings"] = { wire_thruster_uweffect = "rings_grow_rings" },
			["#Color and Magic"] = { wire_thruster_uweffect = "color_magic" },
		}
	})

	panel:AddControl("Slider", {
		Label = "#WireThrusterTool_force",
		Type = "Float",
		Min = "1",
		Max = "10000",
		Command = "wire_thruster_force"
	})

	panel:AddControl("Slider", {
		Label = "#WireThrusterTool_force_min",
		Type = "Float",
		Min = "0",
		Max = "10000",
		Command = "wire_thruster_force_min"
	})

	panel:AddControl("Slider", {
		Label = "#WireThrusterTool_force_max",
		Type = "Float",
		Min = "0",
		Max = "10000",
		Command = "wire_thruster_force_max"
	})

	panel:AddControl("CheckBox", {
		Label = "#WireThrusterTool_bidir",
		Command = "wire_thruster_bidir"
	})

	panel:AddControl("CheckBox", {
		Label = "#WireThrusterTool_collision",
		Command = "wire_thruster_collision"
	})

	panel:AddControl("CheckBox", {
		Label = "#WireThrusterTool_sound",
		Command = "wire_thruster_sound"
	})

	panel:AddControl("CheckBox", {
		Label = "#WireThrusterTool_owater",
		Command = "wire_thruster_owater"
	})

	panel:AddControl("CheckBox", {
		Label = "#WireThrusterTool_uwater",
		Command = "wire_thruster_uwater"
	})
end

//from model pack 1 --TODO: update model pack system to use list system
list.Set( "ThrusterModels", "models/jaanus/thruster_flat.mdl", {} )
