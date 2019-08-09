DeriveGamemode("sandbox")
include( 'shared.lua' )
include( 'VGUI.lua' )
include( 'cl_stats.lua' )
include( 'cl_scoreboard.lua' )
include( 'BORadar.lua' )
include( 'SHelpButton.lua')
include( 'cl_radials.lua')
include( 'old-noclip.lua')
--require("datastream")
include( 'cl_enthooks.lua')
WMMapName = ""
--Rename kept failing to execute or even give me an error. Sad.
if file.Exists("wmservermaplist.txt", "WM-RTS") then
	file.Write("WM-RTS/wmservermaplist-cur.txt", file.Read("WM-RTS/wmservermaplist.txt"))
	file.Delete("WM-RTS/wmservermaplist.txt")
end
if file.Exists("wmserverhighscores.txt","WM-RTS") then
	file.Write("WM-RTS/wmserverhighscores-cur.txt", file.Read("WM-RTS/wmserverhighscores.txt"))
	file.Delete("WM-RTS/wmserverhighscores.txt")
end
WM_CapPoints = 0
local TLTick = 0
local ATarget = 0
local WM_MaxMelons = 0
local WMIncMsgs = {}
local bountyannouncethreshold = CreateClientConVar("WMMinBountytoAnnounce", "5000", true, false)
local WMGamemodeTips = CreateClientConVar("WMGamemodeTips", "1", true, false)

function WMShowHelpMenu()	
	local window = vgui.Create( "DFrame" )
	if ScrW() > 640 then -- Make it larger if we can.
		window:SetSize( ScrW()*0.9, ScrH()*0.9 )
	else
		window:SetSize( 640, 480 )
	end
	window:Center()
	window:SetTitle( "WarMelons:RTS Help" )
	window:SetVisible( true )
	window:MakePopup()
	
	local html = vgui.Create( "HTML", window )
	
	local button = vgui.Create( "DButton", window )
	button:SetText( "Close" )
	button.DoClick = function() window:Close() end
	button:SetSize( 100, 40 )
	button:SetPos( (window:GetWide() - button:GetWide()) / 2, window:GetTall() - button:GetTall() - 10 )	
	html:SetSize( window:GetWide() - 20, window:GetTall() - button:GetTall() - 50 )
	html:SetPos( 10, 30 )
	if(file.Exists("data/WM-RTS/help/MOTD-V1.txt", "GAME")) then
		html:SetHTML(file.Read("data/WM-RTS/help/MOTD-V1.txt", "GAME"))
	else
		html:SetHTML("<p>File not found.</p>")
	end
end
concommand.Add("wmhelp", WMShowHelpMenu);

function time_send_hook( inf )
	if GetGlobalInt("WMScenarioMode") ~= 1 && GetGlobalInt("WMScenarioMode") ~= 2 then
		TLTick = inf:ReadLong() + CurTime()
	else
		TLTick = inf:ReadLong() - CurTime()
	end
end
usermessage.Hook("TimeSend", time_send_hook) 

function wm_cost_message_hook( inf )
	local cost = inf:ReadLong()
	local msgnum = inf:ReadShort()
	
	local msglist = {
	"Cost: " .. cost .. " NRG.",
	"Not enough NRG. Your NRG: " .. LocalPlayer():GetNWInt( "nrg" ) .. " Cost: " .. cost,
	"Spent " .. cost .. " NRG.",
	"Recycled for " .. cost .. " NRG.",
	"Bounty Collected: " .. cost .. " NRG.",
	"Barracks used " .. cost .. " NRG.",
	"Heavy Barracks used " .. cost .. " NRG.",
	"Munitions Factory used " .. cost .. " NRG."}

	table.insert(WMIncMsgs, {msglist[msgnum], 0, "fill"})
end
usermessage.Hook("wm_cost_message", wm_cost_message_hook) 

function wm_custom_ticker_hook( inf )
	local msg = inf:ReadString()
	table.insert(WMIncMsgs, {msg, 0, "fill"})
