TOOL.Category = "(WarMelons)"
TOOL.Name			= "#Spawn Point"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"

if ( CLIENT ) then
	language.Add( "Tool_lap_spawnpoints_name", "War Melon Spawn Points" )
	language.Add( "Tool_lap_spawnpoints_desc", "Creates an area to spawn melons" )
	language.Add( "Tool_lap_spawnpoints_0", "Left-click to spawn a warmelon spawn point. Right-click to display cost." )
	language.Add( "Undone_lap_spawnpoints", "Undone Spawn Point Warmelon" )

end
function TOOL:LeftClick (trace)
if ( SERVER ) then
if !trace.HitWorld then 
return false
end
	local ply = self:GetOwner()
	local Pos = trace.HitPos
	local Ang = trace.HitNormal
	local disfin = 0
	local entz = ents.FindByClass("lap_spawnpoint");
	local entz2 = ents.FindByClass("lap_outpost");
	local entz3 = ents.FindByClass("lap_resnode");
	local entz4 = ents.FindByClass("lap_commuplink");
  	local entz5 = ents.FindByClass("nobuildarea")
      	for k, v in pairs(entz5) do
      	if (v:GetPos():Distance(Pos) <= v.NoBuildRadius) then
        ply:PrintMessage(HUD_PRINTTALK, "Building in this area is restricted")
	return false
	end
      	end
	local cteam = 0
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local nrgsup = ply:GetNWInt( "nrg" )
	local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
	if (UsedSpawns[ply:Team()] == nil) then UsedSpawns[ply:Team()] = 0 end
	local cost = 50000 + (25000 * UsedSpawns[ply:Team()]) * toolcost
	for k, v in pairs(entz) do
	local dist = v:GetPos():Distance(Pos)
		if (v.Team ~= cteam && dist < 2500) then
		disfin = 1
		end
	end
	for k, v in pairs(entz2) do
	local dist = v:GetPos():Distance(Pos)
		if (v.Team ~= cteam && dist < 2500) then
		disfin = 1
		end
	end
	for k, v in pairs(entz3) do
	local dist = v:GetPos():Distance(Pos)
		if (dist < 1500) then
		disfin = 1
		end
	end
	for k, v in pairs(entz4) do
	local dist = v:GetPos():Distance(Pos)
		if (dist < 1500) then
		disfin = 1
		end
	end
if disfin ~= 1 then
if (trace.Hit && !trace.HitNoDraw) then
	 local dist = 160
	 local fail = false
	 local curpos = trace.HitPos + trace.HitNormal * 120
	 --doing things like this makes me feel dirty
	 	local vecs1 = { Vector(0,dist,0), Vector(0,-dist,0), Vector(dist,0,0), Vector(-dist,0,0), Vector(0,0,-dist + 40), Vector(0,0,dist+30)}
	for k,v  in pairs (vecs1) do
					local trace = {}
					trace.start = curpos
					trace.endpos = trace.start + v
					local traceRes = util.TraceLine(trace)
					local TraceLength = traceRes.Fraction
					if TraceLength < 1 then
					curpos = curpos - v
					end
     
	end 
	local vecs = { Vector(0,dist,0), Vector(0,-dist,0), Vector(dist,0,0), Vector(-dist,0,0), Vector(0,0,dist)}
	for k,v  in pairs (vecs) do
	local trace2 = {}
					trace2.start = curpos
					trace2.endpos = trace2.start + v
					local traceRes = util.TraceLine(trace2)
					local TraceLength = traceRes.Fraction
					if TraceLength < 1 then
					fail = true
					--Msg("fail")
					else
					--Msg("true")
					end
	end
	local trace3 = {}
					trace3.start = curpos + Vector(0,0,dist)
					trace3.endpos = trace3.start - Vector(0,0,dist)
					local traceRes = util.TraceLine(trace3)
					local TraceLength = traceRes.Fraction
					Msg(TraceLength .. " ")
					if TraceLength < 1 then
					fail = true
					--Msg("fail")
					else
					--Msg("true")
					end
	if fail then return false end
	if nrgsup >= cost || (FreeSpawns[ply:Team()] > 0 && !ply.UsedFreeSpawn) then
		melon = ents.Create ("lap_spawnpoint")
		melon.Cost = cost
		melon:SetPos (curpos)
		melon:SetAngles (Angle(0,0,0))
		melon.Team = cteam
		melon.Grav = 1
		melon:Spawn ()
		melon:Activate ()
		-- melon:CPPISetOwnerless(true) -- This function does not exist, and I cannot figure out how this ever worked?
		if FreeSpawns[ply:Team()] > 0 then
			FreeSpawns[ply:Team()] = FreeSpawns[ply:Team()] - 1
			melon.Built = 2
			ply.UsedFreeSpawn = true
		else
			if !NRGCheck(ply, cost) then return false end
			UsedSpawns[ply:Team()] = UsedSpawns[ply:Team()] + 1
		end
		upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true)
		trace.Entity:DeleteOnRemove(melon)
		undo.Create("lap_spawnpoints")
		undo.AddEntity (melon)
		undo.SetPlayer (self:GetOwner())
		undo.Finish()
		return true
	else 
	ply:PrintMessage(HUD_PRINTTALK, "You do not have enough nrg and your team has already used their free spawn points.")
	return false end
