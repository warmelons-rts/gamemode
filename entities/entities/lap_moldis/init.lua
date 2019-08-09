include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

DEFINE_BASECLASS( "base_warmelon" )

-- Setting up all the different properties of our melon.
ENT.Move = false;
ENT.Delay = 0.5;
ENT.Healthlol = 500;
ENT.FiringRange = 1000;
ENT.NoMoveRange = 50;
ENT.Speed = 0
ENT.MinRange = 0;
ENT.DeathRadius = 200;
ENT.DeathMagnitude = 65;
ENT.MovingForce = 200;
ENT.MelonModel = "addons/wmm/models/wmm/molecular.mdl";
local chancePerConstraint = 0.01 --1%
--ambient/levels/citadel/zapper_loop1.wav
--ambient/levels/citadel/zapper_loop2.wav

-- Now we tell the base class to set up the melon. Pay attention - the variables must be defined BEFORE calling Setup().
function ENT:Initialize()
	self:Setup();
	local oldangles = self.Entity:GetAngles()
	self.Entity:SetAngles(Angle(0,0,0))
	self.StdMat = "models/props_combine/stasisfield_beam";
	self.Entity:SetMaterial("models/props_combine/stasisfield_beam");
	self.jTarget = ents.Create("info_target");
	self.jTarget:SetPos(self.Entity:GetPos());
	self.jTargetName = "johnnylaser" .. self.Entity:EntIndex();
	self.jTarget:SetKeyValue("targetname", self.jTargetName);
	self.jTarget:Spawn();
	self.jTarget:Activate();
	self.Entity:DeleteOnRemove(self.jTarget);
	self.jLaser = ents.Create("env_laser");
	self.jLaser:SetPos(self.Entity:LocalToWorld(self.Entity:OBBCenter() + Vector(0,0,self.Entity:OBBMaxs().z)));
	self.jLaser:SetAngles(self.Entity:GetAngles());
	self.jLaser:SetKeyValue("texture", "trails/electric.vmt");
	self.jLaser:SetKeyValue("texturescroll", 20);
	self.jLaser:SetKeyValue("damage", 0);
	self.jLaser:SetKeyValue("dissolvetype", 1);
	self.jLaser:SetKeyValue("width", 20);
	self.jLaser:SetKeyValue("force", 0);
	self.jLaser:SetKeyValue("LaserTarget", self.jTargetName);
	self.jLaser:SetKeyValue("renderamt", 255);
	self.jLaser.Team = self.Team
		if (self.Team == 1) then
		self.jLaser:SetKeyValue("rendercolor", "255 0 0");
		end
		if (self.Team == 2) then
		self.jLaser:SetKeyValue("rendercolor", "0 0 255");
		end
		if (self.Team == 3) then
		self.jLaser:SetKeyValue("rendercolor", "0 255 0");
		end
		if (self.Team == 4) then
		self.jLaser:SetKeyValue("rendercolor", "255 255 0");
		end
		if (self.Team == 5) then
		self.jLaser:SetKeyValue("rendercolor", "255 0 255");
		end
		if (self.Team == 6) then
		self.jLaser:SetKeyValue("rendercolor", "0 255 255");
		end	
		if (self.Team == 7) then
		self.jLaser:SetKeyValue("rendercolor", "50 50 50");
		end	
	self.jLaser:Spawn();
	self.jLaser:Activate();
	self.jLaser:SetParent(self.Entity);
	self.jLaser:Fire("turnoff", "", 0);
	self.Entity:DeleteOnRemove(self.jLaser);
	self.Entity:SetAngles(oldangles)
end

function ENT:TargetSearch ()
	--self.jLaser:SetPos(self.Entity:GetPos()+(self.Entity:GetAngles()-Angle(90, 0, 0)):Forward()*60)
	if self.asploded then return end
	if WMPause == true then return end
	if self.Firing then
	self.jLaser:Fire("turnoff", "", 0);
	self.sound:Stop()
	self.Firing = false
	end
	local entz = ents.FindInSphere(self.Entity:GetPos(), self.FiringRange)
	for k, v in pairs(entz) do
	local phys = v:GetPhysicsObject()
		if v.Warmelon && v:GetClass() == "melon_baseprop" && (constraint.HasConstraints(v) || (phys:IsValid() && !phys:IsMoveable())) then
			if (v.Team ~= self.Team) then
				local traceRes=util.QuickTrace (self.jLaser:GetPos(), v:GetPos()-self.jLaser:GetPos(), self.Entity);
				if traceRes.Entity == v then
				  if v.Team ~= nil && v.Team < 0 then
				    if math.random(0, 10) > 7 then
					self.Target = v;
					break;
					end
         		  else
				  self.Target = v;
				  break;
				  end
			     end
			end
		end
	end
