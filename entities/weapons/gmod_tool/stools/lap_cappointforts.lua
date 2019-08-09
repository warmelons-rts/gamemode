TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#CapPoint Fortification"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "marine" ] = "0"

if (CLIENT) then
	language.Add( "Tool_lap_cappointforts_name", "Capture Point Fortifications" )
	language.Add( "Tool_lap_cappointforts_desc", "Secures a capture point location" )
	language.Add( "Tool_lap_cappointforts_0", "Left-click to spawn a capture point fortification. Right-click to display cost." )
	language.Add( "Undone_lap_cappointforts", "Undone Capture Point Fortification" )
end

function TOOL:LeftClick (trace)
	if ( SERVER ) then
		local ply = self:GetOwner()
		local cteam = 0
		local Pos = trace.Entity:GetPos()
		if trace.Entity:GetClass() ~= "lap_cappoint" then
			ply:PrintMessage(HUD_PRINTCENTER, "You must target a capture point.")
		return false

		else
			if trace.Entity.win == ply:Team() || ply:Team() == 0 then
				if !EnemyMelonCheck(ply, Pos) then return false end
				if trace.Entity.secured then
					ply:PrintMessage(HUD_PRINTCENTER, "That point is already secured.")
					return false
				end
			else
				ply:PrintMessage(HUD_PRINTCENTER, "You do not control that capture point.")
				return false
			end
		end
		
		if ply:Team() ~= 0 then
			cteam = ply:Team()
		else
			cteam = self:GetClientNumber("teamnumber")
		end
		local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
		local cost = math.floor((5000+self:GetClientNumber("marine")*2000)*toolcost)
		if !NRGCheck(ply, cost) then return false end
		if (trace.Hit && !trace.HitNoDraw ) then
			melon = ents.Create ("lap_capfort");
			melon.Cost = cost
			melon.CapturePoint = trace.Entity
			melon.Marine = self:GetClientNumber("marine") == 1;
			melon:SetPos (Pos - Vector(0,0,5));
			melon:SetAngles(trace.Entity:GetAngles());
			melon.Team = cteam;
			melon:Spawn ();
			--ply:AddCount('lap_melons', melon)
			melon:Activate ();
			melon:CPPISetOwnerless(true)
			upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true)
			trace.Entity:DeleteOnRemove(melon);
			undo.Create("lap_cappointforts");
			undo.AddEntity (melon);
			undo.AddEntity (upright)
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
		local cost = math.floor((5000+self:GetClientNumber("marine")*2000)*toolcost)
		WMSendCost(ply, cost, false)
	end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_cappointforts_name", Description="#Tool_lap_cappointforts_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Capture Point Fortification");
	CPanel:AddPanel(VGUI);
	if LocalPlayer():IsAdmin() then
		CPanel:AddControl ("Slider", {
			Label = "Team Number (Only applies on Team 0)",
			Command = "lap_cappointforts_teamnumber",
			Type = "Integer",
			Min = "1",
			Max = "6"
		} )
	end
	CPanel:AddControl( "Checkbox", {
		Label = "Marine",
		Description = "Check box and Cp Fort will survive in water.",
		Command = "lap_cappointforts_marine"
	} )
end
