function WMCanister(pos, ply)
Msg("%%%")
end
function WMCheckForWin()
end

function WMDomination()
if server_settings.Int( "WM_Deominaton", 1) ~= 1 then
return
end

local diverse = 0
local entz = ents.FindByClass("lap_spawnpoint")
local lastteam = 0
local playercount = player.GetAll()

	 for k, v in pairs (entz) do
        if lastteam == 0 then
        lastteam = v.Team
        end
        if lastteam ~= v.Team then
        diverse = 1
        break
        end
     end
Msg("Diversity Check")

    if diverse == 0 && table.Count(playercount) > 1 && table.Count(entz) > 0 then
    local someoneisholdingout = 0
        for k, v in pairs (player.GetAll()) do
            if v:GetNWInt("nrg") >= (50000 * server_settings.Int( "WM_ToolCost", 1)) && v:GetNWInt("melonteam") ~= lastteam then
            someoneisholdingout = 1
            end
        end
        
        if someoneisholdingout == 0 then
        Msg("Team " .. lastteam .. " won the round")
        WMWin(lastteam)
        timer.Simple(10, WMLoadNextMap)
        else
        WMWinCountdown(lastteam, 10)
	   end
	end
end

function WMWinCountdown(lastteam, seconds)

local entz = ents.FindByClass("lap_spawnpoint")
if seconds <= 0 then
    WMWin(lastteam)
    Msg("Team " .. lastteam .. " won the round")
    timer.Simple(10, WMLoadNextMap)
    return
end
local diverse = 0
	 for k, v in pairs (entz) do
        if lastteam == 0 then
        lastteam = v.Team
        end
        if lastteam ~= v.Team then
        diverse = 1
        break
        end
     end
if diverse == 1 then
return
end
     for x, y in pairs (player.GetAll()) do
        if y:GetNWInt("melonteam") ~= lastteam then
	     y:PrintMessage(HUD_PRINTCENTER, "You have " .. seconds .. " seconds left to build a spawn point");
	    end
	end

seconds = seconds - 1
timer.Simple(1, WMWinCountdown, lastteam, seconds)
end

function WMWin(lastteam)
	local colors = {}
	colors[0] = "admin"
	colors[1] = "red"
	colors[2] = "blue"
	colors[3] = "green"
	colors[4] = "yellow"
	colors[5] = "magenta"
	colors[6] = "cyan"
	     for x, y in pairs (player.GetAll()) do
	     local message = "Team " .. lastteam .. ", (" .. colors[lastteam] .. "), has won the round!"
	     y:PrintMessage(HUD_PRINTCENTER, message);
	     end
timer.Simple(1, WMWin, lastteam)
end

function WMLoadNextMap()
	hook.Call( "WMLoadNextMap", {} )
end

function WMSaySearch( ply, saywhat )
local playerName = ply:GetName()
if string.find(saywhat, "/join") ~= nil then
  if string.find(saywhat, "1") ~= nil || string.find(saywhat, "red") ~= nil then
  WMJoinTeam(ply, 1)
  elseif string.find(saywhat, "2") ~= nil || string.find(saywhat, "blue") ~= nil then
  WMJoinTeam(ply, 2)
  Msg("Teamchange")
  elseif string.find(saywhat, " 3") ~= nil || string.find(saywhat, " green") ~= nil then
  WMJoinTeam(ply, 3)
  elseif string.find(saywhat, " 4") ~= nil || string.find(saywhat, " yellow") ~= nil then
  WMJoinTeam(ply, 4)
  elseif string.find(saywhat, " 5") ~= nil || string.find(saywhat, " magenta") ~= nil then
  WMJoinTeam(ply, 5)
  elseif string.find(saywhat, " 6") ~= nil || string.find(saywhat, " cyan") ~= nil then
  WMJoinTeam(ply, 6)
  elseif string.find(saywhat, " 0") ~= nil || string.find(saywhat, " none") ~= nil then
  WMJoinTeam(ply, 0)
  end
