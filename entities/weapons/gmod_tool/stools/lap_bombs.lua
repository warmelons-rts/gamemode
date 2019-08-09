TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Explosives"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "type" ] = "1"
TOOL.ClientConVar[ "dtype" ] = "1"
TOOL.ClientConVar[ "detonate" ] = "0"
TOOL.ClientConVar[ "contact" ] = "0"
TOOL.ClientConVar[ "alternate" ] = "0"
TOOL.ClientConVar[ "aoffset" ] = "0"

if (CLIENT) then
	language.Add( "Tool_lap_bombs_name", "Bombs, Mines and Missiles" )
	language.Add( "Tool_lap_bombs_desc", "These melons explode in proximity of enemies" )
	language.Add( "Tool_lap_bombs_0", "Left-click to spawn an explosive Right-click to display cost." )
	language.Add( "Undone_lap_bombs", "Undone Explosive Warmelon" )
	language.Add( 'SBoxLimit_lap_melons', 'Personal Melon Limit Reached' )
end

function TOOL:LeftClick (trace)
if ( SERVER ) then
if ( !self:GetSWEP():CheckLimit( "lap_melons" ) ) then return false end
local ply = self:GetOwner()
trace = ply:GetEyeTraceNoCursor()
local Pos = trace.HitPos
local desiredtype = self:GetClientNumber("dtype")
if desiredtype ~= 4 then
if !InOutpostRange(ply, Pos) then return false end
else
if !InBaseRange(ply, Pos) then return false end
end
local cteam = 0
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local Ang = trace.HitNormal:Angle()
	local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
	local missilecost = 0
	   if desiredtype == 4 then
	   missilecost = 1250
	   end
	   
	local warheadcost = 0
	   if desiredtype == 5 then
	   warheadcost = 1750
	   end
	
	local cost = (250+missilecost+warheadcost)*toolcost
 	if !NRGCheck(ply, cost) then return false end
if (trace.Hit && !trace.HitNoDraw) then
	melon = ents.Create ("lap_bomb");
	melon.Cost = cost
	
	--melon:SetAngles (trace.HitNormal:Angle()+Angle(eang.p, 0, 0));
	melon.Team = cteam;
	melon.Payload = self:GetClientNumber ("type")
	melon.Move = util.tobool(missilecost);
		if desiredtype == 4 then
			melon:SetPos (trace.HitPos + trace.HitNormal * -2);
			end
		if (desiredtype ~= 2 || desiredtype ~= 5) then
			melon:SetPos (trace.HitPos + trace.HitNormal);
			else
			melon:SetPos (trace.HitPos + trace.HitNormal * 12);
			end
		if desiredtype == 1 || desiredtype == 4 then
		  melon.Mine = 0
		  elseif desiredtype == 2 then
		  melon.Mine = 1
		  elseif desiredtype == 3 then
		  melon.Mine = 2
		  end
    if missilecost == 0 then
	melon.Grav = true
	melon.Move = false
	else
	melon.Grav = false
	melon.Move = true
	end
	melon:Spawn();
	melon.DetonateOn = self:GetClientNumber("detonate")
	if self:GetClientNumber("contact") == 1 then melon.Stance = 2 end
	if desiredtype == 3 then melon.HoldFire = 1 end
	ply:AddCount('lap_melons', melon)
	melon:Activate();
	melon:SetAngles(Ang)
	if desiredtype == 4 then
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
	end
	
	if desiredtype == 4 then melon.Weld = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	--melon:GetPhysicsObject():EnableGravity(self:GetClientNumber("gravity") == 1);
	--numpad.OnDown (self:GetOwner(), self:GetClientNumber("amtoggle"), "FireMissiles", melon);
	if (desiredtype == 2 || desiredtype == 5) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("lap_bombs");
    undo.AddEntity (melon);
    cleanup.Add( ply, "WM Explosive", melon )
	if (self:GetClientNumber("welded") == 1) && (self:GetClientNumber("moving") == 0) then undo.AddEntity (upright) end
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
	local missilecost = 0
	   if desiredtype == 4 then
	   missilecost = 1250
	   end
	   
	local warheadcost = 0
	   if desiredtype == 5 then
	   warheadcost = 1750
	   end

