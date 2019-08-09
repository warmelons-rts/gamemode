include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

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
	self.Entity:SetColor(0, 0, 0, 255);
	self.targets = {};
	self.teams = {};
	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0), false, 5, 0, 1, 1/5*0.5, "trails/laser.vmt");
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
		fx:SetScale(1);
		util.Effect("Explosion", fx);
		self.Entity:Fire ("kill", "", 0);
	local entz = ents.FindByClass("info_target");
	for k, v in pairs(entz) do
		if v.Warmelon then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (dist<256 && v:GetParent().asploded ~= true) then
				if (v:GetParent().Team > 0) then
				self.targets = {};
				self.teams = {};
				local randy = math.random(-1000, 0);
				table.insert(self.targets, v);
				table.insert(self.teams, v:GetParent().Team);
				v:GetParent().Team = randy;
				v.Team = randy;
				Msg(v:GetParent().Team .. "\n");
				end
			end
		end
	end
	end
timer.Simple(2, Clarity, self.targets, self.teams);
end

function Clarity (tar, tea)
Msg("Clarity\n");
	for k, v in pairs(tar) do	
	 if v:IsValid() then
		table.remove(tar, k);
		v.Team = table.remove(tea, k);
		v:GetParent().Team = v.Team;
		v:GetParent().Target = nil;
		Msg(v:GetParent().Team .. "\n");
		Msg(v.Team .. "\n");
	 end
	end
end	

function ENT:PhysicsCollide (tjrjdrjtrhtrd, rupihbrhbrseojirsejiuo)
	self:Break();
end
