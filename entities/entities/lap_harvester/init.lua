include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 120;
ENT.FiringRange = 0;
ENT.NoMoveRange = 25;
ENT.MinRange = 0;
ENT.Speed = 60 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 10;
ENT.MovingForce = 85 * GetConVarNumber( "WM_Melonforce", 7);
ENT.MelonModel = "models/Combine_Helicopter/helicopter_bomb01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Full = 0;
	if self.S == 3 then
		self.Stance = 3
		self.S = nil
	end
	self.Marine = true
	
	local r=self.Entity:BoundingRadius()/2;
    self:PhysicsInitSphere(r);
    self:SetCollisionBounds(Vector(-r,-r,-r),Vector(r,r,r));
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	local physics = self:GetPhysicsObject();
    if (physics:IsValid()) then
        physics:Wake();
    end
end

function ENT:TargetSearch()
return
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
return
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
	--if (self:WaterLevel() > 0 ) then
    	--local drowntime = GetConVarNumber( "WM_Drowntime", 10 );
    --	if ( drowntime == 0) then
    --	else
    	--	self.Healthlol = self.Healthlol - self.Maxlol/drowntime*self.Delay - 1
    --	end
    --end
	if self.Move == true && self.Stance == 3 && self.TargetVec[1] == nil then
		if self.Full == 1 then
			local closest = 100000
			local curclosest = 0
			for k, v in pairs (ents.FindByClass("lap_spawnpoint")) do
				local dist = v:GetPos():Distance(self.Entity:GetPos())
				if v.Team == self.Team && self.Built == 2 && dist < closest then
					curclosest = v:GetPos()
					closest = dist
				end
			end
			for k, v in pairs (ents.FindByClass("lap_outpost")) do
				local dist = v:GetPos():Distance(self.Entity:GetPos())
				if v.Team == self.Team && self.Built == 2 && dist < closest then
					curclosest = v:GetPos()
					closest = dist
				end
			end
			if curclosest ~= 0 then
				self.TargetVec[1] = curclosest
				self.Orders = true
			end
		else
			local closest = 100000
			for k, v in pairs (ents.FindByClass("lap_resnode")) do
				local dist = v:GetPos():Distance(self.Entity:GetPos())
				if dist < closest then
					closest = dist
					curclosest = v:GetPos()
				end
			end
			if curclosest ~= 0 then
				self.TargetVec[1] = curclosest
				self.Orders = true
			end
		end
	end
	if self.Full == 1 then
		self.Entity:SetMaterial("brick/brick_model")
	else
		self.Entity:SetMaterial("models/debug/debugwhite")
	end
end


function ENT:OnTakeDamage (dmginfo)

	self.Entity:TakePhysicsDamage (dmginfo);
	self.Healthlol = self.Healthlol - dmginfo:GetDamage();
	if (self.Healthlol <= 0 && !self.asploded) then
	local dmgerteam = dmginfo:GetInflictor().Team
	    if self.Cost == nil then
    	self.Cost = 100
    	end
	if dmgerteam ~= nil && GetConVarNumber("WM_KingoftheHill", 0) == 0 then
        team.SetScore(self.Team, team.GetScore(self.Team) - (self.Cost * GetConVarNumber("WM_ScoreDeathPenalty", 0.5)))
        	   if dmgerteam ~= self.Team then
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
        v:SetNetworkedInt("nrg", v:GetNetworkedInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
        end
	end
	if GetConVarNumber("WM_BountyModifier", 0.5 ) ~= 0 then
        	           local UnitBounty = self.Cost * GetConVarNumber("WM_BountyModifier", 0.5 )
        	           --chaos cannon screws this part good. fix
                        if TeamBounty[self.Team] > 0 then
                        local ModdedBounty
                            if TeamBounty[self.Team] - UnitBounty >=0 then
                            ModdedBounty = UnitBounty
                            else
                            ModdedBounty = math.abs(0 - UnitBounty)
                            end
                                for k,v in pairs (team.GetPlayers(dmgerteam)) do
                                WMSendCost(v, (ModdedBounty / team.NumPlayers(dmgerteam)) * -1, false)
                                v:SetNetworkedInt("nrg", v:GetNetworkedInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
                                end
                        end
    end
	self:Explode()
	end
	if self.Healthlol < self.Maxlol/5 && self.notflaming then
		self.trail = ents.Create("env_fire_trail");
		self.trail:SetPos (self.Entity:GetPos());
		self.trail:Spawn();
		self.trail:Activate();
		self.Entity:DeleteOnRemove(self.trail);
		self.trail:SetParent(self.Entity);
	end
end


--function ENT:PhysicsCollide( data )
--if (data.HitEntity:IsWorld() ) then
--local Pos1 = data.HitPos + data.HitNormal + Vector(0, 0, -0.82)
--local Pos2 = data.HitPos - data.HitNormal 

--util.Decal("Light", Pos2, Pos1) 

-- end
--end