end
usermessage.Hook("wm_custom_ticker_msg", wm_custom_ticker_hook) 

function SWTypeLimitMsg() 
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "You cannot have anymore of that type of superweapon.")
end
usermessage.Hook("SWTypeLimitMsg", SWTypeLimitMsg)

function cap_point_hook( inf )
	WM_MaxMelons = inf:ReadShort()
end
usermessage.Hook("MaxMelonUpdate", cap_point_hook) 

function cap_point_hook( inf )
	WM_CapPoints = inf:ReadShort()
end
usermessage.Hook("CapPointUpdate", cap_point_hook) 

function requestCapPoints()
	RunConsoleCommand("wmupdatecappoints")
	timer.Simple(5, function() requestCapPoints() end)
end

timer.Simple(20, function() requestCapPoints() end)

Buffer = ""  
Text = ""  
   
--Ripped from Kogitsune 
 function ReceiveText( um )  
 --Msg("Recieving...")
     local sentence = um:ReadString()  
       
     if sentence == "RESET" then  
         Buffer = ""  
     elseif sentence == "DONE" then  
         Text = Buffer  
         Buffer = ""  
         --Msg("I'm done here    ")
         --Msg(Text)
     else  
         Buffer = Buffer .. sentence  
     end  
 end  
 usermessage.Hook( "Text" , ReceiveText )

--Croxmeister's GetMap Function Below
--[[ function GetMap()
   local worldspawn = ents.GetByIndex(0)
   print(worldspawn)
   local mapname = worldspawn:GetModel()
  
   mapname = string.gsub(mapname,"(%w*/)","")
   mapname = string.gsub(mapname,".bsp","")
   
   return mapname
end  ]]

timer.Simple(3, function() WMMapName = game.GetMap() end)

CTeamBounty = {-1,-1,-1,-1,-1,-1,-1, -1}

function UpdateTeamBounties(um)
	local teem = um:ReadShort()
	local newbounty = um:ReadLong()
	--Msg((newbounty - CTeamBounty[teem]) .. " ")
	--Msg(bountyannouncethreshold:GetInt())
    if (newbounty - CTeamBounty[teem]) >= bountyannouncethreshold:GetInt() then
    	LocalPlayer():PrintMessage(HUD_PRINTTALK, "Team " .. teem .. "'s, (" .. team.GetName(teem) .. "'s), bounty raised to " .. newbounty .. " NRG.")
    end
	CTeamBounty[teem] = newbounty
end
usermessage.Hook("BountySend", UpdateTeamBounties)


ForbElem = {
"CHudSuitPower",
"CHudHealth",
"CHudBattery",
"CHudAmmo",
"CHudSecondaryAmmo"}
  
function HideThings(name)
   	for _,v in pairs(ForbElem) do
	 	if name == v then
	       	return false
	    end
    end
	return true
end
hook.Add( "HUDShouldDraw", "HideThings", HideThings ) 

local helpbar = CreateClientConVar("cl_wm_helpbar", 1 , true)


