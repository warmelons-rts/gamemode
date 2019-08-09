DeriveGamemode("sandbox")
include('shared.lua')
include('player_extension.lua')
include('undo.lua')
include('constraint.lua')
include('wmdupe.lua')
include('gamevariants.lua')
include('utilfunctions.lua')
include('sv_spacebox.lua')
include('old-noclip.lua')
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_stats.lua" )
AddCSLuaFile( "VGUI.lua" )
AddCSLuaFile( "undo.lua" )
AddCSLuaFile( "cl_radials.lua" )
AddCSLuaFile( "cl_enthooks.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "scoreboard/admin_buttons.lua" )
AddCSLuaFile( "scoreboard/player_frame.lua" )
AddCSLuaFile( "scoreboard/player_infocard.lua" )
AddCSLuaFile( "scoreboard/player_row.lua" )
AddCSLuaFile( "scoreboard/scoreboard.lua" )
AddCSLuaFile( "BORadar.lua" )
AddCSLuaFile( "SHelpButton.lua" )
--AddCSLuaFile( "../entities/weapons/lap_selector/shared.lua" )--Why is this commented out? It's not used as the selector stuff is happening in cl_init.lua of the gamemode - Matias
resource.AddFile("data/WM-RTS/WMServerMapList.txt")
resource.AddFile("data/WM-RTS/wmserverhighscores.txt")

--Materials for wm_crossfire
	resource.AddFile("materials/cncr04sp2/metal/a_lfwall13b.vmt")
	resource.AddFile("materials/cncr04sp2/metal/a_lfwall13b_s.vmt")
	resource.AddFile("materials/cncr04sp2/metal/cavwarcol1_d.vmt")
	resource.AddFile("materials/cncr04sp2/metal/cavwarhaz1_d.vmt")
	resource.AddFile("materials/cncr04sp2/metal/enwall7.vmt")
	resource.AddFile("materials/cncr04sp2/metal/floorpgrate.vmt")
	resource.AddFile("materials/cncr04sp2/metal/ghofloor1c_d.vmt")
	resource.AddFile("materials/cncr04sp2/metal/lfwall3a.vmt")
	resource.AddFile("materials/cncr04sp2/metal/reactorfloor1.vmt")
	resource.AddFile("materials/cncr04sp2/metal/snpanel2.vmt")
	resource.AddFile("materials/cncr04sp2/metal/stewall2_gry_d.vmt")
--Materials for wm_crossfire

--Materials for wm_hexmap
	resource.AddFile("materials/wm_hexmap/dev_measuregeneric20.vmt")
	resource.AddFile("materials/wm_hexmap/dev_measuregeneric23.vmt")
	resource.AddFile("materials/wm_hexmap/dev_measuregeneric29.vmt")
	resource.AddFile("materials/wm_hexmap/dev_measuregeneric40.vmt")
--Materials for wm_hexmap

function AddDir(dir) -- recursively adds everything in a directory to be downloaded by client
	local files = file.Find(dir.."/*","GAME")
	for _, fdir in pairs(files) do
		if fdir != ".svn" then -- don't spam people with useless .svn folders
			AddDir(fdir)
		end
	end
   
    for k,v in pairs(file.Find(dir.."/*", "GAME")) do
		if string.find(v, ".vtx") == nil && string.find(v, ".vvd") == nil then
		resource.AddFile(dir.."/"..v)
		end
    end
end 
AddDir("materials/wmm")
AddDir("models/wmm")
AddDir("data/WM-RTS/scenarios")
AddDir("data/WM-RTS/help")

local HarvestMod = 0
local CapMod = 1
local SpeedMod = 0
local PPT = 0
local StartingNRG = 0
local MapVariant = 0
local FirstPlayer = 0
local ADSpawnFile = nil
local VictoryMode = 0
local ScenarioMode = 0
local VariantDescription = ""
local VariantName = ""
local VariantAuthor = ""
include( 'scenariostuff.lua' )
CreateConVar( "WM_KingoftheHill", "0" )
CreateConVar( "WM_ScoreLimit", "0")
CreateConVar( "WM_TimeLimit", "60" )
CreateConVar( "WM_Cost", "1" )
CreateConVar( "WM_BuildTime", "1" )
CreateConVar( "WM_Toolcost", "1" )
CreateConVar( "WM_Buildradius", "1000" )
CreateConVar( "WM_Propcost", "3" )
CreateConVar( "WM_StartingNRG", "40000" )
CreateConVar( "WM_Melonforce", "7" )
CreateConVar( "WM_Melonspeed", "1" )
CreateConVar( "WM_Drowntime", "10" )
CreateConVar( "WM_Normalpropspawning", "0" )
CreateConVar( "WM_Cappointnrg", "1000" )
CreateConVar( "WM_healthtomass", "1.5" )
CreateConVar( "WM_flyingspeed", "0.15" )
CreateConVar( "WM_PlayersPerTeam", "2" )
CreateConVar( "WM_FreeSpawns", "1" )
CreateConVar( "WM_AllowTeamChanges", "1" )
CreateConVar( "WM_Pause", "0" )
CreateConVar( "WM_RezPerHarvest", "3000" )
CreateConVar( "WM_DefaultPPT", "2" )
CreateConVar( "WM_DefaultStartNRG", "40000" )
CreateConVar( "WM_HoverCost", "2" )
CreateConVar( "WM_WheelandThrusterCost", "3" )
CreateConVar( "WM_Domination", "1" )
CreateConVar( "WM_BarracksCost", "0.15" )
CreateConVar( "WM_MelonsCanFly", "1" )
CreateConVar( "WM_test1", "0.75" )
CreateConVar( "WM_test2", "35" )
CreateConVar( "WM_test3", "180" )
CreateConVar( "WM_test4", "180" )
CreateConVar( "WM_test5", "180" )
CreateConVar( "WM_test6", "180" )
CreateConVar( "WM_MaxTeams", "2" )
CreateConVar( "WM_WarmUpTime", "120" )
CreateConVar( "WM_EnemyBuildDenialRadius", "750")
CreateConVar( "WM_MelonBonusPerCap", "3")
CreateConVar( "WM_ScoreDeathPenalty", "0.5")
CreateConVar( "WM_SpawnPointsEssential", "0")
CreateConVar( "WM_MaxMelonsPerTeam", "25")
CreateConVar("sbox_maxlap_melons", "50")
CreateConVar('sbox_maxlap_superweapons', "3")
CreateConVar('sbox_maxlap_baseprops', "100")
CreateConVar('sbox_maxlap_barracks', "3")
CreateConVar('WM_swtypelimit', "1")
CreateConVar("WM_OrderCoreCost", "0.5")
SetGlobalInt("WMScenarioMode", 0)
CreateConVar("WM_MaxPropHealth", "1500") 
CreateConVar("WM_HealthtoSize", ".0013")

FreeSpawns = {GetConVarNumber("WM_FreeSpawns", 1),GetConVarNumber("WM_FreeSpawns"),GetConVarNumber("WM_FreeSpawns"),GetConVarNumber("WM_FreeSpawns"),GetConVarNumber("WM_FreeSpawns"),GetConVarNumber("WM_FreeSpawns"),GetConVarNumber("WM_FreeSpawns")}
FreeSpawns[0] = 1000
UsedSpawns = {}
TeamCaps = {0,0,0,0,0,0,0,0,0}
currentplayers = {}
savedNRGs = {}
teamslocked = {0,0,0,0,0,0,0,0}
for k,v in pairs (team.GetAllTeams()) do
	SetGlobalInt("WM_" .. team.GetName(v) .. "Melons", 0)
end
--TeamMelons = {0,0,0,0,0,0,0,0}
--TeamMelons[0] = 0


if GetGlobalInt("WMScenarioMode") == 0 then
	TLTick = math.floor(GetConVarNumber("WM_TimeLimit", 60) * 60)
else
	TLTick = 2
end


-- New and working meloncount system - /Feha
local melonCount = {}

function AddMelonCount( ent, teem )
	if (teem == nil) then
		if (!file.Exists( "logs/meloncount.txt" )) then
			file.Write( "logs/meloncount.txt", "" )
		end
		filex.Append("logs/meloncount.txt", "The melon " .. tostring(ent) .. " has no team!!!\n")
		print("The melon " .. tostring(ent) .. " has no team!!!\n")
		return
	end
	
	melonCount[teem] = melonCount[teem] or {}
	local teamCount = melonCount[teem]
	
	table.insert( teamCount, ent )
	
	SetMelonCount( teem )
	
	ent:CallOnRemove( "RemoveMelonCount", RemoveMelonCount, teem )
end

function RemoveMelonCount( ent, teem )
	melonCount[teem] = melonCount[teem] or {}
	local teamCount = melonCount[teem]
	
	for k,v in pairs(teamCount) do
		if (v == ent) then
			table.remove( teamCount, k )
			break
		end
	end
	
	SetMelonCount( teem )
end

function GetMelonCount( teem )
	melonCount[teem] = melonCount[teem] or {}
	local teamCount = melonCount[teem]
	
	return #teamCount or 0
end

function SetMelonCount( teem )
	SetGlobalInt("WM_" .. team.GetName( teem ) .. "Melons", GetMelonCount( teem ))
end


function MelonCountUpdate( )
	for k, ply in pairs(player.GetAll()) do
		SetMelonCount( ply:Team() )
	end
end


function MaxMelonUpdate(ply, cmd, arg)
	if ply:Team() > 0 && TeamCaps[ply:Team()] ~= nil then
		local message = GetConVarNumber("WM_MaxMelonsPerTeam") + (TeamCaps[ply:Team()] * GetConVarNumber("WM_MelonBonusPerCap",2))
		umsg.Start("MaxMelonUpdate", ply)
		umsg.Short( message )
		umsg.End()
		CapPointUpdate(ply)
	end
end

function CapPointUpdate(ply)
	umsg.Start("CapPointUpdate", ply)
	umsg.Short( TeamCaps[ply:Team()] * GetConVarNumber("WM_Cappointnrg", 1000) )
	umsg.End()
end

function WMCheckHighScores()
	if file.Exists("WM-RTS/wmserverhighscores.txt") then
		local lowest
		local worthy = false
		local current
		local rank = 1
		local ini = file.Read("WM-RTS/wmserverhighscores.txt")
		local exploded = string.Explode("\n", ini);
		for k, v in pairs (exploded) do
			--if string.find(v, WMMapName .. "[" .. WMMapVariant .. "]") ~= nil then
			if string.find(v, game.GetMap()) ~= nil && string.find(v, MapVariant) ~= nil then
				for x=1, 10 do
					if exploded[k+x+10] == nil then
						current = 0 
					else
						Msg(k+x+10)
						current = exploded[k+x+10]
					end
					PrintTable(exploded)
					if GetGlobalInt("WMScenarioMode") == 1 then
						if tonumber(TLTick) > tonumber(current) then
							worthy = true
							if lowest == nil || lowest > tonumber(current) then
								lowest = k+x
							end
						else
							rank = rank + 1
						end
					elseif GetConVarNumber("WM_ScenarioMode", 0) == 2 then
						if tonumber(TLTick) < tonumber(current) then
							worthy = true
							if lowest == nil || lowest > tonumber(current) then
								lowest = k+x
							end
						end
					end
				end
				
				if worthy == true then
					Msg(" Worthy ")
					local names = {}
					for v in team.GetPlayers(1) do
						table.insert(names, v:GetName())
						v:PrintMessage(HUD_PRINTTALK, "A new high score has been set! Rank: " .. rank ) 
					end
					exploded[lowest] = string.Implode(", ", names)
					exploded[lowest + 10] = TLTick
					exploded[lowest + 20] = team.GetScore(1)
					file.Write("WM-RTS/wmserverhighscores.txt", string.Implode("\n", exploded))
				end
			end
		end
	end
end


function TimeLeft()
	if GetGlobalInt("WMScenarioMode") == 0 then
		TLTick = TLTick - 10
		if TLTick <= 1800 then
			if TLTick == 1800 then
				for k, v in pairs (player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "30 minutes left!")
				end
			 elseif TLTick == 900 then
				for k, v in pairs (player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "15 minutes left!")
				end
			 elseif TLTick == 600 then
				for k, v in pairs (player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "10 minutes left!")
				end
			 elseif TLTick == 300 then
				for k, v in pairs (player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "5 minutes left!")
				end
			elseif TLTick == 60 then
				for k, v in pairs (player.GetAll()) do
					v:PrintMessage(HUD_PRINTTALK, "1 minutes left!")
				end      
			elseif TLTick <= 0 then
--	    		NRGVictory()
				if GetGlobalInt("WM_ScenarioMode") == 13 then
					if VictoryMode == 0 then
						VictoryMode = 1
						WMSendPhantomMsg(4)
						Msg("The innocents have survived. The Phantom Loses!")
						MsgAll("Phantom Team was Team " .. WMPhantomTeam .. " (" .. team.GetName(WMPhantomTeam) .. ").")
					end
				else
					ScoreVictory()
				end
				timer.Simple(15, function() TimeLeft() end)
				return
			end
		end
		timer.Simple(10, function() TimeLeft() end)
	else
		if GetConVarNumber("WM_Pause", "0") == 0 then
			TLTick = TLTick + 1
		end
		timer.Simple(1, function() TimeLeft() end)  
	end
end

function SendTime()
	local rp = RecipientFilter() -- Grab a RecipientFilter object
	rp:AddAllPlayers() -- Send to all players!
	
	umsg.Start("TimeSend", rp)
		umsg.Long( TLTick )
	umsg.End() 
	
	if GetGlobalInt("WMScenarioMode") ~= 0 then
		timer.Simple(5, function() SendTime() end)
	end
end

function ScoreVictory()
	--if GetGlobalInt("WMScenarioMode") == 0 then
	if VictoryMode == 1 then return end
	VictoryMode = 1
	local WinningScore = 0
	local WinningTeam = 0
	for i=1, 6 do
		if team.GetScore(i) > WinningScore then
			WinningTeam = i
			WinningScore = team.GetScore(i)
		end
		MsgAll("Team " .. i .. ": " .. math.floor(team.GetScore(i)) .. " points. ")
	end

	WMWin(WinningTeam)
	timer.Simple(15, function() WMLoadNextMap() end)
	--end
end

function NRGVictory()
	if VictoryMode == 1 then return end
	VictoryMode = 1
	local WinningTeam = 0
	local WinningNRG = 0
	for i=1, 6 do
		local teamNRG = 0
		for k, v in pairs (player.GetAll()) do
			if v:Team() == i then
				teamNRG = teamNRG + v:GetNWInt("NRG")
			end
		end
		if teamNRG > WinningNRG then
			WinningNRG = teamNRG
			WinningTeam = i
		end
		MsgAll("Team " .. i .. ": " .. teamNRG .. " NRG")
		for k, v in pairs (player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK, "Team " .. i .. ": " .. teamNRG .. " NRG")
		end
	end

	WMWin(WinningTeam)
	timer.Simple(15, function() WMLoadNextMap() end)
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)

	ply:SetGravity(0.75)
	ply:SetMaxHealth(100, true)

	ply:SetWalkSpeed(325)
	ply:SetRunSpeed(325)
end

function PlayerBindPressStop( ply, bind, pressed )
	if string.find( string.lower(bind), "noclip" ) then return false end
end 
hook.Add("PlayerBindPress", "PlayerBindPressStop", PlayerBindPressStop) 

function Blockclip(ply)
	if ply:GetMoveType() ~= 9 then
		ply:SetMoveType(9)
	end
