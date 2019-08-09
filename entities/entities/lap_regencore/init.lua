include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1.4;
ENT.Healthlol = 500;
ENT.FiringRange = 500;
ENT.NoMoveRange = 20;
ENT.Speed = 0
ENT.DeathRadius = 500;
ENT.DeathMagnitude = 75;
ENT.MovingForce = 25;
ENT.MelonModel = "addons/wmm/models/wmm/regenerative.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.StdMat = "addons/wmm/materials/wmm/glass"
	self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/plastic"));
	--items/medcharge4.wav 100+
end

--No attacking or other thoughts function - this is a special warmelon, and as such, we want to override Think().
function ENT:DoAttacks ()
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)
	for k, v in pairs(entz) do
		if v.Warmelon then
			if (v.Team == self.Team) then
			     if v.Healthlol ~= nil && v.Healthlol < v.Maxlol then
					local angle = v:GetPos() - self.Entity:GetPos();
					v.Healthlol = v.Healthlol+2;

					if (v.Healthlol>v.Maxlol/5 && v.trail) then
						v.trail:Remove();
						v.trail = nil;
					end
				 elseif v.health ~= nil && v.health < v.maxhealth then
				   v.health = v.health+2;    
if v.health > (v.maxhealth * 0.5) then

     if (v.Team == 1) then
		v:SetColor (Color(255, 0, 0, 255));
	end
	if (v.Team == 2) then
		v:SetColor (Color(0, 0, 255, 255));
	end
	if (v.Team == 3) then
		v:SetColor (Color(0, 255, 0, 255));
	end
	if (v.Team == 4) then
		v:SetColor (Color(255, 255, 0, 255));
	end
	if (v.Team == 5) then
		v:SetColor (Color(255, 0, 255, 255));
	end
	if (v.Team == 6) then
		v:SetColor (Color(0, 255, 255, 255));
	end
end
end
			end
		end
	end
end
