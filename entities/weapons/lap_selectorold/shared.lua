if ( SERVER ) then
   AddCSLuaFile ( "shared.lua" )
   AddCSLuaFile ( "cl_init.lua" )
end

if ( CLIENT ) then

	SWEP.PrintName          = "WarMelons:RTS Selector"
--	SWEP.Author		= "Lap"
--Thanks to Omen for the idea to just move the selection code down to think instead of having people click twice.
--	SWEP.Contact		= "l_a_p@hotmail.com"
--	SWEP.Purpose		= "Used to Command WarMelons"
--	SWEP.Instructions	= "Primary fire=Start/End Selection (HOLD). Secondary Fire=Order. Reload=Stance(HOLD) Selection"
	SWEP.Slot               = 2
	SWEP.SlotPos            = 8
	SWEP.DrawAmmo           = false
	SWEP.DrawCrosshair      = true
end

SWEP.ViewModelFOV	        = 60
SWEP.ViewModelFlip	        = false
SWEP.ViewModel		        = "models/weapons/v_357.mdl"
SWEP.WorldModel		        = "models/weapons/w_357.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= ""

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= ""

function SWEP:Deploy ( )
	self.Weapon:SendWeaponAnim ( ACT_VM_DRAW )
	return true
end