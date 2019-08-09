include("shared.lua");
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Delay = 100
ENT.Healthlol = 200;
ENT.FiringRange = 1300;
ENT.NoMoveRange = 0;
ENT.MinRange = 0;
ENT.DeathRadius = 250;
ENT.DeathMagnitude = 50;
ENT.MaxMelons = 8;
ENT.Speed = 0
ENT.ActiveMelons = 0;
ENT.MovingForce = 0;
ENT.Move = true;
ENT.Patrol = 0;
ENT.MelonModel = "models/props_trainstation/trainstation_clock001.mdl";

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	self.Entity:SetMaterial("hunter/myplastic")
	self.StdMat = "hunter/myplastic"
	if self.MelonGrav then
	self.MG = 1
	else
	self.MG = 0
	end
if !self.MelonGrav then
self.Delay = 50 * GetConVarNumber( "WM_BuildTime", 1 );
else
self.Delay = 10 * GetConVarNumber( "WM_BuildTime", 1 );
end
end


function ENT:Think()
local teamnrg = 0
local teamcount = team.NumPlayers(self.Team)
local cost = (8000-self.MG*4000)*GetConVarNumber( "WM_Toolcost", 1 )*GetConVarNumber( "WM_BarracksCost", 0.1 )
   	local allplayers = player.GetAll()
	if self.Team ~= 7 then
    	 for k, v in pairs (team.GetPlayers(self.Team)) do
    	   teamnrg = v:GetNetworkedInt( "nrg") + teamnrg
    	end
	else
	teamnrg = 1000000
	end
	if (self.ActiveMelons < self.MaxMelons || self.MaxMelons == 0) && self.TargetVec ~= self.Entity:GetPos() && self.HoldFire ~= 1 && teamnrg >= cost then
    	if self.Team ~= 7 then	   
            if GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") < GetConVarNumber("WM_MaxMelonsPerTeam") + (GetConVarNumber("WM_MelonBonusPerCap",2) * TeamCaps[self.Team]) then
            	for k, v in pairs (team.GetPlayers(self.Team)) do
            	   v:SetNetworkedInt( "nrg", v:GetNetworkedInt("nrg") - (cost / teamcount) )
            	   WMSendCost(v, cost / teamcount, 6 )        
            	end
            else
           	self.Entity:NextThink(CurTime()+self.Delay);
	        return true;
            end
        end

	local expl=ents.Create("johnny_barracksunit");
	expl.Team = self.Team;
	expl.Grav = self.MelonGrav;
	expl.Barracks = self.Entity;
	expl:SetNetworkedInt("WMTipV", 1)
	expl:SetPos(self.Entity:GetPos());
	expl.Stance = self.Stance
	expl.Cost = cost
	expl:SetOwner(self.Entity);
	if (self.FollowRange ~= 0) then	
		if (self.Leader == nil) then
		expl.Leader = self.Entity;
		else
		expl.Leader = self.Leader;
		end
	end
	expl.Patrol = self.Patrol;
	expl.FollowRange = self.FollowRange;
	expl.TargetVec = table.Copy(self.TargetVec);
	expl:Spawn();
	expl:Activate();

	SetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self.Team) .. "Melons") + 1)
	local fx = EffectData();
	fx:SetOrigin(expl:GetPos());
	util.Effect("johnny_build", fx);
	self.ActiveMelons = self.ActiveMelons + 1;
	self.Entity:EmitSound("BaseCombatWeapon.WeaponMaterialize", 100, 100);
	end
	self.Entity:NextThink(CurTime()+self.Delay);
	return true;
end

function ENT:OnRemove()
constraint.RemoveAll(self.Entity)
if self.Sound ~= nil then
self.Sound:Stop()
end
end