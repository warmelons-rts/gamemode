include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 5.55;
ENT.Healthlol = 300;
ENT.FiringRange = 500;
ENT.NoMoveRange = 20;
ENT.DeathRadius = 400;
ENT.Speed = 0
ENT.DeathMagnitude = 20;
ENT.MovingForce = 25;
ENT.MelonModel = "addons/wmm/models/wmm/battlefield.mdl";
ENT.targets = {};
ENT.teams = {};

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.StdMat = "addons/wmm/materials/wmm/hull3"
	self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/hull3"));
local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake();
		phys:SetMass(1000);
	end
end

--No attacking or other thoughts function - this is a special warmelon, and as such, we want to override Think().
function ENT:DoAttacks ()
self:Clarity(self.targets, self.teams);
self.targets = {};
self.teams = {};
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)
	for k, v in pairs(entz) do
		if v.Warmelon then
			if (v.Team == self.Team && v.Delay ~= nil && v ~= self.Entity && !table.HasValue(self.targets, v) && v:GetPos():Distance(self.Entity:GetPos())<self.FiringRange) then
					local angle = v:GetPos() - self.Entity:GetPos();
				  table.insert(self.targets, v);
			   	table.insert(self.teams, v.Delay);
              if (v.Delay ~= nil && v.Delay > 0.1) then
				  v.Delay = v.Delay * 0.75;
			--	  local r, g, b, a = v:GetParent():GetColor()
            --    v:GetParent().lamp = ents.Create( "gmod_light" )
           --     if (! v:GetParent().lamp:IsValid()) then return end
           --  v:GetParent().lamp:SetLightColor( 0, 0, 0 )
           --v:GetParent().lamp:SetBrightness( 5 )
           --v:GetParent().lamp:SetLightSize( 150 )
          -- v:GetParent().lamp:SetPos(v:GetParent():GetPos())
          -- v:GetParent().lamp:SetCollisionGroup(0)
          -- v:GetParent().lamp:SetParent(v:GetParent())
           --v:GetParent().lamp:Spawn()
           local effectdata = EffectData()
effectdata:SetStart( v:GetPos() ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
effectdata:SetOrigin( v:GetPos() )
effectdata:SetScale( 2 )
  util.Effect( "cball_bounce", effectdata ) 
              end


			end
		end
	end
end

function ENT:Clarity (tar, tea)

	for k, v in pairs(tar) do
	if v:IsValid() && v:IsValid() then
   	 v.Delay = tea[k];
   	 --v:GetParent().lamp:Remove()
	end
	end
end	