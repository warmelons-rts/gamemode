function GM:Move(ply, movedata)
return true
end

function GM:Movez(ply, movedata)
	
	if ply:KeyDown(IN_BACKWARD) then
	movedata:SetVelocity(movedata:GetVelocity() - (ply:EyeAngles():Forward() * 10))
	end
return true
end

function GM:FinishMoveA(ply, movedata)
local speed = 25
	if ply:KeyDown(IN_SPEED) then
	speed = speed * 2
	end
	if ply:KeyDown(IN_WALK) then
	speed = speed / 2
	end
	if ply:KeyDown(IN_FORWARD) then
	ply:SetPos(ply:GetPos() + (ply:EyeAngles():Forward() * speed))
	end
	if ply:KeyDown(IN_BACK) then
	ply:SetPos(ply:GetPos() - (ply:EyeAngles():Forward() * speed))
	end
	if ply:KeyDown(IN_MOVELEFT) then
	ply:SetPos(ply:GetPos() - (ply:EyeAngles():Right() * speed))
	end
	if ply:KeyDown(IN_MOVERIGHT) then
	ply:SetPos(ply:GetPos() + (ply:EyeAngles():Right() * speed))
	end
	--if ply:KeyDown(IN_FORWARD) then
	--movedata:SetVelocity(movedata:GetVelocity() + (ply:EyeAngles():Right() * speed))
	--end
	--if ply:KeyDown(IN_BACK) then
	--movedata:SetVelocity(movedata:GetVelocity() - (ply:EyeAngles():Right() * speed))
	--end
end

function GM:FinishMove(ply, movedata)
local speed = 25
	if ply:KeyDown(IN_SPEED) then
	speed = speed * 2
	end
	if ply:KeyDown(IN_WALK) then
	speed = speed / 2
	end
	if ply:KeyDown(IN_FORWARD) then
	ply:SetPos(ply:GetPos() + (ply:EyeAngles():Forward() * speed))
	end
	if ply:KeyDown(IN_BACK) then
	ply:SetPos(ply:GetPos() - (ply:EyeAngles():Forward() * speed))
	end
	if ply:KeyDown(IN_MOVELEFT) then
	ply:SetVelocity(ply:GetVelocity() - (ply:EyeAngles():Right() * speed))
	end
	if ply:KeyDown(IN_MOVERIGHT) then
	ply:SetPos(ply:GetPos() + (ply:EyeAngles():Right() * speed))
	end
	--if ply:KeyDown(IN_FORWARD) then
	--movedata:SetVelocity(movedata:GetVelocity() + (ply:EyeAngles():Right() * speed))
	--end
	--if ply:KeyDown(IN_BACK) then
	--movedata:SetVelocity(movedata:GetVelocity() - (ply:EyeAngles():Right() * speed))
	--end
end