TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Barracks"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "1"
TOOL.ClientConVar[ "melongravity" ] = "1"
TOOL.ClientConVar[ "moving" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "followrange" ] = "0"
TOOL.ClientConVar[ "melonlimit" ] = "0"

if (CLIENT) then
	language.Add( "Tool_barrax_name", "Barracks" )
	language.Add( "Tool_barrax_desc", "Spawns weak melons to provide fire support" )
	language.Add( "Tool_barrax_0", "Left-click to spawn a barracks. Right-click to display cost. Reload to update limit and range." )
	language.Add( "Undone_barrax", "Undone Barracks" )
	language.Add( 'SBoxLimit_lap_barracks', 'Maximum Barracks Reached' )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
if ( !self:GetSWEP():CheckLimit( "lap_barracks" ) ) then return false end
    local ply = self:GetOwner()
    local cteam
    if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
	local cost = (8000-self:GetClientNumber("melongravity")*4000)*toolcost
	if !NRGCheck(ply, cost) then return false end
    if (trace.Hit && !trace.HitNoDraw) then
    melon = ents.Create ("johnny_barracks");
    melon.Cost = cost
    melon:SetPos (trace.HitPos + trace.HitNormal * 1);
    melon:SetAngles (trace.HitNormal:Angle());
    melon.Team = cteam
    melon.Grav = true
    melon.MelonGrav = self:GetClientNumber("melongravity") == 1;
    melon.FollowRange = self:GetClientNumber("followrange");
    melon.MaxMelons = self:GetClientNumber("melonlimit");
    melon:Spawn ();
    ply:AddCount('lap_barracks', melon)
    melon:Activate ();
    melon:GetPhysicsObject():EnableGravity(true);
    if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
    trace.Entity:DeleteOnRemove(melon);
    undo.Create("barrax");
    undo.AddEntity (melon);
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
local cost = (8000-self:GetClientNumber("melongravity")*4000)*toolcost

WMSendCost(ply, cost, false)
end
	return false
end

function TOOL:Reload(trace)
if (SERVER) then
    local ply = self:GetOwner()
    local target = trace.Entity:GetClass()
    if target == "johnny_barracks" || target == "lap_heavybarracks" || target == "lap_munitions" then
    trace.Entity.FollowRange = self:GetClientNumber("followrange");
    trace.Entity.MaxMelons = self:GetClientNumber("melonlimit");
    ply:PrintMessage(HUD_PRINTCENTER, "Follow range and melon limits updated.")
    else
    ply:PrintMessage(HUD_PRINTCENTER, "Target a barracks, heavy barracks, or munitions factory.")
    end
end

end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_barrax_name", Description="#Tool_barrax_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Barracks");
    CPanel:AddPanel(VGUI);
    	if LocalPlayer():IsAdmin() then
		CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "barrax_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "7"
	} )
	   end
	CPanel:AddControl("Label", { Text = "These barracks produce light fighters, up to the specified maximum. Each light fighter will deduct NRG from your team's NRG. You can give the barracks waypoints, patrols, and leaders.To stop production of a barracks, give it a hold fire order." })
    CPanel:AddControl ("Slider", {
		Label = "Melon Limit (0 for none)",
		Command = "barrax_melonlimit",
		Type = "Integer",
		Min = "0",
		Max = "25"
	} )	
    CPanel:AddControl ("Slider", {
		Label = "Following Range (0 for none)",
		Command = "barrax_followrange",
		Type = "Float",
		Min = "0",
		Max = "4096"
	} )
	CPanel:AddControl("Label", { Text = "Setting a follow range of anything but 0 will cause melons to stay near their barracks." })
	CPanel:AddControl( "Checkbox", {
		Label = "Melon Gravity toggle",
		Description = "Uncheck box to make melons have no gravity",
		Command = "barrax_melongravity"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and barracks will not be attached to what you shoot at",
		Command = "barrax_welded"
	} )

end
