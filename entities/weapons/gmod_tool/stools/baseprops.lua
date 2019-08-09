TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Base Prop"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "model" ] = "models/props_c17/concrete_barrier001a.mdl"
TOOL.ClientConVar[ "healthmod" ] = "100"
TOOL.ClientConVar[ "welded" ] = "1"
TOOL.ClientConVar[ "gravity" ] = "0"
TOOL.ClientConVar[ "alternate" ] = "0"
TOOL.ClientConVar[ "aoffset" ] = "0"

if (CLIENT) then
	language.Add( "Tool_baseprops_name", "Base Props" )
	language.Add( "Tool_baseprops_desc", "Creates breakable props." )
	language.Add( "Tool_baseprops_0", "Left-click to spawn a defensive prop. Right-click to set the health of a prop (affects weight and cost). Reload checks price of primary-fire." )
	language.Add( "#Tool_baseprops_grav", "Uncheck box and the baseprop will not have gravity (3-5x cost)")
    language.Add( "Undone_baseprops", "Undone Baseprops" )
end

function TOOL:LeftClick (trace)
	if ( SERVER ) then
		if ( !self:GetSWEP():CheckLimit( "lap_baseprops" ) ) then return false end
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
		local nrgsup = ply:GetNWInt( "nrg" )
		local propcost = GetConVarNumber( "WM_Propcost", 3 )
		local eang = ply:EyeAngles()
		ent = ents.Create ("melon_baseprop");
			ent:SetPos( trace.HitPos )
			ent.model = self:GetClientInfo("model");
			ent:SetSolid(SOLID_VPHYSICS)
			ent:Spawn()
			ent:Activate()
		local min = ent:OBBMins()
		local vec = (ent:OBBMaxs() - min)
		local tsize = vec.x * vec.y * vec.z
		ent:Remove()
			 
		local cost = tsize * GetConVarNumber( "WM_HealthtoSize", 0.0013) * (math.Clamp(self:GetClientNumber("healthmod"),1,100) / 100)* propcost
		if self:GetClientNumber("gravity") == 0 then
			cost = cost * 3
		end
		if !NRGCheck(ply, cost) then return false end
		if (trace.Hit && !trace.HitNoDraw) then
			local t = cteam
			melon = ents.Create ("melon_baseprop");
				melon.Cost = cost
				melon.Team = cteam;
				melon.model = self:GetClientInfo("model");
				melon.Grav = true
				melon.mass = tsize * GetConVarNumber( "WM_HealthtoSize", 0.0013) * (math.Clamp(self:GetClientNumber("healthmod"),1,100) / 100) / GetConVarNumber( "WM_healthtomass", 2)
				melon:Spawn();
				ply:AddCount('lap_baseprops', melon)
				melon:Activate();
			
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
			if (self:GetClientNumber("gravity") == 0) then melon:GetPhysicsObject():EnableGravity(false) end
			if (self:GetClientNumber("welded") == 1) then upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true) end
			trace.Entity:DeleteOnRemove(melon);
			undo.Create("baseprops");
				undo.AddEntity (melon);
				if (self:GetClientNumber("welded") == 1) then undo.AddEntity (upright) end
				undo.SetPlayer (self:GetOwner());
			undo.Finish();
		
		end
	end
end

function TOOL:Reload()
	if (SERVER) then
		local ply = self:GetOwner()
		local nrgsup = ply:GetNWInt( "nrg" )
		local propcost = GetConVarNumber( "WM_Propcost", 3 )
		ent = ents.Create ("melon_baseprop");
			ent:SetPos(Vector(200100,111111,111111));
			ent.model = self:GetClientInfo("model");
			ent:SetSolid(SOLID_VPHYSICS)
			ent:Spawn()
			ent:Activate()
		local vec = (ent:OBBMaxs() - ent:OBBMins())
		local tsize = vec.x * vec.y * vec.z
		ent:Remove()
		local cost = tsize * GetConVarNumber( "WM_HealthtoSize", 0.0013) * (math.Clamp(self:GetClientNumber("healthmod"),1,100) / 100)* propcost
		--if self:GetClientNumber("gravity") == 0 then
		--cost = cost * 3
		--end
		WMSendCost(ply, cost, false)
	end
end

function TOOL:RightClick (trace)
	if (SERVER) then
		local Pos = trace.HitPos
		local ply = self:GetOwner()
		local ent = trace.Entity
		if !InOutpostRange(ply, Pos) then return false end
		if (trace.Hit && ent:IsValid() && ent:GetClass() == "melon_baseprop") then
			local Ang = trace.HitNormal
			if ent.health == nil then return false end
			local percentage = math.Clamp(self:GetClientNumber("healthmod"),1,100) / 100
			local ply = self:GetOwner()
			local vec = (ent:OBBMaxs() - ent:OBBMins())
			local size = vec.x * vec.y * vec.z
			local nrgsup = ply:GetNWInt( "nrg" )
			local propcost = GetConVarNumber( "WM_Propcost", 2 )
			local hpsize = size * GetConVarNumber( "WM_HealthtoSize", 0.0013)
			local cost = math.floor(((hpsize * percentage ) - ent.health) * propcost)
			if self:GetClientNumber("gravity") == 0 then
				cost = cost * 3
			end
			--if !NRGCheck(ply,cost) then return false end
			if nrgsup < cost then
				ply:PrintMessage(HUD_PRINTTALK, "You need: " .. cost)
				return false
			else
				if ent.Built == 2 then
				ply:SetNWInt("nrg", nrgsup - cost)
				ply:PrintMessage(HUD_PRINTTALK, "Cost: " .. cost)
				else
				ply:PrintMessage(HUD_PRINTTALK, "Wait until built.")
				return false
				end
			end
			local mass = size * GetConVarNumber( "WM_HealthtoSize", 0.0013) * percentage / GetConVarNumber( "WM_healthtomass", 1.5 )
			ent.mass = mass
			ent:GetPhysicsObject():SetMass(mass)
			if mass * GetConVarNumber( "WM_healthtomass", 1.5 ) <= GetConVarNumber( "WM_maxprophealth", 1500 ) then
				ent.maxhealth = mass * GetConVarNumber( "WM_healthtomass", 1.5 )
			else
				ent.maxhealth = GetConVarNumber( "WM_maxprophealth", 1500 ) 
			end
			ent.health = ent.maxhealth
			ent.Grav = true;
			ent.Cost  = ent.Cost + cost
			ent:SetNWInt("WMMaxHealth", math.floor(ent.maxhealth))
			--if (self:GetClientNumber("gravity") == 0) then trace.Entity:GetPhysicsObject():EnableGravity(false) end
			ply:PrintMessage(HUD_PRINTTALK, "Health/Mass Updated")
			return true
		end
	end	
