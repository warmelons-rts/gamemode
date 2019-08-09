TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Melon Strike"
--TOOL.Command		= nil
--TOOL.ConfigName		= nil


if (CLIENT) then
	language.Add("Tool_lap_canisters_name", "Melon Strike Tool")
	language.Add("Tool_lap_canisters_desc", "Left-click: Launches a melon strike Right-Click: Phantom melon strike.")
	language.Add("Tool_lap_canisters_0", "Once every two minutes per controlled uplink, you may summon a melon strike.")
end

util.PrecacheModel("models/props_combine/headcrabcannister01a.mdl")
util.PrecacheModel("models/props_combine/headcrabcannister01b.mdl")
util.PrecacheModel("models/props_combine/headcrabcannister01a_skybox.mdl")

function TOOL:LeftClick(trace)
	if ( SERVER ) then
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
						fail = 0
						v.lastfired = CurTime()
						v.ready = 0
						
						local message = self:GetOwner():GetName() .. " launched a melon strike!"
						for k,v in pairs ( player.GetAll() ) do
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
						
						local Offset = self.target:GetPos() - self.hitpos
						local Angle = Offset:Angle()
						--[
						self.canister = ents.Create("env_headcrabcanister")
							self.canister:SetPos(self.hitpos)
							self.canister:SetAngles(Angle)
							self.canister:SetKeyValue("HeadcrabType", 0)
							self.canister:SetKeyValue("HeadcrabCount", 0) --Gmod 13 seems to have solved this issue--(Seems like it, after a gmod update, makes stuff fall trough world if it doesnt spawn any headcrabs)
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
							self.canister:Activate()--]--
						
						local melon = ents.Create("lap_canistertimer");
							melon:SetPos(self.hitpos);
							melon.Team = self:GetOwner():Team()
							melon:Spawn();
							melon:Activate();
						
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
	
function TOOL:RightClick(trace)
	if ( SERVER ) then
    	if GetGlobalInt("WM_ScenarioMode") ~= 13 then
			self:GetOwner():PrintMessage(HUD_PRINTCENTER, "This mode is only used in the Phantom Scenarios.")
			return false
    	end
    	if self:GetOwner():Team() ~= WMPhantomTeam then
			self:GetOwner():PrintMessage(HUD_PRINTCENTER, "Only the Phantom Team can do that.")
			return false
    	end
    	if WMPhantomLastFired > CurTime() - GetConVarNumber("WM_PhatomStrikeInterval", 300) then
			self:GetOwner():PrintMessage(HUD_PRINTCENTER, math.Round(GetConVarNumber("WM_PhatomStrikeInterval", 300) - (CurTime() - WMPhantomLastFired)) .. " seconds left until you can fire again.")
			return false
    	end
		if !trace.HitWorld then 
			local message = "Target the map instead."
			self:GetOwner():PrintMessage(HUD_PRINTTALK, message)
			return false 
		end
		
		local Owner = self:GetOwner()	
		self.hitpos = trace.HitPos
		if self.target2 ~= nil then
			self.target2:Remove()
		end
		
		self.target2 = ents.Create("info_target")
		self.target2:SetPos(Owner:GetShootPos() + (Owner:GetAimVector() * math.random(-100000, 0)) + Vector(0, 0, 50000))
        self.target2:SetKeyValue("targetname", "target2")
		self.target2:Spawn()
		self.target2:Activate()
		self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		
		self.canister = ents.Create("env_headcrabcanister")
		self.canister:SetPos(self.hitpos)


		local Offset = self.target2:GetPos() - self.hitpos
		local Angle = Offset:Angle()

		self.canister:SetAngles(Angle)
			self.canister:SetKeyValue("HeadcrabType", 0)
			self.canister:SetKeyValue("HeadcrabCount", 0)
			self.canister:SetKeyValue("LaunchPositionName", "target2")
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
		WMPhantomLastFired = CurTime()
		local melon = ents.Create("lap_canistertimer");
			melon:SetPos(self.hitpos);
			melon.Team = 7;
			melon:Spawn();
			melon:Activate();
		fail = 0
		Owner:PrintMessage(HUD_PRINTCENTER, "Phantom Melon Strike Launched")
		self.Weapon:SetNextSecondaryFire(CurTime() + 0.8)
		
		return false
    end
end


function TOOL.BuildCPanel (CPanel)
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Melon Strike");
	CPanel:AddPanel(VGUI);

end