TOOL.Category		= "(WarMelons-ADMIN)"
TOOL.Name			= "#No Build Areas"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "radius" ] = "500"
TOOL.ClientConVar[ "model" ] = "models/props_c17/streetsign004e.mdl"

if (CLIENT) then
	language.Add( "Tool_nobuildareas_name", "NoBuildAreas" )
	language.Add( "Tool_nobuildareas_desc", "Creates no build areas (ADMIN ONLY)" )
	language.Add( "Tool_nobuildareas_0", "Left-click to mark a no build area. Admin only." )
	language.Add( "Undone_nobuildareas", "Undone No Build Area" )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
	local ply = self:GetOwner()
if (trace.Hit && !trace.HitNoDraw && ply:IsAdmin() == true) then
	
	melon = ents.Create("nobuildarea");
	melon:SetPos(trace.HitPos + trace.HitNormal);
	melon:SetAngles(trace.HitNormal:Angle());
	melon:SetModel(model);
	melon.model = self:GetClientInfo("model")
	melon.NoBuildRadius = self:GetClientNumber("radius")
	melon:Spawn();
	melon:Activate();
	melon:GetPhysicsObject():EnableMotion(false);
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("cappoint");
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
	CPanel:AddControl ("Header", { Text="#Tool_nobuildareas_name", Description="#Tool_nobuildareas_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("No Build Area");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "nobuildareas_model", Category = "nobuildareas", Models = list.Get( "nobuildareasmodels" ) } )

	CPanel:AddControl ("Slider", {
		Label = "Radius",
		Command = "nobuildareas_radius",
		Type = "Integer",
		Min = "0",
		Max = "10000"
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
     ent:SetAngles( trace.HitNormal:Angle() )
    
     local min = ent:OBBMins()
     ent:SetPos( trace.HitPos + trace.HitNormal * self:GetClientInfo("height") )
    
     ent:SetNoDraw( false )
    
end

list.Set( "nobuildareasmodels", "models/props_c17/streetsign004e.mdl", {} );