end

function TOOL.BuildCPanel (CPanel)
	
	local VGUI = vgui.Create("WMHelpButton",CPanel);
		VGUI:SetTopic("Barracks");
		CPanel:AddPanel(VGUI);
	
	if LocalPlayer():IsAdmin() then
		CPanel:AddControl ("Slider", {
			Label = "Team number (ADMIN ONLY)",
			Command = "baseprops_teamnumber",
			Type = "Integer",
			Min = "1",
			Max = "7"
		} )
	end
	
	
	CPanel:AddControl ("Header", { Text="#Tool_baseprops_name", Description="#Tool_baseprops_desc" })
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "baseprops_model", Category = "Baseprops", Models = list.Get( "BasePropModels" ) } )
	
	
	CPanel:AddControl ("Slider", {
		Label = "Weight/Health/Cost (Percent)",
		Command = "baseprops_healthmod",
		Type = "Integer",
		Min = "1",
		Max = "100"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Weld",
		Description = "#Tool_baseprops_grav",
		Command = "baseprops_welded"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Gravity",
		Description = "#Tool_baseprops_grav",
		Command = "baseprops_gravity"
	} )
	
	CPanel:AddControl( "Checkbox", {
		Label = "Alternate placement method",
		Description = "#Tool_baseprops_placement",
		Command = "baseprops_alternate"
	} )
	
	CPanel:AddControl ("Slider", {
		Label = "Rotation",
		Command = "baseprops_aoffset",
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
	
    local tr    = util.GetPlayerTrace( player, player:GetAimVector() )
    local trace     = util.TraceLine( tr )
    if (!trace.Hit) then return end
    
    if (trace.Entity:IsPlayer() ) then
		
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
list.Set( "BasePropModels", "models/props_c17/fence03a.mdl", {} );
list.Set( "BasePropModels", "models/props_building_details/storefront_template001a_bars.mdl", {} );
list.Set( "BasePropModels", "models/props_c17/fence01a.mdl", {} );
list.Set( "BasePropModels", "models/props_c17/concrete_barrier001a.mdl", {} );
list.Set( "BasePropModels", "models/props_c17/concrete_barrier001a.mdl", {} );
list.Set( "BasePropModels", "models/props_lab/BlastDoor001c.mdl", {} );
list.Set( "BasePropModels", "models/props_lab/BlastDoor001a.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate2x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate4x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate1_tri.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate1x2_tri.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate2x2_tri.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_plate2x4_tri.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_tube.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_tubex2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x1x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire1x2x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire2x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/metal_wire2x2x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/glass/glass_plate1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/glass/glass_plate1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/glass/glass_plate2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/glass/glass_plate2x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/glass/glass_plate4x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/windows/window1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/windows/window1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/windows/window2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/windows/window2x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/windows/window4x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_boardx1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_boardx2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_boardx4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_panel1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_panel1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_panel2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_panel2x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_panel4x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x1x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire1x2x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire2x2b.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/wood/wood_wire2x2x2b.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x3.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x5.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate1x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x3.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x5.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate2x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x3.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x5.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate3x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate4x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate4x5.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate4x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate4x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate4x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate5x5.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate5x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate5x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate5x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate6x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate6x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate6x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate7x7.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate7x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/plates/plate8x8.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x025x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x05x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x075x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x1x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x125x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x150x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x2x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x3x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x5x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x7x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube025x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x05x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x075x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x1x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x2x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x3x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x5x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x7x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x075x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x1x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x2x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x3x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x1x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x2x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x3x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x5x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x7x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x2x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube3x3x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube3x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube3x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube3x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x4x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x6x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x025.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x05x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x105x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x1x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x2x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x3x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x4x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x5x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x6x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x7x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube05x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x1x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x2x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x4x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x6x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x2x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x4x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x6x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube3x3x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x4x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x6x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x05.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x075x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x1x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x2x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x3x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x4x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x5x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x6x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x7x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x8x075.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x1x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x2x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube075x3x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x1x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x2x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x3x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x4x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x6x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube1x8x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x1x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x2x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x4x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x6x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x8x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x4x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x8x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x6x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x8x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x1.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube2x2x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x4x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x6x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x8x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x4x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x4.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x2.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube4x6x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube6x6x6.mdl", {} );
list.Set( "BasePropModels", "models/hunter/blocks/cube8x8x8.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_angle_90.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_angle_180.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_angle_360.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel1x1.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel1x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel1x3.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel1x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel1x8.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel2x2.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel2x3.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel2x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel2x8.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel3x3.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel4x4.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel4x8.mdl", {} );
list.Set( "BasePropModels", "models/props_phx/construct/plastic/plastic_panel8x8.mdl", {} );
list.Set( "BasePropModels", "models/props_c17/FurnitureBed001a.mdl", {} );