CreateConVar( "WM_Rules", "0" )
function physgunPickup( pl, ent )
--the totally immobiles  

	if ent:GetClass() == "lap_nrgtransfer" or ent:GetClass() == "lap_spawnpoint" or ent:GetClass() == "lap_nrgtower" or ent:GetClass() == "lap_cappoint" or ent:GetClass() == "env_headcrabcanister" or ent:GetClass() == "lap_outpost" or ent:GetClass() == "prop_physics" then
			if pl:IsAdmin() then
			return true
			else
			return false
		  end
	end
	if ent:GetClass() == "melon_baseprop" || string.find(ent:GetClass(), "johnny_") ~= nil || string.find(ent:GetClass(), "lap_") ~= nil then
		if pl:GetNWInt("melonteam") ~= ent.Team && pl:GetNWInt("melonteam") ~= 0 then
		return false
		end
		
		if pl:GetNWInt("melonteam") == ent.Team then
	if server_settings.Int( "WM_Buildradius", 750 ) ~= 0 then
      local disfin = 0
     	local entz = ents.FindByClass("lap_spawnpoint");
	    local entz2 = ents.FindByClass("lap_outpost");
	    local cteam = pl:GetNWInt("melonteam")
    	for k, v in pairs(entz) do
  	  local dist = v:GetPos():Distance(ent:GetPos());
  		  if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
  		  disfin = 1
  		  end
  	  end
    	for k, v in pairs(entz2) do
    	local dist = v:GetPos():Distance(ent:GetPos());
    		if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
    		disfin = 1
    		end
    	end
    	 if disfin == 1 then
    	 return true
    	 else 
       return false
       end
      else
      return true
      end
   end
	end
--the sometimes mobile
end

