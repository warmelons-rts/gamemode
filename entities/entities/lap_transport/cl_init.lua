include('shared.lua')

DEFINE_BASECLASS( "base_warmelon" )

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
			e:DrawModel()
			if self:GetNWInt("WMBuilding") ~= -1 then
				AddWorldTip(e:EntIndex(),"Building: " .. self:GetNWInt("WMBuilding") .. "/100\nHealth: " .. self:GetNWInt("WMHealth") .. "/" .. self:GetNWInt("WMMaxHealth"),0.5,e:GetPos(),e)
			else
				local tbl = { e:GetColor() }
				local tbl2 = team.GetColor(LocalPlayer():Team())           
				if tbl[1] == tbl2.r && tbl[2] == tbl2.g && tbl[3] == tbl2.b then
				AddWorldTip( e:EntIndex(), self.PrintName .. "\nAmmo: " .. self.Loaded .. "/" .. self.MaxAmmo, 0.5, e:GetPos(), e )
				else
				AddWorldTip( e:EntIndex(), self.PrintName, 0.5, e:GetPos(), e )
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
	BaseClass.DrawTranslucent( self )
end

function ENT:DrawOverlayText()
	BaseClass.DrawOverlayText( self )
end

function ENT:DrawFlatLabel( size )
	BaseClass.DrawFlatLabel( self )
end

function ENT:SetLabelVariables()
	BaseClass.SetLabelVariables( self )
end


local matOutlineWhite 	= Material( "white_outline" )--EVERYTHING BELOW THIS LINE CAN POSSIBLY BE REMOVED -Matias
local ScaleNormal		= 1
local ScaleOutline1		= 1.05
local ScaleOutline2		= 1.1
local matOutlineBlack 	= Material( "black_outline" )

function ENT:DrawEntityOutline( size )
	BaseClass.DrawEntityOutline( self )
end