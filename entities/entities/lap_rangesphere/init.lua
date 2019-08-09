include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "init.lua" )

function ENT:Initialize()
	self.Entity:SetModel("models/hunter/misc/shell2x2.mdl")
	self.Entity:SetColor(Color(255,255,255, 90))
	self.Entity:DrawShadow( false )
	self.Pos = self.Entity:GetPos()
	self.Entity:SetOwner(self.pl)
end

function ENT:Think()
    self.Entity:SetPos((self.Pos+self.pl:GetEyeTrace().HitPos)/2)
	--self.Entity:SetAngles(Angle(0,self.pl:EyeAngles().yaw,0)
end