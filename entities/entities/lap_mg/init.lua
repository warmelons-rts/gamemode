include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS("base_warmelon")

-- Setting up all the different properties of our melon.
ENT.Delay = 0.5;
ENT.Healthlol = 50;
ENT.FiringRange = 1200;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.Speed = 60 * GetConVarNumber("WM_Melonspeed", 1)
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 5;
ENT.MovingForce = 115 * GetConVarNumber("WM_Melonforce", 12);
ENT.MelonModel = "models/Roller.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()

	self:Setup();
        
    if (self.Team == 1) then
        self.Entity:SetColor(Color(125, 0, 0, 255))
	elseif (self.Team == 2) then
        self.Entity:SetColor(Color(0, 0, 125, 255))
	elseif (self.Team == 3) then
        self.Entity:SetColor(Color(0, 125, 0, 255))
	elseif (self.Team == 4) then
        self.Entity:SetColor(Color(125, 125, 0, 255))
	elseif (self.Team == 5) then
        self.Entity:SetColor(Color(125, 0, 125, 255))
	elseif (self.Team == 6) then
        self.Entity:SetColor(Color(0, 125, 125, 255))
	elseif (self.Team == 7) then
        self.Entity:SetColor(Color(100, 100, 100, 255));
	end
	
	local r=self.Entity:BoundingRadius()/2;
    self:PhysicsInitSphere(r);
    self:SetCollisionBounds(Vector(-r,-r,-r),Vector(r,r,r));
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	local physics = self:GetPhysicsObject();
    if (physics:IsValid()) then
        physics:Wake();
    end
    
    if !self.Grav then 
        self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
    end
    Sound ("npc/strider/strider_minigun.wav");
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
local moving = 1
	for i= 1, 2 do
		if self.Entity:GetVelocity():Length() > 100 then
		moving = 2
		end
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local bullet = {};
		bullet.Num = 1;
		bullet.Src = self.Entity:GetPos();
		bullet.Dir = angle:GetNormalized();
		bullet.Spread = Vector (0.08*moving, 0.08*moving, 0.08*moving);
		bullet.Tracer = 1;
		bullet.Force = 0;
		bullet.Damage = 2;
		bullet.TracerName = "AirboatGunTracer";
		self.Entity:FireBullets (bullet);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetAngles(angle:Angle());
		fx:SetScale(1.5);
		util.Effect("stridcan_fire",fx)
		util.Effect("stridcan_mzzlflash",fx)
		self.Entity:EmitSound("npc/strider/strider_minigun.wav", 100, 100);
	end
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
end
