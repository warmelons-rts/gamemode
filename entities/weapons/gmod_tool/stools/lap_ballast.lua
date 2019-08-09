TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Ballast Tank"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "0"
TOOL.ClientConVar[ "model" ] = "models/props_c17/oildrum001.mdl"
TOOL.ClientConVar[ "alternate" ] = "0"
TOOL.ClientConVar[ "aoffset" ] = "0"
local mdlmass = 0

if (CLIENT) then
	language.Add( "Tool_lap_ballast_name", "Ballast Tanks" )
	language.Add( "Tool_lap_ballast_desc", "Creates very buoyant props for navies." )
	language.Add( "Tool_lap_ballast_0", "Left-click to spawn a ballast prop. Right-click to check the cost.")
    language.Add( "Undone_lap_ballast", "Undone Ballast Tank" )
end

if ( SERVER ) then
    function CheckBForce()

    return true
    end
end

function TOOL:LeftClick (trace)
	if ( SERVER ) then
		if ( !self:GetSWEP():CheckLimit( "lap_baseprops" ) ) then return false end
		local ply = self:GetOwner()
		trace = ply:GetEyeTraceNoCursor()
		local Pos = trace.HitPos
		local Ang = trace.HitNormal
		local cteam = 0
		if !InOutpostRange(ply, Pos) then return false end
		if ply:Team() ~= 0 then
			cteam = ply:Team()
		else
			cteam = self:GetClientNumber("teamnumber")
		end
	    local mdl = self:GetClientInfo("model")
        if mdl == "models/props_c17/oildrum001.mdl" then
			mdlmass = 75
        elseif mdl == "models/props_borealis/bluebarrel001.mdl" then
			mdlmass = 100
        elseif mdl == "models/props_c17/canister_propane01a.mdl" then
			mdlmass = 200
        elseif mdl == "models/xqm/cylinderx1large.mdl" then
			mdlmass = 300
        elseif mdl == "models/props_wasteland/laundry_washer003.mdl" then
			mdlmass = 500
        elseif mdl == "models/props_wasteland/coolingtank02.mdl" then
			mdlmass = 750
        elseif mdl == "models/props_wasteland/horizontalcoolingtank04.mdl" then
			mdlmass = 1000
        end
		local cost = (mdlmass * 3) * GetConVarNumber("WM_Toolcost", 1)
		if !NRGCheck(ply, cost) then return false end
		if (trace.Hit && !trace.HitNoDraw) then
			local t = cteam
			melon = ents.Create ("lap_ballast");
				melon.Cost = cost
				melon:SetModel(self:GetClientInfo("model"))
				melon.Team = cteam;
				melon.model = self:GetClientInfo("model");
				melon.mass = mdlmass
	
				melon:Spawn();
				ply:AddCount('lap_baseprops', melon)
				melon:Activate();
			
			local min = melon:OBBMins()
			local Ang = trace.HitNormal:Angle()
			if self:GetClientNumber("alternate") == 0 then
				Ang:RotateAroundAxis(Ang:Right(),-90)
				Ang:RotateAroundAxis(trace.HitNormal,self:GetClientNumber("aoffset"))
				melon:SetPos( trace.HitPos - trace.HitNormal * min.z )
			else
				Ang:RotateAroundAxis(trace.HitNormal,self:GetClientNumber("aoffset"))
				melon:SetPos( trace.HitPos - trace.HitNormal * min.x)
			end
			melon:SetAngles( Ang )
			
			if (t == 1) then
				melon:SetColor(Color(255, 0, 0, 255));
			end
			if (t == 2) then
				melon:SetColor(Color(0, 0, 255, 255));
			end
			if (t == 3) then
				melon:SetColor(Color(0, 255, 0, 255));
			end
			if (t == 4) then
				melon:SetColor(Color(255, 255, 0, 255));
			end
			if (t == 5) then
				melon:SetColor(Color(255, 0, 255, 255));
			end
			if (t == 6) then
				melon:SetColor(Color(0, 255, 255, 255));
			end
			
			if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
			trace.Entity:DeleteOnRemove(melon);
			
			undo.Create("Ballast Tank");
				undo.AddEntity (melon);
				if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
				undo.SetPlayer (self:GetOwner());
			undo.Finish();

		end
	end
