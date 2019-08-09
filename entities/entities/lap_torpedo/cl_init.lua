include("shared.lua");

function ENT:Draw ()
	self.Entity:DrawModel();
end

function ENT:Think()
	self.BaseClass.Think(self)
--if (vgui.CursorVisible()) then return end 
		self.SmokeTimer = self.SmokeTimer or 0
	if ( self.SmokeTimer > CurTime() ) then return end

	self.SmokeTimer = CurTime() + 0.025

	local vOffset = self.Entity:LocalToWorld( self.Entity:OBBMaxs() )
	local vNormal = (vOffset - self.Entity:GetPos()):GetNormalized()
	vOffset = vOffset + VectorRand() * 5


	local emitter = ParticleEmitter( vOffset )

	local particle = emitter:Add( "effects/bubble", vOffset )
	vNormal.x = vNormal.x * 0.7
	vNormal.y = vNormal.y * 0.7
	vNormal.z = (vNormal.z+1) * 20
	particle:SetVelocity( vNormal)
	particle:SetDieTime( 2 )
	particle:SetStartAlpha( 125 )
	particle:SetEndAlpha( 125 )
	particle:SetColor(Color(255,255,255))
	particle:SetStartSize( 7 )
	particle:SetEndSize( 0 )
	particle:SetRoll( 0 )

	emitter:Finish()
end