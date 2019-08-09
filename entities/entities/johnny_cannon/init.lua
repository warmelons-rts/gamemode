include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 3.2;
ENT.Healthlol = 85;
ENT.FiringRange = 1000;
ENT.Speed = 50 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.NoMoveRange = 50;
ENT.FollowRange = 75;
ENT.MinRange = 200;
ENT.DeathRadius = 75;
ENT.DeathMagnitude = 6;
ENT.MovingForce = 115 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/Roller.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	if !self.Grav then 
		self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
	end
	
	local r=self.Entity:BoundingRadius()/2;
    self:PhysicsInitSphere(r);
    self:SetCollisionBounds(Vector(-r,-r,-r),Vector(r,r,r));
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	local physics = self:GetPhysicsObject();
    if (physics:IsValid()) then
        physics:Wake();
    end
end
Sound ("Weapon_RPG.Single");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
local moving = 1
		if self.Entity:GetVelocity():Length() > 100 then
		moving = 2
		end
		local expl=ents.Create("johnny_cannonshell")
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local xr = math.Rand(0,0.2*moving);
		local yr = math.Rand(0,0.2*moving);
		local zr = math.Rand(0,0.2*moving);
		local final = Vector (angle.x * (xr + 0.9), angle.y * (yr + 0.9), angle.z * (zr + 0.9));
		expl:SetPos(self.Entity:GetPos()+angle:GetNormalized()*10);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team
		expl:SetAngles(final:Angle());
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(final:GetNormalized()*10000);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+final:GetNormalized()*10);
		fx:SetAngles(final:Angle());
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_RPG.Single", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() || !(self.Team ~= self.Target.Team) then
		self:TargetSearch();
		return
	end
	if !self.Target.Grav && self.Target:GetClass() ~= "melon_baseprop" then
		self:TargetSearch();
		return	
	end
	local traceRes=util.QuickTrace (self.Entity:GetPos(), self.Target:GetPos()-self.Entity:GetPos(), self.Entity);
	--Checking that the target is still in range, and that we still have LOS.
	local dist = self.Target:GetPos():Distance(self.Entity:GetPos())
	if traceRes.Entity == self.Target && !self.Target.asploded && dist < self.FiringRange && dist > self.MinRange then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end

function ENT:TargetSearch ()
	if self.asploded then return end
	if WMPause == true then return end
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon then
		if v.Grav || v:GetClass() == "melon_baseprop" then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (dist>self.MinRange && v.Team ~= self.Team && v.asploded ~= true) then
				local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
				if traceRes.Entity == v then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					  self.Target = v;
					  break;
					  end
          else
					self.Target = v;
					break;
					end
				end
			end
		end
		end
	end
end
