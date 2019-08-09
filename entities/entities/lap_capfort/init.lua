include("shared.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

DEFINE_BASECLASS( "base_warmelon" )

ENT.Delay = 5;
ENT.Healthlol = 250;
ENT.FiringRange = 1;
ENT.NoMoveRange = 0;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.DeathRadius = 200;
ENT.DeathMagnitude = 15;
ENT.MovingForce = 0;
--ENT.MelonModel = "models/hunter/misc/cone2x1.mdl";
ENT.MelonModel = "models/hunter/tubes/tube4x4x1to2x2.mdl";
ENT.Stance = 0;
ENT.StdMat = "phoenix_storms/metalfloor_2-3"
function ENT:Initialize()
	self:Setup();
self.Entity:SetMaterial(self.StdMat)
--local min,max = self.Entity:GetParent():WorldSpaceAABB()
--local offset=max-min
--Msg(offset:Length())
--if offset:Length() > 160 then
--self.Entity:SetModel("models/hunter/tubes/tube4x4x1to2x2.mdl")
--end
--if self.Entity:GetParent():GetModel() == "models/props_c17/gravestone_cross001b.mdl" then
--self.Entity:SetPos(self.Entity:GetPos() - Vector(0,0,40))
--end
	self.Entity.CapturePoint.secured = true
	if (self.Team == 1) then
	self.Entity:SetColor(Color(125, 0, 0, 255))
	end
	if (self.Team == 2) then
	self.Entity:SetColor(Color(0, 0, 125, 255))
	end
	if (self.Team == 3) then
	self.Entity:SetColor(Color(0, 125, 0, 255))
	end
	if (self.Team == 4) then
	self.Entity:SetColor(Color(125, 125, 0, 255))
	end
	if (self.Team == 5) then
	self.Entity:SetColor(Color(125, 0, 125, 255))
	end
	if (self.Team == 6) then
	self.Entity:SetColor(Color(0, 125, 125, 255))
	end
	if (self.Team == 7) then
	self.Entity:SetColor(Color(125, 125, 125, 255));
	end
	self.Entity:GetPhysicsObject():EnableMotion(false);
self:SetNWInt("WMHealth", math.floor(self.Maxlol))
self:SetNWInt("WMMaxHealth", math.floor(self.Maxlol))
Sound ("Weapon_P90.Single");
end
--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local bullet = {};
		bullet.Num = 1;
		bullet.Src = self.Entity:GetPos();
		bullet.Dir = angle:GetNormalized();
		bullet.Spread = Vector (0.06, 0.06, 0.06);
		bullet.Tracer = 1;
		bullet.Force = 0;
		bullet.Damage = 10;
		bullet.TracerName = "AR2Tracer";
		self.Entity:FireBullets (bullet);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetAngles(angle:Angle());
		fx:SetScale(1.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_P90.Single", 100, 100);
end

function ENT:OtherThoughts()
if self:GetNWInt("WMHealth") ~= self.Healthlol then
self:SetNWInt("WMHealth", math.floor(self.Healthlol))
end
end

function ENT:OnRemove()

self.Entity.CapturePoint.secured = false
constraint.RemoveAll(self.Entity)

end

function ENT:PhysicsCollide(data, physobj)
	if data.HitEntity:IsValid() && data.HitEntity.Team == self.Team then
	constraint.NoCollide(self.Entity, data.HitEntity, 0, 0)
	end
end