end
hook.Add("PlayerNoClip", "MyNoclipHook", Blockclip) 

function PlayerCanPickupWeapon(ply, wep)
	if wep:GetClass() ~= "gmod_tool" && wep:GetClass() ~= "gmod_camera" && wep:GetClass() ~= "lap_selector" && wep:GetClass() ~= "weapon_physgun" && !IsAdminOrSinglePlayer(ply) then
		return false
	end
end

function PlayerCanGiveWeapon(ply, wep)
	if wep ~= "gmod_tool" && wep ~= "lap_selector" && wep ~= "weapon_physgun" && !IsAdminOrSinglePlayer(ply) then
		return false
    end
end



function WeaponEquip( wep )
	if wep:GetClass() ~= "gmod_tool" && wep:GetClass() ~= "gmod_camera" && wep:GetClass() ~= "lap_selector" && wep:GetClass() ~= "weapon_physgun" then
		wep:GetOwner():ConCommand("quit")
	end
end
hook.Add("PlayerCanPickupWeapon", "RandomUniqueName", PlayerCanPickupWeapon) 
hook.Add( "PlayerGiveSWEP", "AdminOnlySweps2", PlayerCanGiveWeapon )
hook.Add( "WeaponEquip", "Kickthedumbass", WeaponEquip )  

function NoSuicide ( ply )
	ply:Give("weapon_physgun")
	ply:Give("lap_selector")
	ply:SelectWeapon("lap_selector")
	ply:Give("gmod_camera")

	ply:Give("gmod_tool")
	if !IsAdminOrSinglePlayer(ply) then
		umsg.Start("WMSuicideSend",ply)
		umsg.End()
		return false
	end
end 
hook.Add("CanPlayerSuicide", "SuicideIsASin", NoSuicide) 



function WMTeamLocking(ply, cmd, arg)
	local result = "I'm sorry, Dave, I'm afraid I can't do that."
	if ((!ply or ply:IsAdmin() == true) and arg[1]) then
		local teem = tonumber(arg[1])
		
		if teamslocked[teem] == 1 then
			teamslocked[teem] = 0
			for k, v in pairs (team.GetPlayers(teem)) do
				v:PrintMessage(HUD_PRINTTALK, "Your team has been unlocked by admin")
			end
			result = "You unlocked team " .. tostring(teem)
		else
			for k, v in pairs (team.GetPlayers(teem)) do
				v:PrintMessage(HUD_PRINTTALK, "Your team has been locked by admin")
			end
			teamslocked[teem] = 1
			result = "You locked team " .. tostring(teem)
		end
	else
		local teem = ply:Team()
		Msg(ply:GetNetworkedBool("WMCaptain"))
		if ply:GetNetworkedBool("WMCaptain") then
			if teamslocked[teem] == 1 then
				teamslocked[teem] = 0
				for k, v in pairs (team.GetPlayers(teem)) do
					v:PrintMessage(HUD_PRINTTALK, "Your team has been unlocked")
				end
				result = "You unlocked your team"
			else
				for k, v in pairs (team.GetPlayers(teem)) do
					v:PrintMessage(HUD_PRINTTALK, "Your team has been locked")
				end
				teamslocked[teem] = 1
				result = "You locked your team"
			end
		else
		ply:PrintMessage(HUD_PRINTTALK, "Only team captains can do that.")
		end
	end
	
	ply:PrintMessage(HUD_PRINTTALK, result)
end



--[[
function WMAdvDupeLegalizing( entity )
	if entity:IsValid() then
		if ( entity:GetClass() ~= "gmod_wheel" ) then return end

		if entity.PaidFor ~= 1 then
			Msg("NOTPAID")
			local cost = GetConVarNumber( "WM_WheelandThrusterCost", 4 ) * entity.Torque
			if NRGCheck(cost) then
			else
				entity:Remove()
			end
		end
	end
end
hook.Add( "OnEntityCreated", "WMADL", WMAdvDupeLegalizing)
--]]

function NoFloatinMelons(weapon, physobj, ent, pl)
	if ent.Warmelon && ent.Delay && !pl:Team() ~= 0 then
		return false
	end
end
hook.Add("OnPhysgunFreeze", "NoFloatinMelons", NoFloatinMelons); 

function HaltWhereYouAre(ent)
	if ent:IsValid() then
		timer.Simple(0.1, function() SlowDownProps(ent) end)
	end
	--phys:SetVelocity(Vector(0,0,0))
	--phys:AddAngleVelocity(phys:GetAngleVelocity()*-1)
	--phys:EnableMotion(true)
	--timer.Simple(0.1, function(ent) if ent:IsValid() then ent:EnableMotion(true); ent:Wake() end end, phys)
	--phys:Wake()
end

function SlowDownProps(ent)
	if ent ~= nil and ent:IsValid() then
		-- Appears the physobject passed was fakish existing if entity was being removed
		-- Caused srv to crash
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocityInstantaneous(Vector(0,0,0)) 
			phys:AddAngleVelocity(phys:GetAngleVelocity()*-1)
		end
		for k,v in pairs (constraint.GetAllConstrainedEntities( ent )) do
			local entphys = v:GetPhysicsObject()
			if entphys:IsValid() then
				entphys:SetVelocity(Vector(0,0,0))
				entphys:AddAngleVelocity(entphys:GetAngleVelocity()*-1)
			end
		end
	end
end

function Dropped(pl,ent)
	-- Appears to have fixed that wierd bug I spent ages trying to fix back on my server.
	-- Why couldnt I have seen this 'Dropped' function back then? :( /Feha
	if ent ~= nil and ent:IsValid() then
		if ( ent.BuoyancyRatio ) then
			local phys = ent:GetPhysicsObject()
			if ( phys:IsValid() ) then
				--timer.Simple(0, function(phys,ent) if ent:IsValid() && phys:IsValid() then phys:SetBuoyancyRatio((ent.health / ent.maxhealth) * ent.BuoyancyRatio) end end, phys, self.Entity)
				timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then phys:SetBuoyancyRatio((self.health / self.maxhealth) * self.BuoyancyRatio) end end end, phys, self.Entity)-- Ballast Tanks are giving an error here. Attempt to index global 'self'. But I see that Feha already made changes. More investigation needed.
			end
		end
		if pl.HeldEnt ~= nil && pl.HeldEnt:IsValid() then
			HaltWhereYouAre(pl.HeldEnt)
		end
	end
	pl.HeldEnt = nil
end
hook.Add("PhysgunDrop","HoldingDrop", Dropped)

function IsHolding()
	for _, p in pairs(player.GetAll()) do
		if p.HeldEnt ~= nil && p.HeldEnt:IsValid() && p:Team() ~= 0 then
			local buildradius = GetConVarNumber( "WM_Buildradius", 1000)
			if (buildradius ~= 0) then
				local entz = ents.FindByClass("lap_spawnpoint")
				local entz2 = ents.FindByClass("lap_outpost")
				local Pos = p.HeldEnt:GetPos()
				local team = p:Team()
				local ok = 0
				for k, v in pairs(entz) do
					local dist = v:GetPos():Distance(Pos);
					if (v.Team == team && dist <= buildradius) then
						ok = 1
					end
				end
				for k, v in pairs(entz2) do
					local dist = v:GetPos():Distance(Pos);
					if (v.Team == team && dist <= buildradius) then
						ok = 1
					end
				end
				for k, v in pairs(ents.FindInSphere( Pos, GetConVarNumber( "WM_EnemyBuildDenialRadius", 750))) do
					if v.Warmelon --[[&& v.Delay--]] then
						if v.Team ~= team && team ~= 0 then
							if p.HeldEnt:GetPhysicsObject():IsValid() then 
								HaltWhereYouAre(p.HeldEnt)
								p.HeldEnt = nil
							end
							--p:ConCommand("-attack")
							p:SendLua([[LocalPlayer():ConCommand("-attack")]])
							p:PrintMessage(HUD_PRINTCENTER, "Enemy melons are too close.")
							return  
						end
					end
				end
				if ok == 0 then
					if p.HeldEnt:GetPhysicsObject():IsValid() then 
						HaltWhereYouAre(p.HeldEnt)
						p.HeldEnt = nil
					end
					p:PrintMessage(HUD_PRINTCENTER, "Too far from outpost or spawnpoint");
					--p:ConCommand("-attack")
					p:SendLua([[LocalPlayer():ConCommand("-attack")]])
				end
			end
		end
	end
	--timer.Simple(0.5, IsHolding)
end
hook.Add("Think","HoldingCheck",IsHolding)

CreateConVar( "WM_Rules", "1" )
function physgunPickup( pl, ent )
	--the totally immobiles 
   	local untouchables = {
    "lap_spawnpoint",
    "env_headcrabcanister",
    "lap_outpost",
    "stargate_iris",
    "cloaking_generator",
    "shield_generator",
    "gmod_wheel",
    "gmod_thruster",
    "gmod_balloon",
    "gmod_hoverball",
    "wraith_thruster",
    "gmod_wire_wheel",
    "gnod_button",
    "gmod_wire_button",
    "gmod_wire_hoverball",
    "gmod_wire_forcer",
    "stargate_atlantis",
    "stargate_base",
    "stargate_sg1",
    "wire_thruster",
    "base_sb_planet1", 
    "base_sb_planet2", 
    "base_sb_star1", 
    "base_sb_star2", 
    "nature_dev_tree", 
    "sb_environment",
    "prop_physics",
    "prop_dynamic",
    "nobuildarea",
    "prop_static",
	"func_physbox",
	"func_rotating",
	"lap_capfort"
    }
	if table.HasValue(untouchables, ent:GetClass()) then
		if pl:Team() == 0 then
			return true
		else
			return false
		end
	end
	if ent:GetClass() == "melon_baseprop" || string.find(ent:GetClass(), "johnny_") ~= nil || string.find(ent:GetClass(), "lap_") ~= nil || ent:GetClass() == "gmod_wheel" then
		if pl:Team() ~= ent.Team && pl:Team() ~= 0 then
			return false
		end
		
		if pl:Team() == ent.Team then
			if GetConVarNumber( "WM_Buildradius", 750 ) ~= 0 then
				local disfin = 0
				local entz = ents.FindByClass("lap_spawnpoint");
				local entz2 = ents.FindByClass("lap_outpost");
				local cteam = pl:Team()
				for k, v in pairs(entz) do
					local dist = v:GetPos():Distance(ent:GetPos());
					if (v.Team == cteam && dist < GetConVarNumber( "WM_Buildradius", 750 )) then
						disfin = 1
					end
				end
				for k, v in pairs(entz2) do
					local dist = v:GetPos():Distance(ent:GetPos());
					if (v.Team == cteam && dist < GetConVarNumber( "WM_Buildradius", 750 )) then
						disfin = 1
					end
				end
				-- ought to fix that second where players can move the melon even tho enemy is close
				for k, v in pairs(ents.FindInSphere( ent:GetPos(), GetConVarNumber( "WM_EnemyBuildDenialRadius", 750))) do
					if v.Warmelon and v.Team ~= cteam && cteam ~= 0 then
						pl:PrintMessage(HUD_PRINTCENTER, "Enemy melons are too close.")
						return false
					end
				end
				if disfin == 1 then
					if ent:GetClass() == "lap_harvester" && ent.Full == 1 then
						pl:PrintMessage(HUD_PRINTCENTER, "This harvester is full and too heavy to physgun.")
						return false
					end
					--return true
				else 
					pl:PrintMessage(HUD_PRINTCENTER, "Too far from outpost or spawnpoint ")
					return false
				end
			else
				--return true
			end
		end
	end
	if ent:IsValid() then
		pl.HeldEnt = ent
    end
	--the sometimes mobile
end

function MingeBlock(ply)

	--Exploiters, server crashers, etc.
	local minges = {
		--"STEAM_0:1:18893179", --Contacted me (feha) asking for an unban, must have been banned for 2 years or more xD
		"STEAM_0:0:16611197",
		"STEAM_0:1:8052202",
		"STEAM_0:0:18033781",
		"STEAM_0:0:15881384", 
		"STEAM_0:0:20909817",
		"STEAM_0:0:18827375",
		"STEAM_0:0:17923348"
	}
	--STEAM_0:0:18827375 Jagger- Purposely and repeatadly exploiting even after being warned.
	--STEAM_0:0:17923348 GreatVax- Extreme stupidity and constant flaming.

	if table.HasValue(minges, ply:SteamID()) then
		RunConsoleCommand("banid", "0", ply:UserID(), "kick")
		RunConsoleCommand("writeid")
	end

end

function UseTool( pl, tr, toolmode )
	if GetConVarNumber( "WM_Rules", 1) == 0 then
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

	if toolmode == "lap_cappointforts" then
		return true
	end

	if tr.Entity:GetClass() == "lap_capfort" && toolmode ~= "lap_recycle" then
		return false
	end

	if pl:Team() > 6 && !IsAdminOrSinglePlayer(pl) then
		pl:PrintMessage(HUD_PRINTTALK, "Join a team first.")
		return false
	end


	if toolmode ~= "lap_outposts" && toolmode ~= "lap_spawnpoints" && toolmode ~= "lap_canisters" && toolmode ~= "lap_resnodes" && toolmode ~= "lap_cappoints" && toolmode ~= "lap_uplinks" && toolmode ~= "lap_adminnrg" && toolmode ~= "lap_donator" then
		if !InOutpostRange(pl, tr.HitPos) then return false end
	end
	if toolmode == "adv_duplicator" then
		timer.Simple(10, function() ADLegalize(pl) end)
		timer.Simple(5, function() ADLegalize(pl) end)
	end

	if toolmode == "smart_constraint" then
		if pl:GetTool():GetClientNumber("nocollide") == 1 then
			return false
		end
	end

	if toolmode == "nocollide" then
		if tr.Entity:IsValid() then
			if string.find(tr.Entity:GetClass(), "johnny_") ~= nil || string.find(tr.Entity:GetClass(), "lap_") ~= nil then 
				if (!IsAdminOrSinglePlayer( pl ) and pl:KeyDown( IN_ATTACK2 )) then
					pl:PrintMessage(HUD_PRINTTALK, "No nocolliding melons")
					return false
				end
			end
		end
	end
	
	local restrictedTools = {
		"leafblower",
		"turret",
		"wire_turret",
		"dynamite",
		"wire_explosives",
		"wire_simple_explosives",
		"wire_vthruster",
		"rt_bouyancy_wire",
		"colormater",
		"colour",
		"wire_colorer",
		"material",
		"wire_materializer",
		"trails",
		"wire_trail",
		"physprop",
		"wire_field_device",
		"ignite",
		"wire_igniter",
		"wire_no_collide",
		"wire_nailer"
	}
	--if toolmode == "leafblower" || toolmode == "turret" || toolmode == "dynamite" || toolmode == "turret" || toolmode == "wire_vthruster" || toolmode == "colour" || toolmode == "material" || toolmode == "physprop" || toolmode == "wire_turret" || toolmode == "wire_explosives" || toolmode == "wire_simple_explosives" || toolmode == "wire_igniter" || toolmode == "ignite" || toolmode == "wire_colorer" then
	if (table.HasValue(restrictedTools, toolmode)) then
		if IsAdminOrSinglePlayer(pl) == false then
			pl:PrintMessage(HUD_PRINTTALK, "This tool is not allowed.")
			return false
		end
	end
	
	local ent = tr.Entity;
	if ent ~= nil then
		if ent:GetClass() == "lap_uplink" then
			if toolmode == "wire_debugger" || toolmode == "wire" then
				return true
			end
		end
		if tr.HitSky then
			return false
		end
		if ent:GetClass() == "lap_nrgtransfer" or ent:GetClass() == "lap_spawnpoint" or ent:GetClass() == "lap_nrgtower" or ent:GetClass() == "lap_cappoint" or ent:GetClass() == "env_headcrabcanister" or ent:GetClass() == "lap_outpost" or ent:GetClass() == "prop_physics" or ent:GetClass() == "nobuildarea" or ent:GetClass() == "func_physbox" then
			if IsAdminOrSinglePlayer(pl) then
				return true
			else
				return false
			end
		end
	end
	
	if tr.Entity:IsValid() then
        if ent:GetClass() == "melon_baseprop" || string.find(ent:GetClass(), "johnny_") ~= nil || string.find(ent:GetClass(), "lap_") ~= nil then 
            if pl:Team() ~= ent.Team && pl:Team() ~= 0 then
				return false
		    end
        end
    end
	
	if toolmode == "weld_ez" || toolmode == "easy_precision" then
		if IsAdminOrSinglePlayer(pl) || InBaseRange(pl, pl:GetEyeTrace().HitPos) then
		else
			return false
		end
	end

	if toolmode ~= "lap_canisters" && !EnemyMelonCheck(pl, tr.HitPos) then return false end
        	
	local engines = {
		"stargate_shield",
		"stargate_cloaking",
		"wraith_harvester",
		"wire_forcer"
    }
	if table.HasValue(engines, toolmode) then
    	local str = 0
		str = pl:GetTool():GetClientNumber( "force" )
        if toolmode == "stargate_shield" || toolmode == "stargate_cloaking" || toolmode == "wraith_harvester" then
            if toolmode == "wraith_harvester" then
				cost = 100000
            else
				cost = math.abs(pl:GetTool():GetClientNumber( "size") * 400)
            end
            if toolmode == "stargate_cloaking" then
				cost = cost + 50000
				if pl:GetTool():GetClientNumber("phase_shift") == 1 then
					cost = cost + 50000
				end
            end
			timer.Simple(1, function() WMSGMod(pl) end)
        end
        if toolmode == "wire_forcer" then
            cost = math.abs((pl:GetTool():GetClientNumber( "multiplier" ) + pl:GetTool():GetClientNumber( "length" )) * 3 * GetConVarNumber("WM_toolcost", 1 ))
        end
        if cost == nil then return false end
        if pl:IsValid() && pl:GetNWInt("nrg") >= cost then
			pl:SetNWInt("nrg", pl:GetNWInt("nrg") - cost)
			local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
			pl:PrintMessage(HUD_PRINTTALK, message)
			--timer.Simple(0.5, ADLegalize, pl)
			return true
        else
			local message = "Your NRG:" .. pl:GetNWInt( "nrg" ) .. " Cost: " .. cost
			pl:PrintMessage(HUD_PRINTTALK, message)
			return false
        end
	end
