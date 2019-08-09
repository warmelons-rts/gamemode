include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 0.5;
ENT.Healthlol = 20;
ENT.FiringRange = 115;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.Speed = 80 * GetConVarNumber( "WM_Melonspeed", 1)
ENT.DeathRadius = 175;
ENT.DeathMagnitude = 50;
ENT.MovingForce = 30  * GetConVarNumber( "WM_Melonforce", 12);
--ENT.MelonModel = "models/props_phx/misc/soccerball.mdl";
ENT.MelonModel = "models/props_phx/misc/soccerball.mdl"
-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()

	if !self.Grav then
	self.MelonModel = "models/props_phx/ww2bomb.mdl"
	self.StdMat = ""
	end
	self:Setup();
	if self.damping == nil then
	self.damping = 0
	end
	if self.Multiplier == nil then
	self.Multiplier = 1
	end
local phys = self.Entity:GetPhysicsObject()	
	if self.Mine == 1 then
	self.Entity:SetColor(Color(255,255,255,60))
	self.Healthlol = 50
	self.Maxlol = 50
	self.Move = false
	self.Warmelon = nil
	elseif self.Grav then
	self.StdMat = "models/weapons/v_slam/new light1"
	self.Entity:SetMaterial(self.StdMat)
	end
	
	if self.Mine == 2 then
	local Col = self.Entity:GetColor()
	self.Entity:SetColor(Color(Col.r/1.75,Col.g/1.75,Col.b/1.75,255))
	end
	
    if self.Payload == 2 then
    self.DeathMagnitude = self.DeathMagnitude / 3
    self.DeathRadius = self.DeathRadius / 3
    elseif self.Payload == 4 then
    self.DeathMagnitude = 2
    self.DeathRadius = 350
    end	

--timer.Simple(0.2, function(phys,ent) phys:Wake() end, phys, self)
if self.Grav == true then


	if phys:IsValid() then
	--timer.Simple(0.1, function(phys,ent) if phys:IsValid() then phys:EnableDrag(false) end end, phys, self)
	--timer.Simple(0, function(ent) if ent:IsValid() then local phys = ent:GetPhysicsObject(); if phys:IsValid() then construct.SetPhysProp( nil, ent, 0, nil,  { GravityToggle = true, Material = "metal" }); phys:SetBuoyancyRatio(0.175); phys:EnableDrag(false); phys:EnableMotion(true); phys:SetDamping(self.damping,0) end end end, self.Entity)
	timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then construct.SetPhysProp( nil, self, 0, nil,  { GravityToggle = true, Material = "metal" }); phys:SetBuoyancyRatio(0.175); phys:EnableDrag(false); phys:EnableMotion(true); phys:SetDamping(self.damping,0) end end end, self.Entity)
	--timer.Simple(GetConVarNumber("WM_Test1") , function(ent) if ent:IsValid() then local phys = ent:GetPhysicsObject(); if phys:IsValid() then construct.SetPhysProp( nil, ent, 0, nil,  { GravityToggle = true, Material = "metal" });phys:SetDamping(0,0) end end end, self.Entity)
	--timer.Simple(1, function(ent) local vel = ent:GetPhysicsObject():GetVelocity(); local vel2 = math.abs(vel.x) + math.abs(vel.y); local vel2 = (2000- vel2); Msg("RAWR:" .. vel2) end, self.Entity)
	end
else
		
	if phys:IsValid() then
	--timer.Simple(0, function(ent) if ent:IsValid() then local phys = ent:GetPhysicsObject(); if phys:IsValid() then construct.SetPhysProp( nil, ent, 0, nil,  { GravityToggle = true, Material = "metal" }); phys:SetBuoyancyRatio(0.175) end end end, self.Entity)
	timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then construct.SetPhysProp( nil, self, 0, nil,  { GravityToggle = true, Material = "metal" }); phys:SetBuoyancyRatio(0.175) end end end, self.Entity)
	phys:SetBuoyancyRatio(0.16)
	phys:Wake()
	end
self.Marine = true
self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
end
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
self.Healthlol = 0;
end

function ENT:MissileTrail()
	if self.Weld && self.Weld:IsValid() then
		self.Weld:Remove()
		self.Weld = nil
	end
	
	self.trail5 = ents.Create("env_smoketrail");
		self.trail5:SetPos (self.Entity:GetPos());
		self.trail5:SetKeyValue("spawnrate", 15)
		self.trail5:SetKeyValue("startsize", 25)
		self.trail5:SetKeyValue("endsize", 50)
		self.trail5:SetKeyValue("startcolor", "15 15 15")
		self.trail5:Spawn();
		self.trail5:Activate();
		self.Entity:DeleteOnRemove(self.trail5);
		self.trail5:SetParent(self.Entity);
	
	self.Sound = CreateSound(self.Entity, "weapons/rpg/rocket1.wav")
	self.Sound:PlayEx(80, 200)
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableGravity(false)
		phys:Wake()
	end
