include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1.3;
ENT.Healthlol = 50;
ENT.FiringRange = 300;
ENT.NoMoveRange = 50;
ENT.Speed = 100 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.MinRange = 0;
ENT.DeathRadius = 20;
ENT.DeathMagnitude = 2;
ENT.MovingForce = 25 * GetConVarNumber( "WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";
ENT.BuildModifier = 0.5
-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	if self.Phasing then
	self.StdMat = "phoenix_storms/dome"
	end
	self:Setup();
	if self.Phasing then
	self.BuildModifier = 0.1
	self.Collided = {}
	self.Grav = true
		function self:PhysicsCollide(data, physobject)
			if data.HitEntity.Team ~= self.Team && data.HitEntity:GetClass() == "melon_baseprop" && !table.HasValue(self.Collided, data.HitEntity) then
			table.insert(self.Collided, data.HitEntity)
			timer.Simple(1.5, function() self:Phase(data.HitEntity) end)

			end
		end
	end
	if !self.Grav then
	self.Healthlol = 30
	self.Maxlol = 30
	self.BuildModifier = 0.075
	local col = self.Entity:GetColor(); 
	util.SpriteTrail(self.Entity, 0, Color(col.r, col.g, col.b), false, 10, 0, 2, 1/10*0.5, "trails/laser.vmt")
	self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.25)) * 1.25
	self.NoMoveRange = 100
	end
Sound ("Weapon_SMG1.Single");
end
--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
	local angle = self.Target:GetPos() - self.Entity:GetPos();
	self.Target:TakeDamage(3, self.Entity);
	local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetStart(self.Target:GetPos());
		//The color of the laser is stored in the Normal field
		if (self.Team == 1) then
			fx:SetAngles(Angle(255,0,0));
		elseif (self.Team == 2) then
			fx:SetAngles(Angle(0,0,255));
		elseif (self.Team == 3) then
			fx:SetAngles(Angle(0,255,0));
		elseif (self.Team == 4) then
			fx:SetAngles(Angle(255,255,0));
		elseif (self.Team == 5) then
			fx:SetAngles(Angle(255,0,255));
		elseif (self.Team == 6) then
			fx:SetAngles(Angle(0,255,255));
		else
			fx:SetAngles(Angle(50,50,50));
		end
	util.Effect("feha_colorlaser", fx);
	
	--[[
		if (self.Team == 1) then
			util.Effect("johnny_redlaser", fx);
		
		elseif (self.Team == 2) then
			util.Effect("johnny_bluelaser", fx);
		
		elseif (self.Team == 3) then
			util.Effect("johnny_greenlaser", fx);
		elseif (self.Team == 4) then
			util.Effect("johnny_yellowlaser", fx);
		elseif (self.Team == 5) then
			util.Effect("johnny_magentalaser", fx);
		elseif (self.Team == 6) then
			util.Effect("johnny_cyanlaser", fx);
		else
			util.Effect("johnny_blacklaser", fx);
	end
	--]]
	
	local fxx = EffectData();
		fxx:SetOrigin(self.Entity:GetPos());
		fxx:SetAngles(angle:Angle());
		fxx:SetScale(1.2);
	util.Effect("MuzzleEffect", fxx);
	self.Entity:EmitSound("Weapon_Mortar.Single", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end

function ENT:Phase(ent)
if !ent:IsValid() then return end
local phase = constraint.NoCollide(self.Entity, ent, 0, 0)
local phys = ent:GetPhysicsObject()
self.Sound = CreateSound(self.Entity, "ambient/levels/citadel/zapper_warmup4.wav")
self.Sound:Play()
self.Sound:FadeOut(1.25)
self.Entity:SetMaterial("models/alyx/emptool_glow")
if phys:IsValid() then
phys:EnableMotion(false)
phys:EnableMotion(true)
phys:Wake()
end
timer.Simple(2.5, function(phase, ent) if self.UnPhase then self:UnPhase(phase, ent) end end, phase, ent)
end

function ENT:UnPhase(cons, ent)
self.Entity:SetMaterial("phoenix_storms/dome")
self.Sound:Stop()
    for k,v in pairs(self.Collided) do
        if v == ent then
        table.remove(self.Collided, k)
        end
    end
if cons:IsValid() then 
cons:Input( "EnableCollisions", nil, nil, nil ) 
cons:Remove()
end
end