--elseif string.find(saywhat, "/ally") == 1 then
  --if string.find(saywhat, " 1") == 1 || string.find(saywhat, " red") == 1 then
 -- ply.Ally = 1
  --elseif string.find(saywhat, " 2") == 1 || string.find(saywhat, " blue") == 1 then
  --ply.Ally = 2
  --elseif string.find(saywhat, " 3") == 1 || string.find(saywhat, " green") == 1 then
  --ply.Ally = 3
  --elseif string.find(saywhat, " 4") == 1 || string.find(saywhat, " yellow") == 1 then
  --ply.Ally = 4
  --elseif string.find(saywhat, " 5") == 1 || string.find(saywhat, " magenta") == 1 then
  --ply.Ally = 5
  --elseif string.find(saywhat, " 6") == 1 || string.find(saywhat, " cyan") == 1 then
  --ply.Ally = 6
  --elseif string.find(saywhat, " 0") == 1 || string.find(saywhat, " none") == 1 then
  --ply.Ally = 0
  --end
end
if string.find(saywhat, "/help") ~= nil then
ply:ConCommand("wmhelp")
end
end

hook.Add ( "PlayerSay", "WMSaySearch", WMSaySearch ) 

function CanMelonSpawn(Team, Location)

	local melon = ents.Create("johnny_lightfighter");
  melon:SetPos(Location + Vector(0,0,10));
	melon.Team = Team;
	melon.Move = true;
	melon.Grav = true;
	melon:Spawn();
	melon:Activate();
end

function Disaperate(ent)

local col = ent:GetColor()
if col.a > 19 then                                                                                          
ent:SetColor(Color(col.r,col.g,col.b, col.a-20))
end
timer.Simple(0.25, Disaperate(ent))
end

function WMPlayerJoins (ply)
	ply.WMSelections = {};
	ply.WMSelecting = false;
	ply.SetSelectionBox = nil;
	ply.WMG1 = {};
	ply.WMG2 = {};
	ply.WMG3 = {};
	ply.WMG4 = {};
	ply.WMG5 = {};
	ply.WMG6 = {};
	ply:ConCommand("wmhelp")
--ply.Ally = 0;
	ply:SetNWInt( "melonteam" , 7);
	ply:SetNWInt( "nrg" , server_settings.Int( "WM_StartingNRG", 60000) );
	timer.Simple(math.Rand(0, 3), WMInitialJoin, ply)
end

function WMInitialJoin(ply)
	for i=1,6 do  
	local teammemcount = 0
	local colors = {}
	colors[0] = "admin"
	colors[1] = "red"
	colors[2] = "blue"
	colors[3] = "green"
	colors[4] = "yellow"
	colors[5] = "magenta"
	colors[6] = "cyan"
	local allplayers = player.GetAll()
	 for k, v in pairs (allplayers) do
	   if v:GetNWInt( "melonteam") == k then
	   teammemcount = teammemcount + 1
	   end
	   if teammemcount < server_settings.Int( "WM_PlayersPerTeam", 1) then
	   ply:SetNWInt( "melonteam" , i);
	     for x, y in pairs (allplayers) do
	     local message = ply:GetName() .. " has joined team " .. i .. ", (" ..colors[i].. ")."
	     Msg(ply:GetName() .. " joined team " .. i .. ", (" .. colors[i].. ").")
	     y:PrintMessage(HUD_PRINTTALK, message);
	     end
	   return
	   end
   end
  end
end


function WMJoinTeam(ply, team)
ply.WMSelections = {}
	local colors = {}
	colors[0] = "admin"
	colors[1] = "red"
	colors[2] = "blue"
	colors[3] = "green"
	colors[4] = "yellow"
	colors[5] = "magenta"
	colors[6] = "cyan"
