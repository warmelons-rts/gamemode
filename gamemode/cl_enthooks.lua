function WMLoaded(um)
local ent = um:ReadEntity()
ent.Loaded = um:ReadShort()
end

usermessage.Hook("WMLoaded", WMLoaded)

function WMMaxAmmo(um)
local ent = um:ReadEntity()
ent.MaxAmmo = um:ReadShort()
end

usermessage.Hook("WMMaxAmmo", WMMaxAmmo)

function WMRcvStance(um)
local ent = um:ReadEntity()
local stance = um:ReadShort()
	if(IsValid(ent)) then
		if stance == 0 then
		ent.Stance = ""
		elseif stance == 1 then
		ent.Stance = "\nDefensive"
		elseif stance == 2 then
			if ent:GetClass() == "lap_bomb_clone" || ent:GetClass() == "lap_bomb" || ent:GetClass() == "lap_kaboom" then
			ent.Stance = "\nExplode on Contact"
			else
			ent.Stance = "\nOffensive"
			end
		elseif stance == 3 then
		ent.Stance = "\nBerzerk"
		end
	end
end

usermessage.Hook("WMStanceMsg", WMRcvStance)

function WMRcvHoldFire(um)
local ent = um:ReadEntity()
local hold = um:ReadBool()
	if(IsValid(ent)) then
		if hold == true then
		ent.HoldFire = "\nHolding Fire"
		else
		ent.HoldFire = ""
		end
	end
end

usermessage.Hook("WMHoldFireMsg", WMRcvHoldFire)

function WMRcvLoading(um)
local ent = um:ReadEntity()
local hold = um:ReadBool()
	if hold == true then
	ent.Load = "\nLoading"
	else
	ent.Load = "\nUnloading"
	end
end

usermessage.Hook("WMLoadingMsg", WMRcvLoading)