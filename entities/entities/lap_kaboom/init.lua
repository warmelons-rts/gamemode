include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Move = false;
ENT.Delay = 0.2;
ENT.Healthlol = 300;
ENT.FiringRange = 500;
ENT.NoMoveRange = 50;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.DeathRadius = 500;
ENT.DeathMagnitude = 450;
ENT.MovingForce = 150;
ENT.MelonModel = "addons/wmm/models/wmm/megabomb.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:SetMaterial(Material("addons/wmm/materials/wmm/stripes"));
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake();
		phys:SetMass(2500);
	end
		local rp = RecipientFilter()
		for k, v in pairs (team.GetPlayers(self.Team)) do
			rp:AddPlayer(v)
		end
	self.HoldFire = 1
	umsg.Start("WMHoldFireMsg", rp)
	umsg.Entity(x)
	umsg.Bool(true)
	umsg.End()
end


function jStopLaserSound(ent)
	ent:StopSound("Airboat_fan_fullthrottle");
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
self.Healthlol = 0;
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
    if self.Stance == 3 then
    self.Healthlol = 0;
    end
end

function ENT:BeforeDeathFunc()
--100% TetaBonita code right here.
	self.SplodePos = self.Entity:GetPos() + Vector(0,0,4)
	local sndSplode = Sound("ambient/explosions/explode_6.wav")
    local sndRumble = Sound("ambient/explosions/exp1.wav")
        for x,y in pairs(player.GetAll()) do
            if y:IsValid() then
            y:EmitSound(sndRumble, 100, 100)
            timer.Simple(self.SplodePos:Distance(y:GetPos())/18e3, function() y:EmitSound(sndSplode, 100, 100) end)
            end
        end
        --self.Entity:EmitSound(sndSplode,500,100)
        --self.Entity:EmitSound(sndRumble,500,100)
                    local trace = {}
					trace.start = self.SplodePos
					trace.endpos = trace.start - Vector(0,0,750)
					trace.filter = { self.Entity }
					trace.mask = MASK_SOLID_BRUSHONLY
					traceRes = util.TraceLine(trace)
		
		local effectdata = EffectData()
		effectdata:SetMagnitude( 0.13 )
		
		if !traceRes.Hit then
			effectdata:SetOrigin( self.SplodePos )
			effectdata:SetScale( 0.1 )
			util.Effect( "nuke_effect_air", effectdata )
		else --otherwise, we are probably on the ground
			self.SplodePos.z = traceRes.HitPos.z
			effectdata:SetOrigin( self.SplodePos )
			effectdata:SetScale( 1 )
			util.Effect( "nuke_effect_ground", effectdata )	
				util.Effect( "nuke_blastwave", effectdata )	
		end
			
			
			--util.Effect( "nuke_effect_air", effectdata )


		local shake = ents.Create("env_shake")
		shake:SetKeyValue("amplitude", 10)
		shake:SetKeyValue("duration", 3)
		shake:SetKeyValue("radius", 5000) 
		shake:SetKeyValue("frequency", 200)
		shake:SetKeyValue("spawnflags", "4" )
		shake:SetPos(self.Entity:GetPos())
		shake:Spawn()
		shake:Activate()
		shake:Fire("StartShake","","0.4")
		shake:Fire("kill","","4")
		
				local selfpos = self.Entity:GetPos()
		for k, v in pairs (ents.FindInSphere(selfpos, 2000)) do
		if v:IsValid() then
		  local realpos = v:LocalToWorld(v:OBBCenter())
		  local dist = self.Entity:GetPos():Distance(realpos)
		    local class = v:GetClass()
    		local clamped = math.Clamp(dist, 500, 1500)
    		local divisor = 1.4-0.00092*clamped
    		  if class ~= "lap_spawnpoint" && class ~= "lap_outpost" && v.Team ~= nil then
    		      if dist < 500 then
    		          if math.Rand(0,1) > 250 / dist then
    		          
    		          constraint.RemoveAll(v)
    		          end
    		      end
        		  
        		  	local phys = v:GetPhysicsObject()
    		          if phys:IsValid() then
    		          
    		          phys:EnableMotion(true)
    		          phys:Wake()
    		          local angle = realpos - selfpos
    		          phys:ApplyForceCenter(angle:GetNormalized() * 850 * (divisor * phys:GetMass()))
    		          end
		       end
    		      if class ~= "melon_baseprop" && class ~= "lap_ballast" && class ~= "lap_spawnpoint" && class ~= "lap_outpost" then
                  v:TakeDamage((250 * divisor), self.Entity, self.Entity)
    		      else
    		      v:TakeDamage((900 * divisor), self.Entity, self.Entity)
    		      Msg("Dist " .. dist .. " Damage: " .. 900 * divisor .. "\n")
    		      end
    		end
		end

end

function ENT:Explode()	
		self.asploded = true;	
        if self.Built == 2 then
        self:BeforeDeathFunc();
		elseif self.Buildtime ~= nil then
		local expl=ents.Create("env_explosion")
		self:BeforeDeathFunc();
		expl:SetPos(self.Entity:GetPos());
		expl:SetOwner(self.Entity);
		expl.Team = self.Team
		expl:SetKeyValue("iMagnitude", self.DeathMagnitude * (self.CurBuildtime / self.Buildtime));
		expl:SetKeyValue("iRadiusOverride", self.DeathRadius * (self.CurBuildtime / self.Buildtime));
		expl:Spawn();
		expl:Activate();
		expl:Fire("explode", "", 0);
		expl:Fire("kill","",0);
		end
	constraint.RemoveAll (self.Entity);
	self.Entity:SetColor (Color(0, 0, 0, 255));
	self.Entity:Fire("kill","",0)
end

function ENT:PhysicsCollide( data, physobj ) 
if (self.Stance == 2 && self.HoldFire ~= 1) then
self:Explode()
self.Entity:Remove()
end
end