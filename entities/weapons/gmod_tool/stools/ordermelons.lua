TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Order Cores"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "1"
TOOL.ClientConVar[ "moveforce" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "damping" ] = "1.2"
TOOL.ClientConVar[ "marine" ] = "0"
TOOL.ClientConVar[ "ZOnly" ] = "0"

if (CLIENT) then
	language.Add( "Tool_ordermelons_name", "Orderable Melon Cores" )
	language.Add( "Tool_ordermelons_desc", "Unarmed warmelons to pull your contraptions with" )
	language.Add( "Tool_ordermelons_0", "Left-click to spawn a warmelon. Right-click to display cost." )
	language.Add( "Undone_ordermelons", "Undone Order Core" )
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
	local cost = math.floor((5000+self:GetClientNumber("moveforce")*4+self:GetClientNumber("damping")*100-self:GetClientNumber("gravity")*1000+self:GetClientNumber("marine")*500)*toolcost*GetConVarNumber("WM_OrderCoreCost", 0.5))
	local fcost = math.floor(self:GetClientNumber("moveforce")*4*toolcost*GetConVarNumber("WM_OrderCoreCost", 0.5))
	if (trace.Hit && trace.Entity:IsValid() && trace.Entity:GetClass() == "johnny_ordermelon") then
	    if !NRGCheck(ply, fcost) then return false end
		--We've shot an order core. We should update the melon's force to the new move force setting in the context panel.		
		trace.Entity.MovingForce = self:GetClientNumber("moveforce");
		return true;
	else 
		if (trace.Hit && !trace.HitNoDraw) then

        if !NRGCheck(ply, cost) then return false end
--		if trace.Entity:GetClass("johnny_ordermelon") && trace.Entity.Team == ply:Team() then
--		melon = trace.Entity
--		else
		melon = ents.Create ("johnny_ordermelon");
		if (self:GetClientNumber("welded") == 0) then
		melon:SetPos (trace.HitPos + trace.HitNormal * 12);
		else
		melon:SetPos (trace.HitPos + trace.HitNormal);
		end
		melon:SetAngles (trace.HitNormal:Angle());
		melon.Team = cteam;
		melon.Cost = cost;
		--end
		melon.MovingForce = self:GetClientNumber("moveforce");
		melon.Damping = self:GetClientNumber("damping");
		melon.Grav = self:GetClientNumber("gravity") == 1;
		melon.Marine = self:GetClientNumber("marine") == 1;
		melon.ZOnly = self:GetClientNumber("ZOnly") == 1;
		melon:Spawn ();
	ply:AddCount('lap_melons', melon)
		melon:Activate ();
		melon:GetPhysicsObject():EnableGravity(self:GetClientNumber("gravity") == 1);
		if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
		trace.Entity:DeleteOnRemove(melon);
		undo.Create("ordermelons");
		undo.AddEntity (melon);
		cleanup.Add( ply, "WarMelons", melon )
		if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
		undo.SetPlayer (self:GetOwner());
		undo.Finish();
		return true;
        end
		end
	end
end

function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
local cost = math.floor((5000+self:GetClientNumber("moveforce")*4+self:GetClientNumber("damping")*100-self:GetClientNumber("gravity")*1000+self:GetClientNumber("marine")*500)*toolcost*GetConVarNumber("WM_OrderCoreCost", 0.5))
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_ordermelons_name", Description="#Tool_ordermelons_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Order Core");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team Number (Only applies on Team 0)",
		Command = "ordermelons_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
end
	CPanel:AddControl( "Checkbox", {
		Label = "Gravity Toggle",
		Description = "Uncheck box to make melons have no gravity",
		Command = "ordermelons_gravity"
	} )
		CPanel:AddControl( "Checkbox", {
		Label = "No Z-Axis Movement Toggle",
		Description = "Check to make the melon not move up or down",
		Command = "ordermelons_ZOnly"
	} )
	CPanel:AddControl ("Slider", {
		Label = "Movement Force",
		Command = "ordermelons_moveforce",
		Type = "Float",
		Min = "1",
		Max = "50000"
	} )
	CPanel:AddControl ("Slider", {
		Label = "Braking Power",
		Command = "ordermelons_damping",
		Type = "Float",
		Min = "0",
		Max = "20"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "ordermelons_welded"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Marine",
		Description = "Check box and melons will be able to traverse water unharmed",
		Command = "ordermelons_marine"
	} )
end
