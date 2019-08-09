include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize ()
self.trrtmyr = false;
	self.Entity:SetModel("models/Items/combine_rifle_ammo01.mdl");
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
end

function ENT:Break ()
	if (!self.trrtmyr) then
		self.trrtmyr = true;
		local expl=ents.Create("point_hurt")
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("Damage","16");
		expl:SetKeyValue("DamageRadius", "256");
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

function ENT:PhysicsCollide (data, physobj)
	if data.HitEntity:IsValid() && (data.HitEntity:GetClass() == "lap_striker" || data.HitEntity:GetClass() == "lap_strikerbomb")  then
	constraint.NoCollide(self.Entity, data.HitEntity, 0, 0)
	else
	self:Break();
	end

end
