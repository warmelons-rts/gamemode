include("shared.lua")

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Draw()
	self:DoNormalDraw()

end

function ENT:DoNormalDraw()
	local e = self.Entity;
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 256) then
		hook.Add( "PreDrawHalos", "AddHalos", function()
			if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
				halo.Add({self.Entity}, Color( 255, 255, 255 ))
			end
		end)
		self.Entity:DrawModel()
		if self:GetOverlayText() ~= "" then
			AddWorldTip(e:EntIndex(),self:GetOverlayText(),0.5,e:GetPos(),e)
		end
	else
		if(self.OldRenderGroup) then
			self.RenderGroup = self.OldRenderGroup
			self.OldRenderGroup = nil
		end
	end
end

function ENT:Think()
	if (CurTime() >= (self.NextRBUpdate or 0)) then
	    self.NextRBUpdate = CurTime() + math.random(30,100)/10 --update renderbounds every 3 to 10 seconds
	end
end
