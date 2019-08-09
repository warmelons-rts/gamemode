include('shared.lua')
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

DEFINE_BASECLASS( "base_warmelon" )

function ENT:Initialize()  
	self:SetModel(self.model);
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Warmelon = true;
	self.Load = true
	self.damaged = 0;
	self.Loaded = {}
	self.CurLoad = 0
	self.health = 1
	self.Delay = 2
	self.Load = true
	self.maxhealth = self.mass / 5
	if self.Team ~= 7 then
	self.Built = 0
	else
	self.health = self.maxhealth
	self.Built = 2
	end
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
	 construct.SetPhysProp( nil, self.Entity, 0, nil,  { GravityToggle = true, Material = "metal" } ) 
	 phys:SetMass(self.mass)
    self:SetNetworkedInt("WMMaxHealth", math.floor(self.maxhealth))
    phys:EnableMotion(1)
    end
 	if (self.Team == 1) then
		self.Entity:SetColor (Color(255, 0, 0, 255))
	end
	if (self.Team == 2) then
		self.Entity:SetColor (Color(0, 0, 255, 255))
	end
	if (self.Team == 3) then
		self.Entity:SetColor (Color(0, 255, 0, 255))
	end
	if (self.Team == 4) then
		self.Entity:SetColor (Color(255, 255, 0, 255))
	end
	if (self.Team == 5) then
	self.Entity:SetColor (Color(255, 0, 255, 255))
	end
	if (self.Team == 6) then
	self.Entity:SetColor (Color(0, 255, 255, 255))
	end
	if (self.Team == 7) then
	self.Entity:SetColor (Color(125, 125, 125, 255))
	end
	timer.Simple(1, function() self:SendMaxAmmo() end)
end   
function ENT:Destruct()
    LS_Destruct(self.Entity)
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
		self.health = 1
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
	
	if !self.Load && self.Loaded[1] ~= nil then
		
		if GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") >= GetConVarNumber( "WM_MaxMelonsPerTeam", 0 ) + (TeamCaps[self.Team] * GetConVarNumber("WM_MelonBonusPerCap",2)) then return end
		
		SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") + 1)
		
		local name = self.Loaded[1].ClassName
		
		melon = ents.Create(name)
		melon:SetPos(util.LocalToWorld(self.Entity, self.Entity:OBBCenter() + self.DeployVec * 2.5))
		table.Merge(melon, self.Loaded[1])
		melon:Spawn();
		table.Merge(melon, table.remove(self.Loaded, 1))
		melon:Activate()
		
		
		local rp = RecipientFilter()
		for k, v in pairs (team.GetPlayers(self.Team)) do
			rp:AddPlayer(v)
		end
		
		if name == "lap_bomb" || name == "lap_bomb_clone" || name == "lap_cannon" || name == "lap_mg" then
			self.CurLoad = self.CurLoad - 2
		else
			self.CurLoad = self.CurLoad - 1
		end
		
		umsg.Start("WMLoaded", rp)
		umsg.Entity(self.Entity)
		umsg.Short(self.CurLoad)
		umsg.End()
		
	end        
	
	if self.Built == 2 then    			
		self:SetNetworkedInt("WMHealth", math.floor(self.health))
	end
	
	if self.health <= 0 then LS_Destruct(self.Entity) end
	
	self.BaseClass.Think(self)
	self.Entity:NextThink( CurTime() + self.Delay)
	
	return true
	
end

function ENT:OnTakeDamage(DmgInfo)
self:SetNetworkedInt("WMHealth", math.floor(self.health))

		DamageLS(self.Entity, DmgInfo)
end


function ENT:StartTouch(ent)
	
	if (!ent:IsPlayerHolding()) then --fix to server crash when loading a bomb that is held by physgun
		filex.Append( "transportlog.txt", "collided\n" )
		
		if self.Load && self.Built == 2 && ent.Move && ent.Team == self.Team && ent.Built == 2 then
			
			filex.Append( "transportlog.txt", "built and same team\n" )
			local name = ent:GetClass()
			local size = 1
			filex.Append( "transportlog.txt", "its a:" .. name .. "\n" )
			if name == "lap_bomb" || name == "lap_bomb_clone" || name == "lap_cannon" || name == "lap_mg" then
				filex.Append( "transportlog.txt", "big thing!\n" )
				size = 2
			end
			
			if self.CurLoad + size <= self.MaxAmmo then
				local tbl = {}
				
				filex.Append( "transportlog.txt", "preparing table\n" )
				for k,v in pairs (ent:GetTable()) do
					if type(v) ~= "function" && type(v) ~= "table" && k ~= "Entity" then
						tbl[k] = v
					end
				end
				
				filex.Append( "transportlog.txt", "loading\n" )
				table.insert(self.Loaded, tbl)
				self.CurLoad = self.CurLoad + size
				
				filex.Append( "transportlog.txt", "removing melon\n" )
				ent:Remove()
				
				filex.Append( "transportlog.txt", "making recipentfilter\n" )
				local rp = RecipientFilter()
				for k, v in pairs (team.GetPlayers(self.Team)) do
					rp:AddPlayer(v)
				end
				
				filex.Append( "transportlog.txt", "sending umsg\n" )
				umsg.Start("WMLoaded", rp)
				umsg.Entity(self.Entity)
				umsg.Short(self.CurLoad)
				umsg.End()
				
				filex.Append( "transportlog.txt", "sent umsg\n" )
			end
			
		end
		
		filex.Append( "transportlog.txt", "endcollide\n\n" )
	end
	
end

function ENT:Touch(ent)
end

function ENT:OnRemove()
constraint.RemoveAll (self.Entity);
end