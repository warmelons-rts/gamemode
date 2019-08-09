for i = 1, 6 do
WMTeamAbilities[i]["MelonStrike"]

end


function AbilityRecharge(team, ability, time)


end

function SkillPointCheck()


end

function MelonStrike(ply, pos)
		if !trace.HitWorld then 
		local message = "Target the map instead."
		self:GetOwner():PrintMessage(HUD_PRINTTALK, message)
	  	return false 
		end
		local entz = ents.FindByClass("lap_commuplink");
		local fail = 1
		for k, v in pairs(entz) do
		if v.win == self:GetOwner():Team() then
		fail = 2
		  local dist = v:GetPos():Distance(trace.HitPos);
			if (dist < 6000) then
			fail = 3
			 if (v.ready == 1) then
			 v.lastfired = CurTime()
			 v.ready = 0
				local message = self:GetOwner():GetName() .. " launched a melon strike!"
		    local allplayers = player.GetAll( )
		  	 for k,v in pairs ( allplayers ) do
		     v:PrintMessage( HUD_PRINTCENTER, message )
		  	 end 
		  	 			local Owner = self:GetOwner()	
		  self.hitpos = trace.HitPos
		  if self.target ~= nil then
		  self.target:Remove()
		  end
		
		self.target = ents.Create("info_target")
		self.target:SetPos(Owner:GetShootPos() + (Owner:GetAimVector() * math.random(-100000, 0)) + Vector(0, 0, 50000))
    self.target:SetKeyValue("targetname", "target")
		self.target:Spawn()
		self.target:Activate()
		self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		
	  self.canister = ents.Create("env_headcrabcanister")
		self.canister:SetPos(self.hitpos)


		local Offset = self.target:GetPos() - self.hitpos
		local Angle = Offset:Angle()

		self.canister:SetAngles(Angle)
		self.canister:SetKeyValue("HeadcrabType", 0)
		self.canister:SetKeyValue("HeadcrabCount", 0)
		self.canister:SetKeyValue("LaunchPositionName", "target")
		self.canister:SetKeyValue("FlightSpeed", 100)
		self.canister:SetKeyValue("FlightTime", 15)
		self.canister:SetKeyValue("Damage", 60)
		self.canister.Team = self:GetOwner():Team()
		self.canister:SetKeyValue("DamageRadius", 125)
		self.canister:SetKeyValue("SmokeLifetime", 50)
		self.canister:Fire("Spawnflags", "16384", 0)
		self.canister:Fire("FireCanister", "", 0)
		self.canister:Fire("AddOutput", "OnImpacted OpenCanister", 0)
		self.canister:Spawn()
		self.canister:Activate()
		local melon = ents.Create("lap_canistertimer");
    melon:SetPos(self.hitpos);
	  melon.Team = self:GetOwner():Team()
	  melon:Spawn();
  	melon:Activate();
  	fail = 0
	 	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.8)
		return true
       end
		end
		end
		end
		local message = ""
		if fail == 1 then
		message = "Your team does not possess a communications uplink."
		end
    if fail == 2 then
    message = "The communications uplink is too far from your target."
    end
    if fail == 3 then
    message = "The communications uplink is not fully charged yet."
    end
    self:GetOwner():PrintMessage(HUD_PRINTTALK, message)
    end
	end


end



function UseSkillRequest(ply, cmd, arg)

end