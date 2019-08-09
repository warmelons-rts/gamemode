include("shared.lua");
local icu = 0

function ENT:Draw ()
	if self.Entity:GetOwner() == LocalPlayer() then
		self.Entity:DrawModel();	
	end
end