end

function ENT:RemoveMissileTrail()
	self.Sound:Stop()
	self.trail5:Remove()
	self.trail5 = nil
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableGravity(true)
		phys:EnableDrag(false)
		phys:Wake()   	
	end
end

function ENT:DoAttacks ()
	if GetConVarNumber( "WM_Pause", 0 ) ~= 1 && self.HoldFire ~= 1 then
		if self.Target == nil || !self.Target:IsValid() || self.Target.Team == self.Team then
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

function ENT:TargetSearch ()
	if self.asploded then return end
	if GetConVarNumber("WM_Pause", 1) == 1 then return end
--	local entz = ents.FindByClass("info_target");
	for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)) do
		if v.Warmelon && (self.DetonateOn == 0 || (v.Delay && self.DetonateOn == 1) || (!v.Delay && self.DetonateOn == 2)) then
    
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

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
	if GetConVarNumber( "WM_Pause", 0) == 1 then return end
	if self.fuelleft ~= nil then
		if self.fuelleft > 0 then
			if self.TargetVec[1] ~= nil then
				if !self.trail5 then
					self:MissileTrail()
				end
				self.fuelleft = self.fuelleft - self.Delay
			elseif self.trail5 then
				self:RemoveMissileTrail()
			end
		elseif self.trail5 then
			self:RemoveMissileTrail()
			self.Marine = false
		end
	end

    if self.Grav == false && self.fuelleft == nil && self.TargetVec[1] ~= nil then 
        if self.HoldFire ~= 1 then
			self.Move = true
			self.fuelleft = 5
			self:MissileTrail()
        else
			self.Move = false
        end
    end

    if self.Stance == 3 then
		self.Healthlol = 0;
    end

	if self.Mine == 1 then
		if self.asploded then return end
		local entz = ents.FindInSphere(self.Entity:GetPos(), 75);
    	for k, v in pairs(entz) do
    		if v.Warmelon && v.Team ~= self.Team && v.asploded ~= true then
    			self.Healthlol = 0;
    		end
    	end
	end
end

function ENT:BeforeDeathFunc()
    if self.Payload == 2 then
        for i=1, 3 do
        expl=ents.Create("lap_bomblet")
        local angle = self.Entity:GetVelocity():GetNormalized()*360
   		expl:SetPos(self.Entity:GetPos()+angle:GetNormalized()*10);
		expl:SetOwner(self.Entity);
		expl.Team = self.Team;
		expl:Spawn();
		expl:Activate();
		expl:GetPhysicsObject():SetVelocity(angle:GetNormalized()*(self.Entity:GetVelocity():Length()) * 2);
		end
    end

end

function ENT:Explode()

    if self.Payload ~= 3 then
    
    	local expl=ents.Create("env_explosion")
    		self:BeforeDeathFunc();
    		expl:SetPos(self.Entity:GetPos());
    		expl:SetOwner(self.Entity);
    		expl.Team = self.Team
    		if self.Built == 2 then
    		expl:SetKeyValue("iMagnitude", self.DeathMagnitude * self.Multiplier);
    		expl:SetKeyValue("iRadiusOverride", self.DeathRadius * self.Multiplier);
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
    	constraint.RemoveAll (self.Entity);
    	--self.Entity:SetColor (0, 0, 0, 255);
    else
		local effectdata = EffectData()
    		effectdata:SetStart( self.Entity:GetPos() )
    		effectdata:SetOrigin( self.Entity:GetPos() )
    		effectdata:SetScale( 100 )
    	util.Effect( "AntlionGib", effectdata )
		
    	for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 128)) do
			if v.Warmelon && self.Speed ~= nil then
				local par = v
				local target = v:EntIndex()
				local slimetrail = util.SpriteTrail( par, 0, Color(50,255,0), true, 25, 35, 0.51, 1/(15+1)*0.5, "trails/plasma.vmt" )
				timer.Simple(9 + (self.Multiplier * 2.5), function() RestoreSpeed(target, slimetrail) end)
				par.Speed = par.Speed / (1 + self.Multiplier)
			end
		end
        self.Entity:EmitSound("npc/antlion_grub/squashed.wav", 200, 70)  
            
    end
    
    if self.Payload == 4 then
        for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 250 + (100 * self.Multiplier))) do
            
			if v.Warmelon then
                local target = v:EntIndex()
                if v.Grav ~= nil && v.Grav == false && v.ZVelocity == nil && math.Rand(0,1) < (0.3 + 0.1 * self.Multiplier) then
					timer.Simple(15, RestoreFlight, target, v.Delay)
                	if v:GetPhysicsObject():IsValid() then
						v.Grav = true
						v.Delay = 16
						v:GetPhysicsObject():EnableGravity(true)
                    end
            	elseif v:GetClass() == "gmod_hoverball" && v:GetPhysicsObject():GetMass() > 15 then
					v:GetPhysicsObject():SetMass(v:GetPhysicsObject():GetMass() - 15)
                elseif v:GetClass() == "gmod_wire_hoverball" && v.strength > 0.1 then
					v.strength = v.strength - 0.1
            	end
            end
			
        end
    end
    
	self.asploded = true;
	if self.Trail then
		self.Trail:Fire ("kill", "", 1.5);
	end
	
	self.Entity:Remove()
