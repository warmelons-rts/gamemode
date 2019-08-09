TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Launcher"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "welded" ] = "0"
TOOL.ClientConVar[ "teamnumber" ] = "1"
TOOL.ClientConVar[ "alternate" ] = "0"
TOOL.ClientConVar[ "aoffset" ] = "0"
TOOL.ClientConVar[ "model" ] = "models/props_c17/oildrum001.mdl"
--Name, model, force, ammo, cost, fire rate, mass, damage multiplier, standard name, damping, ~range, sound, ?
local launchertbl = {

{ "Shorty", "models/wmm/short.mdl", 900,  2,  5000, 2, 1000, 1.25, "Short & Small", 0.95, "1350", "ambient/explosions/explode_4.wav", 175},
{ "Standard Small", "models/wmm/shortb.mdl", 1000, 3,  7500, 3, 1750, 1.5,  "Short & Standard",  0.775, "1650", "ambient/explosions/explode_4.wav", 150},
{ "The Chode", "models/wmm/shortc.mdl", 1100, 3, 10000, 4, 2500, 2.5, "Short & Large", 0.6, "2000", "ambient/explosions/explode_4.wav", 125}, 
{ "Micro Medium", "models/wmm/medium.mdl", 1200, 3, 10000, 3, 1750, 1,  "Medium & Small", 0.485, "2350", "ambient/explosions/explode_4.wav", 110},
{ "Medium Standard", "models/wmm/mediumb.mdl", 1350, 5, 15000, 3.5, 2600, 1.5, "Medium & Standard", 0.34, "2930", "ambient/explosions/explode_4.wav", 100},
{ "Extended Medium", "models/wmm/mediumc.mdl", 1500, 5, 20000, 3.5, 3000, 2, "Medium & Large", 0.23, "3600", "ambient/explosions/explode_4.wav", 85},
{ "Messenger", "models/wmm/long.mdl", 1425, 4, 15000, 4, 2250, 1, "Long & Slim",0.28, "3250", "ambient/explosions/explode_4.wav", 65},
{ "Diplomat", "models/wmm/longb.mdl", 1600, 5, 25000, 5, 3500, 2, "Long & Standard",0.175, "4075", "ambient/explosions/explode_4.wav", 50},
{ "Ambassador", "models/wmm/longc.mdl", 1750, 5, 30000, 6, 4250, 2.25, "Long & Large", 0.095,"4850", "ambient/explosions/explode_4.wav", 40},
{ "Big Bertha", "models/wmm/bertha.mdl", 2000, 8, 50000, 10, 6750, 3, "Massive",0, "6280", "ambient/explosions/explode_5.wav", 60},
{ "Quad Cannon", "models/wmm/quad.mdl", 1050, 8, 20000, 1, 3000, 1.25, "Quad Cannon (Short)",0.70, "1800", "ambient/explosions/explode_2.wav", 125},
{ "Double Barrel", "models/wmm/double.mdl", 1150, 4, 10000, 0.5, 2250, 1.25, "Double Barrel",0.55, "2160", "ambient/explosions/explode_2.wav", 150}
}
if (CLIENT) then
	language.Add( "Tool_lap_launchers_name", "Launcher" )
	language.Add( "Tool_lap_launchers_desc", "Creates very buoyant props for navies." )
	language.Add( "Tool_lap_launchers_0", "Left-click to spawn a launcher prop. Right-click to check the cost.")
    language.Add( "Undone_lap_launchers", "Undone launcher" )
end

function TOOL:LeftClick (trace)

	if ( SERVER ) then
		local Type = self:ModelCheck()
		local cost = 9999999
		if Type ~= 0 then
			cost = launchertbl[Type][5]* GetConVarNumber("WM_Toolcost", 1)
		end
		local ply = self:GetOwner()
		trace = ply:GetEyeTraceNoCursor()
		local Pos = trace.HitPos
		local Ang = trace.HitNormal:Angle()
		
		local cteam = 0
		
		if !InOutpostRange(ply, Pos) then return false end
		if ply:Team() ~= 0 then
			cteam = ply:Team()
		else
			cteam = self:GetClientNumber("teamnumber")
		end
		
		if !NRGCheck(ply, cost) then return false end
		if (trace.Hit && !trace.HitNoDraw) then
			local t = cteam
			melon = ents.Create ("lap_launcher");
				melon.Cost = cost
				melon:SetModel(self:GetClientInfo("model"))
				melon:SetPos(trace.HitPos)
				melon:SetAngles(Ang)
				melon.Team = cteam;
				melon.model = self:GetClientInfo("model");
				--melon.Force = launchertbl[Type][3]
				melon.Force = 2000
				melon.Multiplier = launchertbl[Type][8]
				melon.damping = launchertbl[Type][10]
				melon.MaxAmmo = launchertbl[Type][4]
				melon.mass = launchertbl[Type][7]
				--melon.FireDelay = launchertbl[Type][6]
				melon.FiringRate = launchertbl[Type][6]
				melon.DamageMultiplier = launchertbl[Type][8]
				melon.LauncherData = launchertbl[Type]
				--melon.Sound = CreateSound(melon, launchertbl[Type][12])
				melon.Sound = launchertbl[Type][12]
				melon.Pitch = launchertbl[Type][13]
				melon:Spawn();
				ply:AddCount('lap_melons', melon)
				melon:Activate();
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
			--local vFlushPoint = trace.HitPos - ( trace.HitNormal * 512 )	// Find a point that is definitely out of the object in the direction of the floor 
			--vFlushPoint = melon:NearestPoint( vFlushPoint )			// Find the nearest point inside the object to that point 
			--vFlushPoint = melon:GetPos() - vFlushPoint				// Get the difference 
			--vFlushPoint = trace.HitPos + vFlushPoint					// Add it to our target pos 
			--melon:SetPos( vFlushPoint ) 					
			melon:GetPhysicsObject():SetMass(launchertbl[Type][7])
			upright = constraint.Weld (melon, trace.Entity, 0, trace.PhysicsBone, 0, true)
			trace.Entity:DeleteOnRemove(melon);
			undo.Create("Launchers");
				undo.AddEntity (melon);
				undo.AddEntity (upright)
				undo.SetPlayer (self:GetOwner());
			undo.Finish();

		end
	end
