local matchstats = CreateClientConVar("WM_Stats_cl", "1", true)
local showteams = {1,1,1,1,1,1}
showteams[1] = CreateClientConVar("WM_Stats_Show_Red", "1", true)
showteams[2] = CreateClientConVar("WM_Stats_Show_Blue", "1", true)
showteams[3] = CreateClientConVar("WM_Stats_Show_Green", "1", true)
showteams[4] = CreateClientConVar("WM_Stats_Show_Yellow", "1", true)
showteams[5] = CreateClientConVar("WM_Stats_Show_Magenta", "1", true)
showteams[6] = CreateClientConVar("WM_Stats_Show_Cyan", "1", true)
local matchstatinterval = CreateClientConVar("WM_Stats_cl_interval", "3", true)
local collectedstats = { { { 0, 0 }, {0 , 0} }, { { 0, 0 }, {0 , 0} },  { { 0, 0 }, {0 , 0} },  { { 0, 0 }, {0 , 0} },  { { 0, 0 }, {0 , 0} },  { { 0, 0 }, {0 , 0} }}
local WMStatsShowInactives = CreateClientConVar("WM_StatsShowInactives", "0", true, false)
local maxtime
local wmshowstats = false
function WMStatCollection()
if matchstats:GetFloat() ~= 1 then return false end
for i=1, 6 do
table.insert(collectedstats[i][1], team.GetScore(i))
end
timer.Simple(matchstatinterval:GetFloat(), WMStatCollection)
end

local testtable = {0, 5, -4, 6, 2, 10, 3, -3, 3, -77, 11}

function WMViewStats()
--if wmshowstats ~= true then
    if matchstats:GetFloat() == 0 then
    LocalPlayer():PrintMessage(HUD_PRINTCENTER,"Your statistic collection is disabled.")
    return false
    end
--end
if StatsPanel ~= nil && StatsPanel:IsVisible() then
StatsPanel:Remove()
else
WMStatShow()
end
end

function WMStatShow()
local minscorebound = -10000
local maxscorebound = 25000
local mintime = 0
local maxtime
local firstpoint = 1
local lastpoint
local intervals = table.getn(collectedstats[1][1])
StatsPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
StatsPanel.Zoomed = false
StatsPanel:SetPos( ScrW()*0.1, ScrH()*0.05 ) -- Position on the players screen
StatsPanel:SetSize( ScrW()*0.8, ScrH()*0.9 ) -- Size of the frame
StatsPanel:SetTitle( "" )
StatsPanel:SetVisible( true )
StatsPanel:SetDraggable( true ) -- Draggable by mouse?
StatsPanel:ShowCloseButton( true ) -- Show the close button?
StatsPanel:MakePopup() -- Show the frame
StatsPanel.StartPressLoc = nil
StatsPanel.CurrentX = 0
StatsPanel.CurrentY = 0
local PW, PH = StatsPanel:GetSize()
local SW = PW*0.075 --Stat graph width / 10
local SH = PH*0.85 --Stat graph height
local BA = 0.75    --Percentage for bars
local toparea = (SH - (PH*BA))
StatsPanel.OnMousePressed = function(panel, mc)
	if mc == 107 then
	StatsPanel.StartX = StatsPanel.CurrentX
	StatsPanel.StartY = StatsPanel.CurrentY
	--return true
	end
end

StatsPanel.OnMouseReleased = function(panel, mc)

	
	if mc == 107 then
	StatsPanel.Zoomed = true
	local topY
	local botY
	--Msg(toparea)
	local scorebounds = (maxscorebound - minscorebound) / (PH*BA)
	--Msg("PHBA " .. (PH*BA) .. "\n")
	--Msg("Scorebounds " .. scorebounds .. "\n")
	local timebounds = (maxtime - mintime) / (PW*BA)
	--Msg("Timebounds " .. timebounds  .. "\n")
	local rightX = StatsPanel.CurrentX
	local leftX = StatsPanel.StartX
		if StatsPanel.StartY < StatsPanel.CurrentY then 
		topY = StatsPanel.CurrentY
		botY = StatsPanel.StartY
		else
		topY = StatsPanel.StartY
		botY = StatsPanel.CurrentY
		end
	if rightX < leftX then
	rightX = StatsPanel.StartX
	leftX = StatsPanel.CurrentX
	end
	--Msg("topY " .. topY .. "\n")
	--Msg("botY " .. botY  .. "\n")
	--Msg("SH " .. SH  .. "\n")
	minscorebound = maxscorebound - (scorebounds * (topY - toparea))
	maxscorebound = maxscorebound - (scorebounds * (botY - toparea))
	--Msg("maxscorebound " .. maxscorebound .. "\n")
	--Msg("minscorebound " .. minscorebound  .. "\n")
	maxtime = mintime + timebounds * (rightX -SW)
	mintime = mintime + timebounds * (leftX - SW)
	--Msg("maxtime " .. maxtime  .. "\n")
	--Msg("mintime " .. mintime  .. "\n")
	firstpoint = nil
		for k,v in pairs (collectedstats[1][1]) do
			if k * matchstatinterval:GetFloat() >= mintime && firstpoint == nil then
			firstpoint = k
			end
			if k * matchstatinterval:GetFloat() >= maxtime then
			intervals = k - firstpoint + 1
			lastpoint = k
			break
			end
		end
	--Msg("firstpoint " .. firstpoint  .. "\n")
	--Msg("intervals " .. intervals  .. "\n")
	--Msg("lastpoint " .. lastpoint  .. "\n")
	StatsPanel.StartX = nil
	end
