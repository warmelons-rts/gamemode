include('shared.lua')
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

DEFINE_BASECLASS( "base_warmelon" )

ENT.Delay = 1;
ENT.Healthlol = 250;
ENT.DeathRadius = 50;
ENT.DeathMagnitude = 250;
ENT.MovingForce = 0;
ENT.MinRange = 0;
ENT.Speed = 0
ENT.FiringRange = 500;
ENT.MelonModel = "models/props_c17/FurnitureBoiler001a.mdl";

function ENT:Initialize()

	self:Setup();
	if (self.Team == 1) then
		self.Entity:SetColor(Color(255, 0, 0, 255));
	end
	if (self.Team == 2) then
		self.Entity:SetColor(Color(0, 0, 255, 255));
	end
	if (self.Team == 3) then
		self.Entity:SetColor(Color(0, 255, 0, 255));
	end
	if (self.Team == 4) then
		self.Entity:SetColor(Color(255, 255, 0, 255));
	end
	if (self.Team == 5) then
	self.Entity:SetColor(Color(255, 0, 255, 255));
	end
	if (self.Team == 6) then
	self.Entity:SetColor(Color(0, 255, 255, 255));
	end
    local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(100000)
	end
self:SetNetworkedInt("WMMaxHealth", math.floor(self.Maxlol))
self:SetNetworkedInt("WMHealth", math.floor(self.Healthlol))
end
function ENT:TargetSearch()
return
end

function ENT:OtherThoughts()
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)
	for k, v in pairs(entz) do
		if v.Warmelon then
			if (v.Team == self.Team && v ~= self.Entity) then
			     if v.Healthlol ~= nil && v.Healthlol < v.Maxlol then
					local angle = v:GetPos() - self.Entity:GetPos();
					v.Healthlol = v.Healthlol+1;
					if (v.Healthlol > v.Maxlol/5 && v.trail) then
						v.trail:Remove();
						v.trail = nil;
					end
				 elseif v.health ~= nil && v.health < v.maxhealth then
				   v.health = v.health+0.5;    
if v.health > (v.maxhealth * 0.5) then

     if (v.Team == 1) then
		v:SetColor(Color(255, 0, 0, 255));
	end
	if (v.Team == 2) then
		v:SetColor(Color(0, 0, 255, 255));
	end
	if (v.Team == 3) then
		v:SetColor(Color(0, 255, 0, 255));
	end
	if (v.Team == 4) then
		v:SetColor(Color(255, 255, 0, 255));
	end
	if (v.Team == 5) then
		v:SetColor(Color(255, 0, 255, 255));
	end
	if (v.Team == 6) then
		v:SetColor(Color(0, 255, 255, 255));
	end
end
end
			end
		end
	end

local entz = ents.FindInSphere(self.Entity:GetPos(),50)
if WMPause == true then return end
	for k, v in pairs(entz) do
		if v:GetClass() == "lap_harvester" then
		  if v.Team == self.Team then
		    if v.Full == 1 then
            v.Full = 0
                if v.Stance == 3 then
                v.TargetVec = {}
                end
            local winners = 0
              for x, y in pairs(player.GetAll()) do
    		      if (y:Team() == self.Team) then
    		      winners = winners + 1;
    		      end 
    	      end
            	for x, y in pairs(player.GetAll()) do
                	 if (y:Team() == self.Team) then
                     local cost = (GetConVarNumber( "WM_RezPerHarvest", 2500 ) / winners)
                     if y.Move == 0 then cost = cost * 2 end
                	 y:SetNetworkedInt( "nrg", y:GetNetworkedInt( "nrg" ) + cost)
                	 --local message = "Your NRG:" .. v:GetNetworkedInt( "nrg" ) .. " Income: " .. cost
                	 --v:PrintMessage(HUD_PRINTTALK, message)
                	 end
            	end
            end
	      end
	    end
		end
	self.Entity:NextThink(CurTime()+self.Delay);
return true
end