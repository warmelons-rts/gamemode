TOOL.Category		= "(WarMelons)"
TOOL.Name		= "#Medics"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "1"
TOOL.ClientConVar[ "moving" ] = "0"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "effects" ] = "1"

if (CLIENT) then
	language.Add( "Tool_medics_name", "Medic War Melons" )
	language.Add( "Tool_medics_desc", "Healing melons" )
	language.Add( "Tool_medics_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_medics", "Undone Warmelon" )
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
	local cost = (4500+self:GetClientNumber("moving")*1500-self:GetClientNumber("gravity")*3000)*toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("johnny_medic");
	melon.Cost = cost
		if (self:GetClientNumber("welded") == 0) || !trace.HitWorld then
		melon:SetPos (trace.HitPos + trace.HitNormal * 9);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		melon.Welded = true
		end
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam
	melon.Move = self:GetClientNumber ("moving") == 1;
	melon.Grav = self:GetClientNumber("gravity") == 1;
	melon.LOLFX = self:GetClientNumber("effects") == 1;
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(true);
	if (self:GetClientNumber("welded") == 1) && (self:GetClientNumber("moving") == 0) && trace.HitWorld then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("medics");
    undo.AddEntity (melon);
    cleanup.Add( ply, "WarMelons", melon )
	if (self:GetClientNumber("welded") == 1) && (self:GetClientNumber("moving") == 0) then undo.AddEntity (upright) end
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
local cost = (4500+self:GetClientNumber("moving")*1500-self:GetClientNumber("gravity")*3000)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end


function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_medics_name", Description="#Tool_medics_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Medic");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "medics_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
end
--	CPanel:AddControl( "Checkbox", {
--		Label = "Gravity Toggle",
--		Description = "Uncheck box to make melons have no gravity",
--		Command = "medics_gravity"
--	} )

	CPanel:AddControl( "Checkbox", {
		Label = "Mobile and Commandable",
		Description = "Whether or not the melon will respond to the command STOOL",
		Command = "medics_moving"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld (Only when not mobile)",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "medics_welded"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Visual Healing Effect",
		Description = "Uncheck, and medics will not produce visual healing effects.",
		Command = "medics_effects"
	} )
end
