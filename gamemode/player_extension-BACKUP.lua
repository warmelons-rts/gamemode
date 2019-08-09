local meta = FindMetaTable( "Player" ) 
   
 // Return if there's nothing to add on to 
 if (!meta) then return end 
 
 g_SBoxObjects = {} 
   
 /*--------------------------------------------------------- 
     Name: GetWebsite 
 ---------------------------------------------------------*/ 
 function meta:GetWebsite() 
 	return self:GetNWString( "Website", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetLocation 
 ---------------------------------------------------------*/ 
 function meta:GetLocation() 
 	return self:GetNWString( "Location", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetEmail 
 ---------------------------------------------------------*/ 
 function meta:GetEmail() 
 	return self:GetNWString( "Email", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetMSN 
 ---------------------------------------------------------*/ 
 function meta:GetMSN() 
 	return self:GetNWString( "MSN", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetAIM 
 ---------------------------------------------------------*/ 
 function meta:GetAIM() 
 	return self:GetNWString( "AIM", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetGTalk 
 ---------------------------------------------------------*/ 
 function meta:GetGTalk() 
 	return self:GetNWString( "GTalk", "N/A" ) 
 end 
   
 /*--------------------------------------------------------- 
     Name: GetXFire 
 ---------------------------------------------------------*/ 
 function meta:GetXFire() 
 	return self:GetNWString( "XFire", "N/A" ) 
 end 
   
local function PlayerUnfreezeObject( ply, ent, object )

	// Not frozen!
	if ( object:IsMoveable() ) then return 0 end
	
	// Unfreezable means it can't be frozen or unfrozen.
	// This prevents the player unfreezing the gmod_anchor entity.
	if ( ent:GetUnFreezable() ) then return 0 end
	
	// NOTE: IF YOU'RE MAKING SOME KIND OF PROP PROTECTOR THEN HOOK "CanPlayerUnfreeze"
	if ( !gamemode.Call( "CanPlayerUnfreeze", ply, ent, object ) ) then return 0 end

	object:EnableMotion( true )
	object:Wake()
	
	gamemode.Call( "PlayerUnfrozeObject", ply, ent, object )
	
	return 1
	
end
   
function meta:PhysgunUnfreeze( weapon )

	// Get the player's table
	local tab = self
	if (!tab.FrozenPhysicsObjects) then return 0 end

	// Detect double click. Unfreeze all objects on double click.
	--if ( tab.LastPhysUnfreeze && CurTime() - tab.LastPhysUnfreeze < 0.25 ) then
	--	return self:UnfreezePhysicsObjects()
	--end
		
	local tr = self:GetEyeTrace()
	if ( tr.HitNonWorld && IsValid( tr.Entity ) ) then
	
		local Ents = constraint.GetAllConstrainedEntities( tr.Entity )
		local UnfrozenObjects = 0
		local teem = self:Team()
		for k, ent in pairs( Ents ) do
			if self:Team() == 0 || (ent.Team ~= nil && ent.Team == teem && ent:GetClass() ~= "lap_capfort") then
				local objects = ent:GetPhysicsObjectCount()
		
				for i=1, objects do
		
					local physobject = ent:GetPhysicsObjectNum( i-1 )
					UnfrozenObjects = UnfrozenObjects + PlayerUnfreezeObject( self, ent, physobject )
			
				end
			end
		
		end
	

		
		return UnfrozenObjects
	
	end
	
	tab.LastPhysUnfreeze = CurTime()	
	return 0

end

   
function meta:CheckLimit( str ) 

	// No limits in single player 
	if (game.SinglePlayer()) then return true end
	if self:GetNWInt("chosenone") == 1 || self:Team() == 0 then return true end
	local c = GetConVarNumber( "sbox_max"..str, 0 )
	local d	= 0
	if str == "lap_melons" then
		d = GetConVarNumber( "WM_MaxMelonsPerTeam", 0 ) + (TeamCaps[self:Team()] * GetConVarNumber("WM_MelonBonusPerCap",2))
		if GetGlobalInt("WM_" .. team.GetName(self:Team()) .. "Melons") >= d then
			self:PrintMessage(HUD_PRINTCENTER, "Your team is at their maximum amount of melons (" .. d .. ").")
			
			return false
		end
	end
	if ( c < 0 ) then return true end 
	if (str == "lap_melons") then
		d = d / team.NumPlayers( self:Team() )
		if (d > c) then
			if (self:GetCount( str ) > d-1 ) then
				self:LimitHit( str )
				return false
			end
		else
			if ( self:GetCount( str ) > c-1 ) then
				self:LimitHit( str )
				return false
			end
		end
	else
		if ( self:GetCount( str ) > c-1 ) then
			self:LimitHit( str )
			return false
		end
	end

	return true

end

 function meta:GetCount( str, minus ) 
 	if ( CLIENT ) then 
 		return self:GetNWInt( "Count."..str, 0 ) 
 	end 
 	 
 	minus = minus or 0 
 	 
 	if ( !self:IsValid() ) then return end 
   
 	local key = self:UniqueID() 
 	local tab = g_SBoxObjects[ key ] 
 	 
 	if ( !tab || !tab[ str ] ) then  
 	 
 		self:SetNWInt( "Count."..str, 0 ) 
 		return 0  
 		 
 	end 
 	 
 	local c = 0 
 	 
 	for k, v in pairs ( tab[ str ] ) do 
 	 
 		if ( v:IsValid() ) then  
 			c = c + 1 
 		else 
 			tab[ str ][ k ] = nil 
 		end 
 	 
 	end 
 	 
 	self:SetNWInt( "Count."..str, c - minus )
 	if str == "lap_melons" then
 	--SetGlobalInt("WM_" .. team.GetName(self:Team()) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self:Team()) .. "Melons") - minus)
 	end
 	return c
   
 end 
   
 function meta:AddCount( str, ent ) 
      	if self:GetNWInt("chosenone") == 1 then return true end
 	if ( SERVER ) then 
   
 		local key = self:UniqueID() 
 		g_SBoxObjects[ key ] = g_SBoxObjects[ key ] or {} 
 		g_SBoxObjects[ key ][ str ] = g_SBoxObjects[ key ][ str ] or {} 
 		 
 		local tab = g_SBoxObjects[ key ][ str ] 
 		 
 		table.insert( tab, ent ) 
 		if str == "lap_melons" then
			--SetGlobalInt("WM_" .. team.GetName(self:Team()) .. "Melons", GetGlobalInt("WM_" .. team.GetName(self:Team()) .. "Melons") + 1)
		end
 		// Update count (for client) 
 		self:GetCount( str ) 
 		ent:CallOnRemove( "GetCountUpdate", function( ent, ply, str ) ply:GetCount(str, 1) end, self, str ) 
 	 
 	end 
   
 end 

function meta:AddMelonCount( ent )
	
	if ( SERVER ) then 
		
		melonCount[self:Team()] = melonCount[self:Team()] or {}
		
		table.insert( melonCount[self:Team()], ent )
		
	end
	
end
   
 function meta:LimitHit( str ) 
   
 	self:SendLua( "GAMEMODE:LimitHit( '".. str .."' )" ) 
   
 end 
   
 function meta:AddCleanup( type, ent ) 
   
 	cleanup.Add( self, type, ent ) 
 	 
 end 
   
 function meta:GetTool( mode ) 
   
 	local wep = self:GetWeapon( "gmod_tool" ) 
 	if (!wep || !wep:IsValid()) then return nil end 
 	 
 	local tool = wep:GetToolObject( mode ) 
 	if (!tool) then return nil end 
 	 
 	return tool 
   
 end 
   
 if (SERVER) then 
   
 	function meta:SendHint( str, delay ) 
   
 		self.Hints = self.Hints or {} 
 		if (self.Hints[ str ]) then return end 
 		 
 		self:SendLua( "GAMEMODE:AddHint( '"..str.."', "..delay.." )" ) 
 		self.Hints[ str ] = true 
   
 	end 
 	 
 	function meta:SuppressHint( str ) 
   
 		self.Hints = self.Hints or {} 
 		if (self.Hints[ str ]) then return end 
 		 
 		self:SendLua( "GAMEMODE:SuppressHint( '"..str.."' )" ) 
 		self.Hints[ str ] = true 
   
 	end 
   
 end  