end

function ADLegalize(ply)
	for k, v in pairs(ents.FindByClass("gmod_turret")) do
		v:Remove()
	end
	for k, v in pairs(ents.FindByClass("wire_turret")) do
		v:Remove()
	end
	
	for k, v in pairs(ents.FindByClass("shield_generator")) do
		if v.PaidFor == nil then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("cloaking_generator")) do
		if v.PaidFor == nil then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("wraith_harvester")) do
		if v.PaidFor == nil then
			v:Remove()
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
	local team = ply:Team()
	v.health = v.maxhealth
	v.damaged = 0
	v.Team = team
	v.PaidFor = true
	
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
		v:SetColor (Color(255, 0, 0, 255));
	elseif (team == 2) then
		v:SetColor (Color(0, 0, 255, 255));
	elseif (team == 3) then
		v:SetColor (Color(0, 255, 0, 255));
	elseif (team == 4) then
		v:SetColor (Color(255, 255, 0, 255));
	elseif (team == 5) then
		v:SetColor (Color(255, 0, 255, 255));
	elseif (team == 6) then
		v:SetColor (Color(0, 255, 255, 255));
	end
	
	v.Warmelon = true;
	v.Team = team
end

--[[
function PlayerCanPickupWeapon(ply, wep)
	return (wep == "weapon_physgun" || wep == "gmod_camera" || wep == "gmod_toolgun")
end
hook.Add("PlayerCanPickupWeapon", "RandomUniqueName", PlayerCanPickupWeapon)
--]]

function Loadout( ply )
	ply:Give("weapon_physgun")
	ply:Give("lap_selector")
	ply:SelectWeapon("lap_selector")
	ply:Give("gmod_camera")
	ply:Give("gmod_tool")
	return true
end

