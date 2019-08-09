include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 500;
ENT.FiringRange = 1000;
ENT.Speed = 0
ENT.NoMoveRange = 50;
ENT.MinRange = 256;
ENT.DeathRadius = 200;
ENT.DeathMagnitude = 65;
ENT.MovingForce = 150;
ENT.MelonModel = "models/Combine_Helicopter/helicopter_bomb01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:SetMaterial("phoenix_storms/wire/pcb_red");
	self.CurrentTimer = 0
end
Sound ("Weapon_RPG.Single");

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
		if self.CurrentTimer <= 0 then
		self.CurrentTimer = 4
		local expl=ents.Create("lap_chaosrocket")
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local xr = math.Rand(0,0.2);
		local yr = math.Rand(0,0.2);
		local zr = math.Rand(0,0.2);
		local final = Vector (angle.x * (xr + 0.9), angle.y * (yr + 0.9), angle.z * (zr + 0.9));
		expl:SetPos(self.Entity:GetPos()+angle:GetNormalized()*10);
		expl:SetOwner(self.Entity);
		expl:SetAngles(final:Angle());
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(final:GetNormalized()*10000);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos()+final:GetNormalized()*10);
		fx:SetAngles(final:Angle());
		fx:SetScale(2.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("weapons/physcannon/superphys_launch3.wav", 100, math.Rand(100, 150));
		end
end

function ENT:OtherThoughts()
if self.CurrentTimer > 0 then
self.CurrentTimer = self.CurrentTimer - self.Delay
end

end