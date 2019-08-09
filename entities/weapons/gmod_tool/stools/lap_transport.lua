TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Transport"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "welded" ] = "0"
TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "0"
TOOL.ClientConVar[ "force" ] = "5000"
TOOL.ClientConVar[ "model" ] = "models/props_c17/oildrum001.mdl"
TOOL.ClientConVar[ "alternate" ] = "0"
TOOL.ClientConVar[ "aoffset" ] = "0"

local mdlmass = 0

if (CLIENT) then
	language.Add( "Tool_lap_transport_name", "Armored Transport" )
	language.Add( "Tool_lap_transport_desc", "Creates a container to store and transport melons in." )
	language.Add( "Tool_lap_transport_0", "Left-click to spawn a transport prop. Right-click to check the cost.")
    language.Add( "Undone_lap_transport", "Undone Transport" )
end

if ( SERVER ) then
    function CheckBForce()

    return true
    end
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
	local Pos = trace.HitPos
	local Ang = trace.HitNormal
	local ply = self:GetOwner()
	local cteam = 0
	if !InOutpostRange(ply, Pos) then return false end
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local mdl = self:GetClientInfo("model")
	local mdlmass
	local deploy = Vector(0,0,0)
	local ammo = 0
        if mdl == "models/props_junk/trashdumpster01a.mdl" then
		mdlmass = 1000
		deploy = Vector(0,0,20)
        cost = 3500
		ammo = 12
        elseif mdl == "models/xqm/podremake.mdl" then
		mdlmass = 2000
        cost = 7000
		deploy = Vector(30,0,0)
		ammo = 20
        elseif mdl == "models/props_wasteland/laundry_dryer002.mdl" then
		deploy = Vector(27,0,5)
		mdlmass = 2000
        cost = 7000
		ammo = 20
		elseif mdl == "models/props_wasteland/laundry_washer001a.mdl" then
		deploy = Vector(0,0,20)
		mdlmass = 1700
		cost = 5000
		ammo = 16
		elseif mdl == "models/props_interiors/vendingmachinesoda01a.mdl" then
		mdlmass = 1400
		deploy = Vector(15,0,0)
		cost = 4000
		ammo = 14
		else
		return false
        end
		
	local cost = 999999999//cost * GetConVarNumber("WM_Toolcost", 1)
if !NRGCheck(ply, cost) then return false end
local Ang = trace.HitNormal:Angle()
if (trace.Hit && !trace.HitNoDraw) then
	local t = cteam
	melon = ents.Create ("lap_transport");
	melon.Cost = cost
	melon:SetModel(self:GetClientInfo("model"))
     melon:SetPos(trace.HitPos)
	melon:SetAngles(trace.HitNormal:Angle())
	melon.Team = cteam;
	melon.model = self:GetClientInfo("model");
	melon.mass = mdlmass
		if (t == 1) then
		melon:SetColor (Color(255, 0, 0, 255));
		end
		if (t == 2) then
		melon:SetColor (Color(0, 0, 255, 255));
		end
		if (t == 3) then
		melon:SetColor (Color(0, 255, 0, 255));
		end
		if (t == 4) then
		melon:SetColor (Color(255, 255, 0, 255));
		end
		if (t == 5) then
		melon:SetColor (Color(255, 0, 255, 255));
		end
		if (t == 6) then
		melon:SetColor (Color(0, 255, 255, 255));
		end
	melon.DeployVec = deploy;
	melon.MaxAmmo = ammo
	melon:Spawn();
		local min = melon:OBBMins()
		if self:GetClientNumber("alternate") == 0 then
		Ang = melon:LocalToWorldAngles(Angle(90,0,0))
		Ang:RotateAroundAxis(melon:GetForward(),self:GetClientNumber("aoffset"))
		melon:SetPos( trace.HitPos - trace.HitNormal * min.z )
		else
		local max = melon:OBBMaxs()
		Ang = melon:LocalToWorldAngles(Angle(0,0,self:GetClientNumber("aoffset")))
		melon:SetPos( trace.HitPos - trace.HitNormal * ((min.x - max.x) / 2))
		end
		melon:SetAngles( Ang )
    ply:AddCount('lap_baseprops', melon)
	melon:Activate();
	upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true)
	local min = melon:OBBMins()
     melon:SetPos(  trace.HitPos + trace.HitNormal * 25 )
	--if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("Transports Tank");
    undo.AddEntity (melon);
	if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
    undo.SetPlayer (self:GetOwner());
	undo.Finish();

