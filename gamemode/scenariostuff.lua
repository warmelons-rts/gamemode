function LoadAndPaste( pl, filepath, _, HeaderTbl, ExtraHeaderTbl, Data )
if ( HeaderTbl.Type ) and ( HeaderTbl.Type == "AdvDupe File" ) then

ExtraHeaderTbl.FileVersion = tonumber(ExtraHeaderTbl.FileVersion)
   
    if ( ExtraHeaderTbl.FileVersion >= 0.82 ) and ( ExtraHeaderTbl.FileVersion < 0.9 )then
     
          local a,b,c = ExtraHeaderTbl.HoldAngle:match("(.-),(.-),(.+)")
          local HoldAngle = Angle( tonumber(a), tonumber(b), tonumber(c) )
          
             local a,b,c = ExtraHeaderTbl.HoldPos:match("(.-),(.-),(.+)")
             local HoldPos = Vector( tonumber(a), tonumber(b), tonumber(c) )
            
             local StartPos
              if ( ExtraHeaderTbl.FileVersion >= 0.83 ) then
                  local a,b,c = ExtraHeaderTbl.StartPos:match("(.-),(.-),(.+)")
                  StartPos = Vector( tonumber(a), tonumber(b), tonumber(c) )
              end
             
              AdvDupe.StartPaste( pl, Data.Entities, Data.Constraints, tonumber(ExtraHeaderTbl.Head), StartPos, Angle(0,0,0), tonumber(HeaderTbl.Entities), tonumber(HeaderTbl.Constraints), false, false )
             
          else
             Error("file old!")
         end
     end
 end


function WMMassMelonSpawn(ply, cmd, arg)
if ply == nil || ply:IsAdmin() || ply:IsAdmin() == nil then
if file.Exists("WM-RTS/melonfiles/" .. game.GetMap() .. "{" .. arg[1] .. "}.txt") then
local ini = file.Read("WM-RTS/melonfiles/" .. game.GetMap() .. "{" .. arg[1] .. "}.txt")
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
    if string.find(exploded[k], "barracks") ~= nil || string.find(exploded[k], "barracks") ~= nil then
    ent.MelonGrav = tobool(exploded[k+4])
    end
    ent.Move = tobool(exploded[k+5])
    ent.Team = tonumber(exploded[k+6])
    ent.Grav = tobool(exploded[k+7])
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
    ent.Built = 2;
    ent:GetPhysicsObject():EnableMotion(false)
    if tobool(exploded[k+12]) then
    timer.Simple(6, WMDelayedPropUnfreeze, ent)
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
 Msg(number .. "\n")
  Msg(exploded[k+17+number] .. "\n")
    if exploded[k+17+number] ~= "nil" then
    	for i=1, tonumber(exploded[k+17+number]) do
    	--table.insert(ent.TargetVec, Vector(tonumber(exploded[k+17+i]),tonumber(exploded[k+18+i]),tonumber(exploded[k+19+i])) )
        
        timer.Simple(5, WMDelayedPropConstrain, ent, exploded[k+17+number+i])
    	end
	end
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
	Msg(ent.Damping .. "/n\n")
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
end

function WMSpecifyBarracks(source, target)
local SL = ents.FindByName(target)
source.Barracks = SL[1]
end

function WMSpecifyLeader(source, target)
local SL = ents.FindByName(target)
source.Leader = SL[1]
end

function WMNameProps(ply, cmd, arg)
    for k,v in pairs(ents.FindByClass("melon_baseprop")) do
        if v:GetName() == nil || v:GetName() == "" then
        v:SetName(k+50000)
        end
    end
    for k,v in pairs(ents.FindByClass("prop_physics")) do
    if v:GetName() == nil || v:GetName() == "" then
    v:SetName(k+90000)
    end
    end
end

function WMSpewNames(ply, cmd, arg)
    for k,v in pairs(ents.FindByClass("melon_baseprop")) do
    Msg(v:GetName() .. "/n\n")
    end
    for k,v in pairs(ents.FindByClass("lap_*")) do
    Msg(v:GetName() .. "/n\n")
    end
    for k,v in pairs(ents.FindByClass("johnny_*")) do
    Msg(v:GetName() .. "/n\n")
    end
    for k,v in pairs(ents.FindByClass("prop_physics")) do
    Msg(v:GetName())
    end
end

function WMSetCost(ply, cmd, arg)
if ply:IsAdmin() then
	if #ply.WMSelections > 0 then
	   for k, x in pairs(ply.WMSelections) do
	   x.Cost = arg[1]
	   end
	end
