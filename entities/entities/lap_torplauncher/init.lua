include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 85;
ENT.FiringRange = 2000;
ENT.Speed = 50 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.NoMoveRange = 50;
ENT.FollowRange = 75;
ENT.MinRange = 250;
ENT.DeathRadius = 75;
ENT.DeathMagnitude = 6;
ENT.MovingForce = 115 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/MetalBucket01a.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.CurrentTimer = 0
	self.Marine = true
end
Sound ("Weapon_RPG.Single");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
		if self.CurrentTimer <= 0 then
		self.CurrentTimer = 6
		self.Entity:EmitSound("weapons/Irifle/irifle_fire2.wav", 100, 75)
		local expl=ents.Create("lap_torpedo")
		local angle1 = self.Target:GetPos() - self.Entity:GetPos();
		expl:SetPos(self.Entity:GetPos()+angle1:GetNormal()*50);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team
		local shit = self.Entity:GetAngles()
		shit:RotateAroundAxis(self.Entity:GetForward(), 180)
		expl:SetAngles(shit)
		expl.TargetPos = self.Target:GetPos()
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(angle1:GetNormalized()*50);
		end
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
if self.CurrentTimer > 0 then
self.CurrentTimer = self.CurrentTimer - self.Delay
end
end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() || self.Target.Team == self.Team then
		self:TargetSearch();
		return
	end
	local traceRes=util.QuickTrace (self.Entity:GetPos(), self.Target:GetPos()-self.Entity:GetPos(), self.Entity);
	--Checking that the target is still in range, and that we still have LOS.
	local dist = self.Target:GetPos():Distance(self.Entity:GetPos())
	if traceRes.Entity == self.Target && !self.Target.asploded && dist < self.FiringRange && dist > self.MinRange && traceRes.Entity:WaterLevel() > 0 then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end

function ENT:TargetSearch ()
local pos = self.Entity:GetPos()
local up = self.Entity:GetUp()
	if self.asploded then return end
	if WMPause == true then return end
    --debugoverlay.Box(pos + Vector(up.x * 250, up.y * 100, up.z * 100), pos + Vector(up.x * 2000, up.y * -100, up.z * -100), 1, Color(200,200,200))
    --local fx = EffectData();
	--fx:SetOrigin(util.LocalToWorld(self.Entity, Vector(200,200,250)));
	--util.Effect("johnny_build", fx);
	--local fx2 = EffectData();
	--fx2:SetOrigin(util.LocalToWorld(self.Entity, Vector(-200,-200,2000)));
	--util.Effect("johnny_build", fx2);
--	Msg(self.Entity:OBBCenter())
	for k, v in pairs(ents.FindInBox(util.LocalToWorld(self.Entity, Vector(300,300,250)), util.LocalToWorld(self.Entity, Vector(-300,-300,2000)))) do
		if v.Warmelon && self.Team && v:WaterLevel() > 0 then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (v.asploded ~= true) then
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