end
end
end

function TOOL:Reload(trace)
if (SERVER) then
return true
end
end

function TOOL:RightClick ()
if (SERVER) then
local ply = self:GetOwner()
    local mdl = self:GetClientInfo("model")
	local cost
        if mdl == "models/props_junk/TrashDumpster01a.mdl" then
        cost = 3500
		ammo = 12
        elseif mdl == "models/XQM/podremake.mdl" then
        cost = 7000
		ammo = 20
        elseif mdl == "models/props_wasteland/laundry_dryer002.mdl" then
        cost = 7000
		ammo = 20
		elseif mdl == "models/props_wasteland/laundry_washer001a.mdl" then
		cost = 5000
		ammo = 16
		elseif mdl == "models/props_interiors/VendingMachineSoda01a.mdl" then
		cost = 4000
		ammo = 14
        end
cost = cost * GetConVarNumber("WM_Toolcost", 1)
WMSendCost(ply, cost, false)
end	
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_transport_name", Description="#Tool_lap_transport_desc" })
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_transport_model", Category = "lap_transport", Models = list.Get( "TransportsModels" ) } )
	CPanel:AddControl( "Checkbox", {
		Label = "Alternate Placement",
		Description = "Switches the placement alignment.",
		Command = "lap_transport_alternate"
	} )
	
	CPanel:AddControl ("Slider", {
		Label = "Rotation",
		Command = "lap_transport_aoffset",
		Type = "Integer",
		Min = "-360",
		Max = "360"
	} )
		CPanel:AddControl ("Slider", {
		Label = "Team number (ADMIN ONLY)",
		Command = "lap_transport_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "7"
	} )
					local VGUI = vgui.Create("WMHelpButton",CPanel);
					VGUI:SetTopic("Transport");
					CPanel:AddPanel(VGUI);
end

function TOOL:Think()
local model = self:GetClientInfo("model")	
     if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != model) then
         self:MakeGhostEntity( model, Vector(0,0,0), Angle(0,0,0) )
     end
    
     self:UpdateGhostEnt( self.GhostEntity, self:GetOwner() )
 end
 
function TOOL:UpdateGhostEnt( ent, player )
	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= player:GetEyeTraceNoCursor()
	if (!trace.Hit) then return end
	
	if (trace.Entity:IsPlayer()) then
	
		ent:SetNoDraw( true )
		return
		
	end
	local Ang = trace.HitNormal:Angle()
	ent:SetAngles(Ang)
	local min = ent:OBBMins()
		if self:GetClientNumber("alternate") == 0 then
		Ang = ent:LocalToWorldAngles(Angle(90,0,0))
		Ang:RotateAroundAxis(ent:GetForward(),self:GetClientNumber("aoffset"))
		ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
		else
		local max = ent:OBBMaxs()
		Ang = ent:LocalToWorldAngles(Angle(0,0,self:GetClientNumber("aoffset")))
		ent:SetPos( trace.HitPos - trace.HitNormal * ((min.x - max.x) / 2))
		end
	ent:SetAngles( Ang )
	
	ent:SetNoDraw( false )
	
end

--Top Facing
list.Set( "TransportsModels", "models/props_junk/TrashDumpster01a.mdl", {} );
list.Set( "TransportsModels", "models/XQM/podremake.mdl", {} );
list.Set( "TransportsModels", "models/props_wasteland/laundry_dryer002.mdl", {} );
list.Set( "TransportsModels", "models/props_wasteland/laundry_washer001a.mdl", {} );
list.Set( "TransportsModels", "models/props_interiors/VendingMachineSoda01a.mdl", {} );