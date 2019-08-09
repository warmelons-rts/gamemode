include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	timer.Simple(14, function() timer.Create("canspawntimer", 2, 6, function() CanMelonSpawn(self.Team, self.Entity:GetPos()) end) end)
	timer.Simple(30, function() self:Remove() end)
end
