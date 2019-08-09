include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 0.1;
ENT.Move = true;
ENT.Speed = 200
ENT.Healthlol = 100;
ENT.FiringRange = 700;
ENT.DeathRadius = 100;
ENT.DeathMagnitude = 50;
-- That's right kiddies, we're not setting MovingForce here, because that SHOULD have been set in the STOOL.
ENT.NoMoveRange = 50;
ENT.MelonModel = "models/props_phx/misc/soccerball.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:GetPhysicsObject():SetMass(100);
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
	if self.ZOnly == nil then
	self.ZOnly = false
	end
		if not (WireAddon == nil) then
		self.go = 0
		self.x = 0
		self.y = 0
		self.z = 0
		self.WireDebugName = self.PrintName
		self.Inputs = Wire_CreateInputs(self.Entity, { "X", "Y", "Z", "ZOnly", "Go" })
		self.Outputs = Wire_CreateOutputs(self.Entity, {"X", "Y", "Z", "ZOnly"})
		self.WireDebugName = "Order Core Melon"
	end
end
function ENT:TriggerInput(iname, value)

	if (iname == "X") then
	self.x = value
	  Wire_TriggerOutput(self.Entity, "X", value)
	end
	if (iname == "Y") then
	self.y = value
	  Wire_TriggerOutput(self.Entity, "Y", value)
	end
	if (iname == "Z") then
	self.z = value
	  Wire_TriggerOutput(self.Entity, "Z", value)
	end
	if (iname == "ZOnly") then
	self.ZOnly = value
	  Wire_TriggerOutput(self.Entity, "ZOnly", value)
	end
	if (iname == "Go") then
	self.go = value
	end

end

function ENT:DoAttacks ()
end
function ENT:DoMoves ()
local leaderrange = -5;
if self.FollowRange == nil then
self.FollowRange = 50;
end

	if (self.Leader && self.Leader:IsValid()) then
	leaderrange = self.Entity:GetPos():Distance(self.Leader:GetPos())
	  if (leaderrange > self.FollowRange && self.TargetVec[2] == nil) then
    self.TargetVec[1] = self.Leader:GetPos();
		self.Orders = true;
	  end
  else
  leaderrange = 100000
  end
  
if self.Stance ~= 0 then
  if self.Stance > 0 && self.Target ~=nil && self.Target:IsValid() && self.Target:GetPos():Distance(self.Entity:GetPos()) < 1500 then
  	local traceRes=util.QuickTrace (self.Entity:GetPos(), self.Target:GetPos()-self.Entity:GetPos(), self.Entity);
  	if traceRes.Entity == self.Target && !self.Target.asploded then
      if self.Stance == 1 or self.Stance == 2 then
      self:Chase();
      end
    self.Stance = self.Stance * -1
    end
  end
  if self.Stance < 0 && self.Stance > -4 then
  self.Leader = self.Target
  self.Orders = true
  self.TargetVec = {}
  if self.Target:IsValid() then
  self.TargetVec[1] = self.Target:GetPos()
  end
    if self.Stance == -1 then
      if self.Entity:GetPos():Distance(self.StartChase) > 1500 || !self.Target:IsValid() then
      self:GoHome()
      end
    end
    if self.Stance == -2 then
      if self.Entity:GetPos():Distance(self.Target) > 1500 || !self.Target:IsValid() then
      self:GoHome()
      end
    end
  end
  if self.Stance < -4 && self.StartChase ~= nil && self.Entity:GetPos():Distance(self.StartChase) < 50 then
  self.Stance = self.Stance * -0.2
  self.Leader = self.Leader2
  self.Leader2 = nil
  self.Patrol = self.Patrol2
  self.Patrol2 = nil
  end
end



  if self.TargetVec ~= nil && self.TargetVec[1] ~= nil then
	local angle1 = self.TargetVec[1] - self.Entity:GetPos();
	if self.ZOnly then angle1.z = 0 end
	if self.Entity:GetPos():Distance(self.TargetVec[1])>self.NoMoveRange && self.Orders then
			self.Entity:GetPhysicsObject():SetDamping(2, 0);
			if self.Entity:GetVelocity():Length() < self.Speed || self.Grav == false then
			self.Entity:GetPhysicsObject():ApplyForceCenter (angle1:GetNormalized() * self.MovingForce);
			end
	else
	
		if self.Move then
			if self.Patrol == 1 then
			table.insert(self.TargetVec, table.remove(self.TargetVec, 1))
			else
			table.remove(self.TargetVec, 1)
			end
		
			   if self.Leader == nil || leaderrange < self.FollowRange then
			    if self.TargetVec[1] == nil then
	           if self.Grav == 0 then
	           self.Entity:SetVelocity(self.Entity:GetVelocity() * 0.05)
	           end
			   	   if self.Entity:GetPhysicsObject():IsValid() then
			       self.Entity:GetPhysicsObject():SetDamping(self:GetDamping(), self:GetDamping());
			       end
			    self.Orders = false;
			    end
			   end
			end
		end
	end
end
function ENT:OtherThoughts()
if not (WireAddon == nil) then
if self.go > 0 then
self.Orders = true
self.TargetVec[1] = Vector(self.x, self.y, self.z)
end
if self.TargetVec[1] ~= nil then 
Wire_TriggerOutput(self.Entity, "X", self.TargetVec[1].x)
Wire_TriggerOutput(self.Entity, "Y", self.TargetVec[1].y)
Wire_TriggerOutput(self.Entity, "Z", self.TargetVec[1].z)
end
end
	self.Entity:NextThink(CurTime() + 1)
	return true
end