include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 2.5;
ENT.Healthlol = 85;
ENT.FiringRange = 1500;
ENT.Speed = 0
ENT.NoMoveRange = 50;
ENT.FollowRange = 75;
ENT.MinRange = 500;
ENT.DeathRadius = 75;
ENT.DeathMagnitude = 10;
ENT.MelonModel = "models/props_trainstation/trashcan_indoor001b.mdl";
ENT.StdMat = "models/props_c17/metalladder002"

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self.Grav = true
	self:Setup();
	self.Entity:SetMaterial("models/props_c17/metalladder002")
	local physics = self.Entity:GetPhysicsObject();
	if (physics:IsValid()) then
	physics:SetMass(1000)
	end
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
	self.Entity:SetColor(Color(125, 125, 125, 255));
	end
end
Sound ("weapons/stinger_fire1.wav");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
		local expl=ents.Create("lap_mortarshell")
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local moving = 1
		if self.Entity:GetVelocity():Length() > 100 then
		moving = 4
		end
		local xr = math.Rand(-90*moving,160*moving);
		local yr = math.Rand(-90*moving,160*moving);
		local zr = math.Rand(-90*moving,160*moving);
		expl:SetPos(self.Entity:GetPos() + Vector(0,0,30) );
		expl:SetOwner(self.Entity);
		expl.Team = self.Team;
		expl:SetAngles(angle:Angle());
		expl.Origin = self.Entity:GetPos()
		expl.TargetPos = self.Target:GetPos() + Vector(xr,yr,zr)
		expl:Spawn();
		expl:Activate();
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos() + Vector(0,0,30) );
		fx:SetAngles(Angle(0,180,0));
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("weapons/mortar/mortar_shell_incomming1.wav", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end

function ENT:TargetSearch ()
	if self.asploded then return end
	if WMPause == true then return end
--	local entz = ents.FindByClass("info_target");
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon then
		if v.Grav ~= nil || v.Grav == true then
		if v.Team ~= self.Team && v.asploded ~= true then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (dist>self.MinRange) then
--			local angle = (v:GetPos() - self.Entity:GetPos());
--			angle.z = GetConVarNumber("WM_test3", 100)
--  local tracedata = {}
--  tracedata.start = self.Entity:GetPos()
--  tracedata.endpos = self.Entity:GetPos()+(angle*150)
--  tracedata.filter = self.Entity
--  local trace = util.TraceLine(tracedata)
--	local entteam = 0
--	if trace.Entity == nil then
--	entteam = 666
--	else
--	entteam = trace.Entity.Team
--	end
--				if entteam ~= self.Team then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					  self.Target = v;
					  break;
					  end
                    else
					self.Target = v;
					break;
					end
--				end
			end
		end
		end
		end
	end
end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() then
		self:TargetSearch();
		return
	end
	if self.Target.Grav ~= nil && self.Target.Grav == false then
		self:TargetSearch();
		return	
	end
--			local angle = (self.Target:GetPos() - self.Entity:GetPos());
--			Msg()
--			angle.z = GetConVarNumber("WM_test3", 100)
 -- local tracedata = {}
 -- tracedata.start = self.Entity:GetPos()
--  tracedata.endpos = self.Entity:GetPos()+(angle*150)
--  tracedata.filter = self.Entity
--  local trace = util.TraceLine(tracedata)

	--Checking that the target is still in range, and that we still have LOS.
	local dist = self.Target:GetPos():Distance(self.Entity:GetPos())
--	local entteam = 0
--	if trace.Entity == nil then
--	entteam = 666
--	else
--	entteam = trace.Entity.Team
--	end
	if self.Target.Team ~= self.Team && !self.Target.asploded && dist < self.FiringRange && dist > self.MinRange then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end
