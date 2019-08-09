include("shared.lua");
local icu = 0

function ENT:Draw ()
	if self.Entity:GetOwner() == LocalPlayer() then
		local ply = LocalPlayer()
		local Vec = Vector(0,0,0)
		Vec = (self.Range/49)
		self.Entity:DrawModel();
		self.Entity:SetModelScale(Vector(Vec,Vec,Vec))
	end
end
