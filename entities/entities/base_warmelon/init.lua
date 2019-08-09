include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS("base_anim")

function ENT:Setup ()
	
	BaseClass.Initialize( self )
	
	local dontCount = {
		"lap_spawnpoint",
		"lap_outpost",
		"lap_capfort",
		"johhny_barracks",
		"lap_heavybarracks",
		"lap_launcher",
		"lap_transport"
	}
	
	if (!table.HasValue( dontCount, self:GetClass() )) then
		AddMelonCount( self, self.Team )
	end
	
	if self.Damping == nil then
		self.Damping = 32
	end
    self.Speed = math.Round(self.Speed)
	self.Loltiem = CurTime();
	self.asploded = false;
	self.Maxlol = self.Healthlol;
	self.notflaming = true;
	self.Stance = 0;
	self.Built = 0;
	if self.Move ~= nil && self.TargetVec == nil then
		self.TargetVec = { };
	end
	self.Target = nil;
	self.Warmelon = true;
	self.Entity:SetModel(self.MelonModel);
	self.Entity:PhysicsInit(SOLID_VPHYSICS);
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS);
	self.Entity:SetSolid(SOLID_VPHYSICS);
	if !self.StdMat then
		self.Entity:SetMaterial("models/debug/debugwhite");
	else
		self.Entity:SetMaterial(self.StdMat)
	end
	
	local physics = self.Entity:GetPhysicsObject();
	
	if (physics:IsValid()) then
		physics:Wake();
		physics:SetBuoyancyRatio(0.2)
		physics:EnableGravity(self.Grav);
		if (self.Team == 1) then
			self.Entity:SetColor(Color(125, 0, 0, 255))
		elseif (self.Team == 2) then
		  self.Entity:SetColor(Color(0, 0, 125, 255))
		elseif (self.Team == 3) then
		  self.Entity:SetColor(Color(0, 125, 0, 255))
		elseif (self.Team == 4) then
		  self.Entity:SetColor(Color(125, 125, 0, 255))
		elseif (self.Team == 5) then
		  self.Entity:SetColor(Color(125, 0, 125, 255))
		elseif (self.Team == 6) then
		  self.Entity:SetColor(Color(0, 125, 125, 255))
		elseif (self.Team == 7) then
		  self.Entity:SetColor(Color(100, 100, 100, 255));
		end
	end
end

function ENT:BeforeDeathFunc ()
end

function ENT:OtherThoughts ()
end

function ENT:DoMoves ()

	local leaderrange = -5;
    
	if self.FollowRange == nil then
		self.FollowRange = 50;
	end
    
	if (self.Leader && self.Leader:IsValid()) then
		leaderrange = self.Entity:GetPos():Distance(self.Leader:GetPos())
		if (leaderrange > tonumber(self.FollowRange) && self.TargetVec[2] == nil) then
			self.TargetVec[1] = self.Leader:GetPos();
			self.Orders = true;
		end
	else
		leaderrange = 100000
	end
  
	if self.Stance ~= 0 then
		if self.Stance > 0 && self.Target ~=nil && self.Target:IsValid() && self.Target:GetPos():Distance(self.Entity:GetPos()) < 1500 then
			local traceRes=util.QuickTrace (self.Entity:GetPos(), self.Target:GetPos()-self.Entity:GetPos(), self.Entity);
			if traceRes.Entity == self.Target && !self.Target.asploded then
				if self.Stance == 1 or self.Stance == 2 then
					self:Chase();
				end
			self.Stance = self.Stance * -1
			end
		end
		if self.Stance < 0 && self.Stance > -4 then
			self.Leader = self.Target
			self.Orders = true
			self.TargetVec = {}
			if self.Target == nil then
				self.Target = self.Entity
			end
			if self.Target:IsValid() then
				self.TargetVec[1] = self.Target:GetPos()
			end
            if self.Stance == -1 then
                if self.Entity:GetPos():Distance(self.StartChase) > 1500 || !self.Target:IsValid() then
                    self:GoHome()
                end
            end
            if self.Stance == -2 then
                if !self.Target or self.Entity:GetPos():Distance(self.Target:GetPos()) > 1500 || !self.Target:IsValid() then
                    self:GoHome()
                end
            end
        end
        if self.Stance < -4 && self.StartChase ~= nil && self.Entity:GetPos():Distance(self.StartChase) < 50 then
            self.Stance = self.Stance * -0.2
            self.Leader = self.Leader2
            self.Leader2 = nil
            self.Patrol = self.Patrol2
            self.Patrol2 = nil
        end
    end

    if self.TargetVec ~= nil && self.TargetVec[1] ~= nil then
        local angle1 = self.TargetVec[1] - self.Entity:GetPos();
        if self.Entity:GetPos():Distance(self.TargetVec[1])>self.NoMoveRange && self.Orders then
            self.Entity:GetPhysicsObject():SetDamping(2, 0);
            local blah = math.abs(angle1.x - angle1.y)
            if ((self.Entity:GetVelocity():Length() < self.Speed || self.Grav == false )&& (blah >= 20 || angle1.z < self.Entity:GetPos().z || (self.Marine && self:WaterLevel() > 2))) then
				self.Entity:GetPhysicsObject():ApplyForceCenter(angle1:GetNormalized() * self.Speed);--Might be the cause of the random movement bug
            end
        else
            if self.Patrol == true then
                table.insert(self.TargetVec, table.remove(self.TargetVec, 1))
            else
                table.remove(self.TargetVec, 1)
            end
        
            if self.Leader == nil || leaderrange < self.FollowRange then
                if self.TargetVec[1] == nil then
                    if self.Grav == false then
                        self.Entity:SetVelocity(self.Entity:GetVelocity() * 0.05)
                    end
                    if self.Entity:GetPhysicsObject():IsValid() then
                        self.Entity:GetPhysicsObject():SetDamping(2, 0);
                    end
                    self.Orders = false;
                end
            end
        end
    end