end
StatsPanel.OnCursorMoved = function(panel,x,y)
--Msg("\n" .. y .. "\n")
	if x >= SW && x < SW*11 then
	StatsPanel.CurrentX = x
	end
	if y <= SH && y >= SH - (PH*BA) then
	StatsPanel.CurrentY = y
	end
end
StatsPanel.PaintOver = function()
	if StatsPanel.StartX ~= nil then
	local vectbl = { {}, {}, {}, {} }
	vectbl[1]["x"] = StatsPanel.StartX
	vectbl[1]["y"] = StatsPanel.StartY
	vectbl[2]["x"] = StatsPanel.StartX
	vectbl[2]["y"] = StatsPanel.CurrentY
	vectbl[3]["x"] = StatsPanel.CurrentX
	vectbl[3]["y"] = StatsPanel.CurrentY
	vectbl[4]["x"] = StatsPanel.CurrentX
	vectbl[4]["y"] = StatsPanel.StartY
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawPoly(vectbl)
	end
end
StatsPanel.Paint = function()
if StatsPanel.Zoomed == false then
intervals = table.getn(collectedstats[1][1])
    for a=1, 6 do
        for k, v in pairs (collectedstats[a][1]) do
            if v > maxscorebound then
            maxscorebound = v
            elseif v < minscorebound then
            minscorebound = v
            end
        end
    end
maxtime = intervals * matchstatinterval:GetFloat()
lastpoint = intervals
end
local minmaxscoredif = maxscorebound - minscorebound
draw.RoundedBox( 10, 0, 0,PW, PH, Color(0, 0, 0, 200) );

