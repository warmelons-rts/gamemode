include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 75;
ENT.FiringRange = 700;
ENT.NoMoveRange = 200;
ENT.MinRange = 0;
ENT.Speed = 80 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 10;
ENT.MovingForce = 20 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";
ENT.Move = true;
ENT.BuildModifier = 10;
-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Built = 2
	self:SetNWInt("WMTipV", 1)
	if (self.Team == 1) then
	self.Entity:SetColor (Color(125, 0, 0, 255))
	end
	if (self.Team == 2) then
	self.Entity:SetColor (Color(0, 0, 125, 255))
	end
	if (self.Team == 3) then
	self.Entity:SetColor (Color(0, 125, 0, 255))
	end
	if (self.Team == 4) then
	self.Entity:SetColor (Color(125, 125, 0, 255))
	end
	if (self.Team == 5) then
	self.Entity:SetColor (Color(125, 0, 125, 255))
	end
	if (self.Team == 6) then
	self.Entity:SetColor (Color(0, 125, 125, 255))
	end
	if (self.Team == 7) then
	self.Entity:SetColor (Color(125, 125, 125, 255))
	end
	self.Orders = true
	if !self.Grav then
self.Healthlol = 50
self.Maxlol = 50
util.SpriteTrail(self.Entity, 0, Color(255, 255, 255), false, 10, 0, 2, 1/10*0.5, "trails/smoke.vmt")
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
self.NoMoveRange = 100
end
end
Sound ("Weapon_Mortar.Single");

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
		bullet.Damage = 5;
		bullet.TracerName = "AR2Tracer";
		self.Entity:FireBullets (bullet);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetAngles(angle:Angle());
		fx:SetScale(1.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_P90.Single", 100, 100);
end

function ENT:OnTakeDamage (dmginfo)
	self.Entity:TakePhysicsDamage (dmginfo);
	self.Healthlol = self.Healthlol - dmginfo:GetDamage();
	if (self.Healthlol < 1 && !self.asploded) then
		local expl=ents.Create("env_explosion")
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("iMagnitude",self.DeathMagnitude);
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius);
		expl:Spawn();
		expl:Activate();
		expl:Fire("explode", "", 0);
		expl:Fire("kill","",0);
		self.asploded = true;
		constraint.RemoveAll (self.Entity);
		self.Entity:SetColor (Color(0, 0, 0, 255));
		self.Entity:Fire ("kill", "", 3);
		if self.Barracks:IsValid() then
			self.Barracks.ActiveMelons = self.Barracks.ActiveMelons - 1;
		end
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

function ENT:OnRemove()
if self.Barracks:IsValid() then
self.Barracks.ActiveMelons = self.Barracks.ActiveMelons - 1;
end
SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") - 1)
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()

end
