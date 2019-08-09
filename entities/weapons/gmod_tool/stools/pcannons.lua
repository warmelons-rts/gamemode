TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Plasma Cannons"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"

if (CLIENT) then
	language.Add( "Tool_pcannons_name", "Plasma Cannons" )
	language.Add( "Tool_pcannons_desc", "Slow, powerful area of effect flechette with low accuracy" )
	language.Add( "Tool_pcannons_0", "Left-click to spawn a plasma cannon. Right-click to display cost." )
	language.Add( "Undone_pcannons", "Undone Plasma Cannon" )
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
	local cost = (6000+self:GetClientNumber("moving")*3000-self:GetClientNumber("gravity")*3000)*toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("johnny_pcannon");
		if (self:GetClientNumber("welded") == 0) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 20);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon.Cost = cost
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam
	melon.Grav = true
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(true);
	if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("pcannons");
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
local cost = (6000+self:GetClientNumber("moving")*3000-self:GetClientNumber("gravity")*3000)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_pcannons_name", Description="#Tool_pcannons_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Plasma Cannon");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "pcannons_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
end
--	CPanel:AddControl( "Checkbox", {
--		Label = "Gravity toggle",
--		Description = "Uncheck box to make melons have no gravity",
--		Command = "pcannons_gravity"
--	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "pcannons_welded"
	} )
end
