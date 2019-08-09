include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

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
		physics:EnableGravity(true);
	end
	self.Entity:SetColor(Color(0, 0, 0, 255));
	self.Offset = self.Entity:GetPos():Distance(self.TargetPos) / GetConVarNumber("WM_test1", 1)
	util.SpriteTrail(self.Entity, 0, Color(255, 255, 0), false, 5, 0, 1, 1/5*0.5, "trails/laser.vmt");
	self.Entity:Fire("break", "", 5);
end

function ENT:Think ()
end

function ENT:Break ()
	if (!self.trrtmyr) then
		self.trrtmyr = true;
		local expl=ents.Create("point_hurt")
		expl.Team= self.Team
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("Damage","16");
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
	end
end

function ENT:PhysicsCollide (tjrjdrjtrhtrd, rupihbrhbrseojirsejiuo)
	self:Break();
end

function ENT:AimOffset(Vect)
if (!Vect) then return end
self:SetAngles((Vect-self:GetPos()):GetNormal():Angle())
end

function ENT:PhysicsUpdate()
     self.Entity:GetPhysicsObject():SetVelocity(self.Entity:GetForward()*750)
     self.Entity.Offset = self.Entity.Offset - (self.Entity:GetVelocity():Length()/GetConVarNumber("WM_test2", 1))
 -- Set the new angle
     self:AimOffset(Vector(self.TargetPos.x,self.TargetPos.y,self.TargetPos.z+self.Entity.Offset))
end
