include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize ()
self.trrtmyr = false;
	self.Entity:SetModel("models/props_junk/watermelon01_chunk02c.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	local physics = self.Entity:GetPhysicsObject();
	if (physics:IsValid()) then
		physics:Wake();
		physics:EnableGravity(false);
	end
	self.Entity:SetColor(Color(0, 0, 0, 255));
	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0), false, 5, 0, 1, 1/5*0.5, "trails/laser.vmt");
	self.Entity:Fire("break", "", 3);
end

function ENT:Think()
if self.Entity:GetPos():Distance(self.Origin) > self.Fuse then
self:Break()
self.Entity:NextThink( CurTime() + 100)
end
end

function ENT:Break ()
	local range = 300
	for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), range)) do
		if v.Warmelon then
			local target = v:EntIndex()
			if v.Grav ~= nil && v.Grav == false && v.ZVelocity == nil && math.Rand(0,1) < 0.175 then
				if v.fuelleft == nil then
					timer.Simple(15, RestoreFlight, target, v.Delay)
				end
				if v:GetPhysicsObject():IsValid() then
					if v.fuelleft == nil then
						v.Grav = true
						v.Delay = 16
					end
					v:GetPhysicsObject():EnableGravity(true)
				end
			elseif v:GetClass() == "gmod_hoverball" then
				local distance = v:GetPos():Distance(self.Entity:GetPos())
				local falloff = 0.5
				local mul = 1.5
				local phys = v:GetPhysicsObject() 
				if (phys and phys:IsValid()) then
					local mass = phys:GetMass()
					phys:SetMass( mass - math.min( (range - distance * falloff) * mul, mass - 1 ) )
				end
			elseif v:GetClass() == "gmod_wire_hoverball" && v.strength > 0.3 then
				v.strength = v.strength - 0.3
				--if v:GetParent().Grav == false && math.Rand(0,1) < 0.1 then
					--Msg("off")
					--if v:GetParent():GetPhysicsObject():IsValid() then
						--timer.Simple(21, RestoreFlight, target, v:GetParent():GetPhysicsObject():GetMass(), v:GetParent():GetVar( "AirResistance", 0 ) )
						--v:GetParent():SetVar("AirResistance", 50)
						--timer.Simple(1, RestoreFlightHover, target, 20, 20)
						--v:GetParent().Grav = true
						--v:GetParent():GetPhysicsObject():SetMass(1)
					--end
				--end
			elseif v:GetClass() == "gmod_thruster" then
				if (v.MaxForce ~= 0) then
					local force = v.force
					
					if (math.abs(force) > 0) then
						force = force - (v.MaxForce/math.abs(v.MaxForce)) * force * 0.25
					else
						force = 0
					end
					v:SetForce( force )
				end
        	elseif v:GetClass() == "gmod_wire_thruster" then
				local forceMax = v.ForceMax
				if (v.maxForceMax ~= 0) then
					if (math.abs(forceMax) > 0) then
						forceMax = forceMax - (v.maxForceMax/math.abs(v.maxForceMax)) * forceMax * 0.25
					else
						forceMax = 0
					end
				end
				
				local forceMin = v.ForceMin
				if (v.minForceMin ~= 0) then
					if (math.abs(forceMin) > 0) then
						forceMin = forceMin - (v.minForceMin/math.abs(v.minForceMin)) * forceMax * 0.25
					else
						forceMin = 0
					end
				end
				v:Setup(v.force, forceMin, forceMax, v.OWEffect, v.UWEffect, v.OWater, v.UWater, v.BiDir, "")
        	end
        end
    end

	local expl=ents.Create("point_hurt")
	expl:SetPos(self.Entity:GetPos());
	expl:SetOwner(self.Entity);
	expl.Team = self.Team;
	expl:SetKeyValue("Damage","1");
	expl:SetKeyValue("DamageRadius", tostring(range));
	expl:SetKeyValue("DamageType", "0");
	expl:Spawn();
	expl:Activate();
	expl:Fire("Hurt", "", 0);
	expl:Fire("kill","",0);
	local fx = EffectData();
	fx:SetOrigin(self.Entity:GetPos());
	fx:SetStart(self.Entity:GetPos());
	fx:SetScale(1);
	util.Effect("Explosion", fx);
	self.Entity:Fire ("kill", "", 0);
	
end

function ENT:PhysicsCollide()
	self:Break();
end
