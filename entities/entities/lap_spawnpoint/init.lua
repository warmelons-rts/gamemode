include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 1000;
ENT.DeathRadius = 600;
ENT.DeathMagnitude = 75;
ENT.MovingForce = 0;
ENT.Speed = 0
ENT.MinRange = 0;
ENT.MelonModel = "addons/wmm/models/wmm/spawnpoint.mdl"

function ENT:Initialize()
self.Grav = true
self:Setup();
self.LastAttacker = nil
self.Move = false
self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/black"))
self.StdMat = "addons/wmm/materials/wmm/black"
self.BuildModifier = 1.5
if self.Cost == nil then 
self.Cost = 50000 * GetConVarNumber( "WM_toolcost", 1 )
end
    local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100000)
		phys:EnableMotion(false)
	end
	if (self.Team == 1) then
		self.Entity:SetColor(Color(255, 0, 0, 255));
	end
	if (self.Team == 2) then
		self.Entity:SetColor(Color(0, 0, 255, 255));
	end
	if (self.Team == 3) then
		self.Entity:SetColor(Color(0, 255, 0, 255));
	end
	if (self.Team == 4) then
		self.Entity:SetColor(Color(255, 255, 0, 255));
	end
	if (self.Team == 5) then
	self.Entity:SetColor(Color(255, 0, 255, 255));
	end
	if (self.Team == 6) then
	self.Entity:SetColor(Color(0, 255, 255, 255));
	end
self:SetNWInt("WMMaxHealth", math.floor(self.Maxlol))
self:SetNWInt("WMHealth", math.floor(self.Healthlol))
end

function ENT:OtherThoughts()

for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 50)) do
    if v ~= self.Entity && v.Warmelon then
    v:SetMaterial("models/alyx/emptool_glow")
    timer.Simple(1, SpawnTouchCheck, v)
    if v:GetClass() == "melon_baseprop" then
    v.health = v.health - (v.maxhealth / 5)
    end
    v:TakeDamage(5)
    end
end

if self:GetNWInt("WMHealth") ~= self.Healthlol then
self:SetNWInt("WMHealth", math.floor(self.Healthlol))
end
if !self.notflaming && self.Healthlol > self.Maxlol/5 then
self.trail2:Remove()
self.trail2 = nil
self.trail3:Remove()
self.trail3 = nil
self.notflaming = true
end


self.Entity:SetNWInt("WMBuilding" , math.floor(self.Healthlol))
	self.Entity:NextThink(CurTime()+self.Delay);
return true
end

function ENT:OnRemove()
    if GetGlobalInt("WMScenarioMode") == 1 || GetGlobalInt("WMScenarioMode") == 2 then
    WMCheckHighScores()
    else
        if GetGlobalInt("WM_ScenarioMode") == 13 then
            if self.Team == WMPhantomTeam && VictoryMode == 0 then
            WMSendPhantomMsg(2)
            VictoryMode = 1
            Msg("Innocents have destroyed the Phantom, Team " .. WMPhantomTeam .. ".")
            timer.Simple(15, WMLoadNextMap)
            else
            
    
                local TeamList = {}
                for k,v in pairs (entsFindByClass("lap_spawnpoint")) do
                    if !table.HasValue(TeamList, self.Team) then
                    table.Insert(TeamList, self.Team)
                    end
                end
                if #TeamList == 1 then
                    if VictoryMode == 0 then
                    VictoryMode = 1
                    Msg("The Phantom, team " .. WMPhantomTeam .. ", has won the match")
                    WMSendPhantomMsg(3)
                    timer.Simple(4, WMWin, WMPhantomTeam)
                    timer.Simple(15, WMLoadNextMap)
                    end
                else
                WMPhantomDiscount = WMPhantomDiscount + GetConVarNumber("WM_PhantomDiscountPerTeam", 0.15)
                WMSendPhantomMsg(1)
                end
            end
        end
        if GetConVarNumber("WM_SpawnPointsEssential", 1) then
        local anyleft = false
            for k, v in pairs (ents.FindByClass("lap_spawnpoint")) do
                if v.Team == self.Team then
                anyleft = true
                end    
            end
            
            if anyleft == false then
            
                for k, v in pairs (ents.GetAll()) do
                    if v.WarMelon && v.Team == self.Team then
                    v:TakeDamage(10000000, self.LastAttacker.Team, self.LastAttacker.Team)
                    end
                end
            end
        end
    timer.Simple(2, WMDomination)
    end
end

