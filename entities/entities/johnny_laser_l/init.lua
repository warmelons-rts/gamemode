include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Move = false;
ENT.Delay = 2.5;
ENT.Healthlol = 100;
ENT.FiringRange = 800;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.DeathRadius = 30;
ENT.DeathMagnitude = 2;
ENT.Speed = 0
ENT.MovingForce = 200;
ENT.MelonModel = "models/props_c17/utilityconnecter006c.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	local physics = self.Entity:GetPhysicsObject();
	if (physics:IsValid()) then
	physics:SetMass(300)
	end
	local oldangles = self.Entity:GetAngles()
	self.Entity:SetAngles(Angle(0,0,0))
	self.jTarget = ents.Create("info_target");
	self.jTarget:SetPos(self.Entity:GetPos());
	self.jTargetName = "johnnylaser" .. self.Entity:EntIndex();
	self.jTarget:SetKeyValue("targetname", self.jTargetName);
	self.jTarget:Spawn();
	self.jTarget:Activate();
	self.Entity:DeleteOnRemove(self.jTarget);
	self.jLaser = ents.Create("env_laser");
	self.jLaser.Team = self.Team
	self.jLaser:SetPos(self.Entity:GetPos()+Vector(0,0,26));
	self.jLaser:SetAngles(self.Entity:GetAngles());
	self.jLaser:SetKeyValue("texture", "sprites/bluelaser1.vmt");
	self.jLaser:SetKeyValue("texturescroll", 50);
	self.jLaser:SetKeyValue("damage", 25);
	self.jLaser:SetKeyValue("dissolvetype", 2);
	self.jLaser:SetKeyValue("width", 12);
	self.jLaser:SetKeyValue("force", 0);
	self.jLaser:SetKeyValue("LaserTarget", self.jTargetName);
	self.jLaser:SetKeyValue("renderamt", 255);
	local col = self.Entity:GetColor()
	self.jLaser:SetKeyValue("rendercolor", col.r.." "..col.g.." "..col.b);
	self.jLaser:Spawn();
	self.jLaser:Activate();
	self.jLaser:SetParent(self.Entity);
	self.jLaser:Fire("turnoff", "", 0);
	self.Entity:DeleteOnRemove(self.jLaser);
	self.Entity:SetAngles(oldangles)
	self.Sound = CreateSound(self.jLaser, "vehicles/airboat/fan_blade_idle_loop1.wav")
end

function ENT:TargetSearch ()
	self.jLaser:SetAngles(self.Entity:GetAngles());
	if self.asploded then return end
	if WMPause == true then return end
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon then
			if (v.Team ~= self.Team && v.asploded ~= true) then
				local traceRes=util.QuickTrace (self.jLaser:GetPos(), v:GetPos()-self.jLaser:GetPos(), self.jLaser);
				if traceRes.Entity == v then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					self.Target = v
					break;
					end
         		  else
				  self.Target = v
				  break;
				  end
			     end
			end
		end
	end
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
	self.jLaser.Team = self.Team
	local col = self.Entity:GetColor()
	self.jLaser:SetKeyValue("rendercolor", col.r.." "..col.g.." "..col.b);
	--self.Entity:EmitSound("Airboat_fan_fullthrottle", 100, 100);
	self.Sound:PlayEx(1, 200)
	self.jTarget:SetPos(self.Target:GetPos());
	self.jLaser:Fire("turnon", "", 0);
	self.jLaser:Fire("turnoff", "", 1.5);
	timer.Simple(1.5, function() self.Sound:Stop() end);
end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1  && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() then
		self:TargetSearch();
		return
	end
	local traceRes=util.QuickTrace (self.jLaser:GetPos(), self.Target:GetPos()-self.jLaser:GetPos(), self.jLaser);
	--Checking that the target is still in range, and that we still have LOS.
	if traceRes.Entity == self.Target && !self.Target.asploded && self.Target:GetPos():Distance(self.Entity:GetPos())<self.FiringRange then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
	--self.jLaser:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10);
end