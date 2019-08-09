include("shared.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize ()
self.trrtmyr = false;
self.timer = 0
	self.Entity:SetModel("models/hunter/misc/sphere025x025.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	local physics = self.Entity:GetPhysicsObject();
	if (physics:IsValid()) then
		physics:Wake();
		physics:EnableGravity(true);
	end
	self.Entity:SetColor(Color(0, 0, 0, 255));
	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0), false, 5, 0, 1, 1/5*0.5, "trails/laser.vmt");
	self.Entity:Fire("break", "", 3);
end

function ENT:Think ()
self.timer = self.timer + 1
	if self.timer >= 2 then
	self:Break()
	end
self.Entity:NextThink(CurTime()+2)
return true

end

function ENT:Break ()
	if (!self.trrtmyr) then
		self.trrtmyr = true;
		local expl=ents.Create("point_hurt")
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("Damage","20");
		expl:SetKeyValue("DamageRadius", "75");
		expl:SetKeyValue("DamageType", "0");
		expl.Team = self.Team;
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
end
