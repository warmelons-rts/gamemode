TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Strikers"
TOOL.Command		= nil
TOOL.ConfigName		= ""
cleanup.Register("wm_melon")
TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "moving" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"

if (CLIENT) then
	language.Add( "Tool_lap_strikers_name", "Striker WarMelon" )
	language.Add( "Tool_lap_strikers_desc", "Dive bomber aircraft. (NEED TO BE MOVING TO FIRE)" )
	language.Add( "Tool_lap_strikers_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_lap_strikers", "Undone Striker Melon" )
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
	local cost = (6000)*toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("lap_striker");
	melon.Cost = cost
		if (self:GetClientNumber("welded") == 0) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 9);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon:SetAngles (Ang:Angle());
	melon.Team = cteam
	melon.Move = true;
	melon.Grav = false;
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(self:GetClientNumber("gravity") == 1);
	if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("strikers");
    undo.AddEntity (melon);
	if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
    undo.SetPlayer (self:GetOwner());
	undo.Finish();
    cleanup.Add( ply, "WarMelons", melon )
	return true;
end
end
end


function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
local cost = (6000)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_strikers_name", Description="#Tool_strikers_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Striker");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "lap_strikers_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
end
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "lap_strikers_welded"
	} )

end