end

--function ENT:PhysicsUpdate(phys)
--Msg("working")
--    phys:SetVelocity( self.Entity:GetForward() * 100 )
--end

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
				if !self.Target:IsValid() || self.Entity:GetPos():Distance(self.StartChase) > 1500 then
					self:GoHome()
				end
			end
			if self.Stance == -2 then
				if !self.Target:IsValid() || self.Entity:GetPos():Distance(self.Target:GetPos()) > 1500 then
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
			--self.Entity:GetPhysicsObject():SetDamping(2, 0);
			--local blah = math.abs(angle1.x - angle1.y)
			--if ((self.Entity:GetVelocity():Length() < self.Speed || self.Grav == false )&& (blah >= 20 || angle1.z < self.Entity:GetPos().z || (self.Marine && self:WaterLevel() > 2))) then
				--self.Entity:GetPhysicsObject():ApplyForceCenter (angle1:GetNormalized() * self.MovingForce);
			--end
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


function ENT:PhysicsUpdate(phys, deltatime)
	if self.Fired then
		local vel = phys:GetVelocity()
		local shit = math.abs(vel.x) + math.abs(vel.y)
		if shit < 300 then
			phys:SetDamping(0,0)
		end
	end
	
	if self.Grav == false then
		local phys = self.Entity:GetPhysicsObject()
		local posi = self.Entity:GetPos()
		local pos2
		if self.TargetVec[1] ~= nil then
			pos2 = self.TargetVec[1]
			phys:Wake()
			local t={
				secondstoarrive = 0.1,
				pos = pos2,
				angle = self.Entity:GetVelocity():Angle(),
				maxangular = 10,
				maxangulardamp = 7,
				maxspeed = 5,
				maxspeeddamp = 1,
				dampfactor = 1,
				deltatime = deltatime,
			}
			phys:ComputeShadowControl(t)
		end
	end
end

function ENT:PhysicsCollide( data, physobj ) 

	if self.Built == 2 then
		if self.Holdfire ~= 1 && self.Mine == 2 && data.HitEntity:GetClass() == "worldspawn" then
			if physobj:IsValid() then
				physobj:EnableMotion(false)
				timer.Simple(0.1, function() if physobj:IsValid() then constraint.Weld(self.Entity, data.HitEntity, 0, 0, 0, true) end end)
			end
			self.Entity:SetPos(self.Entity:GetPos() + data.HitNormal * 13.5)
			self.Mine = 1
			self.Healthlol = self.Healthlol + 30
			self.Maxlol = 50
			self.Entity:EmitSound("weapons/debris1.wav", 100, 100)
			self.Entity:SetColor(Color(255,255,255,60))
			self.Move = false
			self.Warmelon = nil
		end
		
		if self.Grav == false && data.HitEntity.Team ~= self.Team && self.Entity:GetPhysicsObject():IsValid() && (self.fuelleft ~= nil && self.fuelleft <= 7.5) && self.Entity:GetPhysicsObject():GetVelocity():Length() > 75 then
			--Msg(" " .. self.Entity:GetPhysicsObject():GetVelocity():Length() .. " ")
			
			self:Explode()
			self.Entity:Remove()    
		end
		
		if (self.Contact == true  || (self.Stance == 2 && self.HoldFire ~= 1)) && data.HitEntity.Team ~= self.Team && self.Mine ~= 2 then
			self:Explode()
			--local dist = (self.Entity:GetPos() - self.Daddy)
			--Msg("\n" ..  dist:Length() .. " ")
			self.Entity:Remove()
		end

	end
	
end

function ENT:OnRemove()
	if self.Barracks then
		self.Barracks.ActiveMelons = self.Barracks.ActiveMelons - 1
	end
end