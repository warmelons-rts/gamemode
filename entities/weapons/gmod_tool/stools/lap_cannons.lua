TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Cannons"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "1"
TOOL.ClientConVar[ "moving" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"

if (CLIENT) then
	language.Add( "Tool_lap_cannons_name", "Cannon turrets" )
	language.Add( "Tool_lap_cannons_desc", "Slow, longer range melons that fire a cannonshell" )
	language.Add( "Tool_lap_cannons_0", "Left-click to spawn a cannon. Right-click to display cost." )
	language.Add( "Undone_lap_cannons", "Undone Cannon" )
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
	local cost = (4000+self:GetClientNumber("moving")*2000-self:GetClientNumber("gravity")*2000)*toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("johnny_cannon");
	melon.Cost = cost
		if (self:GetClientNumber("welded") == 0) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 14.5);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam;
	melon.Move = self:GetClientNumber ("moving") == 1;
	melon.Grav = self:GetClientNumber("gravity") == 1;
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(true);
	if (self:GetClientNumber("welded") == 1) && (self:GetClientNumber("moving") == 0) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("lap_cannons");
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
local cost = (4000+self:GetClientNumber("moving")*2000-self:GetClientNumber("gravity")*2000)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)

	CPanel:AddControl ("Header", { Text="#Tool_lap_cannons_name", Description="#Tool_lap_cannons_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Cannon");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
        CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "lap_cannons_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
    end
--	end
	--CPanel:AddControl( "Checkbox", {
	--	Label = "Gravity toggle",
	--	Description = "Uncheck box to make melons have no gravity",
	--	Command = "lap_cannons_gravity"
	--} )
	CPanel:AddControl( "Checkbox", {
		Label = "Mobile and Commandable",
		Description = "Uncheck box and melons will not be able to move",
		Command = "lap_cannons_moving"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld (Only when not mobile)",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "lap_cannons_welded"
	} )
end
