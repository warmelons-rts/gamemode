include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
-- Setting up all the different properties of our melon.
ENT.Delay = 4;
ENT.Healthlol = 50;
ENT.FiringRange = 500;
ENT.NoMoveRange = 50;
ENT.MinRange = 500;
ENT.Speed = 80 * server_settings.Int( "WM_Melonspeed", 1)
ENT.DeathRadius = 30;
ENT.DeathMagnitude = 3;
ENT.MovingForce = 35 * server_settings.Int( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	if (self.Team == 1) then
	self.Entity:SetColor (125, 0, 0, 255)
	end
	if (self.Team == 2) then
	self.Entity:SetColor (0, 0, 125, 255)
	end
	if (self.Team == 3) then
	self.Entity:SetColor (0, 125, 0, 255)
	end
	if (self.Team == 4) then
	self.Entity:SetColor (125, 125, 0, 255)
	end
	if (self.Team == 5) then
	self.Entity:SetColor (125, 0, 125, 255)
	end
	if (self.Team == 6) then
	self.Entity:SetColor (0, 125, 125, 255)
	end
	if (self.Team == 7) then
	self.Entity:SetColor (125, 125, 125, 255);
	end
if !self.Grav then 
local r,g,b,a = self.Entity:GetColor(); 
self.MovingForce = (self.MovingForce * server_settings.Int( "WM_flyingspeed", 0.14))
util.SpriteTrail(self.Entity, 0, Color(r, g, b), false, 10, 0, 2, 1/10*0.5, "trails/smoke.vmt")
end
Sound ("Weapon_P90.Single");
end
--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
Msg(self.Entity:GetVelocity():Length())
		local expl=ents.Create("lap_strikerbomb")
		local angle = self.Entity:GetVelocity():GetNormal()*360
		local xr = math.Rand(0,0.075);
		local yr = math.Rand(0,0.075);
		local zr = math.Rand(0,0.075);
		local final = Vector(angle.x * (xr + 0.9), angle.y * (yr + 0.9), angle.z * (zr + 0.95));
		local FFCheck = util.QuickTrace (self.Entity:GetPos(), final * 1000, self.Entity);
			if FFCheck.Entity ~= nil && FFCheck.Entity:GetClass() == "lap_striker" then
			return
			end
		expl:SetPos(self.Entity:GetPos()+angle:Normalize()*10);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team;
		expl:SetAngles(final:Angle());
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(final:Normalize()*(self.Entity:GetVelocity():Length()) * 10);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+final:Normalize()*10);
		fx:SetAngle(final:Angle());
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_RPG.Single", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end


function ENT:DoAttacks ()
if server_settings.Int( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
self.Target = nil
self.FiringRange = 400 + (self.Entity:GetVelocity():Length() * 5.5)
	if self.asploded then return end
	if WMPause == true then return end
--	local entz = ents.FindByClass("info_target");
--self.Entity.base:SetPos(self.Entity:GetPos() + self.Entity:GetVelocity():GetNormal()*1000)
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos() + self.Entity:GetVelocity():GetNormal()*(self.FiringRange * 0.75), self.FiringRange / 3.5)) do
	if v:GetClass() == "info_target" then
		if v.Warmelon then
		if v:GetParent().Grav then
		local dist = v:GetPos():Distance(self.Entity:GetPos());
			if (dist>self.MinRange && dist < self.FiringRange && v.Team ~= self.Team && v:GetParent().asploded ~= true) then
				local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
				if traceRes.Entity == v:GetParent() then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					  self.Target = v:GetParent();
					  self:Attack()
					  break;
					end
                    else
					self.Target = v:GetParent();
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