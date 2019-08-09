AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self:SetMaterial("models/debug/debugwhite");
	self.Entity:GetPhysicsObject():EnableMotion(false);
	self.win = 0
	self.secured = false
end

function ENT:Think()
local winners = 0;
if GetConVarNumber( "WM_Pause", 0 ) == 0 then
    if self.secured == false then
    if self.win ~= 0 then
    TeamCaps[self.win] = TeamCaps[self.win] - 1
    end
	local entz = ents.FindInSphere(self.Entity:GetPos(), 225)
	local a = 0;
	local b = 0;
	local c = 0;
	local d = 0;
	local e = 0;
	local f = 0;
    self.win = 0;
	for k, v in pairs(entz) do
		if v.Warmelon && v.Delay then
			if (v.asploded ~= true) then
				--local traceRes=util.QuickTrace (self.Entity:GetPos(), v:GetPos()-self.Entity:GetPos(), self.Entity);
				--if traceRes.Entity == v:GetParent() then
				if v.Team == 1 then
				a = a + 1;
				end
				if v.Team == 2 then
				b = b + 1;
				end
				if v.Team == 3 then
				c = c + 1;
				end
				if v.Team == 4 then
				d = d + 1;
				end
				if v.Team == 5 then
				e = e + 1;
				end
				if v.Team == 6 then
				f = f + 1;
				end
				--end
			end
		end
	end
	if a > b && a > c && a > d && a > e && a > f then
	self.win = 1;
	elseif b > c && b > d && b > e && b > f then
	self.win = 2;
	elseif c > d && c > e && c > f then
	self.win = 3;
	elseif d > e && d > f then
	self.win = 4;
	elseif e > f then
	self.win = 5;
	elseif f ~= 0 then
  	self.win = 6;
	end
		if (self.win == 0) then
		self.Entity:SetColor(Color(255, 255, 255, 255));
		end
		if (self.win == 1) then
		self.Entity:SetColor(Color(255, 0, 0, 255));
		end
		if (self.win == 2) then
		self.Entity:SetColor(Color(0, 0, 255, 255));
		end
		if (self.win == 3) then
		self.Entity:SetColor(Color(0, 255, 0, 255));
		end
		if (self.win == 4) then
		self.Entity:SetColor(Color(255, 255, 0, 255));
		end
		if (self.win == 5) then
		self.Entity:SetColor(Color(255, 0, 255, 255));
		end
		if (self.win == 6) then
		self.Entity:SetColor(Color(0, 255, 255, 255));
		end
	if self.win ~= 0 then
    TeamCaps[self.win] = TeamCaps[self.win] + 1
    end
	end
	for k, v in pairs(player.GetAll()) do
		if (v:Team() == self.win) then
		winners = winners + 1;
		end 
	end
	 if self.win ~= 0 then
	team.SetScore(self.win, (team.GetScore(self.win) + (500 * GetConVarNumber("wm_toolcost", 1))))
            	       if team.GetScore(self.win) > GetConVarNumber("WM_ScoreLimit", 0) && GetConVarNumber("WM_ScoreLimit", 0) > 0 then
            	       ScoreVictory()
            	       end
	for k, v in pairs(team.GetPlayers(self.win)) do
    
   local cost = math.floor((GetConVarNumber( "WM_Cappointnrg", 1000 ) / winners))
	 v:SetNWInt( "nrg", math.floor(v:GetNWInt( "nrg" ) + cost))
	 --local message = "Your NRG:" .. v:GetNWInt( "nrg" ) .. " Income: " .. cost
	 --v:PrintMessage(HUD_PRINTTALK, message)
	 end
    end
end
	self.Entity:NextThink(CurTime() + 30)
	return true

end
