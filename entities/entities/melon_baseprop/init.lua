include( "shared.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );

function ENT:Initialize()  
	self:SetModel(self.model);
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
	self.Warmelon = true;
	self.damaged = 0;
	self.Team = self.Team;
	if self.mass == nil then self.mass = 100 end
	local vec = (self.Entity:OBBMaxs() - self.Entity:OBBMins())
	local size = vec.x * vec.y * vec.z
	local masstohealthresult = self.mass * GetConVarNumber( "WM_healthtomass", 1.5)
	if masstohealthresult <= size * GetConVarNumber( "WM_HealthtoSize", 2.5) then
				if masstohealthresult <= GetConVarNumber( "WM_MaxPropHealth", 1500) then
				self.maxhealth = masstohealthresult
				else
				self.maxhealth = GetConVarNumber( "WM_MaxPropHealth", 1500)
				end
	else
		if size * GetConVarNumber( "WM_HealthtoSize", 2.5) <= GetConVarNumber( "WM_MaxPropHealth", 1500) then
		self.maxhealth = size * GetConVarNumber( "WM_HealthtoSize", 2.5)
		else
		self.maxhealth = GetConVarNumber( "WM_MaxPropHealth", 1500)
		end
	end
	if self.Team ~= 7 then
	self.health = 1
	self.Built = 0
	else
	self.health = self.maxhealth
	self.Built = 2
	end
	if phys:IsValid() then
	 construct.SetPhysProp( nil, self.Entity, 0, nil,  { GravityToggle = true, Material = "metal" } ) 
	   if phys:GetMass() ~= self.maxhealth / GetConVarNumber( "WM_healthtomass", 1.5) then
	   phys:SetMass(self.mass)
	   end
    self:SetNWInt("WMMaxHealth", math.floor(self.maxhealth))
    phys:EnableMotion(1)
	--This is the old method I was using. It seems to work fine but I'm scared about a crash if for some reason an ent's phys changes or something so here's the less efficent, but foolproof way.
    --timer.Simple(0.1, function(ent, phys) if ent:IsValid() && phys:IsValid() then phys:SetBuoyancyRatio(0.175) end end, self, phys)
	--timer.Simple(0, function(ent) if ent:IsValid() then local phys = ent:GetPhysicsObject(); if phys:IsValid() then phys:SetBuoyancyRatio(0.001) end end end, self.Entity)
	timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then phys:SetBuoyancyRatio(0.001) end end end, self.Entity)
	--timer.Simple(1, function(phys,ent) phys:SetBuoyancyRatio(0.001) end, phys, self.Entity)
	end
    end
 	if (self.Team == 1) then
		self.Entity:SetColor(Color(255, 0, 0, 255))
	end
	if (self.Team == 2) then
		self.Entity:SetColor(Color(0, 0, 255, 255))
	end
	if (self.Team == 3) then
		self.Entity:SetColor(Color(0, 255, 0, 255))
	end
	if (self.Team == 4) then
		self.Entity:SetColor(Color(255, 255, 0, 255))
	end
	if (self.Team == 5) then
	self.Entity:SetColor(Color(255, 0, 255, 255))
	end
	if (self.Team == 6) then
	self.Entity:SetColor(Color(0, 255, 255, 255))
	end
	if (self.Team == 7) then
	self.Entity:SetColor(Color(125, 125, 125, 255))
	end
end   
function ENT:Destruct()
    LS_Destruct(self.Entity)
end

function ENT:Damage()
--if self.Built == 2 then   
--    self:SetNWInt("WMHealth", self.health)
--end

	if (self.damaged == 0) then
		self.damaged = 1
	end
end 

function ENT:Think()
--self.Entity:GetPhysicsObject():SetBuoyancyRatio(0.01)
--self.Entity:GetPhysicsObject():Wake()
            	   if self.Built == 0 then
            	   self.Health = 1
            	   local col = self.Entity:GetColor(); 
            	   self.maxA = col.a
            	       if self.BuildModifier == nil then
            	       self.BuildModifier = 1
                       end
                    self.Buildtime = (self.maxhealth - 1) / (6 / GetConVarNumber("WM_BuildTime", 1) * self.BuildModifier * 5)
                    self.CurBuildtime = 0
                    self.Built = 1
            	   end
            	   if self.Built == 1 then
                	if self.CurBuildtime < self.Buildtime then
                	local hpinc = self.maxhealth / self.Buildtime
                	self.CurBuildtime = self.CurBuildtime + 1
                	local percent = math.floor(self.CurBuildtime / self.Buildtime * 100)
                	if percent > 100 then
                	percent = 100
                	end
                	local col = self.Entity:GetColor(); 
                	self.Entity:SetColor(Color(col.r,col.g,col.b, 50 + ((self.maxA - 50) / percent)))
			self.health = self.health + hpinc
                	
                	    if self.health < self.maxhealth then
                	    --self.health = self.health + (6 / GetConVarNumber("WM_BuildTime", 1) * self.BuildModifier * 5)
			else
			self.health = self.maxhealth
                        end
                        self:SetNWInt("WMHealth", math.floor(self.health))
                        self:SetNWInt("WMBuilding", math.floor(percent))
                    else
                        self:SetNWInt("WMBuilding", -1)
                    local col = self.Entity:GetColor(); 
                	self.Entity:SetColor(Color(col.r,col.g,col.b, self.maxA))
                	self.maxA = nil
                    self.Built = 2
                    self.Buildtime = nil
                    self.CurBuildtime = nil
                    self.BuildModifier = nil
                    end
                   end 
                   	
if self.Built == 2 then    			
self:SetNWInt("WMHealth", math.floor(self.health))
end
if self.health <= 0 then LS_Destruct(self.Entity) end
	self.BaseClass.Think(self)
	self.Entity:NextThink( CurTime() + 5)
	return true
end

function ENT:OnTakeDamage(DmgInfo)
self:SetNWInt("WMHealth", math.floor(self.health))

		DamageLS(self.Entity, DmgInfo)
end

function ENT:OnRemove()
constraint.RemoveAll (self.Entity);
end