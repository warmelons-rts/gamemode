include("shared.lua");

local icu = 0

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
function ENT:Draw ()
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	if self.Entity:GetOwner() == LocalPlayer() then
		local ply = LocalPlayer()
		local Vec = Vector(0,0,0)
		Vec = (ply:GetEyeTrace().HitPos:Distance(self.Entity:GetPos())/49)
		self.Entity:DrawModel();
		self.Entity:SetModelScale(Vector(Vec,Vec,Vec))
	end
end