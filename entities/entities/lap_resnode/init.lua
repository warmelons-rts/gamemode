AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Entity:SetModel("models/hunter/tubes/circle2x2.mdl")
	self.Entity:SetColor(Color(0,0,0,1))
	self.Entity.base = ents.Create("base_gmodentity")
	self.Entity.base:SetPos(self.Entity:GetPos() - Vector(0,0, 0))
self.Entity.base:SetModel("models/props_combine/breentp_rings.mdl")
    self.Entity.base.Team = 0
    self.Entity.base:Spawn()
    self.Entity.base:Activate()
    self:SetOverlayText( "Resource Node\nNRG left: " .. self.Rez)

end

function ENT:Think()
if self.Rez ~= -6999 then
self:SetOverlayText( "Resource Node\nNRG left: " .. self.Rez)
else
self:SetOverlayText( "Resource Node\nNRG left: Infinite")
end
if self.Rez <= 0 && self.Rez ~= -6999 then
self.Entity:Remove()
else

local entz = ents.FindInSphere(self.Entity:GetPos(),30)
  if WMPause == true then return end
	for k, v in pairs(entz) do
		if v:GetClass() == "lap_harvester"  && v.Full == 0 then 
    v.Full = 1
            if v.Stance == 3 then
            v.TargetVec = {}
            end
    if self.Rez ~= -6999 then
    self.Rez = self.Rez - GetConVarNumber( "WM_RezPerHarvest", 2500)
    end
	  break;
		end
	end
end
	self.Entity:NextThink(CurTime()+5);
	return true
end

function ENT:OnRemove()
self.Entity.base:Remove()
end