end

function TOOL:RightClick ()
if (SERVER) then
local ply = self:GetOwner()
    local mdl = self:GetClientInfo("model")
        if mdl == "models/props_c17/oildrum001.mdl" then
        mdlmass = 75
        elseif mdl == "models/props_borealis/bluebarrel001.mdl" then
        mdlmass = 100
        elseif mdl == "models/props_c17/canister_propane01a.mdl" then
        mdlmass = 200
        elseif mdl == "models/xqm/cylinderx1large.mdl" then
        mdlmass = 300
        elseif mdl == "models/props_wasteland/laundry_washer003.mdl" then
        mdlmass = 500
        elseif mdl == "models/props_wasteland/coolingtank02.mdl" then
        mdlmass = 750
        elseif mdl == "models/props_wasteland/horizontalcoolingtank04.mdl" then
        mdlmass = 1000
        end
local cost = (mdlmass * 3) * GetConVarNumber("WM_Toolcost", 1)
WMSendCost(ply, cost, false)
end	
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_ballast_name", Description="#Tool_lap_ballast_desc" })
		local VGUI = vgui.Create("WMHelpButton",CPanel);
		VGUI:SetTopic("Ballast Tank");
		CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_ballast_model", Category = "lap_ballast", Models = list.Get( "BallastModels" ) } )
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "#Tool_lap_ballast_grav",
		Command = "lap_ballast_welded"
	} )
		CPanel:AddControl ("Slider", {
		Label = "Team number (ADMIN ONLY)",
		Command = "lap_ballast_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "7"
	} )
			CPanel:AddControl( "Checkbox", {
		Label = "Alternate placement method",
		Description = "Switches the placement alignment.",
		Command = "lap_ballast_alternate"
	} )
	
	CPanel:AddControl ("Slider", {
		Label = "Rotation",
		Command = "lap_ballast_aoffset",
		Type = "Integer",
		Min = "-360",
		Max = "360"
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

	--local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= player:GetEyeTraceNoCursor()
	if (!trace.Hit) then return end
	
	if (trace.Entity && trace.Entity:GetClass() == "lap_ballast" || trace.Entity:IsPlayer()) then
	
		ent:SetNoDraw( true )
		return
		
	end
	
	local ply = self:GetOwner()
	local eang = ply:EyeAngles()
	
	local Ang = trace.HitNormal:Angle()
	local min = ent:OBBMins()
	if self:GetClientNumber("alternate") == 0 then
		Ang:RotateAroundAxis(Ang:Right(),-90)
		Ang:RotateAroundAxis(trace.HitNormal,self:GetClientNumber("aoffset"))
		ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
	else
		Ang:RotateAroundAxis(trace.HitNormal,self:GetClientNumber("aoffset"))
		ent:SetPos( trace.HitPos - trace.HitNormal * min.x)
	end
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )
	
end


list.Set( "BallastModels", "models/props_c17/oildrum001.mdl", {} );
list.Set( "BallastModels", "models/props_borealis/bluebarrel001.mdl", {} );
list.Set( "BallastModels", "models/props_c17/canister_propane01a.mdl", {} );
list.Set( "BallastModels", "models/xqm/cylinderx1large.mdl", {} );
list.Set( "BallastModels", "models/props_wasteland/laundry_washer003.mdl", {});
list.Set( "BallastModels", "models/props_wasteland/coolingtank02.mdl", {});
list.Set( "BallastModels", "models/props_wasteland/horizontalcoolingtank04.mdl", {});