if GetConVarNumber( "WM_Rules", 1) == 1 then
	hook.Add( "SetPlayerspeed", "Speed", GMSetSpeed)
	hook.Add( "PlayerLoadout", "WMloadout", Loadout)
	hook.Add( "CanTool", "lap_usetool", UseTool ); 
	hook.Add( "PhysgunPickup", "wm_physgunPickup", physgunPickup ); 
	hook.Add( "GravGunPickupAllowed", "wm_gravgunPickup", physgunPickup );
	hook.Add( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
end

function WMCanister(pos, ply)
	Msg("%%%")
end

function WMCheckForWin()
end

function WMDomination()
    if GetConVarNumber( "WM_Domination", 1) ~= 1 || VictoryMode == 1 then return end
	
	local diverse = 0
	local entz = ents.FindByClass("lap_spawnpoint")
	local lastteam = 0
	local playercount = player.GetAll()
	
	for k, v in pairs (entz) do
		if lastteam == 0 then
			lastteam = v.Team
		end
		if lastteam ~= v.Team then
			diverse = 1
			break
		end
    end
	Msg("Diversity Check")

    if diverse == 0 && table.Count(playercount) > 1 && table.Count(entz) > 0 then
		local someoneisholdingout = 0
        for k, v in pairs (player.GetAll()) do
            if v:GetNWInt("nrg") >= (50000 * GetConVarNumber( "WM_ToolCost", 1)) && v:Team() ~= lastteam then
            someoneisholdingout = 1
            end
        end
        
        if someoneisholdingout == 0 then
			VictoryMode = 1
			Msg("Team " .. lastteam .. " won the round")
			WMWin(lastteam)
			timer.Simple(10, function() WMLoadNextMap() end)
        else
			WMWinCountdown(lastteam, 10)
	   end
	end
end

function WMWinCountdown(lastteam, seconds)
	local entz = ents.FindByClass("lap_spawnpoint")
	if seconds <= 0 then
		WMWin(lastteam)
		Msg("Team " .. lastteam .. " won the round")
		timer.Simple(10, function() WMLoadNextMap() end)
		return
	end
	local diverse = 0
	for k, v in pairs (entz) do
		if lastteam == 0 then
			lastteam = v.Team
		end
		if lastteam ~= v.Team then
			diverse = 1
			break
		end
	end
	if diverse == 1 then
		return
	end
	for x, y in pairs (player.GetAll()) do
		if y:Team() ~= lastteam then
			y:PrintMessage(HUD_PRINTCENTER, "You have " .. seconds .. " seconds left to build a spawn point");
		end
	end

	seconds = seconds - 1
	timer.Simple(1, function() WMWinCountdown(lastteam, seconds) end)
end

function WMWin(lastteam)
	for x, y in pairs (player.GetAll()) do
		local message = "Team " .. lastteam .. ", (" .. team.GetName(lastteam) .. "), has won the round!"
		y:PrintMessage(HUD_PRINTCENTER, message);
	end
	timer.Simple(1, function() WMWin(lastteam) end)
end

function WMLoadNextMap()
	game.LoadNextMap()--Enabled as a quick fix for server not changing map.
	hook.Call( "WMLoadNextMap", {} )
end

function WMSaySearch( ply, saywhat, targets )
	
	--Msg(targets)
	local tell= -5
	local text = saywhat
	local lowered = string.lower(saywhat)
	local message = ply:GetName() .. " to team "
	local playerName = ply:GetName()
	
	if string.find(lowered, "how do") ~= nil || string.find (lowered, "how can") ~= nil || string.find (lowered, "how the") ~= nil || string.find (lowered, "how u") ~= nil || string.find (lowered, "how you") ~= nil then 
		ply:ConCommand("wmhelp")
	end
	if string.find(lowered, "/join") ~= nil then
		if string.find(saywhat, "1") ~= nil || string.find(lowered, "red") ~= nil then
			WMJoinTeam(ply, 1)
		elseif string.find(saywhat, "2") ~= nil || string.find(lowered, "blue") ~= nil then
			WMJoinTeam(ply, 2)
		elseif string.find(saywhat, "3") ~= nil || string.find(lowered, " green") ~= nil then
			WMJoinTeam(ply, 3)
		elseif string.find(saywhat, "4") ~= nil || string.find(lowered, " yellow") ~= nil then
			WMJoinTeam(ply, 4)
		elseif string.find(saywhat, "5") ~= nil || string.find(lowered, " magenta") ~= nil then
			WMJoinTeam(ply, 5)
		elseif string.find(saywhat, "6") ~= nil || string.find(lowered, " cyan") ~= nil then
			WMJoinTeam(ply, 6)
		elseif string.find(saywhat, "0") ~= nil || string.find(lowered, " none") ~= nil then
			WMJoinTeam(ply, 0)
		elseif string.find(saywhat, "7") ~= nil || string.find(lowered, " AI") ~= nil then
			WMJoinTeam(ply, 7)
		end
		return false
	elseif string.find(lowered, "/lock") ~= nil then
		ply:ConCommand("wmteamlock")
		return false
	elseif string.find(saywhat, "/tell") ~= nil then
		if targets then
			ply:PrintMessage(HUD_PRINTTALK, "Use say_team (team chat) when messaging other teams.")
			return false
		end
		if string.find(saywhat, "/tell 0") ~= nil then
			text = string.Replace(text, "/tell 0", message .. "0: ")
			tell = 0
		elseif string.find(saywhat, "/tell 1") ~= nil then
			text = string.Replace(text, "/tell 1", message .. "1: ")
			tell = 1
		elseif string.find(saywhat, "/tell 2") ~= nil then
			text = string.Replace(text, "/tell 2", message .. "2: ")
			tell = 2
		elseif string.find(saywhat, "/tell 3") ~= nil then
			text = string.Replace(text, "/tell 3", message .. "3: ")
			tell = 3
		elseif string.find(saywhat, "/tell 4") ~= nil then
			text = string.Replace(text, "/tell 4", message .. "4: ")
			tell = 4
		elseif string.find(saywhat, "/tell 5") ~= nil then
			text = string.Replace(text, "/tell 5", message .. "5: ")
			tell = 5
		elseif string.find(saywhat, "/tell 6") ~= nil then
			text = string.Replace(text, "/tell 6", message .. "6: ")
			tell = 6
		end
	--[[elseif string.find(saywhat, "/ally") == 1 then
		if string.find(saywhat, " 1") == 1 || string.find(saywhat, " red") == 1 then
			ply.Ally = 1
		elseif string.find(saywhat, " 2") == 1 || string.find(saywhat, " blue") == 1 then
			ply.Ally = 2
		elseif string.find(saywhat, " 3") == 1 || string.find(saywhat, " green") == 1 then
			ply.Ally = 3
		elseif string.find(saywhat, " 4") == 1 || string.find(saywhat, " yellow") == 1 then
			ply.Ally = 4
		elseif string.find(saywhat, " 5") == 1 || string.find(saywhat, " magenta") == 1 then
			ply.Ally = 5
		elseif string.find(saywhat, " 6") == 1 || string.find(saywhat, " cyan") == 1 then
			ply.Ally = 6
		elseif string.find(saywhat, " 0") == 1 || string.find(saywhat, " none") == 1 then
			ply.Ally = 0
		end--]]
	end
	if tell ~= -5 then
		WMTeamMsg(tell, text)
		return "[To" .. tell .. "] " .. string.Replace(text, ply:GetName() .. " to team " .. tell, "")
	end
	if string.find(lowered, "/help") ~= nil then
		ply:ConCommand("wmhelp")
		return false
	end
	if string.find(lowered, "/donate") ~= nil then
		ply:ConCommand("wmdonate")
		return false
	end
	if string.find(lowered, "/invite") ~= nil then
		ply:ConCommand("wminvite")
		return false
	end
	if string.find(lowered, "/menu") ~= nil then
		ply:ConCommand("wmmenu")
		return false
	end
	if !targets then
		--return "[TEAM] " .. text, false --Removed [TEAM] from the 
		return text, false
	end

end
hook.Add ( "PlayerSay", "WMSaySearch", WMSaySearch ) 

function WMTeamMsg(team, msg)
	 for k, v in pairs (player.GetAll()) do
	   if v:Team() == team then
	   v:PrintMessage(HUD_PRINTTALK, msg)
	   end
	end
end

function CanMelonSpawn(Team, Location)

	local melon = ents.Create("johnny_lightfighter");
	melon:SetPos(Location + Vector(0,0,10));

	melon.Team = Team;
	melon.Move = true;
	melon.Grav = true;
	melon:Spawn();
	melon:Activate();
	melon.Built = 2;
end

function Disaperate(ent)
	local col = ent:GetColor()
	if a > 19 then                                                                                          
		ent:SetColor(Color(col.r,col.g,col.b, col.a-20))
	end
	timer.Simple(0.25, function() Disaperate(ent) end)
end

function PlayerPussedOut(ply)
	-- As the hook actually is for every removed ent, and we treat it as a Disconnect of Player
	if ply ~= nil and ply:IsValid() and ply:IsPlayer() then
		table.insert(savedNRGs, ply:SteamID())
		table.insert(savedNRGs, ply:GetNWInt("nrg"))
		ply:ConCommand("-wmselect")
		if ply.ZMarker then
			ply.ZMarker:Remove()
			ply.ZMarker = nil
		end
		if team.NumPlayers(ply:Team()) == 0 then -- Appears that new hook runs after team lost 1
			WMNewCaptain(ply:Team(), ply)
			teamslocked[ply:Team()] = 0
		end
	end
end
hook.Add( "EntityRemoved", "playerdisconnected", PlayerPussedOut )
-- hook is normally named PlayerDisconnected, but sometimes it fails. Hence the workaround

function WMSendInvite(ply, cmd, arg)
	if ply:GetNetworkedBool("WMCaptain") then
		local players = player.GetAll()
		for k, v in pairs (players) do
			if arg[1] == v:GetName() then
				if v:GetInfo("WM_IgnoreInvites") == "0" then
					if v.TeamInvitation == nil then
						if ply:Team() > 0 && ply:Team() < 7 then
							v.TeamInvitation = ply:Team()
							v.TeamInviter = ply
							umsg.Start("InviteTrigger", v)
								umsg.Short(v.TeamInvitation)
								umsg.Entity(ply)
							umsg.End()
						else
							ply:PrintMessage(HUD_PRINTTALK, "You cannot invite players to admin-only teams.")
						end
					else
						ply:PrintMessage(HUD_PRINTTALK, v:GetName() .. " already has a pending invitation.")
						return
					end
				else
					ply:PrintMessage(HUD_PRINTTALK, v:GetName() .. " is refusing all invitations.")
				end
				return
			end
		end
	else 
		ply:PrintMessage(HUD_PRINTTALK, "Only team captains can do this.")
	end
end

function WMAcceptInvite(ply, cmd, arg)
	if ply.TeamInvitation ~= nil then
		WMJoinTeam(ply, ply.TeamInvitation, true)
		ply:SetNetworkedBool("WMCaptain", false)
		ply.TeamInvitation = nil
		ply.TeamInviter = nil
	else
		ply:PrintMessage(HUD_PRINTTALK, "You have not been invited to any teams.")
	end
end

function WMDeclineInvite(ply, cmd, arg)
    if ply.TeamInvitation ~= nil then
		ply.TeamInviter:PrintMessage(HUD_PRINTTALK, ply:GetName() .. " declined your invitation.")
		ply.TeamInvitation = nil
		ply.TeamInviter = nil
    end
end

function WMSendNRG(ply, cmd, arg)
	if arg[1] ~= nil && arg[2] ~= nil then
		local donation = math.abs(arg[2])
		if ply:GetNWInt("nrg") >= donation then
			local players = player.GetAll()
			for k, v in pairs (players) do
				if arg[1] == v:GetName() then
					v:SetNWInt("nrg", v:GetNWInt("nrg") + donation)
					ply:SetNWInt("nrg", ply:GetNWInt("nrg") - donation)
					ply:PrintMessage(HUD_PRINTTALK, "You donated " .. donation .. " NRG to " .. v:GetName() .. ".")
					v:PrintMessage(HUD_PRINTTALK, ply:GetName() .." gave you " .. donation .. " NRG.")
					return
				end
			end
			ply:PrintMessage(HUD_PRINTTALK, "No such player.")
		else
			ply:PrintMessage(HUD_PRINTTALK, "You do not have enough NRG")
		end
	end
end

function WMPlayerJoins (ply)
	ply.WMSelections = {};
--	ply.WMSelecting = false;
	ply.SetSelectionBox = nil;
	ply.WMG = {};
	ply.TPLocs = {};
	ply.TPAngs = {};
	ply.LastTP = {};
	ply.Groups = {};
	ply.UsedFreeSpawn = false
	ply:SetSolid(SOLID_VPHYSICS)
	MingeBlock(ply)
--	ply.Ally = 0;
	ply:SetTeam(8);
    ply:SetNWInt("chosenone", 0)
	if table.HasValue(currentplayers, ply:SteamID()) then
		for k, v in pairs (savedNRGs) do
			if string.find(v, ply:SteamID()) ~= nil then
				ply:SetNWInt( "nrg" , savedNRGs[k + 1] );
				table.remove(savedNRGs, k)
				table.remove(savedNRGs, k + 1)
			end
		end
	else
		table.insert(currentplayers, ply:SteamID())
		ply:SetNWInt( "nrg" , GetConVarNumber( "WM_StartingNRG", 60000) );
	end
	timer.Simple(math.Rand(0, 3), function() WMInitialJoin(ply) end)
end

function WMInitialJoin(ply)
	timer.Simple(10, function() SendTime() end)
	ply:ConCommand("wmhelp")
	timer.Simple(2, function() ply:ConCommand("wmmenu") end)
	timer.Simple(1, function() SendText(ply, VariantDescription) end)
	for i = 1, 7 do
		SendBounty(i, ply)
	end
	local message = game.GetMap()
	ply.TeamInvitation = nil
	ply:Spectate(0)
	ply:UnSpectate()
	ply:Give("weapon_physgun")
	ply:Give("lap_selector")
	ply:Give("gmod_camera")
	ply:Give("gmod_tool")
	timer.Simple(15, function() WMSpawnCheck(ply) end)
	if FirstPlayer == 0 && ADSpawnFile ~= nil then
		ply:Team(0)
		AdvDupeTime(ply)
		ply:Freeze(true)
		return
	end
	for i=1,6 do  
		ply:ConCommand("-walk")
		ply:SetMoveType(MOVETYPE_NOCLIP)
		ply:SetCollisionBounds(Vector(0,0,0), Vector(0.01, 0.01, 0.01))
		ply:SetNotSolid(true)
		ply:SetCollisionGroup(COLLISION_GROUP_NONE)
	   if team.NumPlayers(i) < GetConVarNumber( "WM_PlayersPerTeam", 1) && teamslocked[i] == 0 && i ~= 7 then
	        Msg(team.NumPlayers(i))
	        if team.NumPlayers(i) == 0 then
				ply:SetNetworkedBool("WMCaptain", true)
				ply:PrintMessage(HUD_PRINTTALK, "You are the new team captain")
            end
		teamslocked[ply:Team()] = 0
		ply:SetTeam(i);
		teamslocked[i] = 1
        if (i == 1) then
			ply:SetColor (Color(255, 0, 0, 255));
		elseif (i == 2) then
			ply:SetColor (Color(0, 0, 255, 255));
		elseif (i == 3) then
			ply:SetColor (Color(0, 255, 0, 255));
		elseif (i == 4) then
			ply:SetColor (Color(255, 255, 0, 255));
		elseif (i == 5) then
			ply:SetColor (Color(255, 0, 255, 255));
		elseif (i == 6) then
			ply:SetColor (Color(0, 255, 255, 255));
		elseif (i == 0) then
			ply:SetColor (Color(0, 0, 0, 255))
		end
		local message = ply:GetName() .. " has joined team " .. i .. ", (" ..team.GetName(i).. ")."
		Msg(message .. "\n")
	    for x, y in pairs (player.GetAll()) do
			y:PrintMessage(HUD_PRINTTALK, message);
	    end
	    if GetGlobalInt("WM_ScenarioMode") == 10 then
            WMSendATarget(ply)
        end
        if WMPhantomTeam ~= 0 && GetGlobalInt("WM_ScenarioMode") == 10 then
            WMSendPhantomAssignments(ply)
        end
		return
	end
	end
end


function WMJoinTeam(ply, teem, invited)

ply:ConCommand("cl_timeout 60")
ply.WMSelections = {}
local allplayers = player.GetAll()
		if (teem == 7 || teem == 0) then
    		  if IsAdminOrSinglePlayer(ply) ~= true then
    		  local message = "Only admins can be on team 0 or 7"
    		  ply:PrintMessage(HUD_PRINTTALK, message)
    		  return
    		  end
    	    if team.NumPlayers(ply:Team()) == 1 then
    		teamslocked[ply:Team()] = 0
    		end
		WMNewCaptain(ply:Team(), ply)
		ply:SetTeam(teem)
		WMSendTeamEntUmsgs(ply)
		elseif GetConVarNumber( "WM_AllowTeamChanges", 1) == 1 then
		
    		if team.NumPlayers(teem) < GetConVarNumber( "WM_PlayersPerTeam", 1) then
    		  if teamslocked[teem] == 0 || teem == 0 || invited ~= nil then
              teamslocked[teem] = 1          
              else 
              ply:PrintMessage(HUD_PRINTTALK, "That team is locked")
              return
              end
        if team.NumPlayers(ply:Team()) == 1 then
		teamslocked[ply:Team()] = 0
		end
        WMNewCaptain(ply:Team(), ply)
		ply:SetTeam(teem)
		WMSendTeamEntUmsgs(ply)
		if team.NumPlayers(teem) == 1 then
		ply:SetNetworkedBool("WMCaptain", true)
		ply:PrintMessage(HUD_PRINTTALK, "You are the new team captain")
		else
		ply:SetNetworkedBool("WMCaptain", nil)
		end
		if (teem == 1) then
		ply:SetColor (Color(255, 0, 0, 255));
		elseif (teem == 2) then
		ply:SetColor (Color(0, 0, 255, 255));
		elseif (teem == 3) then
		ply:SetColor (Color(0, 255, 0, 255));
		elseif (teem == 4) then
		ply:SetColor (Color(255, 255, 0, 255));
		elseif (teem == 5) then
		ply:SetColor (Color(255, 0, 255, 255));
		elseif (teem == 6) then
		ply:SetColor (Color(0, 255, 255, 255));
		elseif (teem == 0) || team == 7 then
		ply:SetColor (Color(0, 0, 0, 255))
		end
			for k,v in pairs ( allplayers ) do
			local message = ply:GetName() .. "'s team set to: " .. teem .. ", (" .. team.GetName(teem) .. ")."
			v:PrintMessage( HUD_PRINTTALK, message )
			end 
		else
		local message = "Team " .. teem .. " is full."
		ply:PrintMessage(HUD_PRINTTALK, message)
		end
		else
		local message = "The server has disabled team changing."
		ply:PrintMessage(HUD_PRINTTALK, message)
		end
		if GetGlobalInt("WM_ScenarioMode") == 10 then
        WMSendATarget(ply)
        end
        if WMPhantomTeam ~= 0 && GetGlobalInt("WM_ScenarioMode") == 10 then
        WMSendPhantomAssignments(ply)
        end
end

function WMNewCaptain(teem, ply)
	ply:SetNetworkedBool("WMCaptain", nil)
	local newcaptain
    for k, v in pairs (team.GetPlayers(teem)) do
        if v ~= ply then
			v:SetNetworkedBool("WMCaptain", true)
			newcaptain = v
			for x,y in pairs (team.GetPlayers(teem)) do
				if y ~= ply then
					y:PrintMessage(HUD_PRINTTALK, y:GetName() .. " is the new team captain")
				end
			end
			break
		end
	end
	return
end

function WMSendCost(ply, cost, mod)
	umsg.Start("wm_cost_message", ply)
		if mod == false then mod = 1 end
		umsg.Long(cost)
		umsg.Short(mod)
	umsg.End()
end


function WMSendTeamEntUmsgs(ply)
	for k, v in pairs (ents.GetAll()) do
		if v.Warmelon && v.Team == ply:Team() then
			if v.Stance then
			  umsg.Start("WMStanceMsg", ply)
				umsg.Entity(v)
				umsg.Short(v.Stance)
			  umsg.End()
			end
			if v.HoldFire then
			  umsg.Start("WMHoldFireMsg",ply)
				umsg.Entity(v)
				umsg.Bool(true)
				umsg.End()
			end
		     if v.Load ~= nil then
			  	umsg.Start("WMLoadingMsg", ply)
				umsg.Entity(v)
				umsg.Bool(v.Load)
				umsg.End()
			end
			if v.Loaded then
				umsg.Start("WMLoaded", ply)
				umsg.Entity(v)
				umsg.Short(#v.Loaded)
				umsg.End()
			end
			if v.MaxAmmo then
			umsg.Start("WMMaxAmmo", ply)
			umsg.Entity(v)
			umsg.Short(v.MaxAmmo)
			umsg.End()
			end
		end
	end
end


function WMSendTicker(ply, cmd, arg)
	if !ply:IsValid() || IsAdminOrSinglePlayer(ply) then
		local rp = RecipientFilter() -- Grab a RecipientFilter object
		if arg[1] == "all" then
			rp:AddAllPlayers()
		else
			rp = player.GetByID(tonumber(arg[1]))
		end
		
		umsg.Start("wm_custom_ticker_msg", rp)
		umsg.String(arg[2])
		umsg.End()
	end
end

function WMSendMsg(ply, msg)
	umsg.Start("wm_message", ply)
		umsg.String(msg)
	umsg.End()
end

function WMSendStdMsg()
	umsg.Start("wm_std_message", ply)
end


function NRGCheck(ply, cost)
	if ply:Team() == 0 then return true end
    cost = math.abs(math.floor(cost))
	if ply:GetNWInt("nrg") >= cost then
		if GetGlobalInt("WM_ScenarioMode") == 13 then
			if ply:Team() == WMPhantomTeam then
				cost = math.Rand(WMPhantomMaxDiscount, WMPhantomMinDiscount) * cost
			else
				cost = math.Rand(WMPhantomCurDiscount,1) * cost
			end
		end
		ply:SetNWInt("nrg", ply:GetNWInt("nrg") - cost)
		WMSendCost(ply, cost, 3)
		return true
	else
		WMSendCost(ply, cost, 2)
		return false
	end
end

function InBaseRange(ply, Pos)
	if ply:Team() == 0 then
		return true
	end
	local buildradius = GetConVarNumber( "WM_Buildradius", 750)
	if (buildradius ~= 0) then
		local entz = ents.FindByClass("lap_spawnpoint")
		for k, v in pairs(entz) do
			local dist = v:GetPos():Distance(Pos);
			if (v.Team == ply:Team() && dist <= buildradius && v.Built == 2) then
				return true
			end
		end
	else
		return true
	end
	local message = "Too far from spawnpoint"
	ply:PrintMessage(HUD_PRINTCENTER, message);
	return false
end

function InOutpostRange(ply, Pos)
	if ply:Team() == 0 then
		return true
	end
	local buildradius = GetConVarNumber( "WM_Buildradius", 750)
	if (buildradius ~= 0) then
		local entz = ents.FindByClass("lap_spawnpoint")
		local entz2 = ents.FindByClass("lap_outpost")
		for k, v in pairs(entz) do
			local dist = v:GetPos():Distance(Pos);
			if (v.Team == ply:Team() && dist <= buildradius && v.Built == 2) then
				return true
			end
		end
		for k, v in pairs(entz2) do
			local dist = v:GetPos():Distance(Pos);
			if (v.Team == ply:Team() && dist <= buildradius) then
				return true
			end
		end
	else
		return true
	end
	local message = "Too far from spawnpoint or outpost"
	ply:PrintMessage(HUD_PRINTCENTER, message);
	return false
end

function Invis(ply, alpha)
	alpha = alpha or 0
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:Fire( "alpha", alpha, 0 )
	ply:DrawWorldModel(false)
end

function GM:PlayerShouldTakeDamage( victim, pl )
	return false
end 

function EnemyMelonCheck(ply, Pos)
	for k, v in pairs(ents.FindInSphere( Pos, GetConVarNumber( "WM_EnemyBuildDenialRadius", 750))) do
		if v.Warmelon && v.Delay then
			if v.Team ~= ply:Team() && ply:Team() ~= 0 then
				ply:PrintMessage(HUD_PRINTCENTER, "Enemy melons are too close.")
				return false
			end
		end
	end
	return true
end

function WMBlockProps(ply, mdl)
	if ply:Team() ~=0 then
		local trace = ply:GetEyeTrace()
		if !EnemyMelonCheck(ply, trace.HitPos) then return false end
		if GetConVarNumber( "WM_Buildradius", 750) ~= 0 then
			if !InOutpostRange(ply, trace.HitPos) then return false end
		end
		if ( !ply:CheckLimit( "lap_baseprops" ) ) then return false end
	end
end


function SpawnedProp(ply, model, ent)
	local t = ply:Team();
	if (GetConVarNumber( "WM_Normalpropspawning", 0) == 0) && t ~= 0 then
		if ent:GetClass() ~= "melon_baseprop" && ent:IsValid() then
			local p = ent:GetPhysicsObject();
			local h
			local vec = (ent:OBBMaxs() - ent:OBBMins())
			local size = vec.x * vec.y * vec.z
			--Msg("Size: " .. size)
			if (size * GetConVarNumber( "WM_HealthtoSize", ".0015")) <= GetConVarNumber( "WM_MaxPropHealth", 1500) then
				h = size * GetConVarNumber( "WM_HealthtoSize", ".0015")
			else
				h = GetConVarNumber( "WM_MaxPropHealth", 1500)
			end
			--Msg("HP: " .. h)
			--if size > GetConVarNumber( "WM_Propcost", 2) then
				--m = size
			--end
			if NRGCheck(ply,h*GetConVarNumber( "WM_Propcost", 2)) then
				local melon = ents.Create ("melon_baseprop");
				table.Add( melon, ent )
				--ply:SetNWInt( "nrg", math.floor(ply:GetNWInt( "nrg" , 0) - h*GetConVarNumber( "WM_Propcost", 2)));
				melon.Cost = h*GetConVarNumber( "WM_Propcost", 2)
				melon.mass = h / GetConVarNumber( "WM_healthtomass", 1.5)
				--Msg("Mass: " .. melon.mass)
				melon.model = ent:GetModel();
				melon:SetModel(ent:GetModel());
				melon:SetPos(ent:GetPos());
				melon:SetAngles(ent:GetAngles());
				melon.Team = t;
				melon:SetName(ent:GetName())
				melon:Spawn();
				ply:AddCount('lap_baseprops', melon)
				melon:Activate();
				undo.Create("baseprop");
					undo.AddEntity(melon);
					undo.SetPlayer(ply);
				undo.Finish();
			end
			if ent:IsValid() && ent:GetClass() ~= "melon_baseprop" then
				ent:Remove()
			end
		end
	end
end

if GetConVarNumber( "WM_Rules", 1) ~= 0 then
	hook.Add("PlayerSpawnProp", "WMBlockProps", WMBlockProps ) 
	hook.Add("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp) ;
	hook.Add("PlayerInitialSpawn", "WarmelonSpawn", WMPlayerJoins);
end

function TESTMulti(ply, cmd, arg)
	PrintTable(arg)
end
concommand.Add("rar", TESTMulti)

function WMSelect (ply, cmd, arg)
    if !ply:IsValid() then
		return
    end
	local mteam = ply:Team()
	local tr = ply:GetEyeTrace();
	local sendtable = {}
	if !ply:KeyDown(IN_SPEED) then
		--don't clear if shift is held down, so we can select multiple groups of units
		ply.WMSelections = {};
		WMClearPlySelection(ply)
	end
	if ply:KeyDown(IN_DUCK) then
		WMTypeSelect(ply)
	elseif ply:KeyDown(IN_USE) then
		if tr.Entity:IsValid() && tr.Entity.Team ~= nil && (tr.Entity.Team == ply:Team() || ply:Team() == 0) && tr.Entity.Delay then
			table.insert(ply.WMSelections, tr.Entity)
			table.insert(sendtable, tr.Entity)
		end
	end
	--making sure the player is selecting by this point
	--to stop retards breaking it by typing -wmselect into the console
	
	local selCentre = Vector(tonumber(arg[1]),tonumber(arg[2]), tonumber(arg[3]))
	local selRadius = tonumber(arg[4])
	for k, v in pairs(ents.FindInSphere(selCentre, selRadius)) do
		if (v.Warmelon && (v.Move == true || (v.Delay ~= nil && ply:KeyDown(IN_USE)))) then
			local target = v;
			if (mteam == 0 && target.Team > 0) then
				if (!table.HasValue(ply.WMSelections, target)) then
					table.insert(ply.WMSelections, target);
					table.insert(sendtable, target)
				end
			elseif (mteam == target.Team) then
				if (!table.HasValue(ply.WMSelections, target)) then
					table.insert(ply.WMSelections, target);
					table.insert(sendtable, target)
				end
			end
		end
	end
	WMSendPlySelection(ply, sendtable)
	ply:EmitSound("Weapon_SMG1.Special1", 100, 100);
	ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
	--turn this into a umsg. Damn strings and sounds
end
concommand.Add("wmselect", WMSelect)

function GM:AcceptStream ( pl, handler, id )
  return true
end 

function WMSelectionStream( ply, handler, id, encoded, decoded )
	PrintTable(decoded)
	local teem = ply:Team()
	for k, v in pairs (decoded)do
		if (v.Team == teem || teem == 0) && !table.HasValue(ply.WMSelections, v) then
		table.insert(ply.WMSelections, v)
		end
	end
end
--datastream.Hook( "WMSelectionStream", WMSelectionStream )

function WMGiveOrder (ply, cmd, arg)
	local tr = ply:GetEyeTrace()
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = trace.start + ply:GetAimVector() * 100000
	trace.filter = { ply }
	trace.mask = MASK_OPAQUE || MASK_WATER 
	if !ply:KeyDown(IN_WALK) then
		tr.HitPos = util.TraceLine(trace).HitPos
	end
	if GetConVarNumber( "WM_Pause", 0) ~= 1 then
		if tr.Hit && ply:KeyDown(IN_JUMP) && !ply.ZMarker then
			--Msg("Created")
			ply.ZMarker = ents.Create("lap_zmarker")
			ply.ZMarker:SetPos(tr.HitPos)
			ply.ZMarker:SetOwner(ply)
			ply.ZMarker:Spawn()
			ply.ZMarker:SetColor(Color(255,255,255,255))
			ply.ZMarker:Activate()
			return
		end
		if #ply.WMSelections > 0 && (tr.Hit || (ply.ZMarker && ply:KeyDown(IN_JUMP))) then
			ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
			for k, x in pairs(ply.WMSelections) do
			if x ~= nil && x:IsValid() then
				x.Leader = nil;
				x.StartChase = nil;
				if x.Stance ~= nil && x.Stance < 0 then
					if x.Stance > -4 then
						x.Stance = x.Stance * -1
					else
						x.Stance = x.Stance * -0.2
					end
				end
				local movem = true
				if ply:KeyDown(IN_WALK) then
				    if !tr.Entity:IsWorld() then
						x.Target = tr.Entity
						x.HoldFire = nil
						local movem = false
					else
						x.Target = nil
					end
                end
				if movem == true then
					x.Orders = true;
					if !ply:KeyDown(IN_SPEED) then
						x.TargetVec = { };		  
    				end
					if ply.ZMarker && ply:KeyDown(IN_JUMP) then
						table.insert(x.TargetVec, ply.ZMarker:GetPos())
					else	
						table.insert(x.TargetVec, tr.HitPos)
					end
					x:GetPhysicsObject():Wake()
    				if ply:KeyDown(IN_USE) && !tr.Entity:IsWorld() then
    					x.Leader = tr.Entity
    				end
    				if ply:KeyDown(IN_DUCK) then
    					x.Patrol = true;
    					if table.Count(x.TargetVec) < 2 then
							table.insert(x.TargetVec, x:GetPos())
    					end
    				else
    					x.Patrol = false;
    				end
				end
			end
			if ply.ZMarker && ply:KeyDown(IN_JUMP) then
				ply.ZMarker:Remove()
				ply.ZMarker = nil
			end
			if x:IsValid() && x.Move ~= true then
				x.TargetVec = {}
				x.Leader = nil
		    end
		end
	end
	else
		ply:PrintMessage(HUD_PRINTCENTER, "No commanding in warmup time!")
	end
end

function WMSendPlySelection(ply, selection)
	for k, v in pairs (selection) do
		umsg.Start("WM_Selecting", ply)
		umsg.Entity(v)
		umsg.End()
	end
end

function WMClearPlySelection(ply)
	umsg.Start("WM_ClearSelection", ply)
	umsg.End()
end

function WMColor (ply)
	local untouchables = {
		"lap_microwavelaser",
		"lap_kaboom",
		"lap_chaos",
		"lap_regencore",
		"lap_mindcontrol",
		"lap_leader"
    }
	for k, melons in pairs(ply.WMSelections) do
		if melons:IsValid() then
			umsg.Start("WM_Selecting", ply)
				umsg.Entity(melons)
			umsg.End()
			if !table.HasValue(untouchables, melons:GetClass()) then
				--melons:SetMaterial("models/shiny")
			--elseif melons.SelMat then
				--melons:SetMaterial(melons.SelMat)
			end
			--melons:SetMaterial("models/props_c17/FurnitureMetal001a")
		end	
	end
end

function WMDeColor (ply)
	local untouchables = {
		"lap_microwavelaser",
		"lap_kaboom",
		"lap_chaos",
		"lap_regencore",
		"lap_mindcontrol",
		"lap_leader"
    }
	for k, melons in pairs(ply.WMSelections) do
		if melons:IsValid() then
			if !table.HasValue(untouchables, melons:GetClass()) then
				if melons.StdMat then
					-- melons:SetMaterial(melons.StdMat)
				else
					--melons:SetMaterial("models/debug/debugwhite")
				end
			end
		end
	end
end

function WMTypeSelect (ply, cmd, arg)
	--WMDeColor(ply)
	local sr = 1500
	if ply:KeyDown(IN_JUMP) then
		sr = 500
	end
	local sendtable = {}
	local mteam = ply:Team()
	local tr = ply:GetEyeTrace();
	local etr = tr.Entity;
	local Pos = tr.HitPos
	if !ply:KeyDown(IN_SPEED) then
		--don't clear if shift is held down, so we can select multiple groups of units
		ply.WMSelections = {};
	end
	local type = etr:GetClass()
	local cteam = etr.Team
	local entz = ents.FindByClass(type);
	for k, v in pairs(entz) do
		if (v.Move == true) || ply:KeyDown(IN_USE) then
			if (mteam == 0) then
				if !ply:KeyDown(IN_WALK) then
					local dist = v:GetPos():Distance(Pos);
					if (dist <= sr || sr == 0) then
						if !table.HasValue(ply.WMSelections, v) then
							table.insert(ply.WMSelections, v);
							table.insert(sendtable, v)
						end
					end
				else
					if !table.HasValue(ply.WMSelections, v) then
						table.insert(ply.WMSelections, v);
						table.insert(sendtable, v)
					end
				end
				ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
				WMSendPlySelection(ply, sendtable)
			else
				if (v.Team == mteam) then
					if !ply:KeyDown(IN_WALK) then
						local dist = v:GetPos():Distance(Pos);
						if (dist <= sr || sr == 0) then
							if !table.HasValue(ply.WMSelections, v) then
								table.insert(ply.WMSelections, v);
								table.insert(sendtable, v)
							end
						end
					else
						if !table.HasValue(ply.WMSelections, v) then
							table.insert(ply.WMSelections, v);
							table.insert(sendtable, v)
						end
					end
				end
				WMSendPlySelection(ply, sendtable)
				ply:PrintMessage(HUD_PRINTCENTER, #ply.WMSelections.." Warmelons now selected");
			end
		end
	end
end

function WMStanceSelect(ply, cmd, arg)

	if ply.WMSelections ~= nil && #ply.WMSelections > 0 then
	local StanceSelection = tonumber(arg[1])
		ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
		if StanceSelection == nil then 
			if ply:KeyDown(IN_SPEED) then
			StanceSelection = 1;
			elseif ply:KeyDown(IN_WALK) then
			StanceSelection = 2;
			elseif ply:KeyDown(IN_DUCK) then
			StanceSelection = 3;
			elseif ply:KeyDown(IN_USE) then
			StanceSelection = 4;
			elseif ply:KeyDown(IN_JUMP) then
			StanceSelection = 5;
	        end
	    end
    			if StanceSelection == 1 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Stance set to defensive");
    			elseif StanceSelection == 2 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Stance set to offensive");
    			elseif StanceSelection == 3 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Stance set to berzerk");
    			elseif StanceSelection == 4 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Melons will now hold fire");
    			elseif StanceSelection == 5 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Melons will now fire at will");
    			elseif StanceSelection == 6 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Transporters will load melons");
    			elseif StanceSelection == 7 then
    			ply:PrintMessage(HUD_PRINTCENTER, "Transporters will unload melons");
    			else
    			ply:PrintMessage(HUD_PRINTCENTER, "Stance set to stand ground");
    			end
		local rp = RecipientFilter()
		local solo = true
		for k, v in pairs (team.GetPlayers(ply:Team())) do
			if v ~= ply then 
			rp:AddPlayer(v)
			solo = false
			end
		end

		for k, x in pairs(ply.WMSelections) do
			if x ~= nil && x:IsValid() && StanceSelection ~= nil then
		      if StanceSelection < 4 then
		      x.Stance = StanceSelection
				if solo == false then
			  umsg.Start("WMStanceMsg", rp)
				umsg.Entity(x)
				umsg.Short(StanceSelection)
			  umsg.End()
				end
		      elseif StanceSelection == 4 then
		      x.HoldFire = 1
				if solo == false then
			  umsg.Start("WMHoldFireMsg", rp)
				umsg.Entity(x)
				umsg.Bool(true)
				umsg.End()
				end
		      elseif StanceSelection == 5 then
		      x.HoldFire = nil
				if solo == false then
			  	umsg.Start("WMHoldFireMsg", rp)
				umsg.Entity(x)
				umsg.Bool(false)
				umsg.End()
				end
              elseif StanceSelection == 6 && x.Load ~= nil then
		      x.Load = true
				if solo == false then
			  	umsg.Start("WMLoadingMsg", rp)
				umsg.Entity(x)
				umsg.Bool(true)
				umsg.End()
				end
              elseif StanceSelection == 7 && x.Load ~= nil then
				if solo == false then
			  	umsg.Start("WMLoadingMsg", rp)
				umsg.Entity(x)
				umsg.Bool(false)
				umsg.End()
				end
		      x.Load = false		      
		      end
		      
			end
	    end
    end
end

function WMGroupSet (ply, group)
	
	--Make sure the group exists
	if (!ply.WMG[group]) then
		ply.WMG[group] = {}
	end
	
	if (ply:KeyDown(IN_SPEED)) then
		for k, v in pairs(ply.WMSelections) do
			if (!table.HasValue(ply.WMG[group], v)) then
				table.insert(ply.WMG[group], v);
			end
		end
		
		ply:PrintMessage(HUD_PRINTCENTER, "Added to group " .. group);
	else
		ply.WMG[group] = ply.WMSelections
		
		ply:PrintMessage(HUD_PRINTCENTER, "Group " .. group .. " Set");
	end
	
end
function WMGSet (ply, cmd, arg)
	if (#arg == 0) then return end
	WMGroupSet( ply, arg[1] )
end

function WMGroupSelect (ply, group)
	
	--Make sure the group exists
	if (!ply.WMG[group]) then
		ply.WMG[group] = {}
	end
	
	if (ply:KeyDown(IN_SPEED)) then
		ply:PrintMessage(HUD_PRINTCENTER, "Group " .. group .. " Added");
	else
		ply.WMSelections = {};
		WMClearPlySelection(ply)
		
		ply:PrintMessage(HUD_PRINTCENTER, "Group " .. group .. " Selected");
	end
	
	local sendtable = {}
	for k, v in pairs(ply.WMG[group]) do
		if (!table.HasValue(ply.WMSelections, v)) then
			table.insert(ply.WMSelections, v);
			table.insert(sendtable, v)
		end
	end
	
	WMSendPlySelection(ply, sendtable)
	
end
function WMGSelect (ply, cmd, arg)
	if (#arg == 0) then return end
	WMGroupSelect( ply, arg[1] )
end

function WMGroup (ply, group)
	group = "" .. group
	
	if ply:KeyDown(IN_DUCK) then
		WMGroupSet (ply, group)
	else
		WMGroupSelect (ply, group)
	end
	
end
function WMG (ply, cmd, arg)
	if (#arg == 0) then return end
	WMGroup( ply, arg[1] )
end

function WMG1 (ply, cmd, arg)
	WMGroup( ply, 1 )
end
function WMG2 (ply, cmd, arg)
	WMGroup( ply, 2 )
end
function WMG3 (ply, cmd, arg)
	WMGroup( ply, 3 )
end
function WMG4 (ply, cmd, arg)
	WMGroup( ply, 4 )
end
function WMG5 (ply, cmd, arg)
	WMGroup( ply, 5 )
end
function WMG6 (ply, cmd, arg)
	WMGroup( ply, 6 )
end

function ColorDamage(ent, HP, Colar)
	if (ent.health <= (ent.maxhealth / HP)) then
		local col = ent:GetColor(); 
		if col.r ~= 0 then
			col.r = Colar
		end
		if col.g ~= 0 then
			col.g = Colar
		end
		if col.b ~= 0 then
			col.b = Colar
		end
		ent:SetColor(Color(col.r, col.g, col.b, 255))
	end
end

--Life Support Stuff starts here


function DamageLS(ent, dmginfo)
	if not (ent and ent:IsValid() and dmginfo:GetDamage()) then return end
	if not ent.health then return end
	local dmg2 = math.floor(dmginfo:GetDamage() / 2)
	if (ent.health > 0) then
		local HP = ent.health - dmg2
		ent.health = HP
		if (ent.health <= (ent.maxhealth / 2)) then
			ent:Damage()
		end
		ColorDamage(ent, 2, 210)
		ColorDamage(ent, 3, 175)
		ColorDamage(ent, 4, 150)
		ColorDamage(ent, 5, 125)
		ColorDamage(ent, 6, 100)
		ColorDamage(ent, 7, 75)
		
		if (ent.health <= 0) then
		    	if ent.Cost == nil then
    	ent.Cost = 100
    	end
	local dmgerteam = dmginfo:GetInflictor().Team
	if dmgerteam ~= nil && GetConVarNumber("WM_KingoftheHill", 0) == 0 then
        team.SetScore(ent.Team, team.GetScore(ent.Team) - (ent.Cost * GetConVarNumber("WM_ScoreDeathPenalty", 0.5)))
        	   if dmgerteam == ent.Team then
        	       local pointmod = 1
            	   if GetConVarNumber("WM_ScenarioMode", 10) == 4 && ent.Team ~= TeamTargets[dmgerteam] then
                   pointmod = GetConVarNumber("WM_AssassinPenalty", 0.6)             
            	   end
            	   team.SetScore(dmgerteam, team.GetScore(dmgerteam) + (ent.Cost * pointmod ))
            	    if GetConVarNumber("WM_ScoreLimit", 0) > 0 && team.GetScore(dmgerteam) > GetConVarNumber("WM_ScoreLimit", 0) then
                	ScoreVictory()
                	end
        	   end
	end
	if GetConVarNumber("WM_GlobalBounty", 0) ~= 0 then
	local ModdedBounty = ent.Cost * GetConVarNumber("WM_GlobalBounty", 0)
        for k,v in pairs (team.GetPlayers(dmgerteam)) do
        WMSendCost(v, (ModdedBounty / team.NumPlayers(dmgerteam)), 5)
        v:SetNWInt("nrg", v:GetNWInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
        end
	end
	if GetConVarNumber("WM_BountyModifier", 0.5 ) ~= 0 then
        	           local UnitBounty = ent.Cost * GetConVarNumber("WM_BountyModifier", 0.5 )
                        if TeamBounty[ent.Team] > 0 then
                        local ModdedBounty
                            if TeamBounty[ent.Team] - UnitBounty >=0 then
                            ModdedBounty = UnitBounty
                            else
                            ModdedBounty = math.abs(0 - UnitBounty)
                            end
                                for k,v in pairs (team.GetPlayers(dmgerteam)) do
                                WMSendCost(v, (ModdedBounty / team.NumPlayers(dmgerteam)), 5)
                                v:SetNWInt("nrg", v:GetNWInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
                                end
                        end
    end
			ent:SetColor(Color(50, 50, 50, 255))
			ent:Destruct()
		end
	end
end

local function RemoveEntity( ent )
	if (ent:IsValid()) then
		ent:Remove()
	end
end

local function Explode1( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos() + Vector( math.random(-60, 60), math.random(-60, 60), math.random(-60, 60) ))
			Effect:SetScale(1)
			Effect:SetMagnitude(25)
		util.Effect("Explosion", Effect, true, true)
	end
end

local function Explode2( ent )
	if ent:IsValid() then
		local Effect = EffectData()
			Effect:SetOrigin(ent:GetPos())
			Effect:SetScale(3)
			Effect:SetMagnitude(100)
		util.Effect("Explosion", Effect, true, true)
		LS_RemoveEnt( ent )
	end
end

function LS_Destruct( ent, Simple )
	if (Simple) then
		Explode2( ent )
	else
		timer.Simple(1, function() Explode1(ent) end)
		timer.Simple(1.2, function() Explode1(ent) end)
		timer.Simple(2, function() Explode1(ent) end)
		timer.Simple(2, function() Explode2(ent) end)
	end
end

function LS_RemoveEnt( Entity )
	constraint.RemoveAll( Entity )
	timer.Simple( 1, function() RemoveEntity(Entity) end)
	Entity:SetNotSolid( true )
	Entity:SetMoveType( MOVETYPE_NONE )
	Entity:SetNoDraw( true )
end

function ConstraintRape(cns)
    if cns:IsValid() then
		cns:Remove()
    end
end

function SpawnTouchCheck(ent)
	if ent:IsValid() then
		ent:SetMaterial("")
	end
end

function Wire_BuildDupeInfo( ent )
	if (not ent.Inputs) then return end
	
	local info = { Wires = {} }
	for k,input in pairs(ent.Inputs) do
		if (input.Src) and (input.Src:IsValid()) then
		    info.Wires[k] = {
				StartPos = input.StartPos,
				Material = input.Material,
				Color = input.Color,
				Width = input.Width,
				Src = input.Src:EntIndex(),
				SrcId = input.SrcId,
				SrcPos = Vector(0, 0, 0),
			}
			
			if (input.Path) then
				info.Wires[k].Path = {}
				
			    for _,v in ipairs(input.Path) do
			        if (v.Entity) and (v.Entity:IsValid()) then
			        	table.insert(info.Wires[k].Path, { Entity = v.Entity:EntIndex(), Pos = v.Pos })
					end
			    end
			    
			    local n = table.getn(info.Wires[k].Path)
			    if (n > 0) and (info.Wires[k].Path[n].Entity == info.Wires[k].Src) then
			        info.Wires[k].SrcPos = info.Wires[k].Path[n].Pos
			        table.remove(info.Wires[k].Path, n)
			    end
			end
		end
	end
	
	return info
end

function Wire_ApplyDupeInfo(ply, ent, info, GetEntByID)
	if (info.Wires) then
		for k,input in pairs(info.Wires) do
		    
			Wire_Link_Start(ply:UniqueID(), ent, input.StartPos, k, input.Material, input.Color, input.Width)
		    
			if (input.Path) then
		        for _,v in ipairs(input.Path) do
					
					local ent2 = GetEntByID(v.Entity)
					if (!ent2) or (!ent2:IsValid()) then ent2 = ents.GetByIndex(v.Entity) end
					if (ent2) or (ent2:IsValid()) then
						Wire_Link_Node(ply:UniqueID(), ent2, v.Pos)
					else
						Msg("ApplyDupeInfo: Error, Could not find the entity for wire path\n")
					end
				end
		    end
			
			local ent2 = GetEntByID(input.Src)
		    if (!ent2) or (!ent2:IsValid()) then ent2 = ents.GetByIndex(input.Src) end
			if (ent2) or (ent2:IsValid()) then
				Wire_Link_End(ply:UniqueID(), ent2, input.SrcPos, input.SrcId)
			else
				Msg("ApplyDupeInfo: Error, Could not find the output entity\n")
			end
		end
	end
end

function WMJump(ply, cmd, arg)
	if #ply.WMSelections > 0 then
		ply:EmitSound("Weapon_SMG1.Special2", 100, 100);
		for k, v in pairs(ply.WMSelections) do
			local phys = v:GetPhysicsObject()
			phys:SetVelocity(phys:GetVelocity() + Vector(0, 0, 500))
		end
	end
end

function WMEasyMode(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
		game.ConsoleCommand("wm_buildradius 0\n")
		game.ConsoleCommand("wm_toolcost 0\n")
		game.ConsoleCommand("wm_buildtime 0.01\n")
		--game.ConsoleCommand("wm_normalpropspawning 1\n")
		game.ConsoleCommand("wm_propcost 0\n")
		game.ConsoleCommand("wm_rules 0\n") 
	end
end

function IsAdminOrSinglePlayer(ply)
	return ( ply:IsAdmin() || game.SinglePlayer() )--Changed SinglePlayer() to game.SinglePlayer()
end

function WMInsertMapString(ply, mapstring, string2, string1)
	local ini = file.Read("data/WM-RTS/variants/" .. game.GetMap() .. "[" .. mapstring .. "].txt","GAME")
	local exploded = string.Explode("\n", ini);
	local foundit = false
    for k, v in pairs (exploded) do
        if v == "Variant Description" then
			foundit = true
			table.insert(exploded, k+2, string2)
			table.insert(exploded, k+2, string1)
        end
    end
    if foundit == false then
		table.insert(exploded, 1, string2)
		table.insert(exploded, 1, string1)
    end
    file.Write("WM-RTS/variants/" .. game.GetMap() .. "[" .. mapstring .. "].txt", string.Implode("\n", exploded))
    ply:PrintMessage(HUD_PRINTTALK, "Appended variant file WM-RTS/variants/" .. game.GetMap() .. "[" .. mapstring .. "].txt");
end

function WMAppendVariant(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
		WMInsertMapString(ply, arg[1], arg[2], arg[3])
	end
end

function WMSaveMap(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
	local message = {}
	for k,v in pairs(ents.FindByClass("lap_cappoint")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "lap_cappoint")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	end
	for k,v in pairs(ents.FindByClass("lap_spawner")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "lap_spawner")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, self.Skips)
	table.insert(message, self.Delay)
	table.insert(message, self.SpeedMod)
	table.insert(message, self.SFile)
	end
	for k,v in pairs(ents.FindByClass("nobuildarea")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "nobuildarea")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, v.NoBuildRadius)
	end
	for k,v in pairs(ents.FindByClass("lap_commuplink")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, "lap_commuplink")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	end
	for k,v in pairs(ents.FindByClass("lap_spawnpoint")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local team = v.Team
	table.insert(message, "lap_spawnpoint")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, team)
	end
	for k,v in pairs(ents.FindByClass("lap_outpost")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local team = v.Team
	table.insert(message, "lap_outpost")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, team)
	end
	for k,v in pairs(ents.FindByClass("prop_physics")) do
	if string.find(arg[1], "t") ~= nil then

	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, v:GetClass())
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	   elseif string.find(v:GetModel(), "rock") == nil && string.find(v:GetModel(), "stone") == nil && string.find(v:GetModel(), "tree") == nil && v:GetClass() ~= "prop_physics_multiplayer" then
	   	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	table.insert(message, v:GetClass())
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	   end
	end
	for k,v in pairs(ents.FindByClass("lap_resnode")) do
	local pos = v:GetPos()
	local ang = v:GetAngles()
	local model = v:GetModel()
	local res = v.Rez
	table.insert(message, "lap_resnode")
	table.insert(message, pos.x)
	table.insert(message, pos.y)
	table.insert(message, pos.z)
	table.insert(message, ang.p)
	table.insert(message, ang.r)
	table.insert(message, ang.y)
	table.insert(message, model)
	table.insert(message, res)
	end
if arg[1] ~= nil then
arg[1] = string.gsub(arg[1], "t", "")
    if file.Exists("WM-RTS/variants/" .. game.GetMap() .. "[" .. arg[1] .. "].txt") then
    ply:PrintMessage(HUD_PRINTTALK, "Variant " .. arg[1] .. " already exists! Delete it first")
    return
    else
    file.Write("WM-RTS/variants/" .. game.GetMap() .. "[" .. arg[1] .. "].txt", string.Implode("\n", message))
    ply:PrintMessage(HUD_PRINTTALK, "Wrote feature file WM-RTS/variants/" .. game.GetMap() .. "[" .. arg[1] .. "].txt");
    end
else
    if file.Exists("WM-RTS/variants/" .. game.GetMap() .. "[0].txt") then
    ply:PrintMessage(HUD_PRINTTALK, "Variant 0 already exists! Delete it first!")
    return
    else
    file.Write("WM-RTS/variants/" .. game.GetMap() .. "[0].txt", string.Implode("\n", message))
    ply:PrintMessage(HUD_PRINTTALK, "Wrote feature file WM-RTS/variants/" .. game.GetMap() .. "[0].txt");
    end
end
else
ply:PrintMessage(HUD_PRINTCENTER, "That command is admin only");
end
end

function WMDeleteMap(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
		if arg[1] ~= nil then
			if file.Exists("WM-RTS/variants/" .. game.GetMap() .. "[" .. arg[1] .. "].txt") then
				file.Delete("WM-RTS/variants/" .. game.GetMap() .. "[" .. arg[1] .. "].txt")
				ply:PrintMessage(HUD_PRINTTALK, "Deleted feature file WM-RTS/" .. game.GetMap() .. "[" .. arg[1] .. "].txt");
			else
				ply:PrintMessage(HUD_PRINTTALK, "Variant does not exist");
			end
		else
			if file.Exists("WM-RTS/variants/" .. game.GetMap() .. "[0].txt") then
				file.Delete("WM-RTS/variants/" .. game.GetMap() .. "[0].txt")
				ply:PrintMessage(HUD_PRINTTALK, "Deleted feature file WM-RTS/variants/" .. game.GetMap() .. "[0].txt");
			else
				ply:PrintMessage(HUD_PRINTTALK, "Variant does not exist");
			end
		
		end
	else
		ply:PrintMessage(HUD_PRINTCENTER, "That command is admin only");
	end
end

function AdvDupeTime(ply)
ply:SetNWInt("chosenone", 1)
FirstPlayer = 1
if ADSpawnFile ~= nil then
Serialiser.DeserialiseWithHeaders( file.Read(ADSpawnFile), LoadAndPaste, ply, ADSpawnFile, nil )
end
timer.Simple(20, function() WMInitialJoin(ply) end)
timer.Simple(21, function() NoChosenOne(ply) end )
end

function NoChosenOne(ply)
	ply:SetNWInt("chosenone", 0)
	ply:Freeze(false)
end

function LAPCallMapSpawn(ply, cmd, arg)
	if !ply:IsValid() then
		LAPINIParser(arg)
	elseif IsAdminOrSinglePlayer(ply) then
		LAPINIParser(arg)
	end
end

function LAPINIParser(arg)
 local maplist = file.Find("data/WM-RTS/variants/" .. game.GetMap() .. "[*.txt", "GAME")
PrintTable(maplist)
if table.Count(maplist) > 0 || arg ~= nil then
    if arg ~= nil then
    LAPSpawnMapFeatures("data/WM-RTS/variants/"..game.GetMap().."["..arg[1].."].txt", "GAME")
    MapVariant = arg[1]
    return
    end
--    for i=0,20 do  
--        if file.Exists("WM-RTS/" .. game.GetMap() .. "[" ..  i .. "].txt") then
--        choices = choices + 1
--        else
--        break
--        end
--    end
    local maps = file.Find("data/WM-RTS/variants/*.txt","GAME")
    for k,v in pairs (file.Find("data/WM-RTS/variants/*.txt","GAME")) do
    table.insert(maps, v)
    end
    file.Write("/WM-RTS/WMServerMaplist.txt", string.Implode("\n<br>\n", maps ))
    
    if file.Exists("data/WM-RTS/voted-variant.txt", "GAME") && file.Exists("data/WM-RTS/".. game.GetMap() .. "[" .. file.Read("data/WM-RTS/voted-variant.txt","GAME") .. "].txt", "GAME") then
    MapVariant = file.Read("data/WM-RTS/voted-variant.txt","GAME")
    LAPSpawnMapFeatures("data/WM-RTS/variants/" .. MapVariant .. ".txt")
    else
    local rand = math.random(1, table.Count(maplist))
    local mapstring = maplist[rand]
    MapVariant = string.Replace(mapstring, "[", "")
    MapVariant = string.Replace(MapVariant, game.GetMap(), "")
    MapVariant = string.Replace(MapVariant, "].txt", "")
    LAPSpawnMapFeatures("data/WM-RTS/variants/" .. maplist[rand])
    end
end
SetGlobalString("WMVariant", MapVariant)
end

function LAPSpawnMapFeatures(mapstring)
local ini = file.Read(mapstring,"GAME")
local exploded = string.Explode("\n", ini);
--PrintTable(exploded)
local feature = 0
local ResNodes = 0
local CapPoints = 0
local Uplinks = 0
 for k, v in pairs (exploded) do
    if string.find(v, "lap_") == 1 || string.find(v, "prop_") == 1 || string.find(v, "nobuildarea") == 1 then 
    local ent = ents.Create(v);
    if exploded[k+7] == "models/props_buildings/watertower_001c.mdl" then
    --Legacy for old spawnpoints
    ent:SetPos(Vector(exploded[k+1], exploded[k+2], exploded[k+3] + 118))
    else
    ent:SetPos(Vector(exploded[k+1], exploded[k+2], exploded[k+3]))
    end
    ent:SetAngles(Angle(exploded[k+4], exploded[k+6], exploded[k+5]))
    ent:SetModel(exploded[k+7])
        if v == "lap_cappoint" then
        CapPoints = CapPoints + 1
        end
        if v == "lap_resnode"  || v == "lap_commuplink" || string.find(v, "nobuildarea") == 1 || string.find(v, "prop_") == 1 then
        ent.model = exploded[k+7]
            if v == "lap commuplink" then
            Uplinks = Uplinks + 1
            end
        end
        if v == "lap_outpost" || v == "lap_spawnpoint" then
        ent.Team = tonumber(exploded[k+8])
        elseif v == "lap_resnode" then
        ResNodes = ResNodes + 1
        ent.Rez = tonumber(exploded[k+8])
        elseif v == "nobuildarea" then
        ent.NoBuildRadius = tonumber(exploded[k+8])
        end
        ent:Spawn();
        ent:Activate();
                if v == "lap_outpost" || v == "lap_spawnpoint" then
                ent.Built = 2
                end
        if v == "lap_spawner" then
        ent.Skips = tonumber(exploded[k+8])
	    ent.Delay = tonumber(exploded[k+9])
	    ent.SpeedMod = tonumber(exploded[k+10])
	    ent.SFile = exploded[k+11]
	    local cular = string.Explode(" ", exploded[k+11])
	    ent.ColorMod = Vector(cular[1], cular[2], cular[3])
        end
        
        if ent:GetPhysicsObject() ~= nil && ent:GetPhysicsObject():IsValid() then
        ent:GetPhysicsObject():EnableMotion(false)
        end
    elseif string.find(v, "Source/Neo") == 1 then
        for k, v in pairs (ents.FindByClass("func_*")) do
        v:Remove()
        end
        for k, v in pairs (ents.FindByClass("item_*")) do
        v:Remove()
        end
    elseif string.find(v, "ADSpawnFile") == 1 then
    ADSpawnFile = exploded[k+1]
	elseif string.find(v, "wmpurgemap") == 1 then
    for k, v in pairs (ents.FindByClass("prop*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("env*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("johnny_*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("emp*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("johnny_*")) do
v:Remove()
end
elseif string.find(v, "wmclearmap") == 1 then
    for k, v in pairs (ents.FindByClass("lap_*")) do
	v:Remove()
	end
	for k, v in pairs (ents.FindByClass("johnny_*")) do
	v:Remove()
	end
	for k, v in pairs (ents.FindByClass("melon_*")) do
	v:Remove()
	end
    elseif string.find(v, "WM_FreeSpawns") == 1 then
    local num = tonumber(exploded[k+1])
    FreeSpawns = {num,num,num,num,num,num,num}   
    elseif string.find(v, "WM_PlayersPerTeam") == 1 then
    PPT = GetConVarNumber( "WM_PlayersPerTeam", 1 )
    game.ConsoleCommand("WM_PlayersPerTeam ".. exploded[k+1] .. "\n")
    elseif string.find(v, "WM_StartingNRG") == 1 then
    StartingNRG = GetConVarNumber( "WM_StartingNRG", 75000 )
    game.ConsoleCommand("WM_StartingNRG ".. exploded[k+1] .. "\n")
    elseif string.find(v, "WM_RoundTime") == 1 then
    TLTick = exploded[k+1] * 60
    SendTime()
    elseif string.find(v, "SpawnProps") == 1 then
    local tbl = {}
    tbl[1] = exploded[k+1]
    WMPropSpawn(nil, nil, tbl)
    elseif string.find(v,  "Variant Name") == 1 then
    SetGlobalString("WMVariantName", exploded[k+1])
    elseif string.find(v,  "Variant Description") == 1 then
    VariantDescription = tostring(exploded[k+1])
    elseif string.find(v,  "Variant Author") == 1 then
    SetGlobalString("WMVariantAuthor", exploded[k+1])
    elseif string.find(v,  "WM_Fog") == 1 then
    game.ConsoleCommand("wmfogzor ".. exploded[k+1] .. "\n")
    elseif string.find(v, "SpawnMelons") == 1 then
    local tbl = {}
    tbl[1] = exploded[k+1]
    timer.Simple(3, function() WMMassMelonSpawn(nil, nil, tbl) end)
    elseif string.find(v, "WM_RezPerHarvest") == 1 then
    game.ConsoleCommand("WM_RezPerHarvest ".. math.Clamp(exploded[k+1] * GetConVarNumber( "WM_RezPerHarvest", 1000 ), 0, 1000000) .. "\n")
    HarvestMod = exploded[k+1]
    elseif string.find(v, "WM_CappointNRG") ~= nil then
    game.ConsoleCommand("WM_CappointNRG ".. math.Clamp(exploded[k+1] * GetConVarNumber( "WM_CappointNRG", 500 ), 0, 1000000) .. "\n")
    CapMod = exploded[k+1]
    elseif string.find(v, "WM_Melonspeed") == 1 then
    game.ConsoleCommand("WM_Melonspeed ".. math.Clamp(exploded[k+1] * GetConVarNumber( "WM_Melonspeed", 1 ), 0, 1000000) .. "\n")
    SpeedMod = exploded[k+1]
    elseif string.find(v, "WM_ScenarioMode") == 1 then
    SetGlobalInt("WMScenarioMode", tonumber(exploded[k+1]))
        if tonumber(exploded[k+1]) == 1 then
        TLTick = 1
        end
    CreateMTHighScoreTable()
    end
    
 end
 SetGlobalInt("WMCapPoints", CapPoints)
 SetGlobalInt("WMUplinks", Uplinks)
 SetGlobalInt("WMResNodes", ResNodes)
 if GetGlobalInt("WMScenarioMode") == 10 then
 timer.Simple(GetConVarNumber("WM_ScenarioPreGame", 20), function() AssassinTargeting() end)
 end
end

function SendText(ply, text)  
	if ply:IsValid() then
		umsg.Start("Text", ply)  
			 umsg.String("RESET")  
		umsg.End()  
	  
		local parts = math.ceil(string.len(text)/200)  
		for i=1, parts, 1 do  
		   umsg.Start("Text", ply)  
				umsg.String(string.sub(text, 200*(i-1), (200*i)-1))  
		   umsg.End()  
		end  
		   
		umsg.Start("Text", ply)          
			umsg.String("DONE")  
		umsg.End() 
	end
end  

function CreateMTHighScoreTable()
    if file.Exists("data/WM-RTS/wmserverhighscores.txt","GAME") then
        local ini = file.Read("data/WM-RTS/wmserverhighscores.txt","GAME")
        local exploded = string.Explode("\n", ini);
        local success = false
            for k, v in pairs (exploded) do
                if string.find(v, game.GetMap()) ~= nil && string.find(v, MapVariant) ~= nil then
                success = true
                end
            end
        
        if success == false then
            for i=1, 10 do
            table.insert(exploded, "Empty")
            end
            if GetGlobalInt("WMScenarioMode") == 1 then
                for j=1, 10 do
                table.insert(exploded, "0")
                end
            else
                for i=1, 10 do
                table.insert(exploded, "100000000")
                end
            end
            for l=1, 10 do
            table.insert(exploded, "0")
            end
            file.Write("WM-RTS/wmserverhighscores.txt", string.Implode("\n", exploded))
        end
    end
end

function RestoreFlight(ent, dly)
	local entity = ents.GetByIndex(ent:EntIndex())
    if entity:IsValid() && entity:GetPhysicsObject():IsValid() then
		entity.Grav = false
        if entity:GetClass() ~= "gmod_hoverball" && entity:GetClass() ~= "gmod_wire_hoverball" then
			entity:GetPhysicsObject():EnableGravity(false)
			entity.Delay = dly
        else
			entity:GetPhysicsObject():SetMass(dly)
        end
    end
end

function RestoreBombGrav(ent)
	if ent:IsValid() then
		phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableGravity(true)
		end
	end
end

function RestoreSpeed(ent, slimetrail)
	local entity = ents.GetByIndex(ent)
    if entity:IsValid() && entity:GetPhysicsObject():IsValid() && entity.Speed ~= nil then
    entity.Speed = entity.Speed * 2
    slimetrail:Remove()
    end
end

function WMBuoyancy(phys, ratio)
	if ( !phys:IsValid() ) then return end
	phys:SetBuoyancyRatio( ratio )
end

function RestoreFlightHover(ent, max, cur, res)
	local entity = ents.GetByIndex(ent)
    if entity:IsValid() && entity:GetPhysicsObject():IsValid() then
        if cur > (max * 0.6) then
			entity:GetPhysicsObject():SetMass(entity:GetPhysicsObject():GetMass() * 0.6)
        elseif cur <= (max * 0.3) then
			entity:GetPhysicsObject():SetMass(entity:GetPhysicsObject():GetMass() * 2)
        end
		if cur > 0 then
			timer.Simple(1, function() RestoreFlightHover(ent, max, cur - 1, res) end)
		else
			entity:SetVar("AirResistance", res)
		end
    end
end

function SpawnedVehicle(userid, propid )
	if propid:GetClass() == "prop_vehicle_jeep" || propid:GetClass() == "prop_vehicle_jalopy" || propid:GetClass() == "prop_vehicle_airboat" || !InBaseRange(userid, propid:GetPos()) then
		propid:Remove()
	else
		propid:SetCollisionGroup(COLLISION_GROUP_NONE)
		propid:SetGravity(false)
		propid:SetMoveType(MOVETYPE_NOCLIP)
	end
end

function GhostAfterVehicle(ply, vehicle)
	ply:SetMoveType(MOVETYPE_NOCLIP)
	ply:SetCollisionBounds(Vector(0,0,0), Vector(0.01, 0.01, 0.01))
	ply:SetNotSolid(true)
	ply:SetCollisionGroup(COLLISION_GROUP_NONE)
end
hook.Add("PlayerLeaveVehicle", "WMReGhost", GhostAfterVehicle)

function NoSuperVehicles( player, vehicle, role )
	if !(IsAdminOrSinglePlayer(player)) then 
		if vehicle:GetClass() == "prop_vehicle_jeep" || vehicle:GetClass() == "prop_vehicle_jalopy" || vehicle:GetClass() == "prop_vehicle_airboat" then
			return false
		end
	end
end 

hook.Add( "CanPlayerEnterVehicle", "NoSuperVehicles", NoSuperVehicles )

function AdminOnlySweps(ply)
    return IsAdminOrSinglePlayer(ply)
end
hook.Add( "PlayerSpawnSWEP", "AdminOnlySweps", AdminOnlySweps )
hook.Add( "PlayerSpawnSENT", "AdminOnlySENTS3", AdminOnlySweps )

function WMClearMap(ply)
if !ply:IsValid() || IsAdminOrSinglePlayer(ply)then
for k, v in pairs (ents.FindByClass("lap_*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("johnny_*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("melon_*")) do
v:Remove()
end
end

end

function WMPurgeMap(ply)
if !ply:IsValid() || IsAdminOrSinglePlayer(ply) then
for k, v in pairs (ents.FindByClass("prop*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("env*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("johnny_*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("emp*")) do
v:Remove()
end
for k, v in pairs (ents.FindByClass("johnny_*")) do
v:Remove()
end
end

end

function WMWarmup(arg)
	if arg == 1 then
		if GetConVarNumber( "WM_WarmUpTime", 30 ) > 0 then
			game.ConsoleCommand("WM_Pause 1\n" )
			timer.Simple(GetConVarNumber( "WM_WarmUpTime", 30 ), function() WMWarmup(2) end)
		end
	else
		for k, v in pairs (player.GetAll()) do
			v:PrintMessage(HUD_PRINTTALK, "WARMUP TIME IS OVER")
		end
		Msg("Warmup Time over \n")
		game.ConsoleCommand("WM_Pause 0\n")
	end
end

function WMFogOverride(ply, cmd, arg)
if !ply:IsValid() || IsAdminOrSinglePlayer(ply) then
local controllers = 0
for k, v in pairs (ents.FindByClass("env_fog_controller")) do
Msg("Controller!")
controllers = 1
    if arg[1] == 0 then
    v:Fire("TurnOff")
    else
    v:SetKeyValue("fogenable", "true")
v:SetKeyValue("fogstart", "1")
v:SetKeyValue("fogend", arg[1])
v:SetKeyValue("fogcolor", "176 192 202")
v:SetKeyValue("fogcolor", "206 216 222")
v:SetKeyValue("fogmaxdensity", "1")
v:SetKeyValue("fagz", arg[1])
    v:Fire("SetStartDist", "1")
    v:Fire("SetEndDist", arg[1])
    v:Fire("TurnOn")
    end
end
if controllers == 0 then
local fog = ents.Create("env_fog_controller")
fog:SetPos(Vector(0,0,0))
fog:SetKeyValue("fogenable", "true")
fog:SetKeyValue("fogstart", "1")
fog:SetKeyValue("fogend", arg[1])
fog:SetKeyValue("fogcolor", "176 192 202")
fog:SetKeyValue("mindxlevel", "0")
fog:SetKeyValue("targetname", "foggy")
fog:SetKeyValue("fogdir", "176 192 202")
fog:SetKeyValue("fogcolor2", "206 216 222")
fog:SetKeyValue("fogmaxdensity", "1")
fog:SetKeyValue("farz", arg[1])
fog:Spawn()
fog:Activate()
fog:SetKeyValue("fogenable", "true")
fog:SetKeyValue("fogstart", "1")
fog:SetKeyValue("fogend", arg[1])
fog:SetKeyValue("fogcolor", "176 192 202")
fog:SetKeyValue("mindxlevel", "0")
fog:SetKeyValue("targetname", "foggy")
fog:SetKeyValue("fogdir", "176 192 202")
fog:SetKeyValue("fogcolor2", "206 216 222")
fog:SetKeyValue("fogmaxdensity", "1")
fog:SetKeyValue("farz", arg[1])
fog:Fire("SetColor", "60 60 60")
fog:Fire("SetStartDist", "1")
fog:Fire("SetEndDist", arg[1])
fog:Fire("TurnOn")
end
end
end

function ImaShuttingDown()
	local har = GetConVarNumber("WM_RezPerHarvest", 1000) - tonumber(HarvestMod)
	game.ConsoleCommand("WM_RezPerHarvest " .. har .. "\n" )
	local cap = GetConVarNumber("WM_CappointNRG", 500) / tonumber(CapMod)
	game.ConsoleCommand("WM_CappointNRG " .. cap .. "\n" )
	local spe = GetConVarNumber("WM_melonforce", 7) - tonumber(SpeedMod)
	game.ConsoleCommand("WM_Melonforce " .. spe .. "\n" )
	game.ConsoleCommand("WM_PlayersPerTeam " .. GetConVarNumber("WM_DefaultPPT", 2) .. "\n" )
	game.ConsoleCommand("WM_StartingNRG " .. GetConVarNumber("WM_DefaultStartNRG", 75000) .. "\n" )
end
hook.Add( "ShutDown", "shutingdown", ImaShuttingDown ) 
hook.Add( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )

function NoMorePropSpawn(ply, model, propid)
	propid:Remove()
end
hook.Add("PlayerSpawnedRagdoll", "Ragdollstop", NoMorePropSpawn)

function WMTimeLeft(ply, cmd, arg)
	Msg("Minutes Left: " .. TLTick / 60)
end

function WMAdminUnlock(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) || !ply:IsValid() then
		teamslocked[arg[1]] = 0
		ply:PrintMessage(HUD_PRINTTALK, "Team: " .. arg[1] .. " unlocked.")
	end
end
tID = 0

function WMSpawnCheck(ply)
	if ply:IsValid() && !ply:HasWeapon("lap_selector") then
		ply:Give("weapon_physgun")
		ply:Give("lap_selector")
		ply:SelectWeapon("lap_selector")
		ply:Give("gmod_camera")
		ply:Give("gmod_tool")
		timer.Simple(30, function() WMSpawnCheck(ply) end)
	end
end

function WMSetTime(ply, cmd, arg)
	print(ply)
	if (!ply or IsAdminOrSinglePlayer(ply)) then
		TLTick = arg[1]
		MsgAll("Round Time changed to " .. TLTick / 60)
		SendTime()
	end
end

function WMKickTeammate(ply, cmd, arg)
if IsAdminOrSinglePlayer(ply) || ply:GetNetworkedBool("WMCaptain") ~= nil then
local target
for k, v in pairs (team.GetPlayers(ply:Team())) do
if v:GetName() == arg[1] && v:GetName() ~= ply then
    MsgAll(v:GetName() .. " kicked from team " .. v:Team() .. ".")
    v.WMSelections = {}
    v:SetTeam(8)
--    v.WMSelecting = false;
    v.SetSelectionBox = nil;
    v:SetNetworkedBool("WMCaptain", nil)
    v:SetColor(Color(200, 200, 200, 255))
    end
end
else
return false
end
end



function WMTeleport(ply, cmd, arg)
if !ply:KeyDown(IN_DUCK) && !ply:KeyDown(IN_USE) && !ply:KeyDown(IN_SPEED) && !ply:KeyDown(IN_JUMP) && arg[1] == nil then
    if ply.TPRadial == nil then
    ply:ConCommand("+wmteleportradial")
    ply.TPRadial = true
    else
    ply:ConCommand("-wmteleportradial")
    ply.TPRadial = nil
    end
return true    
end

if ply:KeyDown(IN_DUCK) then
ply:ConCommand("WMTPLocation")
return true
end

if ply:KeyDown(IN_USE) || arg[2] == "delete" then

    if ply:KeyDown(IN_USE) then
    WMTPDelete(ply, ply.LastTP[#ply.LastTP])
    else
    WMTPDelete(ply, tonumber(arg[1]))
    end
return true
end


if arg[1] ~= nil || ply:KeyDown(IN_SPEED) then
    if arg[1] == "cycle" || ply:KeyDown(IN_SPEED) then
        if ply.LastTP[1] == nil then
        ply:PrintMessage(HUD_PRINTTALK, "Create a teleport marker first.")
        return false
        end
    WMTPed(ply, ply.LastTP[1])
    table.insert(ply.LastTP, table.remove(ply.LastTP, 1))
    
    elseif ply.TPLocs[1] ~= nil then
    WMTPed(ply, tonumber(arg[1]))
    return true
    end
end

if ply:KeyDown(IN_JUMP) then
local trace = ply:GetEyeTrace()
local angle = ply:GetPos() - trace.HitPos
ply:SetPos(trace.HitPos + angle:GetNormalized()*750)
end
end

function WMTPed(ply, num)
            ply:SnapEyeAngles(ply.TPAngs[num])
            ply:SetPos(ply.TPLocs[num])
            ply:PrintMessage(HUD_PRINTTALK, "Teleported to Position " .. num .. ".")
end

function WMTPDelete(ply, tploc)
Msg("Deleting")
Msg(tploc)
Msg(ply.TPLocs[tploc])
    if ply.TPLocs[tploc] ~= nil then
    Msg("ply.TPLocs[tploc] ~= nil")
        for k,v in pairs (ply.LastTP) do
            if v == tploc then
            table.remove(ply.LastTP, k)
            Msg("fouind it")
            end
        end
        ply.TPLocs[tploc] = nil
        ply.TPAngs[tploc] = nil
    ply:PrintMessage(HUD_PRINTTALK, "Teleported position -" .. tploc .."- deleted.")
    end
end

function WMTPLocation(ply, cmd, arg)
local num
local count = 1
    if arg[1] ~= nil then
    num = tonumber(arg[1])
    else
            if ply.TPLocs[1] ~= nil then
                while num == nil do
                    if ply.TPLocs[count + 1] != nil then
                    count = count + 1
                    else
                    num = count + 1
                    end
                end
            else
            num = 1
            end
    end
ply.TPLocs[num] = ply:GetPos()
ply.TPAngs[num] = ply:EyeAngles()
table.insert(ply.LastTP, num)
    umsg.Start("WMTPMsg", ply)
    umsg.Short( num )
    umsg.End()
end

--Renamed due to conflict, and the fact it seems fail (uses table.merge)
function WMGroupFail(ply, cmd, arg)


	if ply:KeyDown(IN_DUCK) then
	ply:ConCommand("WMSaveGroup")
	return true
	end

	if ply:KeyDown(IN_USE) || arg[2] == "delete" then

		if ply:KeyDown(IN_USE) then
		WMGroupDelete(ply, ply.Groups[ply.LastGroup])
		else
		WMGroupDelete(ply, tonumber(arg[1]))
		end
	return true
	end


	if arg[1] ~= nil then
		WMGroupFailSelect(ply, tonumber(arg[1]))
		return true
	end

	if ply:KeyDown(IN_JUMP) then
	end
end

function WMGroupFailSelect(ply, num)
	if ply:KeyDown(IN_SPEED) then
	table.Merge(ply.WMSelections, ply.Groups[num])
	else
	ply.WMSelections = ply.Groups[num]
	end
end

function WMGroupDelete(ply, tploc)
	Msg(ply.Groups[tploc])
    if ply.Groups[tploc] ~= nil then
		Msg("ply.Groups[tploc] ~= nil")
		for k,v in pairs (ply.Groups[tploc]) do
			local name = ply:EntIndex() .. 555 .. tploc
			if v:IsValid() && v.name ~= nil then
				v.name = nil
			end
		end
        ply.Groups[tploc] = nil
		ply:PrintMessage(HUD_PRINTTALK, "Group -" .. tploc .."- deleted.")
    end
end

function WMSaveGroup(ply, cmd, arg)
	Msg(tonumber(arg[1]))
	local num
	local count = 1
    if arg[1] ~= nil then
		num = tonumber(arg[1])
    else
		if ply.Groups[1] ~= nil then
			while num == nil do
				if ply.Groups[count + 1] != nil then
                    count = count + 1
				else
                    num = count + 1
				end
			end
		else
			num = 1
		end
    end
	Msg(num)
	ply.Groups[num] = ply.WMSelections
	for k,v in pairs (ply.Groups[num]) do
		local name = ply:UniqueID() .. 555 .. num
		if v:IsValid() then
			v[name] = true
		end
	end
    umsg.Start("WMGroupMsg", ply)
    umsg.Short( num )
    umsg.End()
end



function GM:ShowHelp( ply )
    ply:ConCommand("wmhelp")
end

function GM:ShowTeam( ply )
	if ply:GetEyeTrace().Entity.PrintName ~= nil then
		ply:ConCommand("wmencyclopedia " .. ply:GetEyeTrace().Entity.PrintName)
	else
		ply:ConCommand("wmencyclopedia")
	end
end

function GM:ShowSpare1( ply )
    ply:ConCommand("wmshowstats")

end

function GM:ShowSpare2( ply )
    ply:ConCommand("wmmenu")
end

function WMSetFrags()
for k, v in pairs (player.GetAll()) do
v:SetFrags(team.GetScore(v:Team()))
end
timer.Simple(3, function() WMSetFrags() end)
end

function WMSetNextVariant(ply, cmd, arg)
if !ply:IsValid() || IsAdminOrSinglePlayer(ply) then
file.Write("/WM-RTS/voted-variant.txt", arg[1])
end
end

--I BETTER REMOVE THIS BULLSHIT BEFORE RELEASE----
function wmforceinvite(ply, cmd, arg)
	for k, v in pairs (player.GetAll()) do
		if arg[1] == v:GetName() then
			v:ConCommand("wmsendinvite", ply)
		end
	end
end

function WMForceSay(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
		for k,v in pairs (player.GetAll()) do
			if string.find(v:GetName(),arg[1]) ~= nil then
				Msg("Puppet found".. arg[2])
				ply:ConCommand("say", arg[2])
				return
			end
		end
	end
end

function WMTargetID(ply, cmd, arg)
	if IsAdminOrSinglePlayer(ply) then
		tID = arg
	end
end
--I BETTER REMOVE THIS BULLSHIT BEFORE RELEASE---

function WMCoord(ply, cmd, arg)

	local tracez = ply:GetEyeTrace()
	ply:PrintMessage(HUD_PRINTTALK, tracez.HitPos())

end

function WMLod(ply,cmd, arg)
	local hi = ents.Create("water_lod_control")
	hi:SetKeyValue("cheapwaterstartdistance", "100000")
	hi:SetKeyValue("cheapwaterenddistance", "150000")
	hi:SetPos(ply:GetPos())
	hi:Spawn()
	hi:Activate()
end


function WMLod2(ply,cmd, arg)
for k, v in pairs (ents.FindByClass("water_lod_control")) do
--v:SetKeyValue("cheapwaterstartdistance", arg[1])
--v:SetKeyValue("cheapwaterenddistance", arg[2])
v:Remove()
--Fred = v
Msg("Got")
end
end

function WMLod3(ply,cmd, arg)
for k, v in pairs (ents.FindByClass("water_lod_control")) do
v:SetKeyValue("CheapWaterStartDistance", arg[1])
v:SetKeyValue("CheapWaterEndDistance", arg[2])
v:Activate()
Fred = v
Msg("Got")
end
end

concommand.Add("wmeasymode", WMEasyMode);
concommand.Add("wmorder", WMGiveOrder);
concommand.Add("wmg", WMG);
concommand.Add("wmgset", WMGSet);
concommand.Add("wmgselect", WMGSelect);
------------------Back-compability----------------
concommand.Add("wmg1", WMG1);
concommand.Add("wmg2", WMG2);
concommand.Add("wmg3", WMG3);
concommand.Add("wmg4", WMG4);
concommand.Add("wmg5", WMG5);
concommand.Add("wmg6", WMG6);
----------------------------------------------------------
--concommand.Add("+wmselectsend", WMSelectBegin);
--concommand.Add("-wmselectsend", WMSelectEnd);
concommand.Add("wmtypeselect", WMTypeSelect);
concommand.Add("wmstanceselect", WMStanceSelect);
concommand.Add("wmjump", WMJump);
concommand.Add("wmsavemap", WMSaveMap);
concommand.Add("wmspawnmap",  LAPCallMapSpawn);
concommand.Add("wmteamlock", WMTeamLocking);
concommand.Add("wmclearmap", WMClearMap);
concommand.Add("wmpurgemap", WMPurgeMap);
concommand.Add("wmfogzor", WMFogOverride);
concommand.Add("wmtimeleft", WMTimeLeft);
concommand.Add("wmforcesay", WMForceSay);
concommand.Add("wmtargetID", WMTargetID);
concommand.Add("wmdeletemap", WMDeleteMap);
concommand.Add("wmforceunlock", WMAdminUnlock);
concommand.Add("wmsettime", WMSetTime);
concommand.Add("wmteleport", WMTeleport);
concommand.Add("wmtplocation", WMTPLocation);
concommand.Add("wmgroup", WMGroupFail);
concommand.Add("wmsavegroup", WMSaveGroup);
concommand.Add("wmupdatecappoints", MaxMelonUpdate)
concommand.Add("wmupdatemeloncount", MelonCountUpdate);
concommand.Add("wmappendfile", WMAppendVariant);
concommand.Add("wmsendinvite", WMSendInvite)
concommand.Add("wmacceptinvite", WMAcceptInvite)
concommand.Add("wmdeclineinvite", WMDeclineInvite)
concommand.Add("wmforceinvite", wmforceinvite)
concommand.Add("wmsendnrg", WMSendNRG);
concommand.Add("wmcoord", WMCoord)
concommand.Add("wmkickteammate", WMKickTeammate)
concommand.Add("wmnextvariant", WMSetNextVariant)
concommand.Add("wmticker", WMSendTicker)
concommand.Add("wmlod", WMLod)
concommand.Add("wmlod2", WMLod2)
function WMTestzor2()
	Msg("what2")
end
concommand.Add("What", WMTestzor2)
timer.Simple(1, function() LAPINIParser() end)
timer.Simple(1, function() WMWarmup(1) end)
timer.Simple(3, function() WMSetFrags() end)
--timer.Simple(3, IsHolding)
TimeLeft()
if (game.SinglePlayer()) then--Changed SinglePlayer() to game.SinglePlayer()
	game.ConsoleCommand("wm_buildradius 0\n")
	game.ConsoleCommand("wm_toolcost 0\n")
	game.ConsoleCommand("wm_buildtime 0.01\n")
	game.ConsoleCommand("wm_timelimit 9999999\n")
	--game.ConsoleCommand("wm_normalpropspawning 1\n")
	game.ConsoleCommand("wm_propcost 0\n")
	--game.ConsoleCommand("wm_rules 0\n") 
	hook.Remove( "SetPlayerspeed", "Speed", GMSetSpeed)
	hook.Remove( "PlayerLoadout", "WMloadout", Loadout)
	hook.Remove( "CanTool", "lap_usetool", UseTool ); 
	hook.Remove( "PhysgunPickup", "wm_physgunPickup", physgunPickup ); 
	hook.Remove( "GravGunPickupAllowed", "wm_gravgunPickup", physgunPickup ); 
	hook.Remove("PlayerSpawnedProp", "playerSpawnedProp", SpawnedProp) ;
	hook.Remove( "PlayerSpawnedVehicle", "playerSpawnedVehicle", SpawnedVehicle )
end
function WMHealth(ply, cmd, arg)
	ply:GetEyeTrace().Entity:SetMaxHealth(tonumber(arg[2])) 
	ply:GetEyeTrace().Entity:SetHealth(tonumber(arg[1])) 
end
concommand.Add("WMhealth", WMHealth)