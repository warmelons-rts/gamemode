TOOL.Category		= "(WarMelons-ADMIN)"
TOOL.Name			= "#Resource Node"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "height" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/props_combine/breentp_rings.mdl"
TOOL.ClientConVar[ "rez" ] = "100000"
TOOL.ClientConVar[ "unlimited" ] = "false"

if (CLIENT) then
	language.Add( "Tool_lap_resnodes_name", "Resource Node" )
	language.Add( "Tool_lap_resnodes_desc", "Creates a resource node (ADMIN ONLY)" )
	language.Add( "Tool_lap_resnodes_0", "Left-click to spawn a resource node. Admin only." )
	language.Add( "Undone_lap_resnodes", "Undone resource node" )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
	local ply = self:GetOwner()
if (trace.Hit && !trace.HitNoDraw && ply:IsAdmin() == true) then
	
	melon = ents.Create ("lap_resnode");
	melon:SetPos(trace.HitPos + trace.HitNormal * self:GetClientNumber("height"));
	melon:SetAngles(Angle(0,0,0));
	melon:SetModel(model);
	melon.model = model;
	melon.Rez = self:GetClientNumber("rez");
	if self:GetClientNumber("unlimited") == 1 then
	melon.Rez = -6999
	end
	melon:Spawn();
	melon:Activate();
	if melon:GetPhysicsObject():IsValid() then
	melon:GetPhysicsObject():EnableMotion(false);
	end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("resnode");
  undo.AddEntity (melon);
  undo.SetPlayer (self:GetOwner());
	undo.Finish();
	return true;
	else 
	ply:PrintMessage(HUD_PRINTTALK, "This tool is admin only")
	return false end
end
end


function TOOL:RightClick (trace)
if (SERVER) then
	return false
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_resnodes_name", Description="#Tool_lap_resnodes_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Resource Node");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_resnodes_model", Category = "lap_resnodes", Models = list.Get( "resnodesmodels" ) } )

	CPanel:AddControl ("Slider", {
		Label = "Height",
		Command = "lap_resnodes_height",
		Type = "Integer",
		Min = "-200",
		Max = "230"
	} )
	
		CPanel:AddControl ("Slider", {
		Label = "Resources",
		Command = "lap_resnodes_rez",
		Type = "Integer",
		Min = "2500",
		Max = "100000"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Unlimited Resources",
		Description = "Uncheck box and the reznode will never run out.",
		Command = "lap_resnodes_unlimited"
	} )


end

function TOOL:Think()
model = self:GetClientInfo("model")	
     if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != model) then
         self:MakeGhostEntity( model, Vector(0,0,0), Angle(0,0,0) )
     end
    
     self:UpdateGhostEnt( self.GhostEntity, self:GetOwner() )
end
  
function TOOL:UpdateGhostEnt( ent, player )
  
     if ( !ent ) then return end
     if ( !ent:IsValid() ) then return end
  
     local tr    = util.GetPlayerTrace( player, player:GetAimVector() )
     local trace     = util.TraceLine( tr )
     if (!trace.Hit) then return end
    

	local ply = self:GetOwner()
     	local eang = ply:EyeAngles()
     ent:SetAngles( Angle(0,eang.yaw,0) )
    
     local min = ent:OBBMins()
     ent:SetPos( trace.HitPos + trace.HitNormal * self:GetClientInfo("height") )
    
     ent:SetNoDraw( false )

end

list.Set( "resnodesmodels", "models/props_combine/breentp_rings.mdl", {} );
