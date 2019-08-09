TOOL.Category		= "(WarMelons-ADMIN)"
TOOL.Name			= "#Communications Uplink"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "height" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/props_c17/utilitypole03a.mdl"
TOOL.ClientConVar[ "weld" ] = "1"

if (CLIENT) then
	language.Add( "Tool_lap_uplinks_name", "Communications Uplink" )
	language.Add( "Tool_lap_uplinks_desc", "Creates communications uplink (ADMIN ONLY)" )
	language.Add( "Tool_lap_uplinks_0", "Left-click to spawn a communications uplink. Admin only." )
	language.Add( "Undone_lap_uplinks", "Undone communications uplink" )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
	local ply = self:GetOwner()
if (trace.Hit && !trace.HitNoDraw && ply:IsAdmin() == true) then
	
	melon = ents.Create ("lap_commuplink");
	melon:SetPos(trace.HitPos + trace.HitNormal * self:GetClientNumber("height"));
	melon:SetAngles(Angle(0,0,0));
	melon:SetModel(model);
	melon.model = model;
	melon:SetMaterial("models/debug/debugwhite");
	melon:Spawn();
	melon:Activate();
	if melon:GetPhysicsObject():IsValid() then
	melon:GetPhysicsObject():EnableMotion(false);
	end
if (self:GetClientNumber("weld") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	if (self:GetClientNumber("weld") == 1) then undo.AddEntity (upright) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("commuplink");
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
	CPanel:AddControl ("Header", { Text="#Tool_lap_uplinks_name", Description="#Tool_lap_uplinks_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Uplink");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_uplinks_model", Category = "lap_uplinks", Models = list.Get( "uplinkmodels" ) } )

	CPanel:AddControl ("Slider", {
		Label = "Height",
		Command = "lap_uplinks_height",
		Type = "Integer",
		Min = "-200",
		Max = "230"
	} )

	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "Uncheck box and melons will not be attached to what you shoot at",
		Command = "lap_uplinks_weld"
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

list.Set( "uplinkmodels", "models/props_c17/substation_circuitbreaker01a.mdl", {} );
list.Set( "uplinkmodels", "models/props_c17/utilitypole03a.mdl", {} );
list.Set( "uplinkmodels", "models/props_trainyard/fueling_tower.mdl", {} );
list.Set( "uplinkmodels", "models/props_spytech/satellite_dish001.mdl", {} );