end

function ENT:Chase()
    self.Patrol2 = self.Patrol
    self.TargetVec2 = {}
    self.TargetVec2 = table.Copy(self.TargetVec)
    self.Leader2 = self.Leader
    self.StartChase = self.Entity:GetPos()
end

function ENT:GoHome()
    self.TargetVec = {}
    self.TargetVec = table.Copy(self.TargetVec2)
    self.TargetVec2 = {}
    table.insert(self.TargetVec, 1, self.StartChase)

    --if there's a valid leader here they will NOT go back to their start location, they will go to the leader.
    self.Orders = true
    self.Stance = self.Stance * 5
end

function ENT:DoAttacks ()
    if GetConVarNumber("WM_Pause", 0) ~= 1 && self.HoldFire ~= 1 then
        if self.Target == nil || !self.Target:IsValid() || !(self.Target.Team ~= self.Team) then
            self:TargetSearch();
            return
        end
        local traceRes=util.QuickTrace (self.Entity:GetPos(), self.Target:GetPos()-self.Entity:GetPos(), self.Entity);
        --Checking that the target is still in range, and that we still have LOS.
        local dist = self.Target:GetPos():Distance(self.Entity:GetPos())
        if traceRes.Entity == self.Target && !self.Target.asploded && dist < self.FiringRange && dist > self.MinRange then
            self:Attack();
        else
            self:TargetSearch();
        end
    end
end


function ENT:Lolthink ()
	if self.asploded or GetConVarNumber("WM_Pause", 1) == 1 then return end
end

