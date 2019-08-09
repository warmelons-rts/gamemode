
/*----------------------------------------------------------------------
	MotorControl( pl, motor, onoff, dir )
	Numpad controls for the motor constraints
----------------------------------------------------------------------*/
local function MotorControl( pl, motor, onoff, dir )

	if (!motor:IsValid()) then return false end

	local activate = false
	
	if (motor.toggle == 1) then
		
		// Toggle mode, only do something when the key is pressed
		// if the motor is off, turn it on, and vice-versa.
		// This only happens if the same key as the current
		// direction is pressed, otherwise the direction is changed
		// with the motor being left on.
		
		if (onoff) then
		
			if (motor.direction == dir or !motor.is_on) then
			
				// Direction is the same, Activate if the motor is off
				// Deactivate if the motor is on.

				motor.is_on = !motor.is_on

				activate = motor.is_on

			else
			
				// Change of direction, make sure it's activated
			
				activate = true
				
			end
			
		else
		
			return
			
		end
		
	else
	
		// normal mode: activate is based on the key status
		// (down = on, up = off)
		
		activate = onoff
		
	end
	
	if (activate) then
	
		motor:Fire( "Activate", "", 0 )		// Turn on the motor
		motor:Fire( "Scale", dir, 0)		// This makes the direction change
		
	else
		motor:Fire( "Deactivate", "", 0 )	// Turn off the motor
	end
	
	motor.direction = dir
	
	return true
	
end

numpad.Register( "MotorControl", MotorControl )

/*----------------------------------------------------------------------
	Motor( ... )
	Creates a motor constraint
----------------------------------------------------------------------*/
function Motor( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, forcetime, nocollide, toggle, pl, forcelimit, numpadkey_fwd, numpadkey_bwd, direction, LocalAxis )
local cost =  torque * server_settings.Int( "WM_WheelandThrusterCost", 4 )
Msg("RAWR")
	if pl:GetNetworkedInt("chosenone", 0) ~= 1 then
	    if !NRGCheck(pl, cost)  then return false end
	    end
	if ( !CanConstrain( Ent1, Bone1 ) ) then return false end
	if ( !CanConstrain( Ent2, Bone2 ) ) then return false end
	
	// Get information we're about to use
	local Phys1 = Ent1:GetPhysicsObjectNum( Bone1 )
	local Phys2 = Ent2:GetPhysicsObjectNum( Bone2)
	local WPos1 = Phys1:LocalToWorld( LPos1 )
	local WPos2 = Phys2:LocalToWorld( LPos2 )
	
	if ( Phys1 == Phys2 ) then return false end
	
	if ( LocalAxis ) then
		WPos2 = Phys1:LocalToWorld( LocalAxis )
	end

	// The true at the end stops it adding the axis table to the entity's count stuff.
	local axis = Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, 0, 0, friction, nocollide, LocalAxis, true )

	// Delete the axis when either object dies
	Ent1:DeleteOnRemove( axis )
	Ent2:DeleteOnRemove( axis )
	
	// Create the constraint 
	onStartConstraint( Ent1, Ent2 )
	
		local Constraint = ents.Create("phys_torque")
			Constraint:SetPos( WPos1 )
			Constraint:SetKeyValue( "axis", tostring( WPos2 ) ) 
			Constraint:SetKeyValue( "force", torque )
			Constraint:SetKeyValue( "forcetime", forcetime )
			Constraint:SetKeyValue( "spawnflags", 4 )
			Constraint:SetPhysConstraintObjects( Phys1, Phys1 )
		Constraint:Spawn()
		Constraint:Activate()

	onFinishConstraint( Ent1, Ent2 )
	
	AddConstraintTableNoDelete( Ent1, Constraint, Ent2 )
	
	direction = direction or 1
	
	LocalAxis = Phys1:WorldToLocal( WPos2 )
	
	
	
	local ctable = 
	{
		Type 		= "Motor",
		Ent1  		= Ent1,
		Ent2  		= Ent2,
		Bone1 		= Bone1,
		Bone2 		= Bone2,
		LPos1 		= LPos1,
		LPos2 		= LPos2,
		friction 	= friction,
		torque 		= torque,
		forcetime 	= forcetime,
		nocollide 	= nocollide,
		toggle 		= toggle,
		pl 		= pl,
		forcelimit 	= forcelimit,
		forcescale 	= 0,
		direction 	= direction,
		is_on		= false,
		numpadkey_fwd 	= numpadkey_fwd,
		numpadkey_bwd 	= numpadkey_bwd,
		LocalAxis		= LocalAxis
	}

	Constraint:SetTable( ctable )

	if (numpadkey_fwd) then
	
		numpad.OnDown( 	 pl, 	numpadkey_fwd, 	"MotorControl", 	Constraint,		true,	1 )
		numpad.OnUp( 	 pl, 	numpadkey_fwd, 	"MotorControl", 	Constraint,		false,	1 )
	end
		
	if (numpadkey_bwd) then

		numpad.OnDown( 	 pl, 	numpadkey_bwd, 	"MotorControl", 	Constraint,		true,	-1 )
		numpad.OnUp( 	 pl, 	numpadkey_bwd, 	"MotorControl", 	Constraint,		false,	-1 )

	end
	
	return Constraint, axis
	
end
duplicator.RegisterConstraint( "Motor", Motor, "Ent1", "Ent2", "Bone1", "Bone2", "LPos1", "LPos2", "friction", "torque", "forcetime", "nocollide", "toggle", "pl", "forcelimit", "numpadkey_fwd", "numpadkey_bwd", "direction", "LocalAxis" )
