include( "shared.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self:SetModel(self.model)
	self.Entity:GetPhysicsObject():EnableMotion(false);
end