TOOL.Category		= "(WarMelons-ADMIN)"
TOOL.Name			= "#NRG Setter"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "totalnrg" ] = "0"
TOOL.ClientConVar[ "add" ] = "0"
TOOL.ClientConVar[ "playa" ] = "1"
if (CLIENT) then
	language.Add( "Tool_lap_adminnrg_name", "NRG Setter" )
	language.Add( "Tool_lap_adminnrg_desc", "Sets and modifys players NRG (ADMIN ONLY)" )
	language.Add( "Tool_lap_adminnrg_0", "Left-click to modify a player's NRG by ID. Right-click for self. Reload to see all player NRGs. (Admin only)." )
	language.Add( "Undone_adminnrg", "Undone NRG Modificationr" )
end

function TOOL:LeftClick (trace)
if (SERVER) then
	if (self:GetOwner():IsAdmin() == true) then

		local ply = self:GetClientNumber("playa")
			if (self:GetClientNumber("add") == 1) then
				player.GetByID(ply):SetNWInt( "nrg" , player.GetByID(ply):GetNWInt( "nrg" ) + self:GetClientNumber("totalnrg"))
			else
				player.GetByID(ply):SetNWInt( "nrg" , self:GetClientNumber("totalnrg"))
			end
		local nrgsup = player.GetByID(ply):GetNWInt( "nrg" )
		local message = self:GetOwner():GetName() .. " set " .. player.GetByID(ply):GetName() .. "'s NRG to " .. player.GetByID(ply):GetNWInt( "nrg" )
		local allplayers = player.GetAll( )
			for k,v in pairs ( allplayers ) do
				if(message ~= nil) then
					v:PrintMessage( HUD_PRINTTALK, message )
				end
			end 


	else 
	self:GetOwner():PrintMessage(HUD_PRINTTALK, "This tool is admin only")
	return false end
end
end

function TOOL:Reload(trace)
if (SERVER) then
	if (self:GetOwner():IsAdmin() == true) then
		local allplayers = player.GetAll( )
			for k,v in pairs ( allplayers ) do
			local message = "[" .. k .. "]: " .. v:GetName() .. " has " .. v:GetNWInt( "nrg" ) .. " NRG"
			self:GetOwner():PrintMessage( HUD_PRINTTALK, message )
			end 
	else 
	self:GetOwner():PrintMessage(HUD_PRINTTALK, "This tool is admin only")
	return false end
end
end

function TOOL:RightClick (trace)
if (SERVER) then
	if (self:GetOwner():IsAdmin() == true) then

		local ply = self:GetOwner()
			if (self:GetClientNumber("add") == 1) then
			ply:SetNWInt( "nrg" , ply:GetNWInt( "nrg" ) + self:GetClientNumber("totalnrg"))
			else
			ply:SetNWInt( "nrg" , self:GetClientNumber("totalnrg"))
			end
		local nrgsup = ply:GetNWInt( "nrg" )
				local message = self:GetOwner():GetName() .. " set own NRG to " .. player.GetByID(ply):GetNWInt( "nrg" )
		local allplayers = player.GetAll( )
			for k,v in pairs ( allplayers ) do
			v:PrintMessage( HUD_PRINTTALK, message )
			end 
		ply:PrintMessage(HUD_PRINTTALK, message)

	else 
	self:GetOwner():PrintMessage(HUD_PRINTTALK, "This tool is admin only")
	return false end
end
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_adminnrg_name", Description="#Tool_lap_adminnrg_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Admin NRG");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl ("Slider", {
		Label = "PlayerID",
		Command = "lap_adminnrg_playa",
		Type = "Integer",
		Min = "1",
		Max = "32"
	} )
	CPanel:AddControl ("Slider", {
		Label = "NRG",
		Command = "lap_adminnrg_totalnrg",
		Type = "Integer",
		Min = "-100000",
		Max = "100000"
	} )
	CPanel:AddControl( "Checkbox", {
		Label = "Add",
		Description = "Adds or subtracts instead of setting NRG",
		Command = "lap_adminnrg_add"
	} )
end
