include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 2;
ENT.Healthlol = 30;
ENT.FiringRange = 1400;
ENT.NoMoveRange = 200;
ENT.MinRange = 0;
ENT.Speed = 70 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 4;
ENT.MovingForce = 20 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
  
	if (self.Team == 1) then
    self.Entity:SetColor(Color(125, 0, 0, 255))
	elseif (self.Team == 2) then
    self.Entity:SetColor(Color(0, 0, 125, 255))
	elseif (self.Team == 3) then
    self.Entity:SetColor(Color(0, 125, 0, 255))
	elseif (self.Team == 4) then
    self.Entity:SetColor(Color(125, 125, 0, 255))
	elseif (self.Team == 5) then
    self.Entity:SetColor(Color(125, 0, 125, 255))
	elseif (self.Team == 6) then
    self.Entity:SetColor(Color(0, 125, 125, 255))
	elseif (self.Team == 7) then
    self.Entity:SetColor(Color(100, 100, 100, 255));
	end
  
  --Removed for testing.
  --if !self.Grav then 
  --  self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
  --end
end
Sound ("Weapon_AWP.Single");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
local moving = 1
		if self.Entity:GetVelocity():Length() > 100 then
		moving = 3
		end
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local bullet = {};
		bullet.Num = 1;
		bullet.Src = self.Entity:GetPos();
		bullet.Dir = angle:GetNormalized();
		bullet.Spread = Vector (0.02*moving, 0.02*moving, 0.02*moving);
		bullet.Tracer = 1;
		bullet.Force = 0;
		bullet.Damage = 9;
		bullet.TracerName = "AR2Tracer";
		self.Entity:FireBullets (bullet);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetAngles(angle:Angle());
		fx:SetScale(3);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_AWP.Single", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end
