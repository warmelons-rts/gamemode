include("shared.lua")

function ENT:Draw()
	self:DoNormalDraw()

end

function ENT:DoNormalDraw()
	local e = self.Entity;
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 10000) then

		self:DrawEntityOutline(1.0)
		self.Entity:DrawModel()
		if(self:GetOverlayText() ~= "") then
			AddWorldTip(e:EntIndex(),self:GetOverlayText(),0.5,e:GetPos(),e)
		end
	else
		--if(self.OldRenderGroup) then
		--	self.RenderGroup = self.OldRenderGroup
		--	self.OldRenderGroup = nil
		--end
		e:DrawModel()
	end
end

function ENT:Think()
self.Entity:NextThink(CurTime()+1);
self.NextRBUpdate = CurTime() + 1 
--	if (CurTime() >= (self.NextRBUpdate or 0)) then
--	    self.NextRBUpdate = CurTime() + math.random(30,100)/10 --update renderbounds every 3 to 10 seconds
--	end
end