function WMHudDraw()
	if LocalPlayer():GetActiveWeapon().PrintName ~= "#GMOD_Camera" then
		local colar
		local teem = LocalPlayer():Team()
		colar = team.GetColor(teem)

		if helpbar:GetFloat() == 1 then
			draw.RoundedBox( 10, ScrW() - 355, 0, 355, 29, Color(0, 0, 0, 180) );
			draw.DrawText("F1-Help F2-Encyclopedia F3-Stats F4-Menu ", "Default", ScrW(), 2, colar, TEXT_ALIGN_RIGHT)
			--draw.DrawText("F1-Help F2-Encyclopedia F3-Stats F4-Menu ", "ScoreboardSubtitle", ScrW(), 2, colar, TEXT_ALIGN_RIGHT)--REPLACED WITH THE ONE ABOVE
		end

		for k, v in pairs (WMIncMsgs) do
			if v[3] == "fill" then
				if WMIncMsgs[k-1] == nil || (WMIncMsgs[k-1] ~= nil && v[2] - WMIncMsgs[k-1][2] < -15) then
					v[3] = colar.r
		            v[4] = colar.g
		            v[5] = colar.b
		            v[6] = colar.a
		        end
		    elseif v[6] ~= nil then
		        if v[6] <= 2 then
		        	table.remove(WMIncMsgs, k)
		        else
			        draw.SimpleTextOutlined(v[1],"Default",ScrW() * 0.25 ,ScrH() - v[2], Color(v[3], v[4], v[5], v[6]),TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 2, Color(0, 0, 0, v[6]) )
					--draw.SimpleTextOutlined(v[1],"ScoreboardSubtitle",ScrW() * 0.25 ,ScrH() - v[2], Color(v[3], v[4], v[5], v[6]),TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 2, Color(0, 0, 0, v[6]) )--REPLACED WITH THE ONE ABOVE
			        --draw.DrawText(v[1], "ScoreboardSubtitle", ScrW() * 0.25, ScrH() - v[2], Color(v[3], v[4], v[5], v[6]))
					local incmod = (0.025 * #WMIncMsgs) + 0.5
			        v[2] = v[2] + incmod
			        v[6] = v[6] - incmod
		        end
		    end
		end
		draw.RoundedBox( 10, 110, ScrH() - 80,120, 30, Color(0, 0, 0, 180) );
		draw.DrawText("CP Income: " .. (WM_CapPoints / team.NumPlayers(LocalPlayer():Team())), "Default", 118, ScrH() - 73, Color(255,255,255,255),0)
		draw.RoundedBox( 10, 0, ScrH() - 110,105, 30, Color(0, 0, 0, 180) );
		draw.DrawText("Max Melons: " .. GetGlobalInt("WM_" .. team.GetName(teem) .. "Melons") .. "/" .. WM_MaxMelons, "Default", 10, ScrH() - 102, Color(255,255,255,255),0)
		draw.RoundedBox( 10, 0, ScrH() - 80,105, 30, Color(0, 0, 0, 180) );
	    if GetGlobalInt("WMScenarioMode") == 0 then
		    local a, b = math.modf((TLTick - CurTime()) / 60)
		    draw.DrawText("Time Left: " .. math.floor(a) .. ":" .. math.Round(60 * b), "Default", 10, ScrH() - 73, Color(255,255,255,255),0)
	    else
		    local a, b = math.modf((CurTime() - TLTick)/ 60)
		    draw.DrawText("Time: " .. math.floor(a) .. ":" .. math.Round(60 * b), "Default", 10, ScrH() - 73, Color(255,255,255,255),0)
	    end
		draw.RoundedBox( 10, 0, ScrH() - 50,230, 60, Color(0, 0, 0, 180) );
		draw.DrawText("NRG:" .. math.floor(LocalPlayer():GetNWInt("nrg")), "Default", 10, ScrH() - 45, colar,0)
	end
end
hook.Add("HUDPaint", "WMHud", WMHudDraw); 


function WMHudHelp()
	local HudHelp = {}
	local ply = LocalPlayer()
	
    if WMSelecting then
        if ply:KeyDown(IN_DUCK) then
        	if ply:KeyDown(IN_WALK) then
		        table.insert(HudHelp, "Select by Type (All)")   
		    elseif ply:KeyDown(IN_JUMP) then
		        table.insert(HudHelp, "Select by Type (Short Range)")
		    else
		    	table.insert(HudHelp, "Select by Type (Nearby)")
			end
        end
        
        if ply:KeyDown(IN_SPEED) then
        	table.insert(HudHelp, "Add to Selection")
        end
        
        if ply:KeyDown(IN_USE) then
        	table.insert(HudHelp, "Force Select")
        end
    
    else
        if ply:KeyDown(IN_SPEED) then
        	table.insert(HudHelp, "Add Waypoint")
        end   
    
        if ply:KeyDown(IN_DUCK) then
       		table.insert(HudHelp, "Create Patrol")
        end
        
        if ply:KeyDown(IN_WALK) then
        	table.insert(HudHelp, "Force target")
        end
    
        if ply:KeyDown(IN_USE) then
        	table.insert(HudHelp, "Follow")
        end
    end
    draw.DrawText(string.Implode(" + ", HudHelp), "CloseCaption_Bold", (ScrW() - 25), ScrH() - 60, Color(255,255,255,255), 2)
end
hook.Add("HUDPaint", "WMHudHelp", WMHudHelp); 

function WMHelpTicker()
	draw.RoundedBox( 10, ScrW() - 355, 30, 355, 29, Color(0, 0, 0, 180) )
	draw.DrawText(WMtips[1], "ScoreboardSubtitle", ScrW(), 31, Color(255,255,255,255), TEXT_ALIGN_RIGHT)
end
--hook.Add("HUDPaint", "WMHelpTicker", WMHelpTicker); 

--timer.Simple(5, function() HelpTickerTimer() end)

function HelpTickerTimer()
	--table.insert(WMtips, table.remove(WMtips[1]))
	timer.Simple(5, function() HelpTickerTimer() end)
end

local WMTipCounter = 0
local currenttip = {}
WMtips = {
"Create patrols by holding down duck while giving orders.",
"Death isn't the answer", 
"Suicide is a sin",
"Always look on the bright side of life!",
"Have you even tried drugs yet?"}

function WMAssHud()
	draw.RoundedBox( 10, 0, ScrH() - 140,105, 30, Color(0, 0, 0, 180) );
	draw.DrawText("Target: Team" .. ATarget .. ", (" .. team.GetName(ATarget) .. ")", "Default", 10, ScrH() - 132, team.GetColor(),0)
end

function WMRcvATarget(um)
	ATarget = um:ReadShort()
	LocalPlayer():PrintMessage(HUD_PRINTCENTER, "Your target is team " .. ATarget .. ", (" .. team.GetName(ATarget) ").")
	hook.Add("HUDPaint", "WMAssHud", WMAssHud); 
end
usermessage.Hook("WMATargetSend", WMRcvATarget)

WMSelectionOpt = CreateClientConVar("WM_SelectionMethodShiny", "0", true, false)

WMSelected = {}
function WM_Selecting_Hook(um)
	local ent = um:ReadEntity()
	if ent:IsValid() then
		if WMSelectionOpt:GetFloat() == 0 then
			ent.Selected = true
		else
			ent:SetMaterial("models/shiny")
		end
		table.insert(WMSelected, ent)
	end
end
usermessage.Hook("WM_Selecting", WM_Selecting_Hook)

function WM_ClearSelection(um)
	WMClearSelection()
end

usermessage.Hook("WM_ClearSelection", WM_ClearSelection)

function WMClearSelection()
	for k,v in pairs (WMSelected) do
		if v:IsValid() then
			if WMSelectionOpt:GetFloat() == 0 then
				v.Selected = nil
			else
				v:SetMaterial(v:GetMaterial())
			end
		end
	end
	WMSelected = {}
end

function WMSelectRender()
	local ang = LocalPlayer():GetAngles();   
  	local pos = LocalPlayer():GetPos() --+ (LocalPlayer():GetForward() * -10) + (LocalPlayer():GetUp() * 10) + (LocalPlayer():GetRight() * -2)  
  	cam.Start3D2D( pos , ang , 100);  
      
   	draw.RoundedBox( 8, 50, 50, 100, 100, Color( 255, 255, 255 ) );  
   
    cam.End3D2D();   
    print("workedlol")  
end
--hook.Add("RenderScreenspaceEffects", "WMSelectRender", WMSelectRender)



function WMsuicidemsg()
	local suicidehotline = {
	"Don't do it man! You've got too much to live for!",
	"Death isn't the answer", 
	"Suicide is a sin",
	"Always look on the bright side of life!",
	"Have you even tried drugs yet?",
	"Don't die a virgin!",
	"Through death comes life.",
	"That's it man, game over man, game over",
	"NO! Don't go! *Raise hand in air*",
	"Shoot coward, you are only going to kill a man",
	"Shouldn't you have a cult following before you do that?",
	"No, there aren't 72 virgins waiting for you",
	"WarMelons:RTS isn't that bad...is it?",
	"Don't leave me! I can't live without you!",
	"Dun dun dun na nun dun dun dun...SSSNNNNNAAAAAAAAAAAAAKKKKKKKKEEEEEEEE!!!!!!!",
	"You even fail at killing yourself",
	"A life is a terrible thing to waste.",
	"Suicide isn't the answer",
	"Your quite eager to go to hell, aren't you?",
	"Who do you think you are, Heath Ledger?",
	"Don't drink the Kool-Aid",
	"It's hard to collect your own life insurance policy.",
	"Sorry, this life is your penance.",
	"Sorry, this suicide booth is out of order.",
	"Asimov's First Law of Robotics prevents me from fufilling your request.",
	"COWARD!!",
	"You don't want to do that. You'll be reincarnated as Paris Hilton's enema",
	"Hey, at least you're not playing Sassilization.",
	"It's not up to you whether you live or die.",
	"God has chosen a different path for you.",
	"Looking for a permanent solution to a temporary problem?",
	"I take it you're a 'The glass is half empty' kind of person.",
	"Dude! There's no respawns in RL!",
	"You won't be able to live with yourself, knowing you killed yourself.",
	"Without the love of life there is no will to live. Why don't you love me!?!",
	"Why kill yourself? Life will do it for you.",
	"Life is suffering.",
	"You couldn't commit suicide if your life depended on it!",
	"Suicide commencing in 3...2...1...0.5, 0.25, 0.125...",
	"Ran out of ways to try to grief people?",
	"In WM:RTS, suicide isn't an easy way out. Try disconnecting instead.",
	"Please don't go. The melons need you. They look up to you.",
	"The world WOULD be a better place without you, but...meh"}
	LocalPlayer():PrintMessage(HUD_PRINTTALK, suicidehotline[math.random(1, table.Count(suicidehotline))])
end
usermessage.Hook("WMSuicideSend", WMsuicidemsg)


function WMPhantomMsgs(um)
	local msgtable = {
	"An innocent team has been destroyed. The Phantom grows stronger!",
	"The Phantom has been eliminated. Innocent teams win!",
	"All innocent teams have been eliminated. The Phantom wins!",
	"Time has expired. Innocents win!"}
	local msg = msgtable[um:ReadShort()]
	LocalPlayer:PrintMessage(PRINT_HUDTALK, msg)
	LocalPlayer:PrintMessage(PRINT_HUDCENTER, msg)
end
usermessage.Hook("WMPhantomMsg", WMPhantomMsgs)


function WMAmIPhantom( um )
	AmIPhantom = um:ReadBool()
end
usermessage.Hook("Phantom Ass", WMAmIPhantom) 

function ScenarioIntro()
	if GetGlobalInt("WM_ScenarioMode") == 13 then
	end
end
timer.Simple(5, function() ScenarioIntro() end)
concommand.Add("wmbountymenu", WMBountyMenu);


function WMDebug()
	PrintTable(LocalPlayer():GetEyeTrace().Entity) 
end
concommand.Add("WMendebug", WMDebug)

WMSelecting = false

function WMSelectingStart()
	LocalPlayer():ConCommand("+wmselectsend")
	WMSelecting = true
end


function WMSelectingStop()
	LocalPlayer():ConCommand("-wmselectsend")
	WMSelecting = false
end


function testzor()
	WMSelecting = true
   	local ply = LocalPlayer()
   	local tr = ply:GetEyeTrace()
   	local pos = tr.HitPos
	if tr.Hit then
		if selectormdl && selectormdl:IsValid() then selectormdl:Remove() end
		selectormdl = ClientsideModel("models/hunter/misc/shell2x2a.mdl")
		--selectormdl = ents.Create("base_gmodentity")
		selectormdl:SetPos(pos)
		selectormdl.Pos = pos
		selectormdl:SetColor(Color(255,255,255, 90))
		selectormdl:SetRenderMode( RENDERMODE_TRANSALPHA )
		selectormdl:DrawShadow( false )
		selectormdl:SetModelScale(0.01,0)
		selectormdl:Spawn()
		selectormdl:Activate()
		hook.Add("Think", "SelectorSphereCode", SelectorSphereCode)
	end
end
concommand.Add("+wmselect", testzor)
--concommand.Add("+wmselecttest", testzor)

function testzor2()
	WMSelecting = false
	if selectormdl && selectormdl:IsValid() then
		local SelStart = selectormdl.Pos
		local SelEnd = LocalPlayer():GetEyeTrace().HitPos
		local selCentre = (SelStart+SelEnd)/2;
		local selRadius = (SelStart:Distance(SelEnd))/2
		RunConsoleCommand("wmselect", selCentre.x, selCentre.y, selCentre.z, selRadius)
		hook.Remove("Think", "SelectorSphereCode")
		selectormdl:Remove()
		selectormdl = nil
	end
end
concommand.Add("-wmselect", testzor2)

function testzor3()
	if !LocalPlayer():KeyDown(IN_SPEED) then
		WMSelected = {}
	end
	local SelStart = selectormdl.Pos
	local SelEnd = LocalPlayer():GetEyeTrace().HitPos
	local selCentre = (SelStart+SelEnd)/2;
	local selRadius = (SelStart:Distance(SelEnd))/2
	for k, v in pairs(ents.FindInSphere(selCentre, selRadius)) do
		if v.Warmelon then
			local color = team.GetColor(LocalPlayer():Team())
			local r = color.r
			local g = color.g
			local b = color.b
			if r == 0 then
				r = 100
			end
			if g == 0 then
				g = 100
			end
			if b == 0 then
				b = 100
			end
			etbl = {v:GetColor()}
			--er = tonumber(er)
			--eg = tonumber(eg)
			--eb= tonumber(eb)
			--Msg(v:GetClass())
			--Msg(tostring((etbl[1] >= r)) .. " ")
			--Msg(tostring((etbl[2] >= g)) .. " ")
			--Msg(tostring((etbl[3] >= b)) .. " ")
					--if etbl[1] >= r && etbl[2] >= g && etbl[3] >= b && v.PrintName ~= "Base Prop" then
			v.Selected = true
			table.insert(WMSelected, v)
					--end
		end
	end
	if selectormdl:IsValid() then
		selectormdl:Remove()
	end
--datastream.StreamToServer("WMSelectionStream", WMSelected, done)
	hook.Remove("Think", "SelectorSphereCode")
end
--concommand.Add("-wmselecttest", testzor2)

--WMSelectedIdx = {}

--local function done()
--LocalPlayer():PrintMessage(HUD_PRINTCENTER, #WMSelected.." Warmelons now selected")
--end

function SelectorSphereCode()
    --local Vec = Vector(0,0,0)
    --Vec = (LocalPlayer():GetEyeTrace().HitPos:Distance(selectormdl:GetPos())/49)
	--Mat = Matrix()
	--print(Vec)
	--Mat:Scale(Vec)
	local Scale = (LocalPlayer():GetEyeTrace().HitPos:Distance(selectormdl:GetPos())/49)
	selectormdl:DrawModel();
	selectormdl:SetModelScale(Scale, 0)
	selectormdl:SetPos((selectormdl.Pos+LocalPlayer():GetEyeTrace().HitPos)/2)
end