end
else
ply:PrintMessage(HUD_PRINTTALK, "Too close to another spawnpoint, outpost, uplink, or resource node.")
end
end
end

function TOOL:RightClick (trace)
	if (SERVER) then
		local ply = self:GetOwner()
		local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
		local cost
		if FreeSpawns[ply:Team()] > 0 then
			cost = 0
		else
			if (UsedSpawns[ply:Team()] == nil) then UsedSpawns[ply:Team()] = 0 end
			cost = 50000 + (25000 * UsedSpawns[ply:Team()]) * toolcost
		end

		WMSendCost(ply, cost, false)
	end
	return false
end

function TOOL:Think()
	model = "models/wmm/spawnpoint.mdl"
     if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != model) then
         self:MakeGhostEntity( model, Vector(0,0,0), Angle(0,0,0) )
     end
    
     self:UpdateGhostEnt( self.GhostEntity, self:GetOwner() )
 end
  
function TOOL:UpdateGhostEnt( ent, player )
  
     if ( !ent ) then return end
     if ( !ent:IsValid() ) then return end
  
     local tr    = util.GetPlayerTrace( player, player:GetAimVector() )
     local trace     = util.TraceLine( tr )
     if (!trace.Hit) then return end
    
     if (trace.Entity:IsPlayer() ) then
    
         ent:SetNoDraw( true )
         return
        
     end
	local ply = self:GetOwner()
    local eang = ply:EyeAngles()
	ent:SetAngles( Angle(0,0,0))
	
	local min = ent:OBBMins()
	ent:SetPos( trace.HitPos + trace.HitNormal * 120 )
	local dist = 100
	--doing things like this makes me feel dirty
	local vecs = { Vector(0,dist,0), Vector(0,-dist,0), Vector(dist,0,0), Vector(-dist,0,0), Vector(0,0,-dist), Vector(0,0,dist)}
	for k,v  in pairs (vecs) do
		trace.start = ent:GetPos()
		trace.endpos = trace.start + v
		local traceRes = util.TraceLine(trace)
		local TraceLength = traceRes.Fraction*100
		if TraceLength < 100 then
			ent:SetPos(ent:GetPos() - v)
		end
     
	end 
	ent:SetNoDraw( false )
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_spawnpoints_name", Description="#Tool_lap_spawnpoints_desc" })
					local VGUI = vgui.Create("WMHelpButton",CPanel)
					VGUI:SetTopic("Spawn Point")
					CPanel:AddPanel(VGUI)
	if LocalPlayer():IsAdmin() then
		CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "lap_spawnpoints_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
	end
end