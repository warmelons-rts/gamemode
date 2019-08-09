include("shared.lua")
local keyevents = false
local keyevents2 = false

function SWEP:Initialize()
	self.reloadtimer = 0
end

function SWEP:Think()
	local ply = self:GetOwner()
	if (!ply:KeyDown(IN_ATTACK)) && keyevents then
		ply:ConCommand("-wmselect")
		keyevents = false
	end
	if (!ply:KeyDown(IN_RELOAD)) && keyevents2 then
		ply:ConCommand("-wmstanceradial")
		keyevents2 = false
	end
	
	self.Weapon:NextThink(CurTime() + 0.05)
	return true
end


function SWEP:Reload()
	if IsFirstTimePredicted() then
		if self.reloadtimer <= CurTime() then
		   self.reloadtimer = (CurTime() + 1)
		else
			return false
		end
	end
	local ply = self:GetOwner()
	if ply:KeyDown(IN_SPEED) || ply:KeyDown(IN_DUCK) || ply:KeyDown(IN_JUMP) || ply:KeyDown(IN_USE) || ply:KeyDown(IN_WALK) then
		ply:ConCommand("wmstanceselect")
	elseif keyevents2 == false then
		keyevents2 = true
		ply:ConCommand("+wmstanceradial")
	end
end


function SWEP:PrimaryAttack()
	keyevents = true
	self:GetOwner():ConCommand("+wmselect")
end


function SWEP:SecondaryAttack()
	self:GetOwner():ConCommand("wmorder")
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
end


function SWEP:Holster()
	self:GetOwner():ConCommand("-wmselect")
	return true
end
