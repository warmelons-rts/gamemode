include( "shared.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );


DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize()
	self.Entity:SetModel("models/props_phx/ball.mdl")
	self.pl = self:GetOwner()
	self.Entity:DrawShadow( false )
	self.Pos = self.Entity:GetPos()

end

function ENT:Think()
	if self.Start == nil then
		self.Start = self.pl:GetAimVector()
	end

	local xfinal = 0
	local yfinal = 0
	local zfinal = 0
	local keydown = false
    if self.pl ~= nil then
		if self.pl:KeyDown(IN_JUMP) then
			keydown = true
			zfinal = ((self.pl:GetAimVector().z - self.Start.z) * 1000)
		
			--if self.pl:KeyDown(IN_DUCK) then
			--keydown = true
			--xfinal = ((math.AngleDifference(self.pl:GetAimVector():Angle().y, self.Start:Angle().y)) * 25)
			--else
			--yfinal = ((math.AngleDifference(self.pl:GetAimVector():Angle().y, self.Start:Angle().y)) * 25)
			--end
		end
		
		if self.pl:KeyDown(IN_DUCK) then
			keydown = true
			--yfinal = ((self.pl:Length() - self.Start:Length()) * 1000)
			yfinal = ((self.pl:GetAimVector().z - self.Start.z) * 1000)
		end
		
		if self.pl:KeyDown(IN_SPEED) then
			keydown = true
			--xfinal = ((self.pl:Length() - self.Start:Length()) * 1000)
			xfinal = ((self.pl:GetAimVector().z - self.Start.z) * 1000)
		end
		if keydown == false then
			self.Start = self.pl:GetAimVector()
			self.Pos = self.Entity:GetPos()
		else
			self.Entity:SetPos(self.Pos + Vector(xfinal, yfinal, zfinal))
		end
		--self.Entity:SetAngles(Angle(0,self.pl:EyeAngles().yaw,0)
	else
		self.Entity:Remove()
	end
end