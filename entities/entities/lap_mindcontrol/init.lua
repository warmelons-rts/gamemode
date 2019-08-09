include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Move = false;
ENT.Delay = 0.5;
ENT.Healthlol = 500;
ENT.FiringRange = 1200;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.DeathRadius = 200;
ENT.DeathMagnitude = 65;
ENT.MovingForce = 200;
ENT.MelonModel = "addons/wmm/models/wmm/mind.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.CurrentTimer = 0
	local oldangles = self.Entity:GetAngles()
	self.Entity:SetAngles(Angle(0,0,0))
	self.StdMat = "addons/wmm/materials/wmm/steel"
	self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/steel"))
	--self.Entity:SetMaterial("phoenix_storms/wire/pcb_red");
	self.jTarget = ents.Create("info_target");
	self.jTarget:SetPos(self.Entity:GetPos());
	self.jTargetName = "johnnylaser" .. self.Entity:EntIndex();
	self.jTarget:SetKeyValue("targetname", self.jTargetName);
	self.jTarget:Spawn();
	self.jTarget:Activate();
	self.Entity:DeleteOnRemove(self.jTarget);
	self.jLaser = ents.Create("env_laser");
	--self.jLaser:SetPos(self.Entity:GetPos()+(self.Entity:GetAngles()-Angle(90, 0, 0)):Forward()*50);
	Msg(self.Entity:OBBMaxs().z / 2 )
	self.jLaser:SetPos(self.Entity:LocalToWorld(self.Entity:OBBCenter() + Vector(0,0,self.Entity:OBBMaxs().z)));
	self.jLaser:SetAngles(self.Entity:GetAngles());
	self.jLaser:SetKeyValue("texture", "trails/tube.vmt");
	self.jLaser:SetKeyValue("texturescroll", 20);
	self.jLaser:SetKeyValue("damage", 0);
	self.jLaser:SetKeyValue("dissolvetype", 1);
	self.jLaser:SetKeyValue("width", 22);
	self.jLaser:SetKeyValue("force", 0);
	self.jLaser:SetKeyValue("LaserTarget", self.jTargetName);
	self.jLaser:SetKeyValue("renderamt", 255);
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
		self.jLaser:SetKeyValue("rendercolor", "255 0 0");
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
end
--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
if self.Target.Maxlol && self.Target.Maxlol <= 100 then
	if self.CurrentTimer <= 0 then
	self.Entity:EmitSound("weapons/stunstick/alyx_stunner2.wav", 0.7, 50)
		self.CurrentTimer = 6.5
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
		self.jLaser:SetKeyValue("rendercolor", "255 0 0");
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
	self.jTarget:SetPos(self.Target:GetPos());
	self.jLaser:Fire("turnon", "", 0);
	self.Sound = CreateSound(self.jLaser, "weapons/physcannon/hold_loop.wav")
	self.Sound:Play()
	self.jLaser:Fire("turnoff", "", 1);
	timer.Simple(1, function() self.Sound:Stop() end);
	if self.Target:IsValid() then
	SetGlobalInt("WM_" .. team.GetName(self.Target.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Target.Team) .. "Melons") - 1)
	self.Target.Team = self.Team;
	SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") + 1)
		if (self.Team == 1) then
		self.Target:SetColor(Color(255, 0, 0, 255));
		end
		if (self.Team == 2) then
		self.Target:SetColor(Color(0, 0, 255, 255));
		end
		if (self.Team == 3) then
		self.Target:SetColor(Color(0, 255, 0, 255));
		end
		if (self.Team == 4) then
		self.Target:SetColor(Color(255, 255, 0, 255));
		end
		if (self.Team == 5) then
		self.Target:SetColor(Color(255, 0, 255, 255));
		end
		if (self.Team == 6) then
		self.Target:SetColor(Color(0, 255, 255, 255));
		end
	end
	self.Target.Target = nil;
	self:TargetSearch();
	end
end
end

function ENT:TargetSearch ()
	--self.jLaser:SetPos(self.Entity:LocalToWorld(self.Entity:OBBCenter() + Vector(0,0,self.Entity:OBBMaxs().z)))
	if self.asploded then return end
	if WMPause == true then return end
	if self.Firing then
	self.sound:Stop()
	self.Firing = false
	end
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon && v.Maxlol && v.Team then
			if (v.Team ~= self.Team && v.asploded ~= true && v.Maxlol <= 100) then
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

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1  && self.HoldFire ~= 1 then
local tarpar = nil
	if self.Target == nil || !self.Target:IsValid() then
		self:TargetSearch();
		return
	else
	tarpar = self.Target
	end
 
	if self.Target.Team == self.Team || tarpar:GetClass() == "lap_spawnpoint" then
		self:TargetSearch();
		return
	end
	local traceRes=util.QuickTrace (self.jLaser:GetPos(), tarpar:GetPos()-self.jLaser:GetPos(), self.jLaser);
	--Checking that the target is still in range, and that we still have LOS.
	if traceRes.Entity == tarpar && tarpar:GetClass() ~= "melon_baseprop" && !tarpar.asploded && tarpar:GetPos():Distance(self.Entity:GetPos())<self.FiringRange then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end

function ENT:OtherThoughts()
if self.CurrentTimer > 0 then
self.CurrentTimer = self.CurrentTimer - self.Delay
end

end