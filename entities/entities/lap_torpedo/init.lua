include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize ()
self.trrtmyr = false;
	self.Entity:SetModel("models/props_junk/propane_tank001a.mdl");
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self.Fuse = CurTime() + 10
	self.Warmelon = true
	local physics = self.Entity:GetPhysicsObject();
	self.Mode = true
	if (physics:IsValid()) then
		physics:Wake();
		physics:EnableGravity(true);
		timer.Simple(0, function(phys,ent) phys:SetBuoyancyRatio(0.238) end, physics, self)
	end
	self.Entity:SetColor(Color(50, 50, 50, 255));
	util.SpriteTrail(self.Entity, 0, Color(0, 0, 0), false, 5, 0, 1, 1/5*0.5, "effects/bubble.vmt");
	self.Entity:Fire("break", "", 3);
	self.Sound = CreateSound(self.Entity, "ambient/gas/steam2.wav")
	self.Sound:PlayEx(80, 200)
	self.Dist = 10000
end

function ENT:Think()
local phys = self.Entity:GetPhysicsObject()
    if phys:IsValid() && self.Entity:WaterLevel() > 0 then
        if self.Mode == true then
        local tempdist = self.Entity:GetPos():Distance(self.TargetPos)
            if tempdist > self.Dist then
            self.Mode = false
            else
            local angle1 = self.TargetPos - self.Entity:GetPos();
            phys:ApplyForceCenter(angle1:GetNormalized() * 400)
            self.Dist = tempdist
            end
        else 
        local angle2 = self.Entity:GetPos() - self.TargetPos
        Msg(angle2)
        phys:ApplyForceCenter(angle2:GetNormalized() * 400)
        end
    end
    
if self.Fuse < CurTime() then
self:Break()
end
end

function ENT:Break ()
--self.Entity:StopSound("ambient/gas/steam2.wav")
	if (!self.trrtmyr) then
		self.trrtmyr = true;
		local expl=ents.Create("point_hurt")
		expl.Team = self.Team
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("Damage","60");
		expl:SetKeyValue("DamageRadius", "256");
		expl:SetKeyValue("DamageType", "0");
		expl:Spawn();
		expl:Activate();
		expl:Fire("Hurt", "", 0);
		expl:Fire("kill","",0);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetStart(self.Entity:GetPos());
		fx:SetScale(1);
		util.Effect("Explosion", fx);
		self.Entity:Fire ("kill", "", 0);
	end
end

function ENT:PhysicsCollide (tjrjdrjtrhtrd, rupihbrhbrseojirsejiuo)
	self:Break();
end

function ENT:OnRemove()
self.Sound:Stop()
end