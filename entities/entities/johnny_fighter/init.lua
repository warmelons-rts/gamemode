include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS("base_warmelon")

-- Setting up all the different properties of our melon.
ENT.Delay = 1;
ENT.Healthlol = 75;
ENT.FiringRange = 700;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.Speed = 80 * GetConVarNumber("WM_Melonspeed", 1)
ENT.DeathRadius = 25;
ENT.DeathMagnitude = 3;
ENT.MovingForce = 25 * GetConVarNumber("WM_Melonforce", 12);
ENT.MelonModel = "models/props_junk/watermelon01.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	if self.Blink then
        self.BuildModifier = 0.33
        self.StdMat = "models/effects/slimebubble_sheet"
        self.Grav = true
        self.Marine = nil
	elseif self.Marine then
        self.BuildModifier = 0.66
        self.Grav = true
        self.StdMat = ""
	end
    
	self:Setup();
    
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
	
	if self.Blink then
        self.Blinking = 0
        local tempfunc = self.OnTakeDamage
		function self:OnTakeDamage(dmginfo)
            self.Blinking = 5
            tempfunc(self,dmginfo)
		end
	end
    
    if !self.Grav then
        self.Healthlol = 50
        self.Maxlol = 50
        self.BuildModifier = 0.075
        util.SpriteTrail(self.Entity, 0, team.GetColor(self.team) --[[Color(255, 255, 255))]] , false, 10, 0, 2, 1/10*0.5, "trails/smoke.vmt")
        self.NoMoveRange = 100
        self.MovingForce = (self.MovingForce * GetConVarNumber( "WM_Flyingspeed", 0.75))
    end
    Sound ("Weapon_P90.Single");
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack()
		local angle = self.Target:GetPos() - self.Entity:GetPos();
		local bullet = {};
		bullet.Num = 1;
		bullet.Src = self.Entity:GetPos();
		bullet.Dir = angle:GetNormalized();
		bullet.Spread = Vector (0.06, 0.06, 0.06);
		bullet.Tracer = 1;
		bullet.Force = 0;
		bullet.Damage = 5;
		bullet.TracerName = "AR2Tracer";
		self.Entity:FireBullets (bullet);
		local fx = EffectData();
		fx:SetOrigin(self.Entity:GetPos());
		fx:SetAngles(angle:Angle());
		fx:SetScale(1.5);
		util.Effect("MuzzleEffect", fx);
		self.Entity:EmitSound("Weapon_P90.Single", 100, 100);
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
    if self.Blink ~= nil and self.Blinking ~= nil && self.Blinking > 0 then
	self.Blinking = self.Blinking - self.Delay
	self.NoMoveRange = 100
    	if math.Rand(0, 1) < .75 then
        	local trace = {}
        	trace.start = self.Entity:GetPos()
        	if self.Orders == true then
        	local angle = (self.TargetVec[1] - trace.start ):GetNormalized()
        	local xmod1 = 1
        	local xmod2 = 1
        	local ymod1 = 1
        	local ymod2 = 1
        	   
        	   if angle.x >= 0 then
        	   xmod1 = 0.25
        	   else
        	   xmod2 = 0.25
        	   end
                
               if angle.y >= 0 then
        	   ymod1 = 0.25
        	   else
        	   ymod2 = 0.25
        	   end
        	trace.endpos = Vector(trace.start.x + math.Rand(-300*xmod1,300*xmod2), trace.start.y + math.Rand(-300*ymod1,300*ymod2), trace.start.z)
        	else
        	trace.endpos = Vector(trace.start.x + math.Rand(-300,300), trace.start.y + math.Rand(-300,300), trace.start.z)
        	end
        	trace.filter = { self.Entity }
        	trace.mask = MASK_OPAQUE || MASK_WATER 
        	local tr = util.TraceLine(trace)
        			local effectdata = EffectData()
                    effectdata:SetStart( self.Entity:GetPos() ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
                    effectdata:SetOrigin( self.Entity:GetPos() )
                    effectdata:SetScale( 0.5 )
					effectdata:SetMagnitude(0.5)
                      util.Effect( "cball_bounce", effectdata ) 
                      --self.Entity:EmitSound("Weapon_Mortar.Single", 100, 100);
					  if math.Rand(0,1) < 0.5 then
					  self.Entity:EmitSound("weapons/physcannon/energy_bounce1.wav", 100, 100);
					  else
					  self.Entity:EmitSound("weapons/physcannon/energy_bounce2.wav", 100, 100);
					  end
        	self.Entity:SetPos(tr.HitPos)
        				           local effectdata = EffectData()
                    effectdata:SetStart( tr.HitPos ) // not sure if we need a start and origin (endpoint) for this effect, but whatever
                    effectdata:SetOrigin( tr.HitPos )
                    effectdata:SetScale( 0.5 )
					effectdata:SetMagnitude(0.5)
                      util.Effect( "cball_bounce", effectdata ) 
    	end
	else
	self.NoMoveRange = 50
	end
end
