TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Light Fighters"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "type" ] = "2"
if (CLIENT) then
	language.Add( "Tool_l_fightars_name", "Light Fighters" )
	language.Add( "Tool_l_fightars_desc", "Fast and weak short range units" )
	language.Add( "Tool_l_fightars_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_l_fightars", "Undone Light Fighter" )
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
	local cost
	local type = self:GetClientNumber("type")
	if type  == 1 then
	cost = 250
	elseif type  == 2 then
	cost = 500
	elseif type  == 3 then
	cost = 750
	else
	cost = 1000
	end
	cost = cost * toolcost
	if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("johnny_lightfighter");
	melon.Cost = cost
	--local min = melon:OBBMins()
		if (type  ~= 1) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 9);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam
	if type  ~= 1 then
	melon.Move = true
	end
	if type  == 3 then
	melon.Phasing = true
	end
	if type  == 4 then
	melon.Grav = false
	else
	melon.Grav = true
	end
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	if type  == 4 then
	melon:GetPhysicsObject():EnableGravity(false);
	else
	melon:GetPhysicsObject():EnableGravity(true);
	end
	if (type  == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("l_fightars");
    undo.AddEntity (melon);
    cleanup.Add( ply, "Light Fighter", melon )
	if (type  == 1) then undo.AddEntity (upright) end
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
	local cost
	local type = self:GetClientNumber("type")
	if type  == 1 then
	cost = 250
	elseif type  == 2 then
	cost = 500
	elseif type  == 3 then
	cost = 750
	else
	cost = 1000
	end
	cost = cost * toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_l_fightars_name", Description="#Tool_l_fightars_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Light Fighter");
	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "l_fightars_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
    end
	CPanel:AddControl("Label", { Text = "Type", Description = "Type"})
	local choices = {Label = "Types", MenuButton = "0", Options = {}}
	choices.Options["Immobile Turrets ($)"] = {l_fightars_type = "1"}
	choices.Options["Standard ($$)"] = {l_fightars_type = "2"}
	choices.Options["Phase Inflitrators ($$$)"] = {l_fightars_type = "3"}
	choices.Options["Aerial Dogfighters ($$$$)"] = {l_fightars_type = "4"}
	CPanel:AddControl( "ComboBox", choices )
end
