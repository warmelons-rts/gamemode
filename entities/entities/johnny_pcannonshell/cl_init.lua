include("shared.lua");
function ENT:Init()
	--peffect = ClientsideModel("models/Effects/combineball.mdl", RENDERGROUP_TRANSLUCENT)
	peffect = ClientsideModel("models/props_borealis/bluebarrel001.mdl", RENDERGROUP_TRANSLUCENT)
	peffect:SetParent(self.Entity)
	peffect2 = ents.Create("prop_physics")
	peffect2:SetPos(self.Entity:GetPos())
	peffect2:SetModel("models/props_combine/portalball.mdl")
	peffect2:SetParent(self)
	peffect2:Spawn()
	peffect2:Activate()
	self.Entity:SetModelScale(0.5, 1)
	if (self.Team == 1) then
	self.Entity:SetColor (Color(125, 0, 0, 255))
	elseif (self.Team == 2) then
	self.Entity:SetColor (Color(0, 0, 125, 255))
	elseif (self.Team == 3) then
	self.Entity:SetColor (Color(0, 125, 0, 255))
	elseif (self.Team == 4) then
	self.Entity:SetColor (Color(125, 125, 0, 255))
	elseif (self.Team == 5) then
	self.Entity:SetColor (Color(125, 0, 125, 255))
	elseif (self.Team == 6) then
	self.Entity:SetColor (Color(0, 125, 125, 255))
	elseif (self.Team == 7) then
	self.Entity:SetColor (Color(100, 100, 100, 255))
	end
end

function ENT:Draw ()
	--local finalangle = LocalPlayer():EyeAngles()
	--local finalangle = Angle(math.Rand(-180,180),math.Rand(-180,180), math.Rand(-180,180))
	--self.Entity:SetRenderAngles(finalangle)
	self.Entity:DrawModel();
	self.Entity:SetModelScale(0.5, 1)
end