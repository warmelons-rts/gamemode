include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize ()
self.start = false;
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
	self.targets = {};
	self.teams = {};
	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0), false, 5, 0, 1, 1/5*0.5, "trails/tube.vmt");
	self.Entity:Fire("break", "", 3);
end

function ENT:Think ()
end

function ENT:Break ()
	if (!self.start) then
		self.start = true;
		local expl=ents.Create("point_hurt")
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("Damage","0");
		expl:SetKeyValue("DamageRadius", "256");
		expl:SetKeyValue("DamageType", "0");
		expl:Spawn();
		expl:Activate();
		expl:Fire("Hurt", "", 0);
		expl:Fire("kill","",0);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetStart(self.Entity:GetPos());
		fx:SetScale(10);
		util.Effect("cball_explode", fx);
		self.Entity:EmitSound("ambient/levels/labs/electric_explosion2.wav", 100, 100)
		local morphed = EffectData()
		morphed:SetOrigin(self.Entity:GetPos())
		morphed:SetMagnitude(10)
		util.Effect("ChaosWarp", morphed)
		self.Entity:Fire ("kill", "", 0);
		local entz = ents.FindInSphere(self.Entity:GetPos(), 256);
		self.targets = {};
		self.teams = {};
		self.materials = {}
		for k, v in pairs(entz) do
			if v.Warmelon && v.Team ~= nil then
				if v:GetPhysicsObject():IsValid() && v:GetPhysicsObject():IsMoveable() then
				v:GetPhysicsObject():SetVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
				end
				if (v.asploded ~= true) then
					if (v.Team > 0) then
					local randy = math.random(-1000, 0);
					table.insert(self.targets, v);
					table.insert(self.teams, v.Team);
					table.insert(self.materials, v:GetMaterial());-- Changed v.GetMaterial() to v:GetMaterial()
					v.Team = randy;
					v.Team = randy;
					v:SetMaterial("models/flesh");
					end
				end
			end
		end
	end
	local originaltargets = table.Copy(self.targets)
	local originalteams = table.Copy(self.teams)
	local originalmaterials = table.Copy(self.materials)
	timer.Simple(6.5, function() Clarity(originaltargets, originalteams, originalmaterials) end);--Copies needed because the timer has a delay. The tables would be reset when the timer is calling Clarity.
end

function Clarity (tar, tea, mat)
	for k, v in pairs(tar) do
		if v:IsValid() then
			v.Target = NIL;	
			v.Team = tea[k];
			v.Team = v.Team;
			v:SetMaterial(mat[k]);
		end
	end
end	

function ENT:PhysicsCollide (tjrjdrjtrhtrd, rupihbrhbrseojirsejiuo)
	self:Break();
end
