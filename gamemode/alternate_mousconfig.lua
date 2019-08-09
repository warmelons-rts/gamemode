local KeyEvents = false 
 local check = 0
 local function KeyThink()

      if ( input.IsMouseDown(107) && !KeyEvents && input.IsMouseDown(109)) then // mouse1
		RunConsoleCommand("+wmselect")
		KeyEvents = true 
		elseif ( !input.IsMouseDown(107) && KeyEvents && input.IsMouseDown(109)) then // The key has been released
			 RunConsoleCommand("-wmselect")
			 KeyEvents = false
		elseif ( input.IsMouseDown(107) &&  !input.IsMouseDown(109) && !input.IsKeyDown(27)) then
		RunConsoleCommand("+attack")
		elseif ( !input.IsMouseDown(107) &&  !input.IsMouseDown(109) && !input.IsKeyDown(27)) then 
		RunConsoleCommand("-attack")
		elseif ( input.IsMouseDown(108) && input.IsMouseDown(109)) then //mouse2
		RunConsoleCommand("wmorder")
		elseif ( input.IsMouseDown(108) &&  !input.IsMouseDown(109)) then
		RunConsoleCommand("+attack2")
		elseif ( !input.IsMouseDown(108) &&  !input.IsMouseDown(109)) then
		RunConsoleCommand("-attack2")
		
     end
    end 
	 hook.Add("Think", "KeyThink", KeyThink)