surface.SetDrawColor(255,255,255, 50)
    for z = 0, 10 do
    --horizontal grid
    surface.DrawLine(SW, SH - ((PH*BA) / 10 * z), SW + (PW*BA), SH - ((PH*BA) / 10 * z))
    
    --vertical grid
    surface.DrawLine(SW + ((PW*BA) / 10 * z), SH, SW + ((PW*BA) / 10 * z), SH - (PH* BA) )
    end
	--Msg("------------")
	--Msg("firstpoint " .. firstpoint  .. "\n")
	--Msg("intervals " .. intervals  .. "\n")
	--Msg("lastpoint " .. lastpoint  .. "\n")
	--Msg("maxscorebound " .. minmaxscoredif .. "\n")
	--Msg("minscorebound " .. minscorebound  .. "\n")
	--Msg("maxtime " .. maxtime  .. "\n")
	--Msg("mintime " .. mintime  .. "\n")
    for x = 0, 5 do
    --Score Labels (y-axis)
    draw.DrawText(math.Round(minscorebound + (minmaxscoredif / 5 * x)), "Default", SW - 5, SH - ((PH*BA) / 5 * x) - 5, Color(255,255,255,255),TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    --Time Labels (X-axis)
    draw.DrawText(string.ToMinutesSeconds((x) * ((maxtime - mintime) / 5) + mintime), "Default", SW + ((PW*BA) / 5 * x), SH + 15, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.DrawText("SCORE GRAPH", "ScoreboardHeader", SW + ((PW*BA) / 2), SH - ((PH*BA)) - 45, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.DrawText("TIME", "Default", SW + ((PW*BA) / 2), SH + 40, Color(255,255,255,255),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    local scorepercentage = math.abs(minscorebound) / minmaxscoredif
	local minscoreboundpos = math.abs(minscorebound)
        for i=1, 6 do
                if (WMStatsShowInactives:GetFloat() == 1 || collectedstats[i][1][intervals] ~= 0) && showteams[i]:GetFloat() == 1 then
                surface.SetDrawColor(team.GetColor(i))
                local lastx = (SW)
                local lasty = SH - (PH*BA * ((collectedstats[i][1][firstpoint] + math.abs(minscorebound)) / minmaxscoredif))
                    for k,v in pairs (collectedstats[i][1]) do
						if k >= firstpoint && k <= lastpoint && v >= minscorebound && v <= maxscorebound then
						local endx =  SW + (PW*BA * ((k - firstpoint + 1) / intervals))
						local endy =  SH - (PH*BA * (math.abs(v - minscoreboundpos)) / minmaxscoredif)
						surface.DrawLine(lastx, lasty, endx, endy )
						lastx = endx
						lasty = endy
						end
                    end
                end
        end
end
local redteam = vgui.Create( "DCheckBoxLabel", StatsPanel )
redteam:SetText( "Red Team" )
redteam:SetTextColor( Color(255,0,0,255) )
redteam:SetPos( PW*0.85, PH*0.1 )
redteam:SizeToContents()
redteam:SetValue( 1 )
redteam:SetConVar("WM_Stats_Show_Red")

local blueteam = vgui.Create( "DCheckBoxLabel", StatsPanel )
blueteam:SetText( "Blue Team" )
blueteam:SetTextColor( Color(0,0,255,255) )
blueteam:SetPos( PW*0.85, PH*0.1 + 20 )
blueteam:SizeToContents()
blueteam:SetValue( 1 )
blueteam:SetConVar("WM_Stats_Show_Blue")

local greenteam = vgui.Create( "DCheckBoxLabel", StatsPanel )
greenteam:SetText( "Green Team" )
greenteam:SetTextColor( Color(0,255,0,255) )
greenteam:SetPos( PW*0.85, PH*0.1 + 40 )
greenteam:SizeToContents()
greenteam:SetValue( 1 )
greenteam:SetConVar("WM_Stats_Show_Green")

local yellowteam = vgui.Create( "DCheckBoxLabel", StatsPanel )
yellowteam:SetText( "Yellow Team" )
yellowteam:SetTextColor( Color(255,255,0,255) )
yellowteam:SetPos( PW*0.85, PH*0.1 + 60 )
yellowteam:SizeToContents()
yellowteam:SetValue( 1 )
yellowteam:SetConVar("WM_Stats_Show_Yellow")

local magentateam = vgui.Create( "DCheckBoxLabel", StatsPanel )
magentateam:SetText( "Magenta Team" )
magentateam:SetTextColor( Color(255,0,255,255) )
magentateam:SetPos( PW*0.85, PH*0.1 + 80 )
magentateam:SizeToContents()
magentateam:SetValue( 1 )
magentateam:SetConVar("WM_Stats_Show_Magenta")

local cyanteam = vgui.Create( "DCheckBoxLabel", StatsPanel )
cyanteam:SetText( "Cyan Team" )
cyanteam:SetTextColor( Color(0,255,255,255) )
cyanteam:SetPos( PW*0.85, PH*0.1 + 100 )
cyanteam:SizeToContents()
cyanteam:SetValue( 1 )
cyanteam:SetConVar("WM_Stats_Show_Cyan")

local inactiveteams = vgui.Create( "DCheckBoxLabel", StatsPanel )
inactiveteams:SetText( "Show Inactives" )
inactiveteams:SetTextColor( Color(255,255,255,255) )
inactiveteams:SetPos( PW*0.85, PH*0.1 + 140 )
inactiveteams:SizeToContents()
inactiveteams:SetValue( 1 )
inactiveteams:SetConVar("WM_StatsShowInactives")

local unzoom = vgui.Create( "DButton", StatsPanel )
unzoom:SetText( "Standard Zoom" )
unzoom:SetSize(115, 35)
unzoom:SetTextColor( Color(255,255,255,255) )
unzoom:SetPos( PW*0.84, PH*0.1 + 180 )
unzoom.DoClick = function()
StatsPanel.Zoomed = false
minscorebound = -10000
maxscorebound = 25000
firstpoint = 1
mintime = 0
end
end
if matchstats:GetFloat() == 1 then
WMStatCollection()
end
concommand.Add("WMShowStats", WMViewStats)