function UseTool( pl, tr, toolmode )
if server_settings.Int( "WM_Rules", 1) == 0 then
hook.Remove( "SetPlayerspeed", "Speed", GMSetSpeed)
hook.Remove( "PlayerLoadout", "WMloadout", Loadout)
hook.Remove( "CanTool", "lap_usetool", UseTool ); 
hook.Remove( "PhysgunPickup", "wm_physgunPickup", physgunPickup ); 
hook.Remove( "GravGunPickupAllowed", "wm_gravgunPickup", physgunPickup ); 
hook.Remove("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp) ;
hook.Remove( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
game.ConsoleCommand("wm_buildradius 0\n")
else
hook.Add( "SetPlayerspeed", "Speed", GMSetSpeed)
hook.Add( "PlayerLoadout", "WMloadout", Loadout)
hook.Add( "CanTool", "lap_usetool", UseTool ); 
hook.Add( "PhysgunPickup", "wm_physgunPickup", physgunPickup ); 
hook.Add( "GravGunPickupAllowed", "wm_gravgunPickup", physgunPickup );
hook.Add( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
end
if toolmode == "physprop" && pl:IsAdmin() == false then
return false
end
	local ent = tr.Entity;
	if ent ~= nil then
	if ent:GetClass() == "lap_uplink" then
		if toolmode == "wire_debugger" || toolmode == "wire" then
		return true
		end
	end
	if ent:GetClass() == "lap_nrgtransfer" or ent:GetClass() == "lap_spawnpoint" or ent:GetClass() == "lap_nrgtower" or ent:GetClass() == "lap_cappoint" or ent:GetClass() == "env_headcrabcanister" or ent:GetClass() == "lap_outpost" or ent:GetClass() == "prop_physics" then
		if toolmode == "legalizer" then
		return true
		end

                if pl:IsAdmin() then
		return true
		else
                return false
		end
	end
	end
	if tr.Entity:IsValid() then
        if ent:GetClass() == "melon_baseprop" || string.find(ent:GetClass(), "johnny_") ~= nil || string.find(ent:GetClass(), "lap_") ~= nil then 
            if pl:GetNWInt("melonteam") ~= ent.Team && pl:GetNWInt("melonteam") ~= 0 then
		    return false
		    end
        end
    end
	
	if toolmode == "colour" then
	return false
	end
	
	if toolmode == "hoverball"  then
	local str = pl:GetTool():GetClientNumber( "strength" )
	local cost = math.floor(str * server_settings.Int( "WM_HoverCost", 2500 ))
	local cteam = pl:GetNWInt("melonteam")
    local disfin = 0
		if server_settings.Int( "WM_Buildradius", 750 ) ~= 0 then
     	local entz = ents.FindByClass("lap_spawnpoint");
	    local entz2 = ents.FindByClass("lap_outpost");
	    local cteam = pl:GetNWInt("melonteam")
    	   for k, v in pairs(entz) do
  	       local dist = v:GetPos():Distance(tr.HitPos);
  		    if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
  		    disfin = 1
  		    end
  	       end
    	   for k, v in pairs(entz2) do
    	   local dist = v:GetPos():Distance(tr.HitPos);
    	       if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
    	       disfin = 1
    	       end
    	   end
    	 else
    	 disfin = 1
    	 end
    	 if disfin == 1 then
    if pl:GetNWInt("nrg") >= cost then
    pl:SetNWInt("nrg", pl:GetNWInt("nrg") - cost)
   	local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
	pl:PrintMessage(HUD_PRINTTALK, message)
    return true
    else
    local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
	pl:PrintMessage(HUD_PRINTTALK, message)
    return false
	end
	else
	pl:PrintMessage(HUD_PRINTTALK, "Too far from spawnpoint or outpost")
	return false
	end
	end
	
	if toolmode == "wheel" || toolmode == "thruster" || toolmode == "motor" || toolmode == "balloon" || toolmode == "stargate_shield" || toolmode == "stargate_cloaking" || toolmode == "wraith_harvester" then
    	local str = 0
	   if toolmode == "wheel" || toolmode == "motor" then
	   str = pl:GetTool():GetClientNumber( "torque" )
	   else
	   str = pl:GetTool():GetClientNumber( "force" )
	   end
	local cost = math.floor(str * server_settings.Int( "WM_WheelandThrusterCost", 4 ))
	local cteam = pl:GetNWInt("melonteam")
    local disfin = 0
		if server_settings.Int( "WM_Buildradius", 750 ) ~= 0 then
     	local entz = ents.FindByClass("lap_spawnpoint");
	    local entz2 = ents.FindByClass("lap_outpost");
	    local cteam = pl:GetNWInt("melonteam")
    	   for k, v in pairs(entz) do
  	       local dist = v:GetPos():Distance(tr.HitPos);
  		    if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
  		    disfin = 1
  		    end
  	       end
    	   for k, v in pairs(entz2) do
    	   local dist = v:GetPos():Distance(tr.HitPos);
    	       if (v.Team == cteam && dist < server_settings.Int( "WM_Buildradius", 750 )) then
    	       disfin = 1
    	       end
    	   end
    	 else
    	 disfin = 1
    	 end
    	 if disfin == 1 then
    if toolmode == "stargate_shield" || toolmode == "stargate_cloaking" || toolmode == "wraith_harvester" then
        if toolmode ~= "wraith_harvester" then
        cost = 100000
        else
        cost = pl:GetTool():GetClientNumber( "size") * 400     
        end
    timer.Simple(1, WMSGMod, pl)
    end
    if pl:GetNWInt("nrg") >= cost then
    pl:SetNWInt("nrg", pl:GetNWInt("nrg") - cost)
   	local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
	pl:PrintMessage(HUD_PRINTTALK, message)
    return true
    else
    local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
	pl:PrintMessage(HUD_PRINTTALK, message)
    return false
	end
	else
	pl:PrintMessage(HUD_PRINTTALK, "Too far from spawnpoint or outpost")
	return false
	end
	end
end

function WMSGMod(ply)
    for k, v in pairs(ents.FindByClass("shield_generator")) do
        if v.RestoreThresold ~= 30 then
        v.StrengthConfigMultiplier = 0.2
        v.RestoreThresold = 30
        v.maxhealth = 25 + (v.Size / 3)
        SGLegalize(v, ply)
        end
    end
    for k, v in pairs(ents.FindByClass("cloaking_generator")) do
        if v.maxhealth == nil then
        v.maxhealth = 25 + (v.Size / 3)
        SGLegalize(v, ply)
        end
    end
    for k, v in pairs(ents.FindByClass("wraith_harvester")) do
        if v.maxhealth == nil then
        v.maxhealth = 100
        SGLegalize(v, ply)
        end
    end
end

function SGLegalize(v, ply)
        local team = ply:GetNWInt("melonteam")
        v.health = v.maxhealth
        v.damaged = 0
    					function v:OnTakeDamage(DmgInfo)
                        DamageLS(self.Entity, DmgInfo:GetDamage())
						end
						function v:Damage()
	                       if (self.damaged == 0) then
	                       	self.damaged = 1
                        	end
                        end
                        function v:Destruct()
                        LS_Destruct(self.Entity)
                        end
        if (team == 1) then
		v:SetColor(Color(255, 0, 0, 255));
		elseif (team == 2) then
		v:SetColor(Color(0, 0, 255, 255));
        elseif (team == 3) then
		v:SetColor(Color(0, 255, 0, 255));
        elseif (team == 4) then
		v:SetColor(Color(255, 255, 0, 255));
        elseif (team == 5) then
		v:SetColor(Color(255, 0, 255, 255));
        elseif (team == 6) then
		v:SetColor(Color(0, 255, 255, 255));
		end

	v.infot = ents.Create("info_target");
	v.infot:SetPos(v:GetPos());
	v.infot:Spawn();
	v.infot:Activate();
	v.infot:SetParent(v);
	v.infot.Warmelon = true;
	v.infot.Team = team
end
--function PlayerCanPickupWeapon(ply, wep)
--if wep == "weapon_physgun" || wep == "gmod_camera" || wep == "gmod_toolgun" then
--return true
--else
--return false
--end
--end
--hook.Add("PlayerCanPickupWeapon", "RandomUniqueName", PlayerCanPickupWeapon) 

function Loadout( ply )
ply:Give("weapon_physgun")
ply:SelectWeapon("weapon_physgun")
ply:Give("gmod_camera")
ply:Give("gmod_tool")
return true
end

if server_settings.Int( "WM_Rules", 1) == 1 then
hook.Add( "SetPlayerspeed", "Speed", GMSetSpeed)
hook.Add( "PlayerLoadout", "WMloadout", Loadout)
hook.Add( "CanTool", "lap_usetool", UseTool ); 
hook.Add( "PhysgunPickup", "wm_physgunPickup", physgunPickup ); 
hook.Add( "GravGunPickupAllowed", "wm_gravgunPickup", physgunPickup );
hook.Add( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
end