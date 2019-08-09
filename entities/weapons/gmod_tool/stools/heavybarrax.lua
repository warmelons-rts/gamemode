TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#HeavyBarracks"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "1"
TOOL.ClientConVar[ "melongravity" ] = "1"
TOOL.ClientConVar[ "moving" ] = "1"
TOOL.ClientConVar[ "melonmarine" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "followrange" ] = "0"
TOOL.ClientConVar[ "melonlimit" ] = "0"

if (CLIENT) then
	language.Add( "Tool_heavybarrax_name", "Heavy Barracks" )
	language.Add( "Tool_heavybarrax_desc", "Spawns fighter melons to provide fire support" )
	language.Add( "Tool_heavybarrax_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_heavybarrax", "Undone Heavy Barracks" )
	language.Add( 'SBoxLimit_lap_barracks', 'Maximum Barracks Reached' )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
if ( !self:GetSWEP():CheckLimit( "lap_barracks" ) ) then return false end
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
	local cost = (10000-self:GetClientNumber("melongravity")* 5000 + self:GetClientNumber("melonmarine") * 2500)*toolcost
	if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("lap_heavybarracks");
	melon.Cost = cost
	melon:SetPos (trace.HitPos + trace.HitNormal * 1);
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam;
	melon.Grav = true
	melon.MelonMarine = self:GetClientNumber("melonmarine") == 1;
	melon.MelonGrav = self:GetClientNumber("melongravity") == 1;
	melon.FollowRange = self:GetClientNumber("followrange");
	melon.MaxMelons = self:GetClientNumber("melonlimit");
	melon.Orders = true;
	melon.TargetVec = self.TargetVec;
	melon.Barracks = self.Entity;
	melon:Spawn ();
	ply:AddCount('lap_barracks', melon)
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(true);
	if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("heavybarrax");
    undo.AddEntity (melon);
	if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
    undo.SetPlayer (self:GetOwner());
	undo.Finish();
return true
end
end
end

function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
local cost = (10000-self:GetClientNumber("melongravity")* 5000 + self:GetClientNumber("melonmarine") * 2500)*toolcost

WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_heavybarrax_name", Description="#Tool_heavybarrax_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Heavy Barracks");
	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "heavybarrax_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
	end
	CPanel:AddControl("Label", { Text = "These barracks produce fighters, up to the specified maximum. Each fighter will deduct NRG from your team's NRG. You can give the barracks waypoints, patrols, and leaders.To stop production of a barracks, give it a hold fire order." })
    CPanel:AddControl ("Slider", {
		Label = "Melon Limit (0 for none)",
		Command = "heavybarrax_melonlimit",
		Type = "Integer",
		Min = "0",
		Max = "25"
	} )		
	CPanel:AddControl ("Slider", {
		Label = "Following Range (0 for none)",
		Command = "heavybarrax_followrange",
		Type = "Float",
		Min = "0",
		Max = "4096"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Melon Gravity toggle",
		Description = "Uncheck box to make melons have no gravity",
		Command = "heavybarrax_melongravity"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Melon Marine toggle",
		Description = "Check box to make produced melons amphibious",
		Command = "heavybarrax_melonmarine"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and barracks will not be attached to what you shoot at",
		Command = "heavybarrax_welded"
	} )
end
