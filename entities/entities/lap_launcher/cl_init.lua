include('shared.lua')
surface.CreateFont("SandboxLabel", {
	font = "coolvetica", 
	size = 64, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false, 
})
ENT.LabelColor = Color( 255, 255, 255, 255 )

function ENT:Initialize()
self.Loaded = 0
self.MaxAmmo = 0
end

function ENT:Draw()
	local e = self.Entity;
	if self.DrawOverride == nil || self:DrawOverride() == true then
		if (LocalPlayer():GetEyeTrace().Entity == e and (EyePos():Distance(e:GetPos()) < 256 || LocalPlayer():KeyDown(IN_JUMP))) then
			hook.Add( "PreDrawHalos", "AddHalos", function()
				if ( LocalPlayer():GetEyeTrace().Entity == e && EyePos():Distance( e:GetPos() ) < 512 ) then
					halo.Add({e}, Color( 255, 255, 255 ))
				end
			end)
			self.Entity:DrawModel()
			if self:GetNWInt("WMBuilding") ~= -1 then
				AddWorldTip(e:EntIndex(),"Building: " .. self:GetNWInt("WMBuilding") .. "/100\nHealth: " .. self:GetNWInt("WMHealth") .. "/" .. self:GetNWInt("WMMaxHealth"),0.5,e:GetPos(),e)
			else
				local tbl = { self.Entity:GetColor() }
				local tbl2 = team.GetColor(LocalPlayer():Team())           
				if tbl[1] == tbl2.r && tbl[2] == tbl2.g && tbl[3] == tbl2.b then
					AddWorldTip( e:EntIndex(), self.PrintName .. "\nAmmo: " .. self.Loaded .. "/" .. self.MaxAmmo, 0.5, self.Entity:GetPos(), self.Entity )
				else
					AddWorldTip( e:EntIndex(), self.PrintName, 0.5, self.Entity:GetPos(), self.Entity )
				end
			end
		else
			if(self.OldRenderGroup) then
				self.RenderGroup = self.OldRenderGroup
				self.OldRenderGroup = nil
			end
			if self.Selected then
				hook.Add( "PreDrawHalos", "AddHalos", function()
					if ( LocalPlayer():GetEyeTrace().Entity == e && EyePos():Distance( e:GetPos() ) < 512 ) then
						halo.Add({e}, Color( 255, 255, 255 ))
					end
				end)
			end
			e:DrawModel()
		end
	end
end

function ENT:DrawTranslucent( bDontDrawModel )

	if ( bDontDrawModel ) then return end
	
	if (  LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 256 ) then
		hook.Add( "PreDrawHalos", "AddHalos", function()
			if ( LocalPlayer():GetEyeTrace().Entity == e && EyePos():Distance( e:GetPos() ) < 512 ) then
				halo.Add({e}, Color( 255, 255, 255 ))
			end
		end)
		self:Draw()
	end
end

function ENT:DrawOverlayText()
	
	if ( !self:SetLabelVariables() ) then return end
	
	self:DrawLabel()

end

function ENT:DrawFlatLabel( size )

	local TargetAngle 	= self.Entity:GetAngles()
	local TargetPos 	= self.Entity:GetPos() - TargetAngle:Forward() * 16
	
	TargetAngle:RotateAroundAxis( TargetAngle:Up(), 90 )
	
	cam.Start3D2D( TargetPos, TargetAngle, 0.05 * size * self.LabelScale )
	
		local Shadow = Color( 0, 0, 0, self.LabelAlpha * 255 )
		draw.DrawText( self.LabelText, self.LabelFont,  3,  3, Shadow, TEXT_ALIGN_CENTER )

		self.LabelColor.a = self.LabelAlpha * 255
		draw.DrawText( self.LabelText, self.LabelFont, 0, 0, self.LabelColor, TEXT_ALIGN_CENTER )
		
	cam.End3D2D()

end

function ENT:SetLabelVariables()

	-- Override this to set the label position, return true to draw and false to not draw.
	
	self.LabelText = self:GetOverlayText()
	if ( self.LabelText == "" ) then return false end
	
	-- Only draw if so close
	self.LabelDistance = EyePos():Distance( self.Entity:GetPos() )
	if ( self.LabelDistance > 256 ) then return false end
		
	-- Which way should our quad face
	self.LabelAngles = self.Entity:GetAngles()
	self.LabelAngles:RotateAroundAxis( self.LabelAngles:Right(), 90 )
	
	-- Make sure we're standing in front of it (so we can see it)
	local ViewNormal = EyePos() - self.Entity:GetPos()
	ViewNormal:GetNormal()
	local ViewDot = ViewNormal:Dot( self.LabelAngles:Forward() )
	if ( ViewDot < 0 ) then return false end
	
	-- Set the label position
	self.LabelPos = self.Entity:GetPos() + self.LabelAngles:Forward() + self.LabelAngles:Up() * 4
	
	-- Alpha
	self.LabelAlpha = (1 - self.LabelDistance / 256)^0.4
	
	self.LabelFont 	= "SandboxLabel"
	self.LabelScale = 1
	
	return true

end