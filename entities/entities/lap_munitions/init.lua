include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 2;
ENT.Healthlol = 200;
ENT.FiringRange = 0;
ENT.NoMoveRange = 0;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.DeathRadius = 300;
ENT.DeathMagnitude = 60;
ENT.MaxMelons = 8;
ENT.ActiveMelons = 0;
ENT.MovingForce = 0;
ENT.Move = true;
ENT.MelonModel = "models/props_vehicles/tire001a_tractor.mdl";
ENT.Stance = 0;
ENT.Patrol = 0;

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	if self.MelonGrav then
		self.MG = 1
		self.Reload = 16
		self:SetNWInt("MaxAmmo", 10)
		self.MelonMove = false
	else
		self.MG = 0
		self.Reload = 30
		self.MelonMove = true
		self:SetNWInt("MaxAmmo", 5)
	end
	self.Load = false
	self:SetNWInt("Loaded", 0)
	self.CurrentTimer = 16
	
	self.Marine = true
end

function ENT:OnRemove()
	if self.Team > 0 && self.Team <= 6 then
		SetGlobalInt("WM_" .. team.GetName(self.Entity.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Entity.Team) .. "Melons") - self:GetNWInt("Loaded"))
	end
end

function ENT:OtherThoughts()
	local maxedmelons = true
	if GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") < GetConVarNumber("WM_MaxMelonsPerTeam") + (GetConVarNumber("WM_MelonBonusPerCap",2) * TeamCaps[self.Team]) then
		maxedmelons = false
	end
    local goodtogo = false
    local createtime = false
    if self.CurrentTimer > 0 then
		self.CurrentTimer = self.CurrentTimer - self.Delay
    else
		local teamnrg = 0
		local teamcount = team.NumPlayers(self.Team)
		local cost = (17500-self.MG*15000)*GetConVarNumber( "WM_Toolcost", 1 )*GetConVarNumber( "WM_BarracksCost", 0.1 )
    	if self.Team ~= 7 then
			for k, v in pairs (team.GetPlayers(self.Team)) do
				teamnrg = v:GetNWInt( "nrg") + teamnrg
			end
    	else
			teamnrg = 100000
    	end
    	if (self.MaxMelons == 0 or self.ActiveMelons < self.MaxMelons) && self.TargetVec ~= self.Entity:GetPos() && self.HoldFire ~= 1 && teamnrg >= cost then
        	if self.Team ~= 7 then
               	for k, v in pairs (team.GetPlayers(self.Team)) do
					v:SetNWInt( "nrg", v:GetNWInt("nrg") - (cost / teamcount) )
                    WMSendCost(v, cost / teamcount, 6 )        
                end
        	end
			goodtogo = true	
        end
		self.CurrentTimer = self.Reload
    end
	if goodtogo then
		if self.Load && self:GetNWInt("Loaded") < self:GetNWInt("MaxAmmo") then
			self:SetNWInt("Loaded", self:GetNWInt("Loaded") + 1)
			self.ActiveMelons = self.ActiveMelons + 1
		elseif !maxedmelons then
			createtime = true
		end
	end
	
	if !self.Load && self:GetNWInt("Loaded") > 0 && !createtime then
		self:SetNWInt("Loaded", self:GetNWInt("Loaded") - 1)
		self.ActiveMelons = self.ActiveMelons - 1
		createtime = true
	end
	
	if createtime then
		local expl=ents.Create("lap_bomb");
			expl.Team = self.Team;
			expl.Grav = self.MelonGrav;
			expl.Move = self.MelonMove;
			expl.Mine = 0
			expl:SetNWInt("WMTipV", 1)
			expl.Cost = cost
		
			expl.Barracks = self.Entity;
			expl:SetPos(self.Entity:GetPos());
			expl:SetAngles(self.Entity:GetForward():Angle())
			expl:SetOwner(self.Entity);
			expl.Stance = self.Stance
			if self.Stance == 1 then
				expl.HoldFire = 1
			end
			expl.Payload = self.Payload;
			expl.Mine = self.Mine;
			expl.DetonateOn = self.DetonateOn
			expl:Spawn();
			expl:Activate()
			expl.Built = 2
			expl.healthlol = expl.maxlol
			local phys = expl:GetPhysicsObject()
			if phys:IsValid() then
			end
			expl:SetNWInt("WMTipV", 0)
			if self.MelonMove == true then
				expl.TargetVec = table.Copy(self.TargetVec)
				expl.Patrol = self.Patrol;
				expl.Orders = true
			end
		SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") + 1)
		local fx = EffectData();
			fx:SetOrigin(expl:GetPos());
			util.Effect("johnny_build", fx);
		self.ActiveMelons = self.ActiveMelons + 1;
		self.Entity:EmitSound("BaseCombatWeapon.WeaponMaterialize", 100, 100);
		
		--Load a nearby launcher if it exist and factory is set to stand ground stance
		if (self.Stance == 0 and self.MelonGrav == true) then
			for k, v in pairs(ents.FindInSphere(self.Entity:GetPos(), 300)) do
				if (v:GetClass() == "lap_launcher") && #v.Loaded < v.MaxAmmo && v.Team == self.Team and v.Built == 2 then
					table.insert(v.Loaded, expl.Payload)
					expl:Remove()
					v:SendAmmo()
					break
				end
			end
		end
    end
end

function ENT:OnRemove()
	constraint.RemoveAll(self.Entity)
	if self.Sound ~= nil then
		self.Sound:Stop()
	end
end