include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1.4;
ENT.Healthlol = 30;
ENT.FiringRange = 350;
ENT.NoMoveRange = 20;
ENT.DeathRadius = 20;
ENT.Speed = 80 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathMagnitude = 5;
ENT.MovingForce = 25  * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";
ENT.StdMat = "phoenix_storms/metalfloor_2-3"

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:SetMaterial(self.StdMat)
	--What is this? We're overriding the colours too?
	if (self.Team == 1) then
		self.Entity:SetColor(Color(255, 128, 128, 255));
	end
	if (self.Team == 2) then
		self.Entity:SetColor(Color(128, 128, 255, 255));
	end
	if (self.Team == 3) then
		self.Entity:SetColor(Color(128, 255, 128, 255));
	end
	if (self.Team == 4) then
		self.Entity:SetColor(Color(255, 255, 128, 255));
	end
	if (self.Team == 5) then
		self.Entity:SetColor(Color(255, 128, 255, 255));
	end
	if (self.Team == 6) then
		self.Entity:SetColor(Color(128, 255, 255, 255));
	end
	if (self.Team == 7) then
	self.Entity:SetColor(Color(128, 128, 128, 255));
	end
if !self.Grav then 
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
end
end

function ENT:Detach()
if !self.Welded then
    constraint.RemoveAll(self.Entity)
end
end

function ENT:OtherThoughts()
self:Detach()
end

--No attacking or other thoughts function - this is a special warmelon, and as such, we want to override Think().
function ENT:DoAttacks ()
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange);
	for k, v in pairs(entz) do
		if v.Warmelon then
		local Heal = 1;
			local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
			if (v.Team == self.Team) then
			 if (v.Healthlol ~= nil && v.Maxlol ~= nil && v.Healthlol < v.Maxlol && traceRes.Entity == v) then
        v.Healthlol = v.Healthlol+4;
			 elseif (v.health ~= nil && v.maxhealth ~= nil && v.health < v.maxhealth && traceRes.Entity == v) then
          v.health = v.health + 4;
            if v.health > (v.maxhealth * 0.5) then
            v:SetColor(Color(0,0,0,255))
  if (v.Team == 1) then
		v:SetColor(Color(255, 0, 0, 255));
	end
	if (v.Team == 2) then
		v:SetColor(Color(0, 0, 255, 255));
	end
	if (v.Team == 3) then
		v:SetColor(Color(0, 255, 0, 255));
	end
	if (v.Team == 4) then
		v:SetColor(Color(255, 255, 0, 255));
	end
	if (v.Team == 5) then
		v:SetColor(Color(255, 0, 255, 255));
	end
	if (v.Team == 6) then
		v:SetColor(Color(0, 255, 255, 255));
	end
	end
       elseif (v.breakable ~= nil && v.breakable.Cur < v.breakable.Max && traceRes.Entity == v) then
          v.breakable.Cur = v.breakable.Cur + 4;
       else
       Heal = 0;
       end
      else Heal = 0;
      end
      if Heal == 1 then
          local angle = v:GetPos() - self.Entity:GetPos();
          if (self.LOLFX == true) then
						local fx = EffectData();
						fx:SetOrigin(v:GetPos());
						util.Effect("johnny_healing", fx);
          end
		local fx2 = EffectData();
		fx2:SetOrigin(self.Entity:GetPos());
		fx2:SetStart(v:GetPos());
	if (self.Team == 1) then
		util.Effect("johnny_redlaser", fx2);
	elseif (self.Team == 2) then
		util.Effect("johnny_bluelaser", fx2);
	elseif (self.Team == 3) then
		util.Effect("johnny_greenlaser", fx2);
	elseif (self.Team == 4) then
		util.Effect("johnny_yellowlaser", fx2);
	elseif (self.Team == 5) then
		util.Effect("johnny_magentalaser", fx2);
	elseif (self.Team == 6) then
		util.Effect("johnny_cyanlaser", fx2);
	else
		util.Effect("johnny_redlaser", fx2);
	end
		local fxx = EffectData();
		fxx:SetOrigin(self.Entity:GetPos());
		fxx:SetAngles(angle:Angle());
		fxx:SetScale(1.2);
		util.Effect("MuzzleEffect", fxx);
					if (v.Healthlol ~= nil && v.Healthlol>v.Maxlol/5 && v.trail) then
						v.trail:Remove();
						v.trail = nil;
					end
break;
end
			end
		end
	end