end
end

function WMSaveProps(ply, cmd, arg)
if ply:IsAdmin() then
local message = {}
    for k,v in pairs(ents.FindByClass("melon_baseprop")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	table.insert(message, v:GetClass())
	table.insert(message, pos)
	table.insert(message, ang)
	if v.Team == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Team)
	end
	if v.Grav == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Grav)
	end
	if v.model == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.model)
	end
	if v.mass == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.mass)
	end
	table.insert(message, v:GetName())
	if v:GetPhysicsObject():IsValid() then
	table.insert(message, v:GetPhysicsObject():IsMoveable())
	else
	table.insert(message, "nil")
	end
	table.insert(message, 0)
	if constraint.HasConstraints(v) then
	local constraints = constraint.GetAllConstrainedEntities(v)
	PrintTable(constraints)
	table.insert(message, table.Count(constraints) - 1 )
	if constraints ~= nil then
	   for x, y in pairs(constraints) do
	   if y ~= v then
	   table.insert(message, y:GetName())
	   end
	   end
    end
    else
    table.insert(message, "nil")
    end
    --for k,v in pairs(ents.FindByClass("prop_physics")) do
    --local pos = v:GetPos()
	--local ang = v:GetAngles()
	--table.insert(message, v:GetClass())
	--table.insert(message, pos)
	--table.insert(message, ang)
	--table.insert(message, v:GetModel())
	--table.insert(message, v:GetName())
    --end
    end
	for x,y in pairs (message) do
	table.insert(message, x, tostring(table.remove(message, x)))
	end
file.Write("WM-RTS/propfiles" .. game.GetMap() .. "(" .. arg[1] .. ").txt", string.Implode("\n", message))
ply:PrintMessage(HUD_PRINTTALK, "Wrote file /WM-RTS/propfiles/" .. game.GetMap() .. "(" ..  arg[1] .. ").txt.");
end
end

function WMPropSpawn(ply, cmd, arg)
if ply == nil || ply:IsAdmin() || ply:IsAdmin() == nil then
if file.Exists("WM-RTS/propfiles/" .. game.GetMap() .. "(" ..  arg[1] .. ").txt") then
local ini = file.Read("WM-RTS/propfiles/" .. game.GetMap() .. "(" .. arg[1] .. ").txt")
local exploded = string.Explode("\n", ini);
--PrintTable(exploded)
local feature = 0
 for k, v in pairs (exploded) do
    if string.find(v, "melon_baseprop") == 1 then 
    local ent = ents.Create(exploded[k]);
    local ePos = string.Explode(" ", exploded[k+1])
    local eAng = string.Explode(" ", exploded[k+2])
    
    ent:SetPos(Vector(ePos[1], ePos[2], ePos[3]))
    ent:SetAngles(Angle(eAng[1],eAng[2],eAng[3]))
    ent.Team = tonumber(exploded[k+3])
    ent.Grav = tobool(exploded[k+4])
    ent.model = exploded[k+5]
    ent.mass = tonumber(exploded[k+6])
    ent:SetName(exploded[k+7])
    ent.Cost = tonumber(exploded[k+9])
    ent:Spawn();
    ent:Activate();
    ent.Built = 2;
    ent:GetPhysicsObject():EnableMotion(false)
    if tobool(exploded[k+8]) then
    timer.Simple(6, WMDelayedPropUnfreeze, ent)
    end
    if exploded[k+10] ~= nil then
    local number = tonumber(exploded[k+10])
    if number ~= 0 && number ~= nil && number ~= "nil" then
    	for i=1, tonumber(exploded[k+10]) do
    	--table.insert(ent.TargetVec, Vector(tonumber(exploded[k+17+i]),tonumber(exploded[k+18+i]),tonumber(exploded[k+19+i])) )

        timer.Simple(5, WMDelayedPropConstrain, ent, exploded[k+10+i])
    	end
	end
	end
--    if ent:GetPhysicsObject() ~= nil && ent:GetPhysicsObject():IsValid() then
---    ent:GetPhysicsObject():EnableMotion(false)
 --   end
    end
 end



end
end
end

function WMDelayedPropConstrain(ent, name)
local targetent = ents.FindByName(name)
  upright = constraint.Weld (ent, targetent[1], 0, ent.PhysicsBone, 0, true)

end

