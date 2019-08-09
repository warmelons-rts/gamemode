TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Mortars"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"

if (CLIENT) then
	language.Add( "Tool_lap_mortar_name", "Mortars" )
	language.Add( "Tool_lap_mortar_desc", "Fires in a parabolic arc. (Always shoots at an upward angle!" )
	language.Add( "Tool_lap_mortar_0", "Left-click to spawn a mortar cannon. Right-click to display cost." )
	language.Add( "Undone_lap_mortar", "Undone mortar" )
	language.Add( 'SBoxLimit_lap_melons', 'Personal Melon Limit Reached' )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
if ( !self:GetSWEP():CheckLimit( "lap_melons" ) ) then return false end
	local ply = self:GetOwner()
	local Pos = trace.HitPos
	local Ang = trace.HitNormal
	local cteam = 0
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
	local cost = (5000)*toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	local eang = ply:EyeAngles()
	melon = ents.Create ("lap_mortar");
	melon.Cost = cost
		if (self:GetClientNumber("welded") == 0) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 14.5);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon:SetAngles (trace.HitNormal:Angle()+Angle(90, 0, 0));
	melon.Team = cteam;
	melon.Grav = true;
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("lap_mortar");
    undo.AddEntity (melon);
    cleanup.Add( ply, "WarMelons", melon )
	if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
    undo.SetPlayer (self:GetOwner());
	undo.Finish();
	return true;
end
end
end

function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
local cost = (5000)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)

	CPanel:AddControl ("Header", { Text="#Tool_lap_mortar_name", Description="#Tool_lap_mortar_desc" })
local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Mortar");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then	
	CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "lap_mortar_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
	end
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "lap_mortar_welded"
	} )
end
