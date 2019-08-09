include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 2.3;
ENT.Healthlol = 50;
ENT.FiringRange = 500;
ENT.NoMoveRange = 50;
ENT.MinRange = 500;
ENT.Speed = 80 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathRadius = 30;
ENT.DeathMagnitude = 3;
ENT.MovingForce = 35 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/Gibs/scanner_gib05.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self.StdMat = ""
	self:Setup();
--	self.Entity.base = ents.Create("prop_physics")
--	self.Entity.base:SetPos(self.Entity:GetPos())
--	self.Entity.base:PhysicsInit(SOLID_NONE);
--	self.Entity.base:SetMoveType(MOVETYPE_NONE);
--	self.Entity.base:SetSolid(SOLID_VPHYSICS);
--	self.Entity.base:SetModel("models/props_trainstation/trashcan_indoor001a.mdl")
--	self.Entity.base:Spawn()
--	self.Entity.base:Activate()
	if (self.Team == 1) then
	self.Entity:SetColor(Color(125, 0, 0, 255))
	end
	if (self.Team == 2) then
	self.Entity:SetColor(Color(0, 0, 125, 255))
	end
	if (self.Team == 3) then
	self.Entity:SetColor(Color(0, 125, 0, 255))
	end
	if (self.Team == 4) then
	self.Entity:SetColor(Color(125, 125, 0, 255))
	end
	if (self.Team == 5) then
	self.Entity:SetColor(Color(125, 0, 125, 255))
	end
	if (self.Team == 6) then
	self.Entity:SetColor(Color(0, 125, 125, 255))
	end
	if (self.Team == 7) then
	self.Entity:SetColor(Color(35, 35, 35, 255));
	end
if !self.Grav then
self.BuildModifier = 0.2
local col = self.Entity:GetColor(); 
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_flyingspeed", 0.14))
util.SpriteTrail(self.Entity, 0, Color(col.r, col.g, col.b), false, 20, 0, 2, 1/10*0.5, "trails/smoke.vmt")
end
Sound ("Weapon_P90.Single");
end
--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
		local expl=ents.Create("lap_strikerbomb")
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local xr = math.Rand(0,0.075);
		local yr = math.Rand(0,0.075);
		local zr = math.Rand(0,0.075);
		local final = Vector(angle.x * (xr + 0.9), angle.y * (yr + 0.9), angle.z * (zr + 0.95));
		local FFCheck = util.QuickTrace (self.Entity:GetPos(), final * 1000, self.Entity);
			if FFCheck.Entity ~= nil && FFCheck.Entity:GetClass() == "lap_striker" then
			return
			end
		expl:SetPos(self.Entity:GetPos()+angle:GetNormalized()*10);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team;
		expl:SetAngles(final:Angle());
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(final:GetNormalized()*(self.Entity:GetVelocity():Length()) * 10);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+final:GetNormalized()*10);
		fx:SetAngles(final:Angle());
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_RPG.Single", 100, 100);
end

function ENT:DoMoves ()

local leaderrange = -5;
if self.FollowRange == nil then
self.FollowRange = 50;
end

	if (self.Leader && self.Leader:IsValid()) then
	leaderrange = self.Entity:GetPos():Distance(self.Leader:GetPos())
	  if (leaderrange > tonumber(self.FollowRange) && self.TargetVec[2] == nil) then
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
  if self.Target == nil then
  self.Target = self.Entity
  end
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
		if self.Entity:GetPos():Distance(self.TargetVec[1])>self.NoMoveRange && self.Orders then
			--self.Entity:GetPhysicsObject():SetDamping(2, 0);
			--local blah = math.abs(angle1.x - angle1.y)
			--if ((self.Entity:GetVelocity():Length() < self.Speed || self.Grav == false )&& (blah >= 20 || angle1.z < self.Entity:GetPos().z || (self.Marine && self:WaterLevel() > 2))) then
			--	self.Entity:GetPhysicsObject():ApplyForceCenter (angle1:GetNormalized() * self.MovingForce);
			--end
		else
			if self.Patrol == true then
				table.insert(self.TargetVec, table.remove(self.TargetVec, 1))
			else
				table.remove(self.TargetVec, 1)
			end
			if self.Leader == nil || leaderrange < self.FollowRange then
				if self.TargetVec[1] == nil then
					if self.Grav == false then
						self.Entity:SetVelocity(self.Entity:GetVelocity() * 0.05)
					end
					if self.Entity:GetPhysicsObject():IsValid() then
						self.Entity:GetPhysicsObject():SetDamping(self.Entity:GetPhysicsObject():GetDamping(), self.Entity:GetPhysicsObject():GetDamping());-- Replaced self.GetDamping with self.Entity:GetPhysicsObject():GetDamping()
					end
					self.Orders = false;
				end
			end
		end
	end
end
--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
--Msg(self.Entity:GetVelocity())
--Msg("\n")
--Msg(self.Entity:GetAngles())
--self.Entity:SetVelocity(vel)
end

	function ENT:PhysicsUpdate(phys, deltatime)
		local phys = self.Entity:GetPhysicsObject()
		local posi = self.Entity:GetPos()
		local pos2
		if self.TargetVec[1] ~= nil then
		pos2 = self.TargetVec[1]
		else
		pos2 = posi
		end
		
		
					local t={
					secondstoarrive = 0.1,
					pos = self.TargetVec[1],
					--maxangular = GetConVarNumber("WM_Test1",10),
					--maxangulardamp = GetConVarNumber("WM_Test2",5),
					--maxspeed = GetConVarNumber("WM_Test3",10),
					--maxspeeddamp = GetConVarNumber("WM_Test4",15),
					--dampfactor = GetConVarNumber("WM_Test5",0.1),
					maxangular = 5,
					maxangulardamp = 7.5,
					maxspeed = 3,
					maxspeeddamp = 1,
					dampfactor = 1,
					teleportdistance = 0,
					angle = self.Entity:GetVelocity():Angle(),
					deltatime = deltatime
				}
				phys:ComputeShadowControl(t)
	end
	


function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
self.Target = nil
self.FiringRange = 400 + (self.Entity:GetVelocity():Length() * 5.5)
local tracedata = {}
tracedata.start = self.Entity:GetPos()
tracedata.endpos = self.Entity:GetPos() + (self.Entity:GetVelocity():GetNormalized() * (self.FiringRange))
tracedata.filter = self.Entity
local trace = util.TraceLine(tracedata) 
--self.Entity.base:SetPos(trace.HitPos)
	if self.asploded then return end
	if WMPause == true then return end
--	local entz = ents.FindByClass("info_target");
--self.Entity.base:SetPos(self.Entity:GetPos() + self.Entity:GetVelocity():GetNormal()*1000)
if trace.Hit then
	for k, v in pairs(ents.FindInSphere(trace.HitPos, self.FiringRange / 3.5)) do
		if v.Warmelon then
		if v.Grav ~= false then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (dist>self.MinRange && dist < self.FiringRange && v.Team ~= self.Team && v.asploded ~= true) then
				local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
				if traceRes.Entity == v then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					  self.Target = v;
					  self:Attack()
					  break;
					end
                    else
					self.Target = v;
					self:Attack()
					break;
					end
				end
			end
		end
	end
	end
end
end
end