function WMDelayedPropUnfreeze(ent)
if ent:GetPhysicsObject():IsValid() then
ent:GetPhysicsObject():EnableMotion(true)
end
end

function WMSaveMelons(ply, cmd, arg)
if ply:IsAdmin() then
local message = {}
local randtable = {}

local tbl = ents.FindByClass("johnny_*")
table.Add(tbl, ents.FindByClass("lap_*"))

for k,v in pairs(tbl) do
if v:GetClass() ~= "lap_cappoint" &&  v:GetClass() ~= "lap_resnode" &&  v:GetClass() ~= "lap_commuplink" && v:GetClass() ~= "lap_commlink" && v:GetClass() ~= "lap_selector" then
v:SetName(k+1000)
end
end


	for k,v in pairs(tbl)do
    if v:GetClass() ~= "lap_cappoint" &&  v:GetClass() ~= "lap_resnode" &&  v:GetClass() ~= "lap_commuplink" && v:GetClass() ~= "lap_commlink" && v:GetClass() ~= "lap_selector" && v:GetClass() ~= "lap_spawnpoint" then
	local pos = v:GetPos()
	local ang = v:GetAngles()
	table.insert(message, v:GetClass())
	table.insert(message, pos)
	table.insert(message, ang)
	if v.Barracks == nil then
	table.insert(message, "nil")
	elseif v.Barracks:IsValid() then
	table.insert(message, v.Barracks:GetName())
	else
	table.insert(message, "nil")
	end
	if v.MelonGrav == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.MelonGrav)
	end
	if v.Move == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Move)
	end
	if v.Team == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Team)
	end
	if v.Grav == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Grav)
	end
	if v.Marine == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Marine)
	end
	if v.Leader == v || v.Leader == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Leader:GetName())
	end
	if v.Stance == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Stance)
	end
	if v.Patrol == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Patrol)
	end
	if v:GetPhysicsObject():IsValid() then
	table.insert(message, v:GetPhysicsObject():IsMoveable())
	else
	table.insert(message, "nil")
	end
	if v.HoldFire == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.HoldFire)
	end
	if v.Cost == nil then
	table.insert(message, "nil")
	else
	table.insert(message, v.Cost)
	end
	table.insert(message, v:GetName())
	if v.TargetVec ~= nil then
	table.insert(message, table.Count(v.TargetVec))
	table.Add(message, v.TargetVec)
	else
	table.insert(message, "nil")
	end
--	if constraint.HasConstraints(v) then
--	local constraints = constraint.GetAllConstrainedEntities(v)
--	PrintTable(constraints)
--	table.insert(message, table.Count(constraints) )
--	if constraints ~= nil then
--	   for x, y in pairs(constraints) do
--	   table.insert(message, y:GetName())
--	   end
--  end
    if constraint.HasConstraints(v) then
    local constr = constraint.FindConstraint(v, "Weld")
    table.insert(message, "1")
    table.insert(message, constr.Entity[2].Entity:GetName() )
    else
    table.insert(message, "nil")
    end
    if v:GetClass() == "johnny_ordermelon" then
    table.insert(message, v.Damping)
    table.insert(message, v.MovingForce)
    table.insert(message, v.ZOnly)
    elseif v:GetClass() == "lap_bomb" then
    table.insert(message, v.Mine)
    elseif v:GetClass() == "lap_munitions" || v:GetClass() == "johnny_barracks" || v:GetClass() == "lap_heavybarracks" then
    table.insert(message, v.FollowRange)
    end
	for x,y in pairs (message) do
	table.insert(message, x, tostring(table.remove(message, x)))
	end
	end
	end
PrintTable(message)
file.Write("WM-RTS/melonfiles/" .. game.GetMap() .. "{" .. arg[1] .. "}.txt", string.Implode("\n", message))
ply:PrintMessage(HUD_PRINTTALK, "Wrote file /WM-RTS/melonfiles/" .. game.GetMap() .. "{" .. arg[1] .. "}.txt.");
else
ply:PrintMessage(HUD_PRINTCENTER, "That command is admin only");
end
end
concommand.Add("WMMMS", WMMassMelonSpawn);
concommand.Add("wmsavemelons", WMSaveMelons);
concommand.Add("wmsaveprops", WMSaveProps);
concommand.Add("wmnameprops", WMNameProps);
concommand.Add("wmspewnames", WMSpewNames);
concommand.Add("wmspawnprops", WMPropSpawn);
concommand.Add("wmsetcost", WMSetCost);