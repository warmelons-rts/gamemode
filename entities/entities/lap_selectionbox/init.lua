include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/hunter/misc/shell2x2a.mdl")
	self:SetColor(Color(255,255,255, 90))
	self:DrawShadow( false )
	self.Pos = self.Entity:GetPos()
	self:SetOwner(self.pl)
end

function ENT:Think()
    self:SetPos((self.Pos+self.pl:GetEyeTrace().HitPos)/2)
	--self.Entity:SetAngles(Angle(0,self.pl:EyeAngles().yaw,0)
end