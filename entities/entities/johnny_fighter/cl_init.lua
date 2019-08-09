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
	BaseClass.Initialize( self )
	local mat = self.Entity:GetMaterial()
	if mat == "models/effects/slimebubble_sheet" then
		self.PrintName = "Blink Fighter"
	elseif mat == "" then
		self.PrintName = "Marine Fighter" 
	end
	self.Warmelon = true
end

function ENT:Draw()
	BaseClass.Draw( self )
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