function ENT:OnTakeDamage (dmginfo)
    self.LastAttacker = dmginfo:GetInflictor()
	self.Entity:TakePhysicsDamage (dmginfo);
	self.Healthlol = self.Healthlol - dmginfo:GetDamage();
	self:SetNWInt("WMHealth", math.floor(self.Healthlol))
	if (self.Healthlol < 1 && !self.asploded) then
	if dmginfo:GetInflictor().Team ~= nil && GetConVarNumber("WM_KingoftheHill", 0) == 0 then
	local dmgerteam = dmginfo:GetInflictor().Team
	if dmgerteam ~= nil && GetConVarNumber("WM_KingoftheHill", 0) == 0 then
    	if self.Cost == nil then
    	self.Cost = 100
    	end
        team.SetScore(self.Team, team.GetScore(self.Team) - (self.Cost * GetConVarNumber("WM_ScoreDeathPenalty", 0.5)))
        	   if dmgerteam == self.Team then
        	       local pointmod = 1
            	   if GetConVarNumber("WM_ScenarioMode", 10) == 4 && self.Team ~= TeamTargets[dmgerteam] then
                   pointmod = GetConVarNumber("WM_AssassinPenalty", 0.6)             
            	   end
            	   team.SetScore(dmgerteam, team.GetScore(dmgerteam) + (self.Cost * pointmod ))
            	    if GetConVarNumber("WM_ScoreLimit", 0) > 0 && team.GetScore(dmgerteam) > GetConVarNumber("WM_ScoreLimit", 0) then
                	ScoreVictory()
                	end
        	   end
	end
	if GetConVarNumber("WM_GlobalBounty", 0) ~= 0 then
	local ModdedBounty = self.Cost * GetConVarNumber("WM_GlobalBounty", 0)
        for k,v in pairs (team.GetPlayers(dmgerteam)) do
        WMSendCost(v, (ModdedBounty / team.NumPlayers(dmgerteam)) * -1, false)
        v:SetNWInt("nrg", v:GetNWInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
        end
	end
	if GetConVarNumber("WM_BountyModifier", 0.5 ) ~= 0 then
        	           local UnitBounty = self.Cost * GetConVarNumber("WM_BountyModifier", 0.5 )
                        if TeamBounty[self.Team] > 0 then
                        local ModdedBounty
                            if TeamBounty[self.Team] - UnitBounty >=0 then
                            ModdedBounty = UnitBounty
                            else
                            ModdedBounty = math.abs(0 - UnitBounty)
                            end
                                for k,v in pairs (team.GetPlayers(dmgerteam)) do
                                WMSendCost(v, (ModdedBounty / team.NumPlayers(dmgerteam)) * -1, false)
                                v:SetNWInt("nrg", v:GetNWInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
                                end
                        end
    end
	end
	local expl=ents.Create("env_explosion")
		self:BeforeDeathFunc();
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl:SetKeyValue("iMagnitude",self.DeathMagnitude);
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius);
		expl:Spawn();
		expl:Activate();
		expl:Fire("explode", "", 0);
		expl:Fire("kill","",0);
		self.asploded = true;
		constraint.RemoveAll (self.Entity);
		self.Entity:SetColor(Color(0, 0, 0, 255));
		self.Entity:Fire ("kill", "", 3);
	end
	if self.Healthlol < self.Maxlol/5 && self.notflaming then
		self.trail = ents.Create("env_fire_trail");
		self.trail:SetPos (self.Entity:GetPos()+ Vector(35,-20,98));
		self.trail:Spawn();
		self.trail:Activate();
		self.Entity:DeleteOnRemove(self.trail);
		self.trail:SetParent(self.Entity);
		self.trail2 = ents.Create("env_fire_trail");
		self.trail2:SetPos (self.Entity:GetPos()+ Vector(0,40,90));
		self.trail2:Spawn();
		self.trail2:Activate();
		self.Entity:DeleteOnRemove(self.trail);
		self.trail2:SetParent(self.Entity);
		self.trail3 = ents.Create("env_fire_trail");
		self.trail3:SetPos (self.Entity:GetPos()+ Vector(-45,-25,80));
		self.trail3:Spawn();
		self.trail3:Activate();
		self.Entity:DeleteOnRemove(self.trail);
		self.trail3:SetParent(self.Entity);
		self.notflaming = false;
	end
end

function ENT:StartTouch(ent)
if WMPause == true then return end
		if ent:IsValid() && ent:GetClass() == "lap_harvester" then
		  if ent.Team == self.Team then
		    if ent.Full == 1 then
            ent.Full = 0
                if ent.Stance == 3 then
                ent.TargetVec = {}
                end
            local winners = 0
              for x, y in pairs(player.GetAll()) do
    		      if (y:Team() == self.Team) then
    		      winners = winners + 1;
    		      end 
    	      end
            	for x, y in pairs(player.GetAll()) do
                	 if (y:Team() == self.Team) then
                     local cost = (GetConVarNumber( "WM_RezPerHarvest", 2500 ) / winners)
                     if y.Move == 0 then cost = cost * 2 end
                	 y:SetNWInt( "nrg", y:GetNWInt( "nrg" ) + cost)
                	 --local message = "Your NRG:" .. v:GetNWInt( "nrg" ) .. " Income: " .. cost
                	 --v:PrintMessage(HUD_PRINTTALK, message)
                	 end
            	end
            end
	      end
	    end
end

