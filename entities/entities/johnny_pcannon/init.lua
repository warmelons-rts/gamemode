include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 3;
ENT.Healthlol = 100;
ENT.FiringRange = 1000;
ENT.NoMoveRange = 25;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 10;
ENT.MovingForce = 0
--ENT.MovingForce = 360  * GetConVarNumber( "WM_Melonforce", 7);
ENT.MelonModel = "models/Combine_Helicopter/helicopter_bomb01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
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
if !self.Grav then 
self.MovingForce = 40
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
end
end
Sound ("NPC_Strider.FireMinigun");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
local moving = 1
		if self.Entity:GetVelocity():Length() > 100 then
		moving = 1.5
		end
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local xr = math.Rand(0,1*moving);
		local yr = math.Rand(0,1*moving);
		local zr = math.Rand(0,1*moving);
		local final = Vector (angle.x * (xr + 0.5), angle.y * (yr + 0.5), angle.z * (zr + 0.5));
		local expl=ents.Create("johnny_pcannonshell")
		expl:SetPos(self.Entity:GetPos()+final:GetNormalized()*100);
		expl:SetOwner(self.Entity);
		expl:SetAngles(final:Angle());
		expl.Team = self.Team
		expl:Spawn();
		expl:GetPhysicsObject():SetVelocity(final:GetNormalized()*300);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+angle:GetNormalized()*10);
		fx:SetAngles(final:Angle());
		fx:SetEntity(self.Entity);
		fx:SetScale(2.5);
		util.Effect("StriderMuzzleFlash", fx);
		self.Entity:EmitSound("NPC_Hunter.FlechetteShoot", 100, 100);

end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() then
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

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end

function ENT:TargetSearch ()
	if self.asploded then return end
	if WMPause == true then return end
--	local entz = ents.FindByClass("info_target");
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
