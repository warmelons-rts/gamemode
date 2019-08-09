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
ENT.MelonModel = "models/props_phx/misc/soccerball.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	if self.Mine == 1 then
	self.Entity:SetColor(Color(255,255,255,60))
	self.Healthlol = 50
	self.Maxlol = 50
	self.Move = false
	self.Warmelon = nil
	else
	self.StdMat = "models/weapons/v_slam/new light1"
	self.Entity:SetMaterial(self.StdMat)
	end
	
    if self.Payload == 2 then
    self.DeathMagnitude = self.DeathMagnitude / 3
    self.DeathRadius = self.DeathRadius / 3
    elseif self.Payload == 4 then
    self.DeathMagnitude = 2
    self.DeathRadius = 350
    end	
local phys = self.Entity:GetPhysicsObject()
timer.Simple(0.1, function() construct.SetPhysProp( nil, self.Entity, 0, nil,  { GravityToggle = true, Material = "metal" }) end )
timer.Simple(0.15, function(phys,ent) phys:SetBuoyancyRatio(0.175) end, phys, self)
construct.SetPhysProp( nil, self.Entity, 0, nil,  { GravityToggle = true, Material = "metal" } )
if self.Grav == true then

	if phys:IsValid() then
	phys:EnableDrag(false)
	phys:SetDamping(0, 0)
	phys:Wake()
	end
else
	if phys:IsValid() then
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
    	local phys = self.Entity:GetPhysicsObject()
    	if phys:IsValid() then
    	phys:EnableGravity(false)
    	phys:Wake()
    	end
end

function ENT:RemoveMissileTrail()
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
        self.fuelleft = 15
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
    	constraint.RemoveAll (self.Entity);
    	self.Entity:SetColor (Color(0, 0, 0, 255));
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
                    timer.Simple(10, RestoreSpeed, target, slimetrail)
                    par.Speed = par.Speed / 2
                    end
                end
                self.Entity:EmitSound("npc/antlion_grub/squashed.wav", 200, 70)  
            
    end
    
    if self.Payload == 4 then
        for k, v in pairs (ents.FindInSphere(self.Entity:GetPos(), 350)) do
            if v.Warmelon then
                local target = v:EntIndex()
                if v.Grav ~= nil && v.Grav == false && v.ZVelocity == nil && math.Rand(0,1) < 0.4 then
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
self.Entity:Remove()
end

--function ENT:PhysicsUpdate(phys)
--Msg("working")
--    phys:SetVelocity( self.Entity:GetForward() * 100 )
--end

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
    
    if self.Grav == false && data.HitEntity.Team ~= self.Team && self.Entity:GetPhysicsObject():IsValid() && self.Entity:GetPhysicsObject():GetVelocity():Length() > 25 then
    self:Explode()
    self.Entity:Remove()    
    end
    
    if (self.Contact == true  || (self.Stance == 2 && self.HoldFire ~= 1)) && data.HitEntity.Team ~= self.Team && self.Mine ~= 2 then
    self:Explode()
    self.Entity:Remove()
    end

end
end


function ENT:OnRemove()
	if self.Barracks then
		self.Barracks.ActiveMelons = self.Barracks.ActiveMelons - 1
	end
end