include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Move = false;
ENT.Delay = 0.1;
ENT.Healthlol = 500;
ENT.FiringRange = 1200;
ENT.NoMoveRange = 50;
ENT.Speed = 0
ENT.MinRange = 0;
ENT.DeathRadius = 200;
ENT.DeathMagnitude = 65;
ENT.MovingForce = 200;
ENT.MelonModel = "addons/wmm/models/wmm/microwave.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self.StdMat = "addons/wmm/materials/wmm/black";
	self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/black"));
	self:Setup();
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
--	Msg(self.Entity:GetAngles())
--	Msg("/n")
--	Msg("\n")
--	Msg(Angle(90, 0, 0):Forward()*26)GetForward():GetNormalized():Angle()*26)
	self.jLaser:SetPos(self.Entity:LocalToWorld(self.Entity:OBBCenter() + Vector(0,0,self.Entity:OBBMaxs().z + 40)));
	self.jLaser:SetAngles(self.Entity:GetAngles());
	self.jLaser:SetKeyValue("texture", "trails/electric.vmt");
	self.jLaser:SetKeyValue("texturescroll", 20);
	self.jLaser:SetKeyValue("damage", 0);
	self.jLaser:SetKeyValue("dissolvetype", 1);
	self.jLaser:SetKeyValue("width", 22);
	self.jLaser:SetKeyValue("force", 0);
	self.jLaser:SetKeyValue("LaserTarget", self.jTargetName);
	self.jLaser:SetKeyValue("renderamt", 255);
	self.jLaser.Team = self.Team
		if (self.Team == 1) then
		self.jLaser:SetKeyValue("rendercolor", "255 0 0");
		end
		if (self.Team == 2) then
		self.jLaser:SetKeyValue("rendercolor", "0 0 255");
		end
		if (self.Team == 3) then
		self.jLaser:SetKeyValue("rendercolor", "0 255 0");
		end
		if (self.Team == 4) then
		self.jLaser:SetKeyValue("rendercolor", "255 255 0");
		end
		if (self.Team == 5) then
		self.jLaser:SetKeyValue("rendercolor", "255 0 255");
		end
		if (self.Team == 6) then
		self.jLaser:SetKeyValue("rendercolor", "0 255 255");
		end	
		if (self.Team == 7) then
		self.jLaser:SetKeyValue("rendercolor", "50 50 50");
		end
	self.jLaser:Spawn();
	self.jLaser:Activate();
	self.jLaser:SetParent(self.Entity);
	self.jLaser:Fire("turnoff", "", 0);
	self.Entity:DeleteOnRemove(self.jLaser);
	self.Entity:SetAngles(oldangles)
--self.Sound = CreateSound(self.jLaser, "ambient/levels/citadel/zapper_loop2.wav")
end

function ENT:TargetSearch ()
	if self.asploded then return end
	if WMPause == true then return end
	--self.Entity:StopSound("ambient/levels/citadel/zapper_loop2.wav")
	if self.Firing then
		self.sound:Stop()
		self.Firing = false
	end
	
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)
	for k, v in pairs(entz) do
		if v.Warmelon then
			if (v.Team ~= self.Team && v.asploded ~= true) then
				local traceRes=util.QuickTrace (self.jLaser:GetPos(), v:GetPos()-self.jLaser:GetPos(), self.jLaser);
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

function jStopLaserSound(ent)
	ent:StopSound("Airboat_fan_fullthrottle");
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
	--self.Entity:EmitSound("ambient/levels/citadel/zapper_loop2.wav", 100, 200)
	if !self.Firing then
	self.sound = CreateSound(self.jTarget, "ambient/levels/citadel/zapper_loop2.wav")
	self.sound:Play()
	self.Firing = true
	end
	--self.Entity:EmitSound()
	
	self.Target:TakeDamage(2, self.Entity);
	self.jLaser:Fire("turnon", "", 0);
end

function ENT:DoAttacks ()
	if GetConVarNumber( "WM_Pause", 0 ) ~= 1  && self.HoldFire ~= 1 then
		if self.Target == nil || !self.Target:IsValid() || self.Target.Team == self.Team then
			--self.Sound:Stop()
			self:TargetSearch();
			self.jLaser:Fire("turnoff", "", 0.1);
			return
		end
		local traceRes=util.QuickTrace (self.jLaser:GetPos(), self.Target:GetPos()-self.jLaser:GetPos(), self.jLaser);
		--Checking that the target is still in range, and that we still have LOS.
		if traceRes.Entity == self.Target && !self.Target.asploded && self.Target:GetPos():Distance(self.Entity:GetPos())<self.FiringRange then
			self.jTarget:SetPos(self.Target:GetPos());
			self:Attack();
		else
			--self.Sound:Stop()
			self:TargetSearch();
			self.jLaser:Fire("turnoff", "", 0.1);
		end
	end
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
	--self.jLaser:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10);
end