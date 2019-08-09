AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

DEFINE_BASECLASS("base_warmelon")

include('shared.lua')

function ENT:Initialize()  
	self:SetModel(self.model);
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Warmelon = true;
	self.damaged = 0;
	self.Loaded = {}
	self.Delay = self.FiringRate or 5
	self.maxhealth = (self.mass / 5) / GetConVarNumber("WM_Healthtomass")
	if self.Team ~= 7 then
		self.health = 1
		self.Built = 0
	else
		self.health = self.maxhealth
		self.Built = 2
	end
	self.Force = 2000
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		construct.SetPhysProp( nil, self.Entity, 0, nil,  { GravityToggle = true, Material = "metal" } ) 
		self:SetNetworkedInt("WMMaxHealth", math.floor(self.maxhealth))
	--	cw = ents.Create("prop_physics")
	--	cw:SetModel("models/props_borealis/bluebarrel001.mdl")
	--	cw:SetPos(self.Entity:LocalToWorld(self.Entity:OBBMins()))
	--	cw:SetAngles(self.Entity:GetAngles())
	--	cw:Spawn()
	--	cw:GetPhysicsObject():SetMass(self.mass / 2)
	--	cw:SetParent(self.Entity)
	--	cw:Activate()
		phys:SetMass(self.mass / 2)
		phys:EnableMotion(1)
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
	timer.Simple(1, function() self:SendMaxAmmo() end)

end  

function ENT:SendMaxAmmo()
	local rp = RecipientFilter()
	for k, v in pairs (team.GetPlayers(self.Team)) do
		rp:AddPlayer(v)
	end

	umsg.Start("WMMaxAmmo", rp)
		umsg.Entity(self.Entity)
		umsg.Short(self.MaxAmmo)
	umsg.End()
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
		if self.HoldFire ~= 1 then
			if self.Loaded[1] ~= nil then
				--self.Sound:PlayEx(100, self.Pitch)
				self.Entity:EmitSound(self.Sound, 100, self.Pitch)
				melon = ents.Create ("lap_bomb");
					melon.Cost = 250
					melon.Team = self.Team;
					melon.Payload = table.remove(self.Loaded)
					melon.Move = false
					melon.Fired = true
					local max = self.Entity:OBBMaxs()
					melon.Grav = true
					melon.damping = self.damping
					melon.Daddy = self.Entity:GetPos()
					melon:SetPos(util.LocalToWorld(self.Entity, max + Vector(0,0, max.z + 5)))
					melon.Contact = true
					melon:Spawn();
					melon.Built = 2
					melon:SetNWInt("WMTipV", nil)
					melon:Activate()
				self:SendAmmo()
				melon:GetPhysicsObject():SetVelocity(self.Entity:GetUp()*self.Force)
				local shit = self.Entity:GetAngles()
				shit:RotateAroundAxis(self.Entity:GetUp(), 180)
				self.Entity:GetPhysicsObject():ApplyForceCenter(shit, self.Force)
				if self.Force > 2000 then
					melon:GetPhysicsObject():EnableGravity(false)
					timer.Simple((self.Force - 2000)/500, RestoreBombGrav, melon)
				end
			end
		end       
		self:SetNetworkedInt("WMHealth", math.floor(self.health))
	end
	if self.health <= 0 then LS_Destruct(self.Entity) end
	self.BaseClass.Think(self)
	self.Entity:NextThink( CurTime() + self.Delay)
	return true
end

function ENT:SendAmmo()
	umsg.Start("WMLoaded", team.GetPlayers(self.Team))
		umsg.Entity(self.Entity)
		umsg.Short(#self.Loaded)
	umsg.End()
end

function ENT:OnTakeDamage(DmgInfo)
	self:SetNetworkedInt("WMHealth", math.floor(self.health))

	DamageLS(self.Entity, DmgInfo)
end


function ENT:Touch(ent)
	
	if (!ent:IsPlayerHolding()) then --fix to server crash when loading a bomb that is held by physgun - Doesnt work tho
		if (ent:GetClass() == "lap_bomb" || ent:GetClass() == "lap_bomb_clone") && ent.Grav == true && #self.Loaded < self.MaxAmmo && ent.Built == 2 && ent.Team == self.Team && self.Built == 2 then
			table.insert(self.Loaded, ent.Payload)
			ent:Remove()
			self:SendAmmo()
		end
	end
	
end

function ENT:OnRemove()
constraint.RemoveAll (self.Entity);
end