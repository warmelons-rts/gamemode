include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

function ENT:Initialize()  
	self:SetModel(self.model);
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Warmelon = true;
	self.damaged = 0;
	self.Team = self.Team;
	self.maxhealth = (self.mass * GetConVarNumber( "WM_healthtomass", 1.5));
	self.BuoyancyRatio = 0.75
	if self.Team ~= 7 then
	self.health = 1
	self.Built = 0
	else
	self.health = self.maxhealth
	self.Built = 2
	end
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
	phys:SetMass(self.mass)
    self:SetNetworkedInt("WMMaxHealth", math.floor(self.maxhealth))
	phys:Wake()
    phys:EnableMotion(1)
    --timer.Simple(0, function(phys,ent) if ent:IsValid() && phys:IsValid() then phys:SetBuoyancyRatio((ent.health / ent.maxhealth) * ent.BuoyancyRatio) end end, phys, self.Entity)
    timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then phys:SetBuoyancyRatio((self.health / self.maxhealth) * self.BuoyancyRatio) end end end, phys, self.Entity)
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
--    self:SetNetworkedInt("WMHealth", self.health)
--end

	if (self.damaged == 0) then
		self.damaged = 1
	end
end 

function ENT:Think()
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
			local phys = self.Entity:GetPhysicsObject()
			--timer.Simple(0, function(phys,ent) if ent:IsValid() && phys:IsValid() then phys:SetBuoyancyRatio((ent.health / ent.maxhealth) * ent.BuoyancyRatio) end end, phys, self.Entity)
            timer.Simple(0, function() if self:IsValid() then local phys = self:GetPhysicsObject(); if phys:IsValid() then phys:SetBuoyancyRatio((self.health / self.maxhealth) * self.BuoyancyRatio) end end end, phys, self.Entity)
			
                	    if self.health < self.maxhealth then
                	    --self.health = self.health + (6 / GetConVarNumber("WM_BuildTime", 1) * self.BuildModifier * 5)
			else
			self.health = self.maxhealth
                        end
                        self:SetNetworkedInt("WMHealth", math.floor(self.health))
                        self:SetNetworkedInt("WMBuilding", math.floor(percent))
                    else
                        self:SetNetworkedInt("WMBuilding", -1)
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
self:SetNetworkedInt("WMHealth", math.floor(self.health))
end
	self.BaseClass.Think(self)
	self.Entity:NextThink( CurTime() + 5)
	return true
end

function ENT:OnTakeDamage(DmgInfo)

DamageLS(self.Entity, DmgInfo)
self:SetNetworkedInt("WMHealth", math.floor(self.health))
    if self.Entity:GetPhysicsObject():IsValid() then
    self.Entity:GetPhysicsObject():SetBuoyancyRatio((self.health / self.maxhealth) * self.BuoyancyRatio)
    end
end

function ENT:OnRemove()
constraint.RemoveAll (self.Entity);
end

