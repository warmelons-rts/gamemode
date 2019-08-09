include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 0.5;
ENT.Healthlol = 85;
ENT.FiringRange = 1400;
ENT.Speed = 0;
ENT.NoMoveRange = 50;
ENT.FollowRange = 75;
ENT.MinRange = 125;
ENT.DeathRadius = 75;
ENT.DeathMagnitude = 10;
ENT.MelonModel = "models/props_phx/misc/flakshell_big.mdl";
ENT.StdMat = "phoenix_storms/cube"

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:SetMaterial("phoenix_storms/cube")
	local physics = self.Entity:GetPhysicsObject();
	if (physics:IsValid()) then
	physics:SetMass(1000)
	end
end
Sound ("weapons/stinger_fire1.wav");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
		local expl=ents.Create("lap_flakshell")
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local xr = math.Rand(0,0.2);
		local yr = math.Rand(0,0.2);
		local zr = math.Rand(0,0.2);
		local final = Vector (angle.x * (xr + 0.9), angle.y * (yr + 0.9), angle.z * (zr + 0.9));
		expl:SetPos(self.Entity:GetPos()+angle:GetNormalized()*10);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team;
		expl:SetAngles(final:Angle());
		expl.Origin = self.Entity:GetPos()
		expl.Fuse = self.Entity:GetPos():Distance(self.Target:GetPos()) + math.random(-100, 50)
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(final:GetNormalized()*10000);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+final:GetNormalized()*10);
		fx:SetAngles(final:Angle());
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("weapons/stinger_fire1.wav", 100, 100);
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
			if v.Grav ~= nil && v.Grav == false then
				if v.Team ~= self.Team && v.asploded ~= true then
					local dist = v:GetPos():Distance(self.Entity:GetPos());
					if (dist > self.MinRange) then
						local traceRes = util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
						if traceRes.Entity == v || traceRes.HitPos:Distance(v:GetPos()) < 300 then
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
end

function ENT:DoAttacks ()
	if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
		if self.Target == nil || !self.Target:IsValid() || !(self.Team ~= self.Target.Team) then
			self:TargetSearch();
			return
		end
		if self.Target.Grav == nil || self.Target.Grav == true then
			if self.Target:GetClass() ~= "melon_baseprop" then
				self:TargetSearch();
				return	
			end
		end
		local tarpos = self.Target:GetPos()
		local selfpos = self.Entity:GetPos()
		local traceRes=util.QuickTrace (selfpos, tarpos-self.Entity:GetPos(), self.Entity);
		--Checking that the target is still in range, and that we still have LOS.
		local dist = tarpos:Distance(selfpos)
		if (traceRes.Entity == self.Target || traceRes.HitPos:Distance(tarpos) < 300) && !self.Target.asploded && dist < self.FiringRange && dist > self.MinRange then
			self:Attack();
		else
			self:TargetSearch();
		end
	end
end