end

function TOOL:Reload(trace)
if (SERVER) then
trace.Entity.Force = self:GetClientNumber("force")
return true
end
end

function TOOL:RightClick ()
local Type = self:ModelCheck()
	if (SERVER) then
	local ply = self:GetOwner()
	local cost = launchertbl[Type][5] * GetConVarNumber("WM_Toolcost", 1)
	WMSendCost(ply, cost, false)
	
	
	--if (CLIENT) then
	--Msg("shit")
	ply:PrintMessage(HUD_PRINTTALK, launchertbl[Type][1] .. " Max Ammo: " .. launchertbl[Type][4] .. " Reload Rate: " .. launchertbl[Type][6] .. " Mass: " .. launchertbl[Type][7] .. " Damage: x" .. launchertbl[Type][8] .. " Range: ~" .. launchertbl[Type][11])
	--end
	end	
end

function TOOL:ModelCheck()
local mdl = self:GetClientInfo("model");
local Type = 0
	if mdl == "models/wmm/short.mdl" then
	Type = 1
	elseif mdl == "models/wmm/shortb.mdl" then
	Type = 2
	elseif mdl == "models/wmm/shortc.mdl" then
	Type = 3
	elseif mdl == "models/wmm/medium.mdl" then
	Type = 4
	elseif mdl == "models/wmm/mediumb.mdl" then
	Type = 5
	elseif mdl == "models/wmm/mediumc.mdl" then
	Type = 6
	elseif mdl == "models/wmm/long.mdl" then
	Type = 7
	elseif mdl == "models/wmm/longb.mdl" then
	Type = 8
	elseif mdl == "models/wmm/longc.mdl" then
	Type= 9
	elseif mdl == "models/wmm/bertha.mdl" then
	Type = 10
	elseif mdl == "models/wmm/quad.mdl" then
	Type = 11
	elseif mdl == "models/wmm/double.mdl" then
	Type = 12
	end
return Type
end



function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_launchers_name", Description="#Tool_lap_launchers_desc" })
			local VGUI = vgui.Create("WMHelpButton",CPanel);
			VGUI:SetTopic("launchers Tank");
			CPanel:AddPanel(VGUI);
	CPanel:AddControl( "PropSelect", { Label = "Model", ConVar = "lap_launchers_model", Category = "lap_launchers", Models = list.Get( "launchersModels" ) } )
		CPanel:AddControl ("Slider", {
		Label = "Team number (ADMIN ONLY)",
		Command = "lap_launchers_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "7"
	} )
		CPanel:AddControl( "Checkbox", {
		Label = "Alternate placement method",
		Description = "Switches the placement alignment.",
		Command = "lap_launchers_alternate"
	} )
	
	CPanel:AddControl ("Slider", {
		Label = "Rotation",
		Command = "lap_launchers_aoffset",
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
	
	if (trace.Entity && trace.Entity:GetClass() == "lap_launchers" || trace.Entity:IsPlayer()) then
	
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


list.Set( "launchersModels", "models/wmm/short.mdl", {} );
list.Set( "launchersModels", "models/wmm/shortb.mdl", {} );
list.Set( "launchersModels", "models/wmm/shortc.mdl", {} );
list.Set( "launchersModels", "models/wmm/medium.mdl", {} );
list.Set( "launchersModels", "models/wmm/mediumb.mdl", {} );
list.Set( "launchersModels", "models/wmm/mediumc.mdl", {} );
list.Set( "launchersModels", "models/wmm/long.mdl", {} );
list.Set( "launchersModels", "models/wmm/longb.mdl", {} );
list.Set( "launchersModels", "models/wmm/longc.mdl", {} );
list.Set( "launchersModels", "models/wmm/bertha.mdl", {} );
list.Set( "launchersModels", "models/wmm/quad.mdl", {} );
list.Set( "launchersModels", "models/wmm/double.mdl", {} );