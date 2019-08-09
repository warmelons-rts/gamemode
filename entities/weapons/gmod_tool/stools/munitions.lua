TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Munitions Factory"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "type" ] = "1"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "type" ] = "1"
TOOL.ClientConVar[ "dtype" ] = "1"
TOOL.ClientConVar[ "detonate" ] = "0"
TOOL.ClientConVar[ "contact" ] = "0"
TOOL.ClientConVar[ "melonlimit" ] = "0"
TOOL.ClientConVar[ "load" ] = "0"

if (CLIENT) then
	language.Add( "Tool_munitions_name", "Munitions Factory" )
	language.Add( "Tool_munitions_desc", "Continually spawns bombs" )
	language.Add( "Tool_munitions_0", "Left-click to spawn a munitions factory. Right-click to display cost." )
	language.Add( "Undone_munitions", "Undone Munitions Factory" )
	language.Add( 'SBoxLimit_lap_barracks', 'Maximum Barracks/Factories Reached' )
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
		local missile = 0
		if self:GetClientNumber("dtype") == 4 then missile = 1 end
		local cost = (2500+missile*15000)*toolcost
		if !NRGCheck(ply, cost) then return false end
		if (trace.Hit && !trace.HitNoDraw) then
			melon = ents.Create ("lap_munitions");
				melon.Cost = cost;
				melon:SetPos (trace.HitPos + trace.HitNormal * 1);
				melon:SetAngles (trace.HitNormal:Angle());
				melon.Team = cteam
				melon.Grav = true;
				--melon.MelonGrav = self:GetClientNumber("melongravity") == 1;
				melon.MelonGrav = util.tobool(missile - 1) 
				if self:GetClientNumber("dtype") == 1 || self:GetClientNumber("dtype") == 4 then
					melon.Mine = 0
				elseif self:GetClientNumber("dtype") == 2 then
					melon.Mine = 1
				elseif self:GetClientNumber("dtype") == 3 then
					melon.Mine = 2
				end
				melon.Payload = self:GetClientNumber("type")
				melon.DetonateOn = self:GetClientNumber("detonate")
				melon.MaxMelons = self:GetClientNumber("melonlimit");
				melon:Spawn ();
				ply:AddCount('lap_barracks', melon)
				melon:Activate ();
			
			melon:GetPhysicsObject():EnableGravity(true);
			if (self:GetClientNumber("load") ~= 1) then melon.Stance = 2 end
			if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
			trace.Entity:DeleteOnRemove(melon);
			
			undo.Create("munitions");
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
		local missile = 0
		if self:GetClientNumber("dtype") == 4 then missile = 1 end
		local cost = (2500+missile*15000)*toolcost
		WMSendCost(ply, cost, false)
	end
	return true
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_munitions_name", Description="#Tool_munitions_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Munitions Factory");
    	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
		CPanel:AddControl ("Slider", {
			Label = "Team Number (Only applies on Team 0)",
			Command = "munitions_teamnumber",
			Type = "Integer",
			Min = "1",
			Max = "6"
		} )
	end
	CPanel:AddControl("Label", { Text = "These factories produce bombs, up to the specified maximum. Each bomb will deduct NRG from your team's NRG. You can give the factory waypoints, patrols, and leaders.To stop production of a factory, give it a hold fire order." })
    CPanel:AddControl ("Slider", {
		Label = "Melon Limit (0 for none)",
		Command = "munitions_melonlimit",
		Type = "Integer",
		Min = "0",
		Max = "25"
	} )	
	CPanel:AddControl("Label", { Text = "Delivery Type", Description = "Type of Explosive"})
	local choices2 = {Label = "Delivery Type", MenuButton = "0", Options = {}}
	choices2.Options["Bomb"] = {munitions_dtype = "1"}
	choices2.Options["Mine"] = {munitions_dtype = "2"}
	choices2.Options["Deployable Mine"] = {munitions_dtype = "3"}
	choices2.Options["Missile"] = {munitions_dtype = "4"}
	CPanel:AddControl( "ComboBox", choices2 )
	
	CPanel:AddControl("Label", { Text = "Payload Type", Description = "Bomb Payload"})
	local choices = {Label = "Payload Type", MenuButton = "0", Options = {}}
	choices.Options["Standard Explosive"] = {munitions_type = "1"}
	choices.Options["Cluster Bomb"] = {munitions_type = "2"}
	choices.Options["Slime"] = {munitions_type = "3"}
	choices.Options["Flak (Missile-Only)"] = {munitions_type = "4"}
	--choices.Options["Acid"] = {munitions_type = "5"}
	CPanel:AddControl( "ComboBox", choices )
	
	CPanel:AddControl("Label", { Text = "Detonate On Proximity to...", Description = "Detontation Parameters"})
	local choices3 = {Label = "Detonate On Proximity to...", MenuButton = "0", Options = {}}
	choices3.Options["Any Enemy"] = {munitions_detonate = "0"}
	choices3.Options["Just Melons"] = {munitions_detonate = "1"}
	choices3.Options["Props or Vehicles"] = {munitions_detonate = "2"}
	--choices.Options["Acid"] = {munitions_type = "5"}
	CPanel:AddControl( "ComboBox", choices3 )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Explode On Contact",
		Description = "Check and your explosive will explode if it touches enemies or the world.",
		Command = "munitions_contact"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and the factory will not be attached to what you shoot at",
		Command = "munitions_welded"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Load nearby launchers",
		Description = "Check and the factory will load a launcher if its in a 250 unit radius.",
		Command = "munitions_load"
	} )
	
end
