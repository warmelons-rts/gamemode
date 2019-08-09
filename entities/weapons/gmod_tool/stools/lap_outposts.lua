TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Outposts"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "teamnumber" ] = "1"
if (CLIENT) then
	language.Add( "Tool_lap_outposts_name", "WarMelon Outpost" )
	language.Add( "Tool_lap_outposts_desc", "Allows the building of props in the immediate area." )
	language.Add( "Tool_lap_outposts_0", "Left-click to spawn an outpost. Right-click to display cost." )
	language.Add( "Undone_lap_outposts", "Undone WarMelon Outpost" )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
if !trace.HitWorld then 
return false
end
	local Pos = trace.HitPos
	local Ang = trace.HitNormal
	local ply = self:GetOwner()
	local disfin = 0
	local entz = ents.FindByClass("lap_spawnpoint");
	local entz2 = ents.FindByClass("lap_outpost");
	local entz3 = ents.FindByClass("lap_resnode");
  	local entz4 = ents.FindByClass("nobuildarea")
  	local entz5 = ents.FindByClass("lap_commuplink")
      	for k, v in pairs(entz4) do
      	if (v:GetPos():Distance(Pos) <= v.NoBuildRadius) then
        ply:PrintMessage(HUD_PRINTTALK, "Building in this area is restricted");
	return false
	end
      	end
	local cteam = 9;
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local nrgsup = ply:GetNWInt( "nrg" )
	local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
	local cost = 20000*toolcost
	for k, v in pairs(entz) do
	local dist = v:GetPos():Distance(Pos);
		if (v.Team ~= cteam && dist < 2500) then
		disfin = 1
		end
	end
	for k, v in pairs(entz2) do
	local dist = v:GetPos():Distance(Pos);
		if (v.Team ~= cteam && dist < 2500) then
		disfin = 1
		end
	end
	for k, v in pairs(entz3) do
	local dist = v:GetPos():Distance(Pos);
		if (dist < 1250) then
		disfin = 1
		end
	end
	for k, v in pairs(entz5) do
	local dist = v:GetPos():Distance(Pos);
		if (dist < 1500) then
		disfin = 1
		end
	end
if disfin ~= 1 then
if (trace.Hit && !trace.HitNoDraw && nrgsup >= cost) then
	ply:SetNWInt( "nrg" , nrgsup - cost)
	melon = ents.Create ("lap_outpost");
	melon.Cost = cost
	melon:SetPos (trace.HitPos + trace.HitNormal * 10);
	melon:SetAngles (Angle(0,0,0));
	melon.Team = cteam;
	melon:Spawn ();
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(1);
	melon:CPPISetOwnerless(true) --So people cant start owning stuff (good as disconnected players stuff clean up)
	upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true)
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("relay");
    undo.AddEntity (melon);
	 undo.AddEntity (upright)
    undo.SetPlayer (self:GetOwner());
	undo.Finish();
	return true;
	else 
	local message = "Your NRG:" .. ply:GetNWInt( "nrg" ) .. " Cost: " .. cost
	ply:PrintMessage(HUD_PRINTTALK, message)
	return false end
else
ply:PrintMessage(HUD_PRINTTALK, "Too close to another spawnpoint, outpost, uplinks or resource node.")
end
end
end


function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
local cost = 20000*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_outposts_name", Description="#Tool_lap_outposts_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Outpost");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "lap_outposts_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
	end
end
