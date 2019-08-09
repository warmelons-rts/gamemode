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
self.Stance = ""
self.HoldFire = ""
end

function ENT:Draw()
	local e = self.Entity;
	if self.DrawOverride == nil || self:DrawOverride() == true then
		if (LocalPlayer():GetEyeTrace().Entity == e and (EyePos():Distance(e:GetPos()) < 512 || LocalPlayer():KeyDown(IN_JUMP))) then
			hook.Add( "PreDrawHalos", "AddHalos", function()
				if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
					halo.Add({self.Entity}, Color( 255, 255, 255 ))
				end
			end)
			self.Entity:DrawModel()
				AddWorldTip( e:EntIndex(), self.PrintName .. self.Stance .. self.HoldFire, 0.5, self.Entity:GetPos(), self.Entity )
		else
			if(self.OldRenderGroup) then
				self.RenderGroup = self.OldRenderGroup
				self.OldRenderGroup = nil
			end
			if self.Selected then
				hook.Add( "PreDrawHalos", "AddHalos", function()
					if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
						halo.Add({self.Entity}, Color( 255, 255, 255 ))
					end
				end)
			end
			e:DrawModel()
		end
	end
end

function ENT:DrawTranslucent( bDontDrawModel )
	if ( bDontDrawModel ) then return end
	
	if (  LocalPlayer():GetEyeTrace().Entity == self.Entity && 
		  EyePos():Distance( self.Entity:GetPos() ) < 256 ) then
	
		hook.Add( "PreDrawHalos", "AddHalos", function()
			if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
				halo.Add({self.Entity}, Color( 255, 255, 255 ))
			end
		end)
		
	end
	
	self:Draw()
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

local matOutlineWhite 	= Material( "white_outline" )
local ScaleNormal		= 1
local ScaleOutline1		= 1.05
local ScaleOutline2		= 1.1
local matOutlineBlack 	= Material( "black_outline" )

function ENT:DrawEntityOutline( size )
	size = size or 1.0
	render.SuppressEngineLighting( true )
	render.SetAmbientLight( 1, 1, 1 )
	render.SetColorModulation( 1, 1, 1 )
	
		-- First Outline	
		self:SetModelScale( ScaleOutline2 * size )
		render.MaterialOverride( matOutlineBlack )
		self:DrawModel()
		
		
		-- Second Outline
		self:SetModelScale( ScaleOutline1 * size )
		render.MaterialOverride( matOutlineWhite )
		self:DrawModel()
		
		-- Revert everything back to how it should be
		render.MaterialOverride( nil )
		self:SetModelScale( ScaleNormal )
		
	render.SuppressEngineLighting( false )
	
	local col = self:GetColor()
	render.SetColorModulation( col.r/255, col.g/255, col.b/255 )
end