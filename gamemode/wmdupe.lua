function CapPointDupe (ply, Pose, angles, modele)
if ply:IsAdmin() or ply:GetNetworkedInt("chosenone") == 1 then
	local melon = ents.Create("lap_cappoint");
	melon:SetPos(Pose);
	melon:SetAngles(angles)
	melon:SetModel(modele)
	melon:Spawn();
	melon:Activate();
end
end
duplicator.RegisterEntityClass("lap_cappoint", CapPointDupe, "Pos", "Angle", "Model")

function CommUplinkDupe (ply, Pose, angles, modele)
if ply:IsAdmin() or ply:GetNetworkedInt("chosenone") == 1 then
	local melon = ents.Create("lap_resnode");
	melon:SetPos(Pose);
	melon:SetAngles(angles)
	melon:SetModel(modele)
	melon:Spawn();
	melon:Activate();
end
end
duplicator.RegisterEntityClass("lap_commuplink", CommUplinkDupe, "Pos", "Angle", "Model")

function NoBuildAreaDupe (ply, Pose, angles, modele)
return false
end
duplicator.RegisterEntityClass("lap_capfort", CapfortDupe, "Pos", "Angle", "Model")

function CapfortDupe (ply, Pose, angles, modele)
return false
end
duplicator.RegisterEntityClass("lap_capfort", CapfortDupe, "Pos", "Angle", "Model")

function ResNodeDupe (ply, Pose, angles, modele)
return false
end
duplicator.RegisterEntityClass("nobuildarea", NoBuildAreaDupe, "Pos", "Angle", "Model")

function TransportDupe(ply, Pose, angles, modele)
return false
end
duplicator.RegisterEntityClass("lap_transport", TransportDupe, "Pos", "Angle", "Model")

function OrderCoreDupe (ply, Pose, Movee, Grave, MF, DF, Marinee, Teame, ZOnlye)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_ordermelon");
	if (!melon:IsValid()) then return false end
	melon:SetPos (Pose);
	local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = Grave;
		MovingForce = MF;
		Damping = DF;
		Marine = Marinee;
		ZOnly = ZOnlye
	}
	local mov = 0
	local Gra = 0
	local Mar = 0
if Movee then 
  mov = 1
  else
  mov = 0
  end  
  if Grave then 
  Gra = 1
  else
  Gra = 0
  end
  if Marinee then 
  Mar = 1
  else
  Mar = 0
  end 
	table.Merge(melon, tab);
		if InOutpostRange(ply, Pose) then
	local cost = math.floor((2000+MF*5+DF*100-Gra*1000+Mar*500)*server_settings.Int( "WM_toolcost", 1)*server_settings.Int("WM_OrderCoreCost", 0.5))
    if NRGCheck(ply, cost) then
      melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end

end
duplicator.RegisterEntityClass("johnny_ordermelon", OrderCoreDupe, "Pos", "Move", "Grav", "MovingForce", "Damping", "Marine", "Team", "ZOnly");

function FighterDupe (ply, Pose, Marinee, Movee, Grave, Ange, Teame, Blinke)
	if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_fighter");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team();
	else
		lteam = Teame;
	end
	local tab = {
		Team = lteam;
		Marine = Marinee;
		Move = Movee;
		Grav = Grave;
		Blink = Blinke
	}
	local mov = 0
	local Gra = 0
	local Mar = 0
	if Movee then 
		mov = 1
	else
		mov = 0
	end  
	if Grave then 
		Gra = 1
	else
		Gra = 0
	end
	if Marinee then 
		Mar = 1
	else
		Mar = 0
	end 
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
		
		--Cant do arithmetic on boolean values
		local blinker = 0
		if (util.tobool(Blinke) == true) then
			blinker = 1
		end
		
		local cost = ((1500+mov*1000-Gra*1000+500*Mar+blinker*500)*server_settings.Int( "WM_toolcost", 1))
		if NRGCheck(ply, cost) then
			melon.Cost = cost;
			melon:Spawn();
			ply:AddCount('lap_melons', melon)
			melon:Activate();
			DoPropSpawnedEffect(melon);
			return melon;
		end
	end