local allplayers = player.GetAll()
local teammemcount = 0;
		if (ply:IsAdmin() ~= true && team == 0) then
		local message = "Only admins can be on team 0"
		ply:PrintMessage(HUD_PRINTTALK, message)
		elseif server_settings.Int( "WM_AllowTeamChanges", 1) == 1 then
		for k, v in pairs ( allplayers )	do
			if v:GetNWInt( "melonteam" ) == team then
			teammemcount = teammemcount + 1
			end
		end	
		if teammemcount <= server_settings.Int( "WM_PlayersPerTeam", 1) then
		ply:SetNWInt( "melonteam" , team)
			for k,v in pairs ( allplayers ) do
			local message = ply:GetName() .. "'s team set to: " .. team .. ", (" .. colors[team] .. ")."
			v:PrintMessage( HUD_PRINTTALK, message )
			end 
		else
		local message = "Team " .. team .. " is full."
		ply:PrintMessage(HUD_PRINTTALK, message)
		end
		else
		local message = "The server has disabled team changing."
		ply:PrintMessage(HUD_PRINTTALK, message)
		end
end

function NRGCheck(ply, cost)
	 if ply:GetNWInt("nrg") >= cost then
	 ply:SetNWInt("nrg", ply:GetNWInt("nrg") - cost)
	 local message = "Your NRG:" .. ply:GetNWInt( "nrg" ) .. " Cost: " .. cost
	 ply:PrintMessage(HUD_PRINTTALK, message);
	 return true
	 else
   local message = "Not enough NRG. Your NRG:" .. ply:GetNWInt( "nrg" ) .. " Cost: " .. cost
   ply:PrintMessage(HUD_PRINTTALK, message);
   return false
   end
end

function InBaseRange(ply)
 local buildradius = server_settings.Int( "WM_Buildradius", 750)
  if (buildradius ~= 0) then
    local trace = ply:GetEyeTrace()
  	local entz = ents.FindByClass("lap_spawnpoint")
	  local Pos = trace.HitPos
		for k, v in pairs(entz) do
	  local dist = v:GetPos():Distance(Pos);
		  if (v.Team == ply:GetNWInt( "melonteam" ) && dist <= buildradius) then
		  return true
		  end
	  end
	else
	return true
	end
local message = "Too far from spawnpoint"
ply:PrintMessage(HUD_PRINTTALK, message);
return false
end

function Invis(ply, alpha)
alpha = alpha or 0
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:Fire( "alpha", alpha, 0 )
	ply:DrawWorldModel(false)
end

function SpawnedProp(ply, model, ent)

if ply:GetNWInt("melonteam") ~=0 then
 if (server_settings.Int( "WM_Normalpropspawning", 0) == 0) then
 local disfin = 0
 local buildradius = server_settings.Int( "WM_Buildradius", 750)
  if (buildradius ~= 0) then
    local trace = ply:GetEyeTrace()
  	local entz = ents.FindByClass("lap_spawnpoint")
  	local entz2 = ents.FindByClass("lap_outpost")
	  local Pos = trace.HitPos
		for k, v in pairs(entz) do
	  local dist = v:GetPos():Distance(Pos);
		  if (v.Team == ply:GetNWInt( "melonteam" ) && dist <= buildradius) then
		  disfin = 1
		  end
	  end
	 	for k, v in pairs(entz2) do
	  local dist = v:GetPos():Distance(Pos);
		  if (v.Team == ply:GetNWInt( "melonteam" ) && dist <= buildradius) then
		  disfin = 1
		  end
	  end
	else
	disfin = 1
	end
   if (disfin == 1) then
	if ent:GetClass() ~= "melon_baseprop" then
    local p = ent:GetPhysicsObject();
    local m = p:GetMass();
     local t = ply:GetNWInt("melonteam");
       if m > 1000 then
       m = 1000;
       end
    if ply:GetNWInt( "nrg" ) >= m then
    local melon = ents.Create ("melon_baseprop");
    ply:SetNWInt( "nrg", math.floor(ply:GetNWInt( "nrg" , 0) - m*server_settings.Int( "WM_Propcost", 2)));
    melon.mass = m
    melon.model = ent:GetModel();
    melon:SetModel(ent:GetModel());
    melon:SetPos(ent:GetPos());
    melon:SetAngles(ent:GetAngles());
    melon.Team = t;
    melon:Spawn();
    melon:Activate();
		if (t == 1) then
		melon:SetColor(Color(255, 0, 0, 255));
		end
		if (t == 2) then
		melon:SetColor(Color(0, 0, 255, 255));
		end
		if (t == 3) then
		melon:SetColor(Color(0, 255, 0, 255));
		end
		if (t == 4) then
		melon:SetColor(Color(255, 255, 0, 255));
		end
		if (t == 5) then
		melon:SetColor(Color(255, 0, 255, 255));
		end
		if (t == 6) then
		melon:SetColor(Color(0, 255, 255, 255));
		end
   undo.Create("baseprop");
   undo.AddEntity(melon);
   undo.SetPlayer(ply);
   undo.Finish();
    end
   local cost = math.floor(m*server_settings.Int( "WM_Propcost", 2))
   local message = "Your NRG:" .. ply:GetNWInt( "nrg" ) .. " Cost: " .. cost
  ply:PrintMessage(HUD_PRINTTALK, message);
    if ent:IsValid() && ent:GetClass() ~= "melon_baseprop" then
    ent:Remove();
    end
    end
 else
 local message = "Too far from spawn point"
 ply:PrintMessage(HUD_PRINTTALK, message);
 ent:Remove();
 end