end

local function Dissasemble(ent, chance)
	
	if ent.Constraints ~= nil then
		for k, v in pairs (ent.Constraints) do
			if math.Rand(0,1) < chance then
				if v:IsValid() then
					v:Remove()
					return true
				end
				--timer.Simple(math.Rand(0,5), ConstraintRape, v)
			end    
		end
	end
	
	return false
	
end

--This function gets only the entities that is directly constrained to target entity, instead of whole contraption
local function GetDirectlyConstrainedEntities( ent )
	
	if ( !ent ) then return end
	if ( !ent:IsValid() ) then return end
	
	--constraint.GetTable( entity ) is a function which lack documentation in gmod wiki.
	--It returns a table of the constraints on the entity.
	local conTable = constraint.GetTable( ent )
	
	local returnTable = {}
	
	for key1, cons in pairs (conTable) do
		
		--We are only interested about constrained entities
		for key2, entity in pairs (cons.Entity) do
			
			--Entities are a table of index, entity and such, and we want the actuall entity
			local actuallEntity = entity.Entity
			
			--This way we fill the returnTable with one index of every entity in the conTable, including the one we got conTable from.
			returnTable[actuallEntity] = actuallEntity
			
		end
		
	end
	
	return returnTable
	
end

--What to do when we've found a target, and we've got the goahead to start attacking
function ENT:Attack ()
	
	local mat = self.Target:GetMaterial()
	
    --for k, v in pairs (constraint.GetAllConstrainedEntities( self.Target )) do
	for k, v in pairs (GetDirectlyConstrainedEntities( self.Target )) do
		
		local phys = v:GetPhysicsObject()
        if phys:IsValid() then
			phys:EnableMotion(true)
        end
		
		timer.Simple( 3, function(ent, mat) if (ent) then ent:SetMaterial(mat) end end, v, v:GetMaterial() )
		v:SetMaterial("models/alyx/emptool_glow")
		
		if (Dissasemble(v, chancePerConstraint)) then
			--We dont want stuff flying around after dissasembling, unless it is supposed to
			if (phys:IsValid() and !v.Grav) then
				phys:EnableGravity(true)
			end
		end
		
    end
	
    local phys = self.Target:GetPhysicsObject()
    if phys:IsValid() then
		phys:EnableMotion(true)
    end
	
	Dissasemble(self.Target, chancePerConstraint)
	
    timer.Simple( 3, function(ent, mat) if (ent) then ent:SetMaterial(mat) end end, self.Target, self.Target:GetMaterial() )
	
	self.Target:SetMaterial("models/alyx/emptool_glow")
	
	self.Target:TakeDamage(1, self.Entity);
	self.jTarget:SetPos(self.Target:GetPos());
	self.jLaser:Fire("turnon", "", 0);
	if !self.Firing then
	self.sound = CreateSound(self.Entity, "ambient/levels/labs/teleport_malfunctioning.wav")
	self.sound:Play()
	self.Firing = true
	end
end

function ENT:DoAttacks ()
if GetConVarNumber( "WM_Pause", 0 ) ~= 1  && self.HoldFire ~= 1 then
	if self.Target == nil || !self.Target:IsValid() || self.Target.Team == self.Team then
		self:TargetSearch();
		return
	end
	local phys = self.Target:GetPhysicsObject()
	local traceRes=util.QuickTrace (self.jLaser:GetPos(), self.Target:GetPos()-self.jLaser:GetPos(), self.Entity);
	--Checking that the target is still in range, and that we still have LOS.
	if traceRes.Entity == self.Target && self.Target:GetPos():Distance(self.Entity:GetPos()) < self.FiringRange && (constraint.HasConstraints(self.Target)  || (phys:IsValid() && !phys:IsMoveable())) then
		self:Attack();
	else
		self:TargetSearch();
	end
end
end

--Any other code you want to tag on to the end of the think function.
function ENT:OtherThoughts()
	--self.jLaser:SetPos(self.Entity:GetPos()+self.Entity:GetAngles():Forward()*10);
end