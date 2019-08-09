

sbgrav = {}
local planets = {}



function sbgrav.getplanetztolua()
	local i = 0
	
	CreateConVar( "gm_sbx_gravitypull", "0" , FCVAR_NOTIFY)
	CreateConVar( "gm_sbx_gravitydecaystep", "1400" , FCVAR_NOTIFY )
	CreateConVar( "gm_sbx_spacedrag", "1" , FCVAR_NOTIFY )
	
	entities = ents.FindByClass( "logic_case" )
	for _,p in pairs(entities) do
		local isPlanet = 0
		local pl = {}
		local values = p:GetKeyValues()
		for key, value in pairs(values) do
			if key == "Case01" and (value == "planet" || value == "planet2" ) then isPlanet = 1 end
			if (key == "Case02") then pl.radi = tonumber(value) end
			if (key == "Case03") then pl.grav = tonumber(value) end
		end
		pl.pos = p:GetPos()
		if isPlanet == 1 then
			table.insert( planets, pl )
		end
	end
end


--[[ function sbgrav.think()//I think spacebuild is required for this part, disabled for now.
	if sbgrav.ThinkDelay <= 0 then
		if #planets == 0 then return end
		
		local gpull = GetConVarNumber( "gm_sbx_gravitypull" )
		local drag = GetConVarNumber( "gm_sbx_spacedrag" )
		
		local junk_in_space = ents.GetAll( )
		for _,j in pairs(junk_in_space) do
			if (j:GetPhysicsObject():IsValid() and !j:IsPlayer() and !j:IsWorld() and !j:IsWeapon() ) then
				local inat = false
				local pos = j:GetPos()
				local phy = j:GetPhysicsObject()
				local vel
				if phy:IsValid() && gpull != 0 then
					vel = phy:GetVelocity()
				end
				for _,p in pairs(planets) do
					if (pos:Distance(p.pos) > p.radi && inat == false) then
					
						if gpull != 0 then vel = vel + sbgrav.gravtosurface( pos, p ) * gpull end
					else
						if j.Grav == nil || (j.Grav ~= nil &&  j.Grav == true) then
						phy:EnableGravity(true)
						if drag == 0 then phy:EnableDrag( true ) end
						inat = true
						break
						end
					end
				end
				if inat == false then
					 if j.Grav == nil || (j.Grav ~= nil &&  j.Grav == true) then
					if gpull != 0 then phy:SetVelocity(vel) end
					phy:EnableGravity(false)
					if drag == 0 then phy:EnableDrag(false) end
					end
				end
			end
		end
	else
	sbgrav.ThinkDelay = sbgrav.ThinkDelay - 1
	end

end ]]



function sbgrav.gravtosurface( pos, ind )

	local gdecay = GetConVarNumber( "gm_sbx_gravitydecaystep" )
	
	if gdecay == 0 then gdecay = 1 end
	
	local vec = pos - ind.pos
	vec = vec:GetNormalized()
	local dis = pos:Distance(ind.pos)
	dis =  dis - ind.radi
	dis = dis / gdecay
	
	if dis != 0 then dis = 1/(dis * 2) end --don't divide by zero!
	if dis > 1 then dis = 1 end
	
	vec = vec * dis * ind.grav * -1
	return vec
end


function sbgrav.start()
		sbgrav.ThinkDelay = 20
		sbgrav.getplanetztolua()
end
hook.Add( "Think", "sbgravinit", sbgrav.think )
hook.Add( "InitPostEntity", "sbgravinit", sbgrav.start )