--I'm going to have to give most of the credit for this method to the Infected Wars team. Their math fuels most of this code.
local stances = {"Stand Ground", "Defensive", "Offensive", "Berszerk", "Hold Fire", "Fire at Will", "Load", "Unload"}

function GetCurrentStance()
	
	local x = ScrW()/2 - gui.MouseX()
	local y = ScrH()/2 - gui.MouseY()
	local step = 360 / #stances
	if math.abs(x) + math.abs(y) < 75 then
	return "fail"
	else
	local angle = math.deg(math.atan2(-x,y))
	if angle < 0 then 
    angle = angle + 360
    end
	local j = math.Round(angle / step) + 1
    	if (j > #stances)then 
    		j = 1	
    	end
	return j
	end
end

function StanceMenuPaint()
	
	local ply = LocalPlayer()
	local teamcol = team.GetColor(ply:Team())
	if #stances > 0 then
		local count = #stances
		local dist = 360 / count
		
		surface.SetDrawColor(teamcol)
		if (gui.MouseX() ~= 0 && gui.MouseY() ~= 0) then
			surface.DrawLine((ScrW()/2),(ScrH()/2),gui.MouseX(),gui.MouseY())
		end
		local angle = 180
		for k, item in pairs(stances) do
			local x = (ScrW()/2) + (math.sin(math.rad(angle)) * 135)
			local y = (ScrH()/2) + (math.cos(math.rad(angle)) * 135)

			local color = teamcol
			if k > 4 && k < 7 then
    			local r = color.r
    			local g = color.g
    			local b = color.b
    			if r == 0 then
    			r = 255
    			else
    			r = 0
    			end
    			if g == 0 then
    			g = 255
    			else
    			g = 0
    			end
    			if b == 0 then
    			b = 255
    			else
    			b = 0
    			end
    		color = Color(r,g,b,255)
    		elseif k > 6 then
    		color = Color(115,115,115,255)
			end
			local color2 = Color(0,0,0,255)
			if (GetCurrentStance() == k) then
				color2 = Color(255,255,255,255)
			end
			local w = 110
			local h = 40
			draw.RoundedBox( 10, x-(w/2),y - (h/2),w,h, Color(0, 0, 0, 200) )
			draw.SimpleTextOutlined(item,"Default",x ,y, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color2 )			
			--draw.SimpleTextOutlined(item,"MenuLarge",x ,y, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color2 )--REPLACED WITH THE ONE ABOVE
		
			angle = angle - dist
		end
	end
end

function StanceStart()
	gui.EnableScreenClicker(true) 
	gui.SetMousePos(ScrW()/2,ScrH()/2)
hook.Add("HUDPaint","StanceMenuPaint",StanceMenuPaint)
hook.Add("GUIMousePressed","StanceClick",StanceClick)
end

function StanceClick(num)
if num == 107 then
RunConsoleCommand("-wmstanceradial")
end
end

function StanceEnd()
local selection = GetCurrentStance()
if selection ~= "fail" then
RunConsoleCommand("wmstanceselect", selection - 1)
	if selection == 2 then
		for k,v in pairs (WMSelected) do
			if v.Stance ~= nil then
			v.Stance = "\nDefensive"
			end
		end
	elseif selection == 3 then
		for k,v in pairs (WMSelected) do
			if v.Stance ~= nil then
				if v:GetClass() == "lap_bomb_clone" || v:GetClass() == "lap_bomb" || v:GetClass() == "lap_kaboom" then
				v.Stance = "\nExplode on Contact"
				else
				v.Stance = "\nOffensive"
				end
			end
		end
	elseif selection == 4 then
		for k,v in pairs (WMSelected) do
			if v.Stance ~= nil then
			v.Stance = "\nBerzerk"
			end
		end
	elseif selection == 5 then
		for k,v in pairs (WMSelected) do
			v.HoldFire = "\nHolding Fire"
		end
	elseif selection == 6 then
		for k,v in pairs (WMSelected) do
			v.HoldFire = ""
		end
	elseif selection == 7 then
		for k,v in pairs (WMSelected) do
			v.Load = "\nLoading"
		end
	elseif selection == 8 then
		for k,v in pairs (WMSelected) do
			v.Load = "\nUnloading"
		end
	end
end
hook.Remove("HUDPaint","StanceMenuPaint")
hook.Remove("GUIMousePressed","StanceClick")
gui.EnableScreenClicker(false)
end

concommand.Add("+wmstanceradial", StanceStart);
concommand.Add("-wmstanceradial", StanceEnd);

teleportlocations = {"New TP Marker"}
--teleportlocations[0] = "New TP Marker"
local tpoptions = {"Delete", "Rename", "Overwrite"}

function GetCurrentTPSel()
	
	local x = ScrW()/2 - gui.MouseX()
	local y = ScrH()/2 - gui.MouseY()
	local step = 360 / table.Count(teleportlocations)
	if math.abs(x) + math.abs(y) < 110 then
	return "cycle"
	else
	local angle = math.deg(math.atan2(-x,y))
    	if angle < 0 then 
        angle = angle + 360
        end
	local j = math.Round(angle / step) + 1
    	if (j > table.Count(teleportlocations))then 
    		j = 1	
    	end
	return j
	end
end

function GetCurrentTPSel2(origin)
	local x = ScrW()/2 - gui.MouseX()
	local y = ScrH()/2 - gui.MouseY()
	local step = 360 / (table.Count(teleportlocations) * 12)
	local origin = math.abs(origin - 180)
        if math.abs(x) + math.abs(y) > 275 then
    	local angle = math.deg(math.atan2(-x,y))
        	if angle < 0 then 
            angle = angle + 360
            end
    	local j = math.AngleDifference(angle,origin)
        	if j <=  -step then
        	j = 3
        	elseif j > -step && j < step then
        	j = 2
        	elseif j >= step then
        	j = 1
        	end
        --LocalPlayer():PrintMessage(HUD_PRINTTALK, j )         
    	return j
    	else
    	return 9999
    	end
end

local submenu = 1
local submenupointer = 1
function TeleportMenuPaint()
if LocalPlayer():KeyDown(IN_JUMP) then
RunConsoleCommand("-wmteleportradial")
end	
	local ply = LocalPlayer()
	local teamcol = team.GetColor(ply:Team())
	if table.Count(teleportlocations) > 0 then
		local count = table.Count(teleportlocations)
		local dist = 360 / count
		
		surface.SetDrawColor(teamcol)
		if (gui.MouseX() ~= 0 && gui.MouseY() ~= 0) then
			surface.DrawLine((ScrW()/2),(ScrH()/2),gui.MouseX(),gui.MouseY())
		end
		local angle = 180
		local w = 110
		local h = 40
		local tempcount = 0
		for k, item in pairs(teleportlocations) do
		tempcount = tempcount + 1
			local x = (ScrW()/2) + (math.sin(math.rad(angle)) * 135)
			local y = (ScrH()/2) + (math.cos(math.rad(angle)) * 135)

			local color = teamcol
			if k == 1 then
    			local r = color.r
    			local g = color.g
    			local b = color.b
    			if r == 0 then
    			r = 255
    			else
    			r = 0
    			end
    			if g == 0 then
    			g = 255
    			else
    			g = 0
    			end
    			if b == 0 then
    			b = 255
    			else
    			b = 0
    			end
    		color = Color(r,g,b,255)
			end
			local color2 = Color(0,0,0,255)
			if (GetCurrentTPSel() == tempcount) then
				color2 = Color(255,255,255,255)
				submenupointer = k
			     if tempcount ~= 1 then
        			     
        			local subangle = 180 / (table.Count(teleportlocations) * 3) * -1
        			local insubmenu = false
            		  for e, r in pairs (tpoptions) do
            		    
                		 local x2 = (ScrW()/2) + (math.sin(math.rad(angle + subangle)) * 275)
            			 local y2 = (ScrH()/2) + (math.cos(math.rad(angle + subangle)) * 275)
            			 local color4 = Color(0,0,0,255)
            			if GetCurrentTPSel2(angle) == e then 
                        color4 = Color(255,255,255,255)
                        submenu = e
                        insubmenu = true
                        elseif e == 3 && insubmenu == false then
                        submenu = 9999
                        end
                		draw.RoundedBox( 10, x2-(95/2),y2 - (30/2),95,30, Color(0, 0, 0, 125) )			
            			draw.SimpleTextOutlined(r,"MenuLarge",x2 ,y2, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color4 )
            			subangle = subangle + (180 / (table.Count(teleportlocations) * 3))
            		  end
            	 end
			end
			draw.RoundedBox( 10, x-(w/2),y - (h/2),w,h, Color(0, 0, 0, 200) )			
			draw.SimpleTextOutlined(item,"MenuLarge",x ,y, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color2 )
		
			angle = angle - dist
		end
		
		local color3 = Color(0,0,0,255)
		if GetCurrentTPSel() == "cycle" then color3 = Color(255,255,255,255) end
		draw.RoundedBox( 10, (ScrW()/2)-(w/2),(ScrH()/2) - (h/2),w,h, Color(0, 0, 0, 200) )			
		draw.SimpleTextOutlined("Cycle","MenuLarge",(ScrW()/2) ,(ScrH()/2), Color(100,100,100,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2,  color3 )
	end
end

function TeleportRadialStart()
	gui.EnableScreenClicker(true) 
	gui.SetMousePos(ScrW()/2,ScrH()/2)
hook.Add("HUDPaint","TeleportMenuPaint",TeleportMenuPaint)
hook.Add("GUIMousePressed","TeleportRadialClick",TeleportRadialClick)
end

function TeleportRadialClick(num)
if num == 107 then
RunConsoleCommand("-wmteleportradial")
end
end

function TeleportRadialEnd()
local menu1 = GetCurrentTPSel()
    if menu1 == "cycle" then
    RunConsoleCommand("WMTeleport", "cycle")
    elseif menu1 == 1 then
    RunConsoleCommand("WMTPlocation")
    elseif submenu == 9999 then
    RunConsoleCommand("WMTeleport", submenupointer - 1)
    elseif submenu == 1 then
    teleportlocations[submenupointer] = nil
    Msg(submenupointer)
    RunConsoleCommand("WMTeleport", submenupointer - 1, "delete")
    elseif submenu == 2 then
    WMTPRename(submenupointer)
    else
    RunConsoleCommand("WMTPlocation", submenupointer - 1)
    end
hook.Remove("HUDPaint","TeleportMenuPaint")
hook.Remove("GUIMousePressed","TeleportRadialClick")
gui.EnableScreenClicker(false)
end

function TPLocMsgHook( inf )
local num = inf:ReadShort() + 1
    if table.Count(teleportlocations) == 1 then
    teleportlocations[num] = 1
    else
    teleportlocations[num] = num - 1
    end
LocalPlayer():PrintMessage(HUD_PRINTTALK, "Teleport location saved in slot " .. num - 1 .. ".")
end
usermessage.Hook("WMTPMsg", TPLocMsgHook) 

concommand.Add("+wmteleportradial", TeleportRadialStart);
concommand.Add("-wmteleportradial", TeleportRadialEnd);

function WMTPRename(loc)
local TPRenamePanel = vgui.Create( "DFrame" ) -- Creates the frame itself
TPRenamePanel:SetPos( ScrW()/2 - 100, ScrH()/2 - 107) -- Position on the players screen
TPRenamePanel:SetSize( 200, 215 ) -- Size of the frame
TPRenamePanel:SetTitle( "Rename a Teleport Location")
TPRenamePanel:SetVisible( true )
TPRenamePanel:SetSizable(true)
TPRenamePanel:SetDraggable( true ) -- Draggable by mouse?
TPRenamePanel:ShowCloseButton( true ) -- Show the close button?
TPRenamePanel:MakePopup() -- Show the frame
local TextBox = vgui.Create( "DTextEntry", TPRenamePanel )
TextBox:SetPos( 77, 30)
TextBox:SetTall( 20 )
TextBox:SetWide( 65 )
TextBox:SetEnterAllowed( true )
TextBox:SetMultiline(false)
TextBox:SetUpdateOnType(true)
TextBox.m_bLoseFocusOnClickAway = false
TextBox.OnEnter = function()
    teleportlocations[loc] = string.sub(string.Trim(TextBox:GetValue()), 1, 14)
    TPRenamePanel:Remove()
    end
local VarTextLabel = vgui.Create( "Label", TPRenamePanel)
VarTextLabel:SetPos(5, 26)
VarTextLabel:SetText("Custom Name")
VarTextLabel:SizeToContents()

local CheckBox = vgui.Create( "DButton", TPRenamePanel )
CheckBox:SetPos( 152, 27 )
CheckBox:SetSize(25, 25)
CheckBox:SetText("")
CheckBox.Paint = function()
 	 local mat = Material( "gui/silkicons/check_off" )
 	surface.SetDrawColor( 255, 255, 255, 255 )
 	local length = string.len(TextBox:GetValue())
 	if length < 14 && length > 0 then
 	mat = Material( "gui/silkicons/check_on" )
 	end
 	surface.SetMaterial( mat ) 
 	CheckBox:DrawTexturedRect() 
end
CheckBox.DoClick = function()
    teleportlocations[loc] = TextBox:GetValue()
    TPRenamePanel:Remove()
    end


local BaseBox = vgui.Create( "DButton", TPRenamePanel )
BaseBox:SetText( "Home Base" )
BaseBox:SetPos( 10, 55 )
BaseBox:SetSize(85, 23)
BaseBox.DoClick = function()
    teleportlocations[loc] = "Home Base"
    TPRenamePanel:Remove()
    end
local UplinkBox = vgui.Create( "DButton", TPRenamePanel )
UplinkBox:SetText( "Uplink" )
UplinkBox:SetPos( 10, 80 )
UplinkBox:SetSize(85, 23)
UplinkBox.DoClick = function()
    teleportlocations[loc] = "Uplink"
    TPRenamePanel:Remove()
    end

local TargetBox = vgui.Create( "DButton", TPRenamePanel )
TargetBox:SetText( "Target 1" )
TargetBox:SetPos( 10, 105 )
TargetBox:SetSize(85, 23)
TargetBox.DoClick = function()
    teleportlocations[loc] = "Target 1"
    TPRenamePanel:Remove()
    end

local Target2Box = vgui.Create( "DButton", TPRenamePanel )
Target2Box:SetText( "Target 2" )
Target2Box:SetPos( 10, 130 )
Target2Box:SetSize(85, 23)
Target2Box.DoClick = function()
    teleportlocations[loc] = "Target 2"
    TPRenamePanel:Remove()
    end

local Outpost1Box = vgui.Create( "DButton", TPRenamePanel )
Outpost1Box:SetText( "Outpost 1" )
Outpost1Box:SetPos( 10, 155 )
Outpost1Box:SetSize(85, 23)
Outpost1Box.DoClick = function()
    teleportlocations[loc] = "Outpost 1"
    TPRenamePanel:Remove()
    end
local Outpost2Box = vgui.Create( "DButton", TPRenamePanel )
Outpost2Box:SetText( "Outpost 2" )
Outpost2Box:SetPos( 10, 180 )
Outpost2Box:SetSize(85, 23)
Outpost2Box.DoClick = function()
    teleportlocations[loc] = "Outpost 2"
    TPRenamePanel:Remove()
    end
    
--Second Column

local RedBox = vgui.Create( "DButton", TPRenamePanel )
RedBox:SetText( "Red" )
RedBox:SetPos( 105, 55 )
RedBox:SetSize(85, 23)
RedBox.DoClick = function()
    teleportlocations[loc] = "Red"
    TPRenamePanel:Remove()
    end
    
local BlueBox = vgui.Create( "DButton", TPRenamePanel )
BlueBox:SetText( "Blue" )
BlueBox:SetPos( 105, 80 )
BlueBox:SetSize(85, 23)
BlueBox.DoClick = function()
    teleportlocations[loc] = "Blue"
    TPRenamePanel:Remove()
    end
    
local GreenBox = vgui.Create( "DButton", TPRenamePanel )
GreenBox:SetText( "Green" )
GreenBox:SetPos( 105, 105 )
GreenBox:SetSize(85, 23)
GreenBox.DoClick = function()
    teleportlocations[loc] = "Green"
    TPRenamePanel:Remove()
    end
    
local YellowBox = vgui.Create( "DButton", TPRenamePanel )
YellowBox:SetText( "Yellow" )
YellowBox:SetPos( 105, 130 )
YellowBox:SetSize(85, 23)
YellowBox.DoClick = function()
    teleportlocations[loc] = "Yellow"
    TPRenamePanel:Remove()
    end

local MagentaBox = vgui.Create( "DButton", TPRenamePanel )
MagentaBox:SetText( "Magenta" )
MagentaBox:SetPos( 105, 155 )
MagentaBox:SetSize(85, 23)
MagentaBox.DoClick = function()
    teleportlocations[loc] = "Magenta"
    TPRenamePanel:Remove()
    end

local CyanBox = vgui.Create( "DButton", TPRenamePanel )
CyanBox:SetText( "Cyan" )
CyanBox:SetPos( 105, 180 )
CyanBox:SetSize(85, 23)
CyanBox.DoClick = function()
    teleportlocations[loc] = "Cyan"
    TPRenamePanel:Remove()
    end


end


--teleportlocations[0] = "New TP Marker"
local groupoptions = {"Delete", "Rename", "Overwrite"}
savedgroups = {"Create New Group"}
groupedmelons = {}

function GetCurrentGroupSel()
	
	local x = ScrW()/2 - gui.MouseX()
	local y = ScrH()/2 - gui.MouseY()
	local step = 360 / table.Count(savedgroups)
	if math.abs(x) + math.abs(y) < 110 then
	return "cycle"
	else
	local angle = math.deg(math.atan2(-x,y))
    	if angle < 0 then 
        angle = angle + 360
        end
	local j = math.Round(angle / step) + 1
    	if (j > table.Count(savedgroups))then 
    		j = 1	
    	end
	return j
	end
end

function GetCurrentGroupSel2(origin)
	local x = ScrW()/2 - gui.MouseX()
	local y = ScrH()/2 - gui.MouseY()
	local step = 360 / (table.Count(savedgroups) * 12)
	local origin = math.abs(origin - 180)
        if math.abs(x) + math.abs(y) > 275 then
    	local angle = math.deg(math.atan2(-x,y))
        	if angle < 0 then 
            angle = angle + 360
            end
    	local j = math.AngleDifference(angle,origin)
        	if j <=  -step then
        	j = 3
        	elseif j > -step && j < step then
        	j = 2
        	elseif j >= step then
        	j = 1
        	end
        --LocalPlayer():PrintMessage(HUD_PRINTTALK, j )         
    	return j
    	else
    	return 9999
    	end
end

local submenu2 = 1
local submenupointer2 = 1
function GroupMenuPaint()

	local ply = LocalPlayer()
	local teamcol = team.GetColor(ply:Team())
	if table.Count(savedgroups) > 0 then
		local count = table.Count(savedgroups)
		local dist = 360 / count
		
		surface.SetDrawColor(teamcol)
		if (gui.MouseX() ~= 0 && gui.MouseY() ~= 0) then
			surface.DrawLine((ScrW()/2),(ScrH()/2),gui.MouseX(),gui.MouseY())
		end
		local angle = 180
		local w = 110
		local h = 40
		local tempcount = 0
		for k, item in pairs(savedgroups) do
		tempcount = tempcount + 1
			local x = (ScrW()/2) + (math.sin(math.rad(angle)) * 135)
			local y = (ScrH()/2) + (math.cos(math.rad(angle)) * 135)

			local color = teamcol
			if k == 1 then
    			local r = color.r
    			local g = color.g
    			local b = color.b
    			if r == 0 then
    			r = 255
    			else
    			r = 0
    			end
    			if g == 0 then
    			g = 255
    			else
    			g = 0
    			end
    			if b == 0 then
    			b = 255
    			else
    			b = 0
    			end
    		color = Color(r,g,b,255)
			end
			local color2 = Color(0,0,0,255)
			if (GetCurrentGroupSel() == tempcount) then
				color2 = Color(255,255,255,255)
				submenupointer2 = k
			     if tempcount ~= 1 then
        			     
        			local subangle = 180 / (table.Count(savedgroups) * 3) * -1
        			local insubmenu = false
            		  for e, r in pairs (groupoptions) do
            		    
                		 local x2 = (ScrW()/2) + (math.sin(math.rad(angle + subangle)) * 275)
            			 local y2 = (ScrH()/2) + (math.cos(math.rad(angle + subangle)) * 275)
            			 local color4 = Color(0,0,0,255)
            			if GetCurrentGroupSel2(angle) == e then 
                        color4 = Color(255,255,255,255)
                        submenu2 = e
                        insubmenu = true
                        elseif e == 3 && insubmenu == false then
                        submenu2 = 9999
                        end
                		draw.RoundedBox( 10, x2-(95/2),y2 - (30/2),95,30, Color(0, 0, 0, 125) )			
            			draw.SimpleTextOutlined(r,"MenuLarge",x2 ,y2, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color4 )
            			subangle = subangle + (180 / (table.Count(savedgroups) * 3))
            		  end
            	 end
			end
			draw.RoundedBox( 10, x-(w/2),y - (h/2),w,h, Color(0, 0, 0, 200) )			
			draw.SimpleTextOutlined(item,"MenuLarge",x ,y, color,TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color2 )
		
			angle = angle - dist
		end
		
		local color3 = Color(0,0,0,255)
		if GetCurrentGroupSel() == "cycle" then color3 = Color(255,255,255,255) end
		draw.RoundedBox( 10, (ScrW()/2)-(w/2),(ScrH()/2) - (h/2),w,h, Color(0, 0, 0, 200) )			
		draw.SimpleTextOutlined("Cancel","MenuLarge",(ScrW()/2) ,(ScrH()/2), Color(100,100,100,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2,  color3 )
	end
end

function GroupRadialStart()
Msg("Start")
	gui.EnableScreenClicker(true) 
	gui.SetMousePos(ScrW()/2,ScrH()/2)
hook.Add("HUDPaint","GroupRadialStart",GroupMenuPaint)
hook.Add("GUIMousePressed","GroupRadialClick",GroupRadialClick)
end

function GroupRadialClick(num)
Msg("Click")
if num == 107 then
RunConsoleCommand("-wmgroupradial")
end
return false
end

function GroupRadialEnd()
Msg("End")
local menu1 = GetCurrentGroupSel()

    if menu1 == "cycle" then
    elseif menu1 == 1 && WMSelected ~= {} then
	local exists
		for x, y in pairs (WMSelected) do
			if y:IsValid() then
			exists = true
			end
		end
		if exists == true then RunConsoleCommand("WMSaveGroup") end
    elseif submenu2 == 9999 then
	local exists
		for x, y in pairs (groupedmelons[submenupointer2 - 1]) do
			if y:IsValid() then
			exists = true
			end
		end
		if exists == true then
			if LocalPlayer():KeyDown(IN_SPEED) then
			WMClearSelection()
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "Added group.")
			else
			LocalPlayer():PrintMessage(HUD_PRINTTALK, "Group selected.")
			end
				for k, ent in pairs (groupedmelons[submenupointer2 - 1]) do
					if ent:IsValid() then
						if WMSelectionOpt:GetFloat() == 0 then
						ent.Selected = true
						else
						ent:SetMaterial("models/shiny")
						end
					--table.insert(WMSelected, ent)
					end
				end
			RunConsoleCommand("WMGroup", submenupointer2 - 1)
		else
		RunConsoleCommand("WMGroup", submenupointer2 - 1, "delete")
		LocalPlayer():PrintMessage(HUD_PRINTTALK, "That group has been destroyed.")
		end
    elseif submenu2 == 1 then
    savedgroups[submenupointer2] = nil
    RunConsoleCommand("WMGroup", submenupointer2 - 1, "delete")
    elseif submenu2 == 2 then
    WMGroupRename(submenupointer2)
    elseif WMSelected ~= {} then
    RunConsoleCommand("WMSaveGroup", submenupointer2 - 1)
    end
hook.Remove("HUDPaint","GroupRadialStart")
hook.Remove("GUIMousePressed","GroupRadialClick")
gui.EnableScreenClicker(false)
end

function GroupMsgHook( inf )
Msg("Rec")
local num = inf:ReadShort() + 1
    if table.Count(savedgroups) == 1 then
    savedgroups[num] = 1
	groupedmelons[1] = WMSelected
    else
    savedgroups[num] = num - 1
	groupedmelons[num-1] = WMSelected
    end
LocalPlayer():PrintMessage(HUD_PRINTTALK, "Group saved in slot " .. num - 1 .. ".")
end
usermessage.Hook("WMGroupMsg", GroupMsgHook) 

concommand.Add("+wmgroupradial", GroupRadialStart);
concommand.Add("-wmgroupradial", GroupRadialEnd);

function WMGroupRename(loc)
local TPRenamePanel = vgui.Create( "DFrame" ) -- Creates the frame itself
TPRenamePanel:SetPos( ScrW()/2 - 100, ScrH()/2 - 107) -- Position on the players screen
TPRenamePanel:SetSize( 200, 285 ) -- Size of the frame
TPRenamePanel:SetTitle( "Rename a Group")
TPRenamePanel:SetVisible( true )
TPRenamePanel:SetSizable(true)
TPRenamePanel:SetDraggable( true ) -- Draggable by mouse?
TPRenamePanel:ShowCloseButton( true ) -- Show the close button?
TPRenamePanel:MakePopup() -- Show the frame
local TextBox = vgui.Create( "DTextEntry", TPRenamePanel )
TextBox:SetPos( 77, 30)
TextBox:SetTall( 20 )
TextBox:SetWide( 65 )
TextBox:SetEnterAllowed( true )
TextBox:SetMultiline(false)
TextBox:SetUpdateOnType(true)
TextBox.m_bLoseFocusOnClickAway = false
TextBox.OnEnter = function()
    savedgroups[loc] = string.sub(string.Trim(TextBox:GetValue()), 1, 14)
    TPRenamePanel:Remove()
    end
local VarTextLabel = vgui.Create( "Label", TPRenamePanel)
VarTextLabel:SetPos(5, 26)
VarTextLabel:SetText("Custom Name")
VarTextLabel:SizeToContents()

local CheckBox = vgui.Create( "DButton", TPRenamePanel )
CheckBox:SetPos( 152, 27 )
CheckBox:SetSize(25, 25)
CheckBox:SetText("")
CheckBox.Paint = function()
 	 local mat = Material( "gui/silkicons/check_off" )
 	surface.SetDrawColor( 255, 255, 255, 255 )
 	local length = string.len(TextBox:GetValue())
 	if length < 14 && length > 0 then
 	mat = Material( "gui/silkicons/check_on" )
 	end
 	surface.SetMaterial( mat ) 
 	CheckBox:DrawTexturedRect() 
end
CheckBox.DoClick = function()
    savedgroups[loc] = TextBox:GetValue()
    TPRenamePanel:Remove()
    end


local BaseBox = vgui.Create( "DButton", TPRenamePanel )
BaseBox:SetText( "Base Patrol" )
BaseBox:SetPos( 10, 55 )
BaseBox:SetSize(85, 23)
BaseBox.DoClick = function()
    savedgroups[loc] = "Base Patrol"
    TPRenamePanel:Remove()
    end
local UplinkBox = vgui.Create( "DButton", TPRenamePanel )
UplinkBox:SetText( "Dogfighters" )
UplinkBox:SetPos( 10, 80 )
UplinkBox:SetSize(85, 23)
UplinkBox.DoClick = function()
    savedgroups[loc] = "Dogfighters"
    TPRenamePanel:Remove()
    end

local TargetBox = vgui.Create( "DButton", TPRenamePanel )
TargetBox:SetText( "Missiles" )
TargetBox:SetPos( 10, 105 )
TargetBox:SetSize(85, 23)
TargetBox.DoClick = function()
    savedgroups[loc] = "Missiles"
    TPRenamePanel:Remove()
    end

local Target2Box = vgui.Create( "DButton", TPRenamePanel )
Target2Box:SetText( "Bombers" )
Target2Box:SetPos( 10, 130 )
Target2Box:SetSize(85, 23)
Target2Box.DoClick = function()
    savedgroups[loc] = "Bombers"
    TPRenamePanel:Remove()
    end

local Outpost1Box = vgui.Create( "DButton", TPRenamePanel )
Outpost1Box:SetText( "Vehicle 1" )
Outpost1Box:SetPos( 10, 155 )
Outpost1Box:SetSize(85, 23)
Outpost1Box.DoClick = function()
    savedgroups[loc] = "Vehicle 1"
    TPRenamePanel:Remove()
    end
local Outpost2Box = vgui.Create( "DButton", TPRenamePanel )
Outpost2Box:SetText( "Vehicle 2" )
Outpost2Box:SetPos( 10, 180 )
Outpost2Box:SetSize(85, 23)
Outpost2Box.DoClick = function()
    savedgroups[loc] = "Vehicle 2"
    TPRenamePanel:Remove()
    end
    
--Second Column

local RedBox = vgui.Create( "DButton", TPRenamePanel )
RedBox:SetText( "Transports" )
RedBox:SetPos( 105, 55 )
RedBox:SetSize(85, 23)
RedBox.DoClick = function()
    savedgroups[loc] = "Transports"
    TPRenamePanel:Remove()
    end
    
local BlueBox = vgui.Create( "DButton", TPRenamePanel )
BlueBox:SetText( "Battleship" )
BlueBox:SetPos( 105, 80 )
BlueBox:SetSize(85, 23)
BlueBox.DoClick = function()
    savedgroups[loc] = "Battleship"
    TPRenamePanel:Remove()
    end
    
local GreenBox = vgui.Create( "DButton", TPRenamePanel )
GreenBox:SetText( "Carrier" )
GreenBox:SetPos( 105, 105 )
GreenBox:SetSize(85, 23)
GreenBox.DoClick = function()
    savedgroups[loc] = "Carrier"
    TPRenamePanel:Remove()
    end
    
local YellowBox = vgui.Create( "DButton", TPRenamePanel )
YellowBox:SetText( "Submarine" )
YellowBox:SetPos( 105, 130 )
YellowBox:SetSize(85, 23)
YellowBox.DoClick = function()
    savedgroups[loc] = "Submarine"
    TPRenamePanel:Remove()
    end

local MagentaBox = vgui.Create( "DButton", TPRenamePanel )
MagentaBox:SetText( "Marines" )
MagentaBox:SetPos( 105, 155 )
MagentaBox:SetSize(85, 23)
MagentaBox.DoClick = function()
    savedgroups[loc] = "Marines"
    TPRenamePanel:Remove()
    end

local CyanBox = vgui.Create( "DButton", TPRenamePanel )
CyanBox:SetText( "Assualt" )
CyanBox:SetPos( 105, 180 )
CyanBox:SetSize(85, 23)
CyanBox.DoClick = function()
    savedgroups[loc] = "Assualt"
    TPRenamePanel:Remove()
    end
----------------------------------
local Snipers = vgui.Create( "DButton", TPRenamePanel )
Snipers:SetText( "Snipers" )
Snipers:SetPos( 105, 205 )
Snipers:SetSize(85, 23)
Snipers.DoClick = function()
    savedgroups[loc] = "Snipers"
    TPRenamePanel:Remove()
    end
	
local Artillery = vgui.Create( "DButton", TPRenamePanel )
Artillery:SetText( "Artillery" )
Artillery:SetPos( 105, 230 )
Artillery:SetSize(85, 23)
Artillery.DoClick = function()
    savedgroups[loc] = "Artillery"
    TPRenamePanel:Remove()
    end
	
local Strikers = vgui.Create( "DButton", TPRenamePanel )
Strikers:SetText( "Strikers" )
Strikers:SetPos( 10, 205 )
Strikers:SetSize(85, 23)
Strikers.DoClick = function()
    savedgroups[loc] = "Strikers"
    TPRenamePanel:Remove()
    end
	
local Superweapons = vgui.Create( "DButton", TPRenamePanel )
Superweapons:SetText( "Superweapons" )
Superweapons:SetPos( 10, 230 )
Superweapons:SetSize(85, 23)
Superweapons.DoClick = function()
    savedgroups[loc] = "Superweapons"
    TPRenamePanel:Remove()
    end

local Harvesters = vgui.Create( "DButton", TPRenamePanel )
Harvesters:SetText( "Harvesters" )
Harvesters:SetPos( 105, 255 )
Harvesters:SetSize(85, 23)
Harvesters.DoClick = function()
    savedgroups[loc] = "Harvesters"
    TPRenamePanel:Remove()
    end
	
local Barracks = vgui.Create( "DButton", TPRenamePanel )
Barracks:SetText( "Barracks" )
Barracks:SetPos( 10, 255 )
Barracks:SetSize(85, 23)
Barracks.DoClick = function()
    savedgroups[loc] = "Barracks"
    TPRenamePanel:Remove()
    end	

end