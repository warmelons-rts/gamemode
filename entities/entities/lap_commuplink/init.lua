include('shared.lua')
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

function ENT:Initialize()
self.Entity:PhysicsInit(SOLID_VPHYSICS)
self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
self.Entity:SetSolid(SOLID_VPHYSICS)
--self.Entity:SetMass(100000)
self.Entity:GetPhysicsObject():EnableMotion(false);
self.lastfired = CurTime()
self.ready = 1
self.win = 0
self.Entity:SetModel(self.model)
--self:SetNetworkedString("Owner", "World")
loopingSound = CreateSound( self.Entity, "npc/roller/mine/rmine_moveslow_loop1.wav" )
	if not (WireAddon == nil) then
		self.WireDebugName = self.PrintName
		self.Inputs = Wire_CreateInputs(self.Entity, { })
		self.Outputs = Wire_CreateOutputs(self.Entity, {"ReadytoFire"})
		self.WireDebugName = "Communications Uplink"
	end
end

function ENT:Think()
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
		self.Entity:SetColor(Color (255, 255, 255, 255));
		end
		if (self.win == 1) then
		self.Entity:SetColor(Color (255, 0, 0, 255));
		end
		if (self.win == 2) then
		self.Entity:SetColor(Color(0, 0, 255, 255));
		end
		if (self.win == 3) then
		self.Entity:SetColor(Color (0, 255, 0, 255));
		end
		if (self.win == 4) then
		self.Entity:SetColor(Color (255, 255, 0, 255));
		end
		if (self.win == 5) then
		self.Entity:SetColor(Color (255, 0, 255, 255));
		end
		if (self.win == 6) then
		self.Entity:SetColor(Color (0, 255, 255, 255));
		end

if ((!self.lastfired || self.lastfired < (CurTime() - 120)) && (self.ready == 0)) then
self.ready = 1
end
if (self.ready == 1) then
self:SetOverlayText( "Melon Strike Ready" )
self.Entity:SetMaterial("models/shiny")
loopingSound:Play()
else
self:SetOverlayText( "Melon Strike Charging" )
self.Entity:SetMaterial("models/debug/debugwhite")
loopingSound:FadeOut( 5 )
end
if not (WireAddon == nil) then Wire_TriggerOutput(self.Entity, "ReadytoFire", self.ready) end
if GetConVarNumber("WM_KingoftheHill", 0) == 0 then
	self.Entity:NextThink(CurTime() + 15)
else	
	if self.win ~= 0 then
	team.SetScore(self.win, team.GetScore(self.win) + 1000)
	            	       if team.GetScore(self.win) > GetConVarNumber("WM_ScoreLimit", 0) && GetConVarNumber("WM_ScoreLimit", 0) > 0 then
            	       ScoreVictory()
            	       end
	end
	self.Entity:NextThink(CurTime() + 5)
end
	return true
end

function ENT:OnRemove()
loopingSound:Stop()
end