end
end
end
if server_settings.Int( "WM_Rules", 1) ~= 0 then
hook.Add("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp) ;
hook.Add("PlayerInitialSpawn", "WarmelonSpawn", WMPlayerJoins);
end

function WMSelectBegin (ply, cmd, arg)
	local tr = ply:GetEyeTrace();
	WMDeColor(ply)
	if ply.SelectionBox ~= nil && ply.SelectionBox:IsValid() then
	ply.SelectionBox:Remove()
	end
    local selbox = ents.Create("lap_selectionbox")
    ply.SelectionBox = selbox
    selbox:SetPos(tr.HitPos + tr.HitNormal)
    local eang = ply:EyeAngles()
    selbox.pl = ply
    selbox:SetAngles(Angle(0,eang.yaw,0))
    selbox:Spawn()
    selbox:Activate()
	--making sure the player isn't already selecting and that the trace hit something
	if (ply.WMSelecting != true && tr.Hit) then
		if !ply:KeyDown(IN_SPEED) then
		--don't clear if shift is held down, so we can select multiple groups of units
			ply.WMSelections = {};
		end
		if ply:KeyDown(IN_DUCK) then
		WMTypeSelect(ply)
		elseif ply:KeyDown(IN_USE) then
		  if tr.Entity:IsValid() && tr.Entity.Team ~= nil && tr.Entity.Team == ply:GetNWInt("melonteam") then
		  table.insert(ply.WMSelections, tr.Entity)
		  end
		end
		--flag him as selecting and mark where he's looking at
		ply.WMSelecting = true;
		ply.WMSelStart = tr.HitPos;
	end
end

function WMSelectEnd (ply, cmd, arg)
    if ply.SelectionBox ~= nil && ply.SelectionBox:IsValid() then
    ply.SelectionBox:Remove()
    end
	local mteam = ply:GetNWInt( "melonteam" )
	local tr = ply:GetEyeTrace();
	--making sure the player is selecting by this point
	--to stop retards breaking it by typing -wmselect into the console
	if (ply.WMSelecting == true && tr.Hit) then
		ply.WMSelecting = false;
		ply.WMSelEnd = tr.HitPos;
		ply:EmitSound("Weapon_SMG1.Special1", 100, 100);
		local selCentre = (ply.WMSelStart+ply.WMSelEnd)/2;
		local selRadius = (ply.WMSelStart:Distance(ply.WMSelEnd))/2
		for k, info in pairs(ents.FindByClass("info_target")) do
			if (info:GetPos():Distance(selCentre)<selRadius && info.Warmelon && info:GetParent().Move == true ) then
	local target = info:GetParent();
	if (mteam == 0 && target.Team > 0) then
	if (table.HasValue(ply.WMSelections, target)) then
	else
	table.insert(ply.WMSelections, target);
	end
	else
		if (mteam == target.Team) then
			if (table.HasValue(ply.WMSelections, target)) then
	else
	table.insert(ply.WMSelections, target);
	end
		end
	end
			end
		end
		ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
	end
	WMColor(ply)
end

function WMGiveOrder (ply, cmd, arg)
	local tr = ply:GetEyeTrace();
	if server_settings.Int( "WM_Pause", 0) ~= 1 then
	if #ply.WMSelections > 0 && tr.Hit then
		ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
		for k, x in pairs(ply.WMSelections) do
			if x ~= nil && x:IsValid() then
				x.Leader = nil;
				x.StartChase = nil;
				if x.Stance < 0 then
				  if x.Stance > -4 then
				  x.Stance = x.Stance * -1
				  else
				  x.Stance = x.Stance * -0.2
				  end
				end
				if ply:KeyDown(IN_WALK) then
				    if !tr.Entity:IsWorld() then
					x.Target = tr.Entity
					x.HoldFire = nil
					else
					x.Target = nil
					end
                else
				
				x.Orders = true;
				if !ply:KeyDown(IN_SPEED) then
					x.TargetVec = { };		  
				end
				table.insert(x.TargetVec, tr.HitPos)
				if ply:KeyDown(IN_USE) && !tr.Entity:IsWorld() then
					x.Leader = tr.Entity
				end
				if ply:KeyDown(IN_DUCK) then
					x.Patrol = 1;
				else
					x.Patrol = 0;
				end
				end
				if x.Move ~= true then
				x.TargetVec = nil
				x.Leader = nil
				end
			end
		end
	end
	end
end

function WMColor (ply)
	for k, melons in pairs(ply.WMSelections) do
	if melons:IsValid() then
	melons:SetMaterial("models/shiny")
	--melons:SetMaterial("models/props_c17/FurnitureMetal001a")
	end	
	end
end

function WMDeColor (ply)
	for k, melons in pairs(ply.WMSelections) do
	if melons:IsValid() then
	melons:SetMaterial("models/debug/debugwhite")
	end
	end
end

function WMTypeSelect (ply, cmd, arg)
WMDeColor(ply)
local sr = 1500
if ply:KeyDown(IN_USE) then
sr = 500
end
local mteam = ply:GetNWInt( "melonteam" )
local tr = ply:GetEyeTrace();
local etr = tr.Entity;
local Pos = tr.HitPos
	if !ply:KeyDown(IN_SPEED) then
	--don't clear if shift is held down, so we can select multiple groups of units
	ply.WMSelections = {};
	end
local type = etr:GetClass()
local cteam = etr.Team
local entz = ents.FindByClass(type);
	for k, v in pairs(entz) do
	if (v.Move == true) || ply:KeyDown(IN_USE) then
	if (mteam == 0) then
		if !ply:KeyDown(IN_WALK) then
		local dist = v:GetPos():Distance(Pos);
			if (dist <= sr || sr == 0) then
			table.insert(ply.WMSelections, v);
			end
		else
		table.insert(ply.WMSelections, v);
		end
	ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
	else
		if (v.Team == mteam) then
			if !ply:KeyDown(IN_WALK) then
			local dist = v:GetPos():Distance(Pos);
				if (dist <= sr || sr == 0) then
				table.insert(ply.WMSelections, v);
				end
			else
			table.insert(ply.WMSelections, v);
			end
		end
	ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
	end
	end
	end
WMColor(ply)
end

function WMStanceSelect(ply, cmd, arg)
	if #ply.WMSelections > 0 then
		ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
		for k, x in pairs(ply.WMSelections) do
			if x ~= nil && x:IsValid() then
			  if ply:KeyDown(IN_SPEED) || arg == 1 then
				ply:PrintMessage(HUD_PRINTCENTER, "Stance set to defensive");
			  x.Stance = 1;
			 	elseif ply:KeyDown(IN_WALK) || arg == 2 then
				ply:PrintMessage(HUD_PRINTCENTER, "Stance set to offensive");
			  x.Stance = 2;
			  elseif ply:KeyDown(IN_DUCK) || arg == 3 then
				ply:PrintMessage(HUD_PRINTCENTER, "Stance set to bezerk");
			  x.Stance = 3;
			   elseif ply:KeyDown(IN_USE) || arg == 4 then
				ply:PrintMessage(HUD_PRINTCENTER, "Melons will now hold fire");
			  x.HoldFire = 1;
			elseif ply:KeyDown(IN_JUMP) || arg == 5 then
				ply:PrintMessage(HUD_PRINTCENTER, "Melons will now fire at will");
			  x.HoldFire = nil;
			  else
				ply:PrintMessage(HUD_PRINTCENTER, "Stance set to stand ground");
			  x.Stance = 0;
			  end
			 end
    end
  end
end

function WMG1 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG1 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 1 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG1
	ply:PrintMessage(HUD_PRINTCENTER, "Group 1 Selected");
	
	end

end

function WMG2 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG2 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 2 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG2
	ply:PrintMessage(HUD_PRINTCENTER, "Group 2 Selected");
	end

end
function WMG3 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG3 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 3 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG3
	ply:PrintMessage(HUD_PRINTCENTER, "Group 3 Selected");
	end

end
function WMG4 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG4 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 4 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG4
	ply:PrintMessage(HUD_PRINTCENTER, "Group 4 Selected");
	end

end
function WMG5 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG5 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 5 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG5
	ply:PrintMessage(HUD_PRINTCENTER, "Group 5 Selected");
	end

end
function WMG6 (ply, cmd, arg)
	if ply:KeyDown(IN_DUCK) then
	ply.WMG6 = ply.WMSelections
	ply:PrintMessage(HUD_PRINTCENTER, "Group 6 Set");
	else
	WMDeColor(ply)
	ply.WMSelections = ply.WMG6
	ply:PrintMessage(HUD_PRINTCENTER, "Group 6 Selected");
	end

end

function ColorDamage(ent, HP, Col)
	if (ent.health <= (ent.maxhealth / HP)) then
		ent:SetColor(Color(Col, Col, Col, 255))
	end
end
local function RemoveEntity( ent )
	if (ent:IsValid()) then
		ent:Remove()
	end
end

local function Explode1( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos() + Vector( math.random(-60, 60), math.random(-60, 60), math.random(-60, 60) ))
			Effect:SetScale(1)
			Effect:SetMagnitude(25)
		util.Effect("Explosion", Effect, true, true)
	end
end

local function Explode2( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos())
			Effect:SetScale(3)
			Effect:SetMagnitude(100)
		util.Effect("Explosion", Effect, true, true)
		LS_RemoveEnt( ent )
	end
end

function LS_Destruct( ent, Simple )
	if (Simple) then
		Explode2( ent )
	else
		timer.Simple(1, Explode1, ent)
		timer.Simple(1.2, Explode1, ent)
		timer.Simple(2, Explode1, ent)
		timer.Simple(2, Explode2, ent)
	end
end

function LS_RemoveEnt( Entity )
	constraint.RemoveAll( Entity )
	timer.Simple( 1, RemoveEntity, Entity )
	Entity:SetNotSolid( true )
	Entity:SetMoveType( MOVETYPE_NONE )
	Entity:SetNoDraw( true )
end

--Life Support Stuff starts here


function ColorDamage(ent, HP, Col)
	if (ent.health <= (ent.maxhealth / HP)) then
		ent:SetColor(Color(Col, Col, Col, 255))
	end
end


function DamageLS(ent, dam)
	if not (ent and ent:IsValid() and dam) then return end
	if not ent.health then return end
	dam = math.floor(dam / 2)
	if (ent.health > 0) then
		local HP = ent.health - dam
		ent.health = HP
		if (ent.health <= (ent.maxhealth / 2)) then
			ent:Damage()
		end
		ColorDamage(ent, 2, 200)
		ColorDamage(ent, 3, 175)
		ColorDamage(ent, 4, 150)
		ColorDamage(ent, 5, 125)
		ColorDamage(ent, 6, 100)
		ColorDamage(ent, 7, 75)
		if (ent.health <= 0) then
			ent:SetColor(Color(50, 50, 50, 255))
			ent:Destruct()
		end
	end
end

local function RemoveEntity( ent )
	if (ent:IsValid()) then
		ent:Remove()
	end
end

local function Explode1( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos() + Vector( math.random(-60, 60), math.random(-60, 60), math.random(-60, 60) ))
			Effect:SetScale(1)
			Effect:SetMagnitude(25)
		util.Effect("Explosion", Effect, true, true)
	end
end

local function Explode2( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos())
			Effect:SetScale(3)
			Effect:SetMagnitude(100)
		util.Effect("Explosion", Effect, true, true)
		LS_RemoveEnt( ent )
	end
end

function LS_Destruct( ent, Simple )
	if (Simple) then
		Explode2( ent )
	else
		timer.Simple(1, Explode1, ent)
		timer.Simple(1.2, Explode1, ent)
		timer.Simple(2, Explode1, ent)
		timer.Simple(2, Explode2, ent)
	end
end

function LS_RemoveEnt( Entity )
	constraint.RemoveAll( Entity )
	timer.Simple( 1, RemoveEntity, Entity )
	Entity:SetNotSolid( true )
	Entity:SetMoveType( MOVETYPE_NONE )
	Entity:SetNoDraw( true )
end


function Wire_BuildDupeInfo( ent )
	if (not ent.Inputs) then return end
	
	local info = { Wires = {} }
	for k,input in pairs(ent.Inputs) do
		if (input.Src) and (input.Src:IsValid()) then
		    info.Wires[k] = {
				StartPos = input.StartPos,
				Material = input.Material,
				Color = input.Color,
				Width = input.Width,
				Src = input.Src:EntIndex(),
				SrcId = input.SrcId,
				SrcPos = Vector(0, 0, 0),
			}
			
			if (input.Path) then
				info.Wires[k].Path = {}
				
			    for _,v in ipairs(input.Path) do
			        if (v.Entity) and (v.Entity:IsValid()) then
			        	table.insert(info.Wires[k].Path, { Entity = v.Entity:EntIndex(), Pos = v.Pos })
					end
			    end
			    
			    local n = table.getn(info.Wires[k].Path)
			    if (n > 0) and (info.Wires[k].Path[n].Entity == info.Wires[k].Src) then
			        info.Wires[k].SrcPos = info.Wires[k].Path[n].Pos
			        table.remove(info.Wires[k].Path, n)
			    end
			end
		end
	end
	
	return info
end

function Wire_ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (info.Wires) then
		for k,input in pairs(info.Wires) do
		    
			Wire_Link_Start(ply:UniqueID(), ent, input.StartPos, k, input.Material, input.Color, input.Width)
		    
			if (input.Path) then
		        for _,v in ipairs(input.Path) do
					
					local ent2 = GetEntByID(v.Entity)
					if (!ent2) or (!ent2:IsValid()) then ent2 = ents.GetByIndex(v.Entity) end
					if (ent2) or (ent2:IsValid()) then
						Wire_Link_Node(ply:UniqueID(), ent2, v.Pos)
					else
						Msg("ApplyDupeInfo: Error, Could not find the entity for wire path\n")
					end
				end
		    end
			
			local ent2 = GetEntByID(input.Src)
		    if (!ent2) or (!ent2:IsValid()) then ent2 = ents.GetByIndex(input.Src) end
			if (ent2) or (ent2:IsValid()) then
				Wire_Link_End(ply:UniqueID(), ent2, input.SrcPos, input.SrcId)
			else
				Msg("ApplyDupeInfo: Error, Could not find the output entity\n")
			end
		end
	end
end

function WMJump(ply, cmd, arg)
	if #ply.WMSelections > 0 then
		ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
		for k, x in pairs(ply.WMSelections) do
  x:SetVelocity(x:GetVelocity() + Vector(0, 0, 500))
    end
  end
end

function WMEasyMode(ply, cmd, arg)
if ply:IsAdmin() then
game.ConsoleCommand("wm_buildradius 0\n")
game.ConsoleCommand("wm_toolcost 0\n")
game.ConsoleCommand("wm_normalpropspawning 1\n")
game.ConsoleCommand("wm_propcost 0\n")
game.ConsoleCommand("wm_rules 0\n") 
end
end


function WMSaveMap(ply, cmd, arg)
if ply:IsAdmin() then
local message = {}
	for k,v in pairs(ents.FindByClass("lap_cappoint")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "lap_cappoint")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	end
	for k,v in pairs(ents.FindByClass("lap_commuplink")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "lap_commuplink")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	end
	for k,v in pairs(ents.FindByClass("lap_spawnpoint")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local team = v.Team
	table.insert(message, "lap_spawnpoint")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, team)
	end
	for k,v in pairs(ents.FindByClass("lap_outpost")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local team = v.Team
	table.insert(message, "lap_outpost")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, team)
	end
	for k,v in pairs(ents.FindByClass("prop_*")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, v:GetClass())
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	end
	for k,v in pairs(ents.FindByClass("lap_resnode")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local res = v.Rez
	table.insert(message, "lap_resnode")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, res)
	end
file.Write("WM-RTS/" .. game.GetMap() .. ".txt", string.Implode("\n", message))
else
ply:PrintMessage(HUD_PRINTCENTER, "That command is admin only");
end
end

function LAPINIParser(ply)
if ply == nil || ply:IsAdmin() then
if file.Exists("WM-RTS/" .. game.GetMap() .. ".txt")then
local ini = file.Read("WM-RTS/" .. game.GetMap() .. ".txt")
local exploded = string.Explode("\n", ini);
--PrintTable(exploded)
local feature = 0
 for k, v in pairs (exploded) do
    if string.find(v, "lap_") == 1 || string.find(v, "prop_") == 1 then 
    local ent = ents.Create(v);
    ent:SetPos(Vector(exploded[k+1], exploded[k+2], exploded[k+3]))
    ent:SetAngles(Angle(exploded[k+4], exploded[k+6], exploded[k+5]))
    ent:SetModel(exploded[k+7])
    if v == "lap_resnode"  || v == "lap_commuplink" || string.find(v, "prop_") == 1 then
    ent.model = exploded[k+7]
    end
    if v == "lap_outpost" || v == "lap_spawnpoint" then
    ent.Team = tonumber(exploded[k+8])
    end
    if v == "lap_resnode" then
    ent.Rez = tonumber(exploded[k+8])
    end
    ent:Spawn();
    ent:Activate();
    if ent:GetPhysicsObject() ~= nil && ent:GetPhysicsObject():IsValid() then
    ent:GetPhysicsObject():EnableMotion(false)
    end
    end
 end



end
else
end
end

function SpawnedVehicle(userid, propid )

propid:Remove()
end


hook.Add( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
concommand.Add("+wmselect", WMSelectBegin);
concommand.Add("-wmselect", WMSelectEnd);
concommand.Add("wmeasymode", WMEasyMode);
concommand.Add("wmorder", WMGiveOrder);
concommand.Add("wmg1", WMG1);
concommand.Add("wmg2", WMG2);
concommand.Add("wmg3", WMG3);
concommand.Add("wmg4", WMG4);
concommand.Add("wmg5", WMG5);
concommand.Add("wmg6", WMG6);
concommand.Add("wmtypeselect", WMTypeSelect);
concommand.Add("wmstanceselect", WMStanceSelect);
concommand.Add("wmjump", WMJump);
concommand.Add("wmsavemap", WMSaveMap);
concommand.Add("wmspawnmap", LAPINIParser);
CreateConVar( "WM_Cost", "1" )
CreateConVar( "WM_Time", "1" )
CreateConVar( "WM_Toolcost", "1" )
CreateConVar( "WM_Buildradius", "1000" )
CreateConVar( "WM_Propcost", "3" )
CreateConVar( "WM_StartingNRG", "100000" )
CreateConVar( "WM_Melonspeed", "1" )
CreateConVar( "WM_Drowntime", "10" )
CreateConVar( "WM_Normalpropspawning", "0" )
CreateConVar( "WM_Cappointnrg", "1000" )
CreateConVar( "WM_healthtomass", "1.5" )
CreateConVar( "WM_flyingspeed", "0.75" )
CreateConVar( "WM_PlayersPerTeam", "1" )
CreateConVar( "WM_AllowTeamChanges", "1" )
CreateConVar( "WM_Pause", "0" )
CreateConVar( "WM_RezPerHarvest", "2500" )
CreateConVar( "WM_HoverCost", "2500" )
CreateConVar( "WM_WheelandThrusterCost", "4" )
CreateConVar( "WM_Domination", "1" )
timer.Simple(6, LAPINIParser)