function ENT:Think ()
	if (self.Healthlol ~= nil && self.Healthlol <= 0 && self.asploded ~= nil && !self.asploded) then
		self:Explode()
	end
	if not (self.asploded or GetConVarNumber("WM_Pause", 1) == 1) then
		if (self.Loltiem == nil) then
			print("loltiem is nil on entity " .. tostring(self))
			return
		end -- just to get rid of error spam
    	if (CurTime()>self.Loltiem) then
    		self.Loltiem = CurTime()+self.Delay;
            if self.Built == 0 then
            	self.Healthlol = 1
            	local col = self.Entity:GetColor()
            	self.maxA = col.a
            	if self.BuildModifier == nil then
            	    self.BuildModifier = 1
                end
                self.Buildtime = (self.Maxlol - 1) / (6 / GetConVarNumber("WM_BuildTime", 1) * self.BuildModifier * self.Delay)
                self.CurBuildtime = 0
                self.Built = 1
            end
            if self.Built == 1 then
				if self.CurBuildtime < self.Buildtime then
					self.CurBuildtime = self.CurBuildtime + 1
					local percent = math.floor(self.CurBuildtime / self.Buildtime * 100)
					if percent > 100 then
						percent = 100
					end
					local hpinc = self.Maxlol / self.Buildtime
					local col = self.Entity:GetColor();
					self.Entity:SetColor(Color(col.r,col.g,col.b, 50 + ((self.maxA - 40) / percent)))
					self.Healthlol = self.Maxlol * (percent / 100)
					self:SetNWInt("WMTipV", percent * -1)
					if self.Healthlol < self.Maxlol then
						self.Healthlol = self.Healthlol + hpinc
					else
						self.Healthlol = self.Maxlol
					end
					if (self.Healthlol > self.Maxlol / 5 && self.trail) then
						self.trail:Remove();
						self.trail = nil;
					end
				else
					local col = self.Entity:GetColor();
					self.Entity:SetColor(Color(col.r,col.g,col.b, self.maxA))
					self.maxA = nil
					self.Built = 2
					self.Buildtime = nil
					self:SetNWInt("WMTipV", 0)
					self.CurBuildtime = nil
					self.BuildModifier = nil
					if self.Healthlol > self.Maxlol then
						self.Healthlol = self.Maxlol
					end
				end
            end 
            if self.Built == 2 then
				if self.FiringRange ~= nil && self.FiringRange > 0 then
					self:DoAttacks();
                end
                self:OtherThoughts();
            end		
    		if (self:WaterLevel() > 2 ) then
				local drowntime = GetConVarNumber( "WM_Drowntime", 10 );
    			if (self.Marine) then
    			
				elseif ( drowntime == 0) then
    			
				else
    			    if self.Move ~= 1 then
						drowntime = drowntime * 3
					end
    				self.Healthlol = self.Healthlol - self.Maxlol/drowntime*self.Delay - 1;
    			end
			end
    	end
	end
    		if self.Move ~= nil && self.Built == 2 then
				self:DoMoves();
				self.Entity:NextThink(CurTime());
    		else
				self.Entity:NextThink(CurTime()+self.Delay);
    		end
	return true;
end

function ENT:TargetSearch()
	if self.asploded then return end
	if GetConVarNumber("WM_Pause", 1) == 1 then return end
--	local entz = ents.FindByClass("info_target");
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon then

			if (v.Team ~= self.Team && v.asploded ~= true) then
			local dist = v:GetPos():Distance(self.Entity:GetPos());
			if dist > self.MinRange then
				local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
				if traceRes.Entity == v then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					  self.Target = v;
					  break;
					end
                  else
					self.Target = v;
					break;
				  end
				end
			end
			end
	end
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
        v:SetNWInt("nrg", v:GetNWInt("nrg") + (ModdedBounty / team.NumPlayers(dmgerteam)) )
        end
	end
	if GetConVarNumber("WM_BountyModifier", 0.5 ) ~= 0 then
        	           local UnitBounty = self.Cost * GetConVarNumber("WM_BountyModifier", 0.5 )
        	           --chaos cannon screws this part good. fix
					   
					   --[[ Eventually the chaos cannon should be re-made to have it set a berzerk flag or something on the melons
					   and in the targetting and firing part of the melons code just make it skip Friend-or-Foe stuff when that flag is enabled
						That would fix this and future cases when performing checks based on teams. -|DK|2Matias]]
					   
                        --if TeamBounty[self.Team] > 0 then
						if (self.Team > 0 && TeamBounty[self.Team] > 0) then--Quick fix
							local ModdedBounty
                            --if TeamBounty[self.Team] - UnitBounty >=0 then
							if (self.Team > 0 && TeamBounty[self.Team] >= 0) then--Quick fix
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

function ENT:OnRemove()
constraint.RemoveAll(self.Entity)
if self.Team ~= nil && self.Team > 0 && self.Team <= 6 then
SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") - 1)
end
if self.Sound ~= nil then
self.Sound:Stop()
end

if self.sound ~= nil then
self.sound:Stop()
end

end

function ENT:Explode()
	local expl=ents.Create("env_explosion")
		self:BeforeDeathFunc();
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl.Team = self.Team
		if self.Built == 2 then
		expl:SetKeyValue("iMagnitude", self.DeathMagnitude);
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius);
		elseif self.Buildtime ~= nil then
		expl:SetKeyValue("iMagnitude", self.DeathMagnitude * (self.CurBuildtime / self.Buildtime));
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius * (self.CurBuildtime / self.Buildtime));
		else
		expl:SetKeyValue("iMagnitude", self.DeathMagnitude);
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius);
		end
		expl:Spawn();
		expl:Activate();
		expl:Fire("explode", "", 0);
		expl:Fire("kill","",0);
		self.asploded = true;
	constraint.RemoveAll (self.Entity);
	self.Entity:SetColor(Color(0, 0, 0, 255));
	self.Entity:Fire ("kill", "", 3);
end