end
duplicator.RegisterEntityClass("johnny_fighter", FighterDupe, "Pos", "Marine", "Move", "Grav", "Ang", "Team", "Blink");


function CannonDupe (ply, Pose, Movee, Grave, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_cannon");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = true;
	}
	local mov = 0
	local Gra = 0
	if Movee then 
  mov = 1
  else
  mov = 0
  end  

	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((2000+mov*2000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
      melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("johnny_cannon", CannonDupe, "Pos", "Move", "Grav", "Ang", "Team");

function HarvesterDupe (ply, Pose, Movee, Stancee, Grave, Ange, Teame)
	if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_harvester");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team();
	else
		lteam = Teame;
	end
	local tab = {
		Team = lteam;
		Move = Movee;
		S = Stancee,
		Stance = Stancee,
		Grav = true;
	}
	local mov = 0
	local Gra = 0
	if Movee then 
		mov = 1
	else
		mov = 0
	end  
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
		local cost = ((3000+mov*5000)*server_settings.Int( "WM_toolcost", 1))
		if NRGCheck(ply, cost) then
			melon.Cost = cost;
			melon:Spawn();
			ply:AddCount('lap_melons', melon)
			melon:Activate();
			DoPropSpawnedEffect(melon);
			return melon;
		end
	end
end
duplicator.RegisterEntityClass("lap_harvester", HarvesterDupe, "Pos", "Move", "Stance", "Grav", "Ang", "Team");

function LightFighterDupe (ply, Pose, Movee, Grave, Ange, Teame, Phasinge)
	if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_lightfighter");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team();
	else
		lteam = Teame;
	end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = Grave;
		Phasing = Phasinge
	}
	local mov = 0
	local Gra = 0
	if Movee then 
		mov = 1
	else
		mov = 0
	end  
	if Grave then 
		Gra = 1
	else
		Gra = 0
	end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
		--Cant do arithmetic on boolean values
		local phaser = 0
		if (util.tobool(Phasinge) == true) then
			phaser = 1
		end
		
		local cost = ((750+mov*250-Gra*500+phaser*250)*server_settings.Int( "WM_toolcost", 1))
		if NRGCheck(ply, cost) then
			melon.Cost = cost;
			melon:Spawn();
			ply:AddCount("lap_melons", melon)
			melon:Activate();
			DoPropSpawnedEffect(melon);
			return melon;
		end
	end
end
duplicator.RegisterEntityClass("johnny_lightfighter", LightFighterDupe, "Pos", "Move", "Grav", "Ang", "Team", "Phasing");

function BombDupe (ply, Pose, Movee, Grave, Ange, Teame, Minee, Payloade )
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_bomb");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
	    Mine = Minee;
		Team = lteam;
		Move = Movee;
		Grav = Grave;
		Payload = Payloade;
	}
	local mov = 0
	local Gra = 0
	if Movee then 
  mov = 1
  else
  mov = 0
  end  
  if Grave then 
  Gra = 1
  else
  Gra = 0
  end

	table.Merge(melon, tab);
	local chkspawn = 0
	if Minee || mov == 0 then
	if InOutpostRange(ply, Pose) then chkspawn = 1 end
	else
	if InBaseRange(ply, Pose) then chkspawn = 1 end
	end
	if chkspawn == 1 then
	local cost = ((250+mov*750)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_bomb", BombDupe, "Pos", "Move", "Grav", "Ang", "Team", "Mine", "Payload");

function SniperDupe (ply, Pose, Movee, Grave, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_sniper");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = true;
	}
	local mov = 0
	local Gra = 0
	if Movee then 
  mov = 1
  else
  mov = 0
  end  
  if Grave then 
  Gra = 1
  else
  Gra = 0
  end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((1000+mov*1000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_sniper", SniperDupe, "Pos", "Move", "Grav", "Ang", "Team");

function MGDupe (ply, Pose, Movee, Grave, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_mg");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = true;
	}
	local mov = 0
	local Gra = 0
	if Movee then 
  mov = 1
  else
  mov = 0
  end  
  if Grave then 
  Gra = 1
  else
  Gra = 0
  end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((1000+mov*1000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_mg", MGDupe, "Pos", "Move", "Grav", "Ang", "Team");

function PCannonDupe (ply, Pose, Movee, Grave, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_pcannon");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = false;
		Grav = true;
	}
	local mov = 0
	local gra = 0
	if Movve then 
  mov = 1
  else
  mov = 0
  end  
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((3000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("johnny_pcannon", PCannonDupe, "Pos", "Move", "Grav", "Ang", "Team");

function MedicDupe (ply, Pose, Movee, Grave, Ange, LOLFXe, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_medic");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Move = Movee;
		Grav = true;
		LOLFX = LOLFXe;
	}
	local mov = 0
	local Gra = 0
	local lolz = 0
	if Movee then 
  mov = 1
  else
  mov = 0
  end  
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((1500+mov*1500)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("johnny_medic", MedicDupe, "Pos", "Move", "Grav", "Ang", "LOLFX", "Team");

function LaserDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("johnny_laser_l");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Grav = true
	}
	local gra = 0
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((2000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("johnny_laser_l", LaserDupe, "Pos", "Ang", "Team");

function FlakDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_flak");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((4000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_flak", FlakDupe, "Pos", "Ang", "Team");

function TorpLauncherDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_torplauncher");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((5000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
    melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_torplauncher", TorpLauncherDupe, "Pos", "Ang", "Team");

function BallastDupe (ply, Pose, Modele, Ange, Teame)
if ( !ply:CheckLimit( "lap_baseprops" ) ) then return false end
	local melon = ents.Create("lap_ballast");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local mdlmass = 10000
        if Modele == "models/props_c17/oildrum001.mdl" then
        mdlmass = 75
        elseif Modele == "models/props_borealis/bluebarrel001.mdl" then
        mdlmass = 100
        elseif Modele == "models/props_c17/canister_propane01a.mdl" then
        mdlmass = 200
        elseif Modele == "models/xqm/cylinderx1large.mdl" then
        mdlmass = 300
        elseif Modele == "models/props_wasteland/laundry_washer003.mdl" then
        mdlmass = 500
        elseif Modele == "models/props_wasteland/coolingtank02.mdl" then
        mdlmass = 750
        elseif Modele == "models/props_wasteland/horizontalcoolingtank04.mdl" then
        mdlmass = 1000
        end
	local tab = {
		Team = lteam;
		model = Modele;
		mass = mdlmass
		
	}

	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((mdlmass * 3) * server_settings.Int("WM_Toolcost", 1))
    if NRGCheck(ply, cost) then
    melon.Cost = cost;
    melon:SetModel(Modele)
	  melon:Spawn();
	  ply:AddCount('lap_baseprops', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_ballast", BallastDupe, "Pos", "model", "Ang", "Team");

function MortarDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_melons" ) ) then return false end
	local melon = ents.Create("lap_mortar");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((5000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_melons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_mortar", MortarDupe, "Pos", "Ang", "Team");

function KaboomDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	local melon = ents.Create("lap_kaboom");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = (250000*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_superweapons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_kaboom", KaboomDupe, "Pos", "Ang", "Team");

function MicrowaveLaserDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	local melon = ents.Create("lap_microwavelaser");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = (100000*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_superweapons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_microwavelaser", MicrowaveLaserDupe, "Pos", "Ang", "Team");

function ChaosDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	local melon = ents.Create("lap_chaos");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = (100000*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_superweapons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_chaos", ChaosDupe, "Pos", "Ang", "Team");

function MindControlDupe (ply, Pose, Ange, Teame)
	//disable duping for a while
	if (true) then return false end
	if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	if InBaseRange(ply, Pose) then
		local cost = (250000*server_settings.Int( "WM_toolcost", 1))
		if NRGCheck(ply, cost) then
			local melon = ents.Create("lap_mindcontrol");
			if (!melon:IsValid()) then return false end
			melon:SetPos(Pose);
			melon:SetAngles(Ange);	
			local lteam = 0
			if ply:Team() ~= 0 then
				lteam = ply:Team();
			else
				lteam = Teame;
			end
			local tab = {
				Team = lteam;
			}
			table.Merge(melon, tab);
            melon.Cost = cost;
			melon:Spawn();
			ply:AddCount('lap_superweapons', melon)
			melon:Activate();
			DoPropSpawnedEffect(melon);
			return melon;
		end
	end
end
duplicator.RegisterEntityClass("lap_mindcontrol", MindControlDupe, "Pos", "Ang", "Team");

function RegenCoreDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	local melon = ents.Create("lap_regencore");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = (150000*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_superweapons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_regencore", RegenCoreDupe, "Pos", "Ang", "Team");

function LeaderDupe (ply, Pose, Ange, Teame)
if ( !ply:CheckLimit( "lap_superweapons" ) ) then return false end
	local melon = ents.Create("lap_leader");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
	}
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = (150000*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_superweapons', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_leader", LeaderDupe, "Pos", "Ang", "Team");

function BarracksDupe (ply, Pose, Ange, Grave, MelonGrave, FollowRangee, Teame, MaxMelonse)
if ( !ply:CheckLimit( "lap_barracks" ) ) then return false end
	local melon = ents.Create("johnny_barracks");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Grav = true;
		MelonGrav = MelonGrave;
		FollowRange = FollowRangee;
		MaxMelons = MaxMelonse;
	}
	local MGra = 0
	if MelonGrave then 
  MGra = 1
  else
  MGra = 0
  end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((8000-MGra*4000)*server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_barracks', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("johnny_barracks", BarracksDupe, "Pos", "Ang", "Grav", "MelonGrav", "FollowRange", "Team", "MaxMelons");

function HeavyBarracksDupe (ply, Pose, Ange, Grave, MelonGrave, FollowRangee, Teame, MelonMarinee, MaxMelonse)
if ( !ply:CheckLimit( "lap_barracks" ) ) then return false end
	local melon = ents.Create("lap_heavybarracks");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
local lteam = 0
		if ply:Team() ~= 0 then
		lteam = ply:Team();
		else
		lteam = Teame;
		end
	local tab = {
		Team = lteam;
		Marine = Marinee;
		Grav = true;
		FollowRange = FollowRangee;
		MelonGrav = MelonGrave;
		MaxMelons = MaxMelonse;
	}
    local MGra = 0
    local Mar = 0
  if Marinee then 
  Mar = 1
  else
  Mar = 0
  end
  if MelonGrave then 
              MGra = 1
              else
              MGra = 0
              end
  if MelonMarinee then 
              MM = 1
              else
              MM = 0
              end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
	local cost = ((10000 - MGra * 5000 + MM * 2500) * server_settings.Int( "WM_toolcost", 1))
    if NRGCheck(ply, cost) then
                  melon.Cost = cost;
	  melon:Spawn();
	  ply:AddCount('lap_barracks', melon)
	  melon:Activate();
	  DoPropSpawnedEffect(melon);
	  return melon;
	  end
	end
end
duplicator.RegisterEntityClass("lap_heavybarracks", HeavyBarracksDupe, "Pos", "Ang", "Grav", "MelonGrav", "FollowRange", "Team", "MelonMarine", "MaxMelons");

function MunitionsDupe (ply, Pose, Ange, Grave, Stancee, MelonGrave, FollowRangee, Payloade, Teame, MelonMovee, Minee, MaxMelonse)
	if ( !ply:CheckLimit( "lap_barracks" ) ) then return false end
	local melon = ents.Create("lap_munitions");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);	
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team();
	else
		lteam = Teame;
	end
	local tab = {
		Team = lteam;
		Grav = true;
		Stance = Stancee,
		Mine = Minee;
		MelonGrav = MelonGrave;
		MelonMove = MelonMovee;
		FollowRange = FollowRangee;
		Payload = Payloade,
		MaxMelons = MaxMelonse;
	}
	local MGra = 0
	local MM = 0
	if MelonGrave then 
		MGra = 1
	else
		MGra = 0
	end
	if MelonMove then 
		MM = 1
	else
		MM = 0
	end
	table.Merge(melon, tab);
	if InBaseRange(ply, Pose) then
		local cost = (12500-MGra*10000+MM*7500)*server_settings.Int( "WM_toolcost", 1)
		if NRGCheck(ply, cost) then
			melon.Cost = cost;
			melon:Spawn();
			ply:AddCount('lap_barracks', melon)
			melon:Activate();
			DoPropSpawnedEffect(melon);
			return melon;
		end
	end
end
duplicator.RegisterEntityClass("lap_munitions", MunitionsDupe, "Pos", "Ang", "Grav", "Stance", "MelonGrav", "FollowRange", "Payload", "Team", "MelonMove", "Mine", "MaxMelons");

function BasePropDupe (ply, Pose, Masse, modele, Ange, Grave, MaxHealthe, Teame)
	if ( !ply:CheckLimit( "lap_baseprops" ) ) then return false end
	local melon = ents.Create("melon_baseprop");
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose);
	melon:SetAngles(Ange);
	
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team();
	else
		lteam = Teame;
	end
	local tab = {
		Team = lteam;
		Grav = Grave;
        Grav = true;
		model = modele;
		mass = Masse;
	}
	table.Merge(melon, tab);
	local MGra = 0
	if Grave ~= nil && Grave == true then 
		MGra = 3
	else
		MGra = 1
	end
	table.Merge(melon, tab);
	if InOutpostRange(ply, Pose) then
		local cost = (Masse*server_settings.Int( "WM_healthtomass", 2)*server_settings.Int( "WM_propcost", 3)*MGra)
		local cost = (Masse*server_settings.Int( "WM_healthtomass", 2)*server_settings.Int( "WM_propcost", 3))
		if NRGCheck(ply, cost) then
			melon.Cost = cost;
			melon:Spawn();
			construct.SetPhysProp( nil, melon, 0, nil,  { GravityToggle = true, Material = "metal" } ) 
			ply:AddCount('lap_baseprops', melon)
			melon:Activate();
			if Grav == true then
				melon:GetPhysicsObject():EnableGravity(false)
			end
			DoPropSpawnedEffect(melon);
			return melon;
        end
    end
end
duplicator.RegisterEntityClass("melon_baseprop", BasePropDupe, "Pos", "mass", "Model", "Ang", "Grav", "maxhealth", "Team");

function LauncherDupe (ply, Pose, Ange, modele, Forcee, Multipliere, dampinge, MaxAmmoe, masse, FiringRatee, DamageMultipliere, Sounde, Pitche, LauncherDatae, Teame)
	melon = ents.Create ("lap_launcher")
	if (!melon:IsValid()) then return false end
	melon:SetPos(Pose)
	melon:SetAngles(Ange)
	
	local launchertbl = table.Copy(LauncherDatae)
	local lteam = 0
	if ply:Team() ~= 0 then
		lteam = ply:Team()
	else
		lteam = Teame
	end
	local tab = {
		Team = lteam,
		model = modele,
		Force = Forcee,
		Multiplier = Multipliere,
		damping = dampinge,
		MaxAmmo = MaxAmmoe,
		mass = masse,
		FiringRate = FiringRatee,
		DamageMultiplier = DamageMultipliere,
		Sound = Sounde,
		Pitch = Pitche
	}
	--melon.FireDelay = launchertbl[Type][6]
	--melon.Sound = CreateSound(melon, launchertbl[Type][12])
	table.Merge(melon, tab)
	
	if InOutpostRange(ply, Pose) then
		local cost = launchertbl[5]* server_settings.Int("WM_Toolcost", 1)
		if NRGCheck(ply, cost) then
			melon.Cost = cost
			melon:Spawn()
			ply:AddCount('lap_melons', melon)
			melon:Activate()
			DoPropSpawnedEffect(melon)
			return melon
		end
	end		
end
duplicator.RegisterEntityClass("lap_launcher", LauncherDupe, "Pos", "Ang", "model", "Force", "Multiplier", "damping", "MaxAmmo", "mass", "FiringRate", "DamageMultiplier", "Sound", "Pitch", "LauncherData", "Team")