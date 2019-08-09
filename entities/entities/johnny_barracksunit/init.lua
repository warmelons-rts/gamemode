include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )


-- Setting up all the different properties of our melon.
ENT.Delay = 1.3;
ENT.Healthlol = 50;
ENT.Speed = 100 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.FiringRange = 300;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.DeathRadius = 30;
ENT.DeathMagnitude = 2;
ENT.MovingForce = 30 * GetConVarNumber( "WM_Melonforce", 7);
ENT.Move = true;
ENT.MelonModel = "models/props_junk/watermelon01.mdl";
ENT.BuildModifier = 10;
-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Orders = true;
	if !self.Grav then 
self.Healthlol = 30
self.Maxlol = 30
util.SpriteTrail(self.Entity, 0, team.GetColor(self.team)--[[Color(255, 255, 255)]], false, 10, 0, 2, 1/10*0.5, "trails/smoke.vmt")
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
self.NoMoveRange = 100
end
end
Sound ("Weapon_Mortar.Single");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
	local angle = self.Target:GetPos() - self.Entity:GetPos();
		self.Target:TakeDamage(3, self.Entity);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetStart(self.Target:GetPos());
	if (self.Team == 1) then
		util.Effect("johnny_redlaser", fx);
	end
	if (self.Team == 2) then
		util.Effect("johnny_bluelaser", fx);
	end
	if (self.Team == 3) then
		util.Effect("johnny_greenlaser", fx);
	end
	if (self.Team == 4) then
		util.Effect("johnny_yellowlaser", fx);
	end
	if (self.Team == 5) then
		util.Effect("johnny_magentalaser", fx);
	end
	if (self.Team == 6) then
		util.Effect("johnny_cyanlaser", fx);
	end
	if (self.Team == 7) then
		util.Effect("johnny_blacklaser", fx);
	end
		local fxx = EffectData();
		fxx:SetOrigin(self.Entity:GetPos());
		fxx:SetAngles(angle:Angle());
		fxx:SetScale(1.2);
		util.Effect("MuzzleEffect", fxx);
		self.Entity:EmitSound("Weapon_Mortar.Single", 100, 100);
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
		self.Entity:SetColor(Color(0, 0, 0, 255));
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
