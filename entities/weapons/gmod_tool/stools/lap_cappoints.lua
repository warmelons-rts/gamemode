TOOL.Category		= "(WarMelons-ADMIN)"
TOOL.Name			= "#Cap Points"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "height" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/props_trainstation/tracksign01.mdl"

if (CLIENT) then
	language.Add( "Tool_lap_cappoints_name", "Capture Point" )
	language.Add( "Tool_lap_cappoints_desc", "Creates capture points (ADMIN ONLY)" )
	language.Add( "Tool_lap_cappoints_0", "Left-click to spawn a capture point. Admin only." )
	language.Add( "Undone_lap_cappoints", "Undone capture Point" )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
	local ply = self:GetOwner()
if (trace.Hit && !trace.HitNoDraw && ply:IsAdmin() == true) then
	
	melon = ents.Create ("lap_cappoint");
	melon:SetPos(trace.HitPos + trace.HitNormal * self:GetClientNumber("height"));
	melon:SetAngles(Angle(0,0,0));
	melon:SetModel(model);
	melon:SetMaterial("models/debug/debugwhite");
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
	CPanel:AddControl ("Header", { Text="#Tool_lap_cappoints_name", Description="#Tool_lap_cappoints_desc" })
local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Capture Point");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_cappoints_model", Category = "lap_cappoints", Models = list.Get( "cappointmodels" ) } )

	CPanel:AddControl ("Slider", {
		Label = "Height",
		Command = "lap_cappoints_height",
		Type = "Integer",
		Min = "-200",
		Max = "230"
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

list.Set( "cappointmodels", "models/props_trainstation/tracksign01.mdl", {} );
list.Set( "cappointmodels", "models/props_c17/furnitureboiler001a.mdl", {} );
list.Set( "cappointmodels", "models/props_c17/gravestone_cross001b.mdl", {} );
list.Set( "cappointmodels", "models/props_docks/channelmarker_gib02.mdl", {} );
list.Set( "cappointmodels", "models/props_trainstation/clock01.mdl", {} );
list.Set( "cappointmodels", "models/XQM/afterburner1large.mdl", {} );