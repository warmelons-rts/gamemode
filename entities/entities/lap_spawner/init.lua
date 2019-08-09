AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial("models/debug/debugwhite");
	self.Entity:GetPhysicsObject():EnableMotion(false);
	self.CurWave = 0
	self.Skips = 1
	self.Delay = 60
	self.SpeedMod = 0.75
	self.SFile = ""
	self.ColorMod = {}
end

function ENT:Think()
    if self.CurWave > self.Skips then
        if table.Count(ents.FindByClass("lap_*")) + table.Count(ents.FindByClass("johnny_*")) < 150 then
        self:SpawnStuff(self.SFile)
        end
    end
	self.Entity:NextThink(CurTime() + self.Delay)
	if GetConVarNumber("WM_Pause") == 0 then
--	self.Delay = self.Delay * 0.95
	self.CurWave = self.CurWave + 1
	end
	return true

end

function ENT:SpawnStuff(SFile)
if file.Exists("addons/melonwars server content/data/WM-RTS/Scenarios/" .. SFile) then
local ini = file.Read("addons/melonwars server content/data/WM-RTS/Scenarios/" .. SFile)
local exploded = string.Explode("\n", ini);
--PrintTable(exploded)
local feature = 0
 for k, v in pairs (exploded) do
    if string.find(v, "johnny_") == 1 || string.find(v, "lap_") == 1 then 
    local ent = ents.Create(exploded[k]);
    local ePos = string.Explode(" ", exploded[k+1])
    local eAng = string.Explode(" ", exploded[k+2])
    
    ent:SetPos(Vector(ePos[1], ePos[2], ePos[3]))
    ent:SetAngles(Angle(eAng[1],eAng[2],eAng[3]))
    if exploded[k+3] ~= "nil" then
    timer.Simple(1.5, WMSpecifyBarracks, ent, exploded[k+3]) 
    end
    ent.Move = tobool(exploded[k+5])
    ent.Team = tonumber(exploded[k+6])
    ent.Grav = util.tobool(exploded[k+7])
    ent.Marine = tonumber(exploded[k+8])
    ent:SetName(exploded[k+15])
    ent.Stance = tonumber(exploded[k+10])
    ent.HoldFire = tonumber(exploded[k+13])
    ent.Cost = tonumber(exploded[k+14])
    ent:Spawn();
    if exploded[k+9] ~= "nil" && exploded[k+9] ~= nil then
     timer.Simple(1.5, WMSpecifyLeader, ent, exploded[k+9])
     else
     ent.Leader = nil
    end
    ent.Patrol = tobool(exploded[k+11])
    ent:Activate();
    ent:GetPhysicsObject():EnableGravity(util.tobool(exploded[k+7]));
    ent.Healthlol = ent.Healthlol * (1 + (self.CurWave / 5))
    ent.Maxlol = ent.Healthlol
    ent.Speed = ent.Speed * (self.SpeedMod * (1 + (self.CurWave / 15)))
    ent.Built = 2;
    if util.tobool(exploded[k+12]) then
    end
    local number = tonumber(exploded[k+16])
    ent.TargetVec = {}
    if number ~= 0 && number ~= nil && number ~= "nil" then
    	for i=1, number do
    	local exploded2 = string.Explode(" ", exploded[k+16+i])
    	--table.insert(ent.TargetVec, Vector(tonumber(exploded[k+17+i]),tonumber(exploded[k+18+i]),tonumber(exploded[k+19+i])) )
    	table.insert(ent.TargetVec, Vector(exploded2[1],exploded2[2],exploded2[3]))
    	end
    ent.Orders = true
    else
    number = 0
	end
--    if ent:GetPhysicsObject() ~= nil && ent:GetPhysicsObject():IsValid() then
---    ent:GetPhysicsObject():EnableMotion(false)
 --   end
--    if exploded[k+17+number] ~= "nil" then
--    	for i=1, tonumber(exploded[k+17+number]) do
   	--table.insert(ent.TargetVec, Vector(tonumber(exploded[k+17+i]),tonumber(exploded[k+18+i]),tonumber(exploded[k+19+i])) )
--    	end
--	end
 --   local r,g,b,a = ent:GetColor()
--    local clr = Color(math.Clamp(r + self.ColorMod[1], 0, 255), math.Clamp(g + self.ColorMod[2], 0, 255), math.Clamp( b + self.ColorMod[3], 0, 255), a)
--    ent:SetColor{255,255,125,200}
	if exploded[k] == "lap_bomb" then
	local number2 = 0
	if exploded[k+17+number] ~= "nil" then
	number2 = tonumber(exploded[k+17+number])
	end
	ent.Mine = exploded[k+18+number+number2]
	end
	if exploded[k] == "johnny_ordermelon" then
	local number2 = 0
	if exploded[k+17+number] ~= "nil" then
	number2 = tonumber(exploded[k+17+number])
	end
	ent.Damping = exploded[k+18+number+number2]
	ent.MovingForce = exploded[k+19+number+number2]
	ent.ZOnly = exploded[k+20+number+number2]
	end
	if exploded[k] == "johnny_barracks" || exploded[k] == "lap_munitions" || exploded[k] == "lap_heavybarracks" then
	local number2 = 0
    	if exploded[k+17+number] ~= "nil" then
    	number2 = tonumber(exploded[k+17+number])
    	end
	ent.FollowRange = tonumber(exploded[k+18+number+number2])
	end
	end
 end



end
end