local cost = (250+missilecost+warheadcost)*toolcost
WMSendCost(ply, cost, false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_bombs_name", Description="#Tool_lap_bombs_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Bomb");
    CPanel:AddPanel(VGUI);
	CPanel:AddControl("Label", { Text = "Bombs that are welded, uncommandable, and have gravity are mines." })
	CPanel:AddControl("Label", { Text = "Mines are transparent, mostly covered, and can be built near outposts." })
		local params = { Label = "#Presets", MenuButton = 1, Folder = "wm_bombs", Options = {}, CVars = {} }
		params.Options.default = {
			lap_bombs_ttype		=		1,
			lap_bombs_dtype		=		1,
			lap_bombs_detonate	=		0,
			lap_bombs_contact   =       1,
			lap_bombs_teamnumber =      1,
		}
		table.insert( params.CVars, "lap_bombs_dtype" )
		table.insert( params.CVars, "lap_bombs_type" )
		table.insert( params.CVars, "lap_bombs_detonate" )
		table.insert( params.CVars, "lap_bombs_contact" )
		table.insert( params.CVars, "lap_bombs_teamnumber" )
		CPanel:AddControl( "ComboBox", params )
	if LocalPlayer():IsAdmin() then
	CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "lap_bombs_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )
    end
	
	CPanel:AddControl("Label", { Text = "Delivery Type", Description = "Type of Explosive"})
	local choices2 = {Label = "Delivery Type", MenuButton = "0", Options = {}}
	choices2.Options["Bomb($)"] = {lap_bombs_dtype = "1"}
	choices2.Options["Mine($)"] = {lap_bombs_dtype = "2"}
	choices2.Options["Deployable Mine($)"] = {lap_bombs_dtype = "3"}
	choices2.Options["Missile($$$$$$)"] = {lap_bombs_dtype = "4"}
	choices2.Options["Warhead($$$$$$)"] = {lap_bombs_dtype = "5"}
	CPanel:AddControl( "ComboBox", choices2 )
	
	CPanel:AddControl("Label", { Text = "Payload Type", Description = "Bomb Payload"})
	local choices = {Label = "Payload Type", MenuButton = "0", Options = {}}
	choices.Options["Standard Explosive"] = {lap_bombs_type = "1"}
	choices.Options["Cluster Bomb"] = {lap_bombs_type = "2"}
	choices.Options["Slime (Slows)"] = {lap_bombs_type = "3"}
	choices.Options["Flak (Anti-Air)"] = {lap_bombs_type = "4"}
	--choices.Options["Acid"] = {lap_bombs_type = "5"}
	CPanel:AddControl( "ComboBox", choices )
	
	CPanel:AddControl("Label", { Text = "Detonate On Proximity to...", Description = "Bomb Payload"})
	local choices3 = {Label = "Detonate On Proximity to...", MenuButton = "0", Options = {}}
	choices3.Options["Any Enemy"] = {lap_bombs_detonate = "0"}
	choices3.Options["Just Melons"] = {lap_bombs_detonate = "1"}
	choices3.Options["Props or Vehicles"] = {lap_bombs_detonate = "2"}
	--choices.Options["Acid"] = {lap_bombs_type = "5"}
	CPanel:AddControl( "ComboBox", choices3 )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Explode On Contact",
		Description = "Check and your explosive will explode if it touches enemies or the world.",
		Command = "lap_bombs_contact"
	} )
			CPanel:AddControl( "Checkbox", {
		Label = "Alternate Missile Placement",
		Description = "Switches the placement alignment.",
		Command = "lap_bombs_alternate"
	} )
	
	CPanel:AddControl ("Slider", {
		Label = "Rotation",
		Command = "lap_bombs_aoffset",
		Type = "Integer",
		Min = "-360",
		Max = "360"
	} )
	
end


function TOOL:Think()
if self:GetClientNumber("dtype") ~= 4 then
model = "models/props_phx/misc/soccerball.mdl"
else
model = "models/props_phx/ww2bomb.mdl"
end	
     if (!self.GhostEntity || !self.GhostEntity:IsValid() || self.GhostEntity:GetModel() != model) then
         self:MakeGhostEntity( model, Vector(0,0,0), Angle(0,0,0) )
     end
    
     self:UpdateGhostEnt( self.GhostEntity, self:GetOwner() )
 end
  
function TOOL:UpdateGhostEnt( ent, player )
local destype = self:GetClientNumber("dtype")
	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end

	local tr 	= util.GetPlayerTrace( player, player:GetAimVector() )
	local trace 	= player:GetEyeTraceNoCursor()
	if (!trace.Hit) then return end
	
	if (trace.Entity && trace.Entity:GetClass() == "lap_launchers" || trace.Entity:IsPlayer()) then
	
		ent:SetNoDraw( true )
		return
		
	end
	local Ang = trace.HitNormal:Angle()
	ent:SetAngles(Ang)
	if destype == 4 then
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
	else
		if (destype == 2 || destype == 5) then
		ent:SetPos (trace.HitPos + trace.HitNormal * 12);
		else
		ent:SetPos (trace.HitPos + trace.HitNormal * -2);
		end
	end
	 

	
	ent:SetNoDraw( false )
	
end
