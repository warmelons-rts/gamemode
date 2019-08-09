TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Fighters"
TOOL.Command		= nil
TOOL.ConfigName		= ""
cleanup.Register("WarMelons")
TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "type" ] = "1"

if (CLIENT) then
	language.Add( "Tool_fightars_name", "Fighter WarMelon" )
	language.Add( "Tool_fightars_desc", "Standard melons that attack enemies" )
	language.Add( "Tool_fightars_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_fightars", "Undone Fighter Melon" )
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
	local type = self:GetClientNumber("type")
	local cost
	if type  == 1 then
	cost = 500
	elseif type  == 2 then
	cost = 1500
	elseif type  == 3 || type  == 4 then
	cost = 2000
	elseif type  == 5 then
	cost = 2500
	end
	cost = cost*toolcost
	if InBaseRange(ply, Pos) then 
        if !NRGCheck(ply, cost) then return false end
    else
    return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("johnny_fighter");
		if (type  ~= 1) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 9);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
	melon.Cost = cost
	melon:SetAngles (Ang:Angle());
	melon.Team = cteam
	if type ~= 1 then
	melon.Move = true
	end
	if type == 4 then
	melon.Blink = true
	end
	if type  == 5 then
	melon.Grav = false
	else
	melon.Grav = true
	end
	melon.Marine = type  == 3;
	melon:Spawn ();
	ply:AddCount('lap_melons', melon)
	melon:Activate ();
	if type  == 5 then
	melon:GetPhysicsObject():EnableGravity(false);
	else
	melon:GetPhysicsObject():EnableGravity(true);
	end
	if (type  == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("fightars");
    undo.AddEntity (melon);
	if (type  == 1) then undo.AddEntity (upright) end
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
local cost
local type = self:GetClientNumber("type")	
	if type  == 1 then
	cost = 500
	elseif type  == 2 then
	cost = 1500
	elseif type  == 3 || type  == 4 then
	cost = 2000
	elseif type  == 5 then
	cost = 2500
	end
cost = cost*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_fightars_name", Description="#Tool_fightars_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Fighter");
	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "fightars_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "7"
	} )
	end
	CPanel:AddControl("Label", { Text = "Type", Description = "Type"})
	local choices = {Label = "Types", MenuButton = "0", Options = {}}
	choices.Options["Immobile Turrets ($)"] = {fightars_type = "1"}
	choices.Options["Standard ($$$)"] = {fightars_type = "2"}
	choices.Options["Marine Fighter ($$$$)"] = {fightars_type = "3"}
	choices.Options["Blink Fighter ($$$$)"] = {fightars_type = "4"}
	choices.Options["Aerial Dogfighters ($$$$$)"] = {fightars_type = "5"}
	CPanel:AddControl( "ComboBox", choices )
end
