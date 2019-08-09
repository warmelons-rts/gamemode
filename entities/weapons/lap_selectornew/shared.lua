if ( CLIENT ) then

	SWEP.PrintName			= "#WarMelons:RTS Selector"		
	SWEP.Slot				= 2
	SWEP.SlotPos			= 8
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true

end

local keyevents = false
local keyevents2 = false

function SWEP:Initialize()
	
	self:SetHoldType("pistol")
	self.reloadtimer = 0
		
end
	
function SWEP:PrimaryAttack()
	if IsFirstTimePredicted() then
		keyevents = true
		self.Owner():ConCommand("+wmselect")
	end
end

function SWEP:Think()
	if IsFirstTimePredicted() then
		local ply = self:GetOwner()
		if (!ply:KeyDown(IN_ATTACK)) && keyevents then
			ply:ConCommand("-wmselect")
			keyevents = false
		end
		if (!ply:KeyDown(IN_RELOAD)) && keyevents2 then
			ply:ConCommand("-wmstanceradial")
			keyevents2 = false
		end
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
	local ply = self.Owner()
	if ply:KeyDown(IN_SPEED) || ply:KeyDown(IN_DUCK) || ply:KeyDown(IN_JUMP) || ply:KeyDown(IN_USE) || ply:KeyDown(IN_WALK) then
		ply:ConCommand("wmstanceselect")
	elseif keyevents2 == false then
		keyevents2 = true
		ply:ConCommand("+wmstanceradial")
	end
end

function SWEP:SecondaryAttack()
	if IsFirstTimePredicted() then
		self.Owner():ConCommand("wmorder")
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )
end


function SWEP:Holster()
	if (CLIENT and IsValid(self.Owner) and IsValid(self.Owner:GetViewModel())) then
		self.Owner():ConCommand("-wmselect")
	end
	return true
end

function SWEP:Deploy ( )
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )
	return true
end

------------General Swep Info---------------
SWEP.Author			= "Lap"
SWEP.Contact		= "l_a_p@hotmail.com"
SWEP.Purpose		= "Used to Command WarMelons"
SWEP.Instructions	= "Primary fire=Start/End Selection (HOLD). Secondary Fire=Order. Reload=Stance(HOLD) Selection"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.IconLetter		= "x"
-----------------------------------------------

------------Models---------------------------
SWEP.ViewModelFOV		= 60
SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"
-----------------------------------------------

-------------Primary Fire Attributes--------------------------------------
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
-------------End Primary Fire Attributes----------------------------------

-------------Secondary Fire Attributes------------------------------------
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
-------------End Secondary Fire Attributes--------------------------------