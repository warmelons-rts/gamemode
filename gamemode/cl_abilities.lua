local savethetrees = CreateClientConVar("savethetrees", "0", true)
local SaveMapText
local SavePropText
local SaveMelonText
local InsertStringVarText
local InsertString2Text
local InsertString1Text
local OriginalHelp = CreateClientConVar("WM_OriginalHelpOnly", 0, true, false)
local IgnoreInvites = CreateClientConVar("WM_IgnoreInvites", 0, false, true)
RunConsoleCommand("WM_IgnoreInvites", "0")
function ScenarioandVariantControl()

local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
DermaPanel:SetPos( 50,50 ) -- Position on the players screen
DermaPanel:SetSize( 365, 340 ) -- Size of the frame
DermaPanel:SetTitle( "WarMelons:RTS Menus (F3)" ) -- Title of the frame
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true ) -- Draggable by mouse?
DermaPanel:ShowCloseButton( true ) -- Show the close button?
DermaPanel:MakePopup() -- Show the frame
 

local PropertySheet = vgui.Create( "DPropertySheet" )
PropertySheet:SetParent( DermaPanel )
PropertySheet:SetPos( 5, 30 )
PropertySheet:SetSize( 350, 300 )

local Prop1 = vgui.Create( "DPropertySheet" )
Prop1:SetParent( DermaPanel )
Prop1:SetPos( 5, 30 )
Prop1:SetSize( 350, 300)

local Prop2 = vgui.Create( "DPropertySheet" )
Prop2:SetParent( DermaPanel )
Prop2:SetPos( 5, 30 )
Prop2:SetSize( 350, 300 )
Prop2.Paint = function()
if LocalPlayer( ):IsAdmin( ) then
else
draw.SimpleText("This page is for admins only", "Default", 0, 10, Color(0,0,0,255),0,0)
end
end

local Prop3 = vgui.Create( "DPropertySheet" )
Prop3:SetParent( DermaPanel )
Prop3:SetPos( 5, 30 )
Prop3:SetSize( 450, 350 )
Prop3.Paint = function()

if LocalPlayer( ):IsAdmin( ) then
draw.SimpleText("Variant #", "Default", 0, 100, Color(0,0,0,255),0,0) 
draw.SimpleText("Variant String #1", "Default", 0, 122, Color(0,0,0,255),0,0)
draw.SimpleText("Variant String #2", "Default", 0, 148, Color(0,0,0,255),0,0) 
else
draw.SimpleText("This page is for admins only", "Default", 0, 10, Color(0,0,0,255),0,0)
end
end

local ERadar = vgui.Create( "DCheckBoxLabel", Prop1 )
ERadar:SetText( "Enable Radar (Other radar settings are in options)" )
ERadar:SetTextColor( color_black )
ERadar:SetPos( 0, 5 )
ERadar:SetConVar( "radar_enabled" )
ERadar:SetValue( 1 )
ERadar:SizeToContents()
--SIList:AddItem(SI1)

    local BountyMenu = vgui.Create( "DButton", Prop1 )
    BountyMenu:SetText( "Bounty Menu" )
    BountyMenu:SetPos( 0, 25)
    BountyMenu:SetSize(125, 25)
    BountyMenu.DoClick = function()
    RunConsoleCommand( "wmbountymenu" ) -- What happens when you left click the button
    end

if LocalPlayer():GetNetworkedBool("WMCaptain") then
    local CLabel = vgui.Create("DLabel", Prop1)
    CLabel:SetTextColor(Color( 0, 0, 0, 255 ))
    CLabel:SetText("Captain Controls")
    CLabel:SetPos(170, 30)
    CLabel:SizeToContents()
    
    local TeamLocking = vgui.Create( "DButton", Prop1 )
    TeamLocking:SetText( "Lock/Unlock Team" )
    TeamLocking:SetPos( 150, 55)
    TeamLocking:SetSize(125, 25)
    TeamLocking.DoClick = function()
    RunConsoleCommand( "wmteamlock" ) -- What happens when you left click the button
    end
    
    local InvitePlayers = vgui.Create( "DButton", Prop1 )
    InvitePlayers:SetText( "Invite Players to Team" )
    InvitePlayers:SetPos( 150, 85)
    InvitePlayers:SetSize(125, 25)
    InvitePlayers.DoClick = function()
    RunConsoleCommand( "wminvite" ) -- What happens when you left click the button
    end

    local KickPlayers = vgui.Create( "DButton", Prop1 )
    KickPlayers:SetText( "Kick Teammates" )
    KickPlayers:SetPos( 150, 115)
    KickPlayers:SetSize(125, 25)
    KickPlayers.DoClick = function()
    RunConsoleCommand( "wmkickteammatemenu" ) -- What happens when you left click the button
    end    
    
end
--SIList:AddItem(SI2)
local JoinButton = vgui.Create("DButton", Prop1 )
  JoinButton:SetText( "Join Team" )
  JoinButton:SetPos(0, 85)
  JoinButton:SetSize( 125, 25 )
  JoinButton.DoClick = function ( btn )
   local JoinButtonOptions = DermaMenu() -- Creates the menu
   JoinButtonOptions:AddOption("1-Red", function() RunConsoleCommand( "say_team", "/join 1" ) end ) -- Add options to the menu
   JoinButtonOptions:AddOption("2-Blue", function() RunConsoleCommand( "say_team", "/join 2" ) end )
   JoinButtonOptions:AddOption("3-Green", function() RunConsoleCommand( "say_team", "/join 3" ) end )
   JoinButtonOptions:AddOption("4-Yellow", function() RunConsoleCommand( "say_team", "/join 4" ) end )
   JoinButtonOptions:AddOption("5-Magenta", function() RunConsoleCommand( "say_team", "/join 5" ) end )
    JoinButtonOptions:AddOption("6-Cyan", function() RunConsoleCommand( "say_team", "/join 6" ) end )
   JoinButtonOptions:Open() -- Open the menu AFTER adding your options
   end

local DonateButton = vgui.Create( "DButton", Prop1 )
DonateButton:SetText( "Give NRG to Others" )
DonateButton:SetPos( 0, 115)
DonateButton:SetSize(125, 25)
DonateButton.DoClick = function()
RunConsoleCommand( "wmdonate" ) -- What happens when you left click the button
end

local HelpButton = vgui.Create( "DButton", Prop1 )
HelpButton:SetText( "Help/Manual (F1)" )
HelpButton:SetPos( 0, 145)
HelpButton:SetSize(125, 25)
HelpButton.DoClick = function()
RunConsoleCommand( "wmhelp" ) -- What happens when you left click the button
end

local HelpButton = vgui.Create( "DButton", Prop1 )
HelpButton:SetText( "View Maps/Variants" )
HelpButton:SetPos( 0, 175)
HelpButton:SetSize(125, 25)
HelpButton.DoClick = function()
RunConsoleCommand( "wmcheckmaps" ) -- What happens when you left click the button
end

local ERadar = vgui.Create( "DCheckBoxLabel", Prop1 )
ERadar:SetText( "Enable Help Bar" )
ERadar:SetTextColor( color_black )
ERadar:SetPos( 0, 205 )
ERadar:SetConVar( "cl_wm_helpbar" )
ERadar:SetValue( 1 )
ERadar:SizeToContents()

if LocalPlayer( ):IsAdmin( ) then 

confirmcp = CreateClientConVar("confirmcp", "0", true)

   
local wmsettime = vgui.Create( "DButton", Prop2 )
wmsettime:SetText( "Set Remaining Time (seconds)" )
wmsettime:SetPos( 0, 0 )
wmsettime:SetSize(175, 25)
wmsettime.DoClick = function()
    RunConsoleCommand( "wmsettime", SetTimeText:GetValue())
    end

SetTimeText = vgui.Create( "DTextEntry", Prop2 )
SetTimeText:SetPos( 190, 5 )
SetTimeText:SetTall( 20 )
SetTimeText:SetWide( 50 )
SetTimeText:SetEnterAllowed( false )

local wmfogzor = vgui.Create( "DButton", Prop2 )
wmfogzor:SetText( "Set Fog Distance" )
wmfogzor:SetPos( 0, 30 )
wmfogzor:SetSize(125, 25)
wmfogzor.DoClick = function()
    RunConsoleCommand( "wmfogzor", SetFogText:GetValue() )
    end

SetFogText = vgui.Create( "DTextEntry", Prop2 )
SetFogText:SetPos( 135, 30 )
SetFogText:SetTall( 20 )
SetFogText:SetWide( 50 )
SetFogText:SetEnterAllowed( false )

local wmspawnmap = vgui.Create( "DButton", Prop2 )
wmspawnmap:SetText( "Spawn Variant" )
wmspawnmap:SetPos( 0, 60 )
wmspawnmap:SetSize(125, 25)
wmspawnmap.DoClick = function()
    RunConsoleCommand( "wmspawnmap", SpawnMapText:GetValue() )
    end

SpawnMapText = vgui.Create( "DTextEntry", Prop2 )
SpawnMapText:SetPos( 135, 60 )
SpawnMapText:SetTall( 20 )
SpawnMapText:SetWide( 50 )
SpawnMapText:SetEnterAllowed( false )

local wmspawnprops = vgui.Create( "DButton", Prop2 )
wmspawnprops:SetText( "Spawn Props From File" )
wmspawnprops:SetPos( 0, 90 )
wmspawnprops:SetSize(135, 25)
wmspawnprops.DoClick = function()
    RunConsoleCommand( "wmspawnprops", SpawnPropsText:GetValue() )
    end

SpawnPropsText = vgui.Create( "DTextEntry", Prop2 )
SpawnPropsText:SetPos( 145, 90 )
SpawnPropsText:SetTall( 20 )
SpawnPropsText:SetWide( 50 )
SpawnPropsText:SetEnterAllowed( false )

local wmspawnmelons = vgui.Create( "DButton", Prop2 )
wmspawnmelons:SetText( "Spawn Melons From File" )
wmspawnmelons:SetPos( 0, 120 )
wmspawnmelons:SetSize(135, 25)
wmspawnmelons.DoClick = function()
    RunConsoleCommand( "wmmms", SpawnMelonsText:GetValue() )
    end

   
SpawnMelonsText = vgui.Create( "DTextEntry", Prop2 )
SpawnMelonsText:SetPos( 145, 120 )
SpawnMelonsText:SetTall( 20 )
SpawnMelonsText:SetWide( 50 )
SpawnMelonsText:SetEnterAllowed( false )

    
local ForceUnlockButton = vgui.Create("DButton", Prop2 )
  ForceUnlockButton:SetText( "Unlock Team" )
  ForceUnlockButton:SetPos(0, 150)
  ForceUnlockButton:SetSize( 125, 25 )
  ForceUnlockButton.DoClick = function ( btn )
   local ForceUnlockButtonOptions = DermaMenu() -- Creates the menu
   ForceUnlockButtonOptions:AddOption("1-Red", function() RunConsoleCommand( "wmforceunlock", "1") end ) -- Add options to the menu
   ForceUnlockButtonOptions:AddOption("2-Blue", function() RunConsoleCommand( "wmforceunlock", "2" ) end )
   ForceUnlockButtonOptions:AddOption("3-Green", function() RunConsoleCommand( "wmforceunlock", "3" ) end )
   ForceUnlockButtonOptions:AddOption("4-Yellow", function() RunConsoleCommand( "wmforceunlock", "4" ) end )
   ForceUnlockButtonOptions:AddOption("5-Magenta", function() RunConsoleCommand( "wmforceunlock", "5" ) end )
    ForceUnlockButtonOptions:AddOption("6-Cyan", function() RunConsoleCommand( "wmforceunlock", "6" ) end )
   ForceUnlockButtonOptions:Open() -- Open the menu AFTER adding your options
   end


local confcpcheck = vgui.Create( "DCheckBoxLabel", Prop2 )
confcpcheck:SetText( "Confirm" )
confcpcheck:SetTextColor( color_black )
confcpcheck:SetPos( 140, 200 )
confcpcheck:SetConVar( "confirmcp" )
confcpcheck:SetValue( 0 )

local wmclearmap = vgui.Create( "DButton", Prop2 )
wmclearmap:SetText( "Clear Map" )
wmclearmap:SetPos( 0, 200 )
wmclearmap:SetSize(125, 25)
wmclearmap.DoClick = function()
    if confirmcp:GetFloat() == 1 then
    RunConsoleCommand( "wmclearmap" )
    end
end

local wmpurgemap = vgui.Create( "DButton", Prop2 )
wmpurgemap:SetText( "Purge Map" )
wmpurgemap:SetPos( 210, 200 )
wmpurgemap:SetSize(125, 25)
wmpurgemap.DoClick = function()
    if confirmcp:GetFloat() == 1 then
    RunConsoleCommand( "wmpurgemap" )
    end
end

local wmspawnmelons = vgui.Create( "DButton", Prop2 )
wmspawnmelons:SetText( "ULX Server Settings" )
wmspawnmelons:SetPos( 0, 230 )
wmspawnmelons:SetSize(135, 25)
wmspawnmelons.DoClick = function()
    RunConsoleCommand( "say_team", "!adminmenu" )
    end

local wmsavemap = vgui.Create( "DButton", Prop3 )
wmsavemap:SetText( "Save Map Features" )
wmsavemap:SetPos( 0, 2.5 )
wmsavemap:SetSize(125, 25)
wmsavemap.DoClick = function()
    RunConsoleCommand("wmvariantinfomenu")
    end

SaveMapText = vgui.Create( "DTextEntry", Prop3 )
SaveMapText:SetPos( 130, 5 )
SaveMapText:SetTall( 20 )
SaveMapText:SetWide( 25 )
SaveMapText:SetEnterAllowed( true )

local wmsavemap = vgui.Create( "DButton", Prop3 )
wmsavemap:SetText( "Save Scenario Props" )
wmsavemap:SetPos( 0, 35)
wmsavemap:SetSize(125, 25)
wmsavemap.DoClick = function()
RunConsoleCommand("wmnameprops")
timer.Simple(2,function() RunConsoleCommand( "wmsaveprops", SavePropText:GetValue()) end)
end

SavePropText = vgui.Create( "DTextEntry", Prop3 )
SavePropText:SetPos( 130, 35 )
SavePropText:SetTall( 20 )
SavePropText:SetWide( 50 )
SavePropText:SetEnterAllowed( true )

local wmsavemap = vgui.Create( "DButton", Prop3 )
wmsavemap:SetText( "Save Melons" )
wmsavemap:SetPos( 0, 65)
wmsavemap:SetSize(125, 25)
wmsavemap.DoClick = function()
RunConsoleCommand( "wmsavemelons", SaveMelonText:GetValue())
end

SaveMelonText = vgui.Create( "DTextEntry", Prop3 )
SaveMelonText:SetPos( 130, 65 )
SaveMelonText:SetTall( 20 )
SaveMelonText:SetWide( 50 )
SaveMelonText:SetEnterAllowed( true )

InsertStringVarText = vgui.Create( "DTextEntry", Prop3 )
InsertStringVarText:SetPos( 130, 95 )
InsertStringVarText:SetTall( 20 )
InsertStringVarText:SetWide( 50 )
InsertStringVarText:SetEnterAllowed( true )

--VarTextLabel = vgui.Create( "DLabel", Prop3)
--VarTextLabel:SetPos(0, 90)
--VarTextLabel:SetText("Variant #")

InsertString1Text = vgui.Create( "DTextEntry", Prop3 )
InsertString1Text:SetPos( 130, 120 )
InsertString1Text:SetTall( 20 )
InsertString1Text:SetWide( 200 )
InsertString1Text:SetEnterAllowed( true )

InsertString2Text = vgui.Create( "DTextEntry", Prop3 )
InsertString2Text:SetPos( 130, 145 )
InsertString2Text:SetTall( 20 )
InsertString2Text:SetWide( 200 )
InsertString2Text:SetEnterAllowed( true )

local appendfile = vgui.Create( "DButton", Prop3 )
appendfile:SetText( "Append Variant File" )
appendfile:SetPos( 0, 175 )
appendfile:SetSize(125, 25)
appendfile.DoClick = function()
    RunConsoleCommand( "wmappendfile", InsertStringVarText:GetValue(), InsertString2Text:GetValue(), InsertString1Text:GetValue() )  
    end
    
local appendfile = vgui.Create( "DButton", Prop3 )
appendfile:SetText( "Append Variant Help" )
appendfile:SetPos( 190, 175 )
appendfile:SetSize(125, 25)
appendfile.DoClick = function()
    RunConsoleCommand( "wmappendhelp" )
    end
    
local linkfilesbtn = vgui.Create( "DButton", Prop3 )
linkfilesbtn:SetText( "Link All Files" )
linkfilesbtn:SetPos( 190, 55 )
linkfilesbtn:SetSize(125, 25)
linkfilesbtn.DoClick = function()
    RunConsoleCommand( "wmappendfile", SaveMapText:GetValue(), SavePropText:GetValue(), "SpawnProps" )
    RunConsoleCommand( "wmappendfile", SaveMapText:GetValue(), SaveMelonText:GetValue(), "SpawnMelons" )
    end

local wmdeletemap = vgui.Create( "DButton", Prop3 )
wmdeletemap:SetText( "Delete Variant" )
wmdeletemap:SetPos( 0, 205)
wmdeletemap:SetSize(125, 25)
wmdeletemap.DoClick = function()
RunConsoleCommand( "wmdeletemap", DeleteMelonText:GetValue())
end

DeleteMelonText = vgui.Create( "DTextEntry", Prop3 )
DeleteMelonText:SetPos( 130, 210 )
DeleteMelonText:SetTall( 20 )
DeleteMelonText:SetWide( 25 )
DeleteMelonText:SetEnterAllowed( true )

local wmsetcost = vgui.Create( "DButton", Prop3 )
wmsetcost:SetText( "Set Cost of Selected Entities" )
wmsetcost:SetPos( 0, 235)
wmsetcost:SetSize(150, 25)
wmsetcost.DoClick = function()
RunConsoleCommand( "wmsetcost", SetCostText:GetValue())
end

SetCostText = vgui.Create( "DTextEntry", Prop3 )
SetCostText:SetPos( 155, 240 )
SetCostText:SetTall( 20 )
SetCostText:SetWide( 75 )
SetCostText:SetEnterAllowed( true )
    
SaveTrees = vgui.Create( "DCheckBoxLabel", Prop3 )
SaveTrees:SetText( "Save Trees and Rocks?" )
SaveTrees:SetTextColor(color_black)
SaveTrees:SetPos( 160, 7.5 )
SaveTrees:SetConVar( "savethetrees" )
SaveTrees:SetValue( 1 )
SaveTrees:SizeToContents()

end

PropertySheet:AddSheet( "Player", Prop1, "gui/silkicons/user", false, false, "Basic Commands and Options" )
PropertySheet:AddSheet( "Admin",  Prop2, "gui/silkicons/wrench", false, false, "Match Settings" )
PropertySheet:AddSheet( "Editor", Prop3, "gui/silkicons/world", false, false, "For Creation of Map Variants and Scenarios." )

end

function VariantInfoMenu()

local VIPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
VIPanel:SetPos( 200,200 ) -- Position on the players screen
VIPanel:SetSize( 500, 400 ) -- Size of the frame
VIPanel:SetTitle( "WarMelons:RTS Variant Saver" ) -- Title of the frame
VIPanel:SetVisible( true )
VIPanel:SetDraggable( true ) -- Draggable by mouse?
VIPanel:ShowCloseButton( true ) -- Show the close button?
VIPanel:MakePopup() -- Show the frame

VIPanel.label1 = vgui.Create( "Label", VIPanel ) -- Creates the frame itself
VIPanel.label1:SetPos( 3,20) -- Position on the players screen
VIPanel.label1:SetText("Formal Name:")
VIPanel.label2 = vgui.Create( "Label", VIPanel ) -- Creates the frame itself
VIPanel.label2:SetPos( 3,66) -- Position on the players screen
VIPanel.label2:SetText("Author:")
VIPanel.label3 = vgui.Create( "Label", VIPanel ) -- Creates the frame itself
VIPanel.label3:SetPos( 3,105) -- Position on the players screen
VIPanel.label3:SetText("Description:")
local VariantName = vgui.Create( "DTextEntry", VIPanel )
VariantName:SetPos( 3, 45 )
VariantName:SetTall( 20 )
VariantName:SetWide( 45)
VariantName:SetEnterAllowed( true )

local VariantAuthor = vgui.Create( "DTextEntry", VIPanel )
VariantAuthor:SetPos( 3, 83)
VariantAuthor:SetTall( 20 )
VariantAuthor:SetWide( 45 )
VariantAuthor:SetEnterAllowed( true )

local VariantDescription = vgui.Create( "DTextEntry", VIPanel )
VariantDescription:SetPos( 3, 123)
VariantDescription:SetTall( 60 )
VariantDescription:SetWide( 350 )
VariantDescription:SetEnterAllowed( true )
VariantDescription:SetMultiline(true)

local wmsavemap = vgui.Create( "DButton", VIPanel )
wmsavemap:SetText( "Save Variant Info" )
wmsavemap:SetPos( 3, 190)
wmsavemap:SetSize(125, 25)
wmsavemap.DoClick = function()
    if savethetrees:GetFloat() == 1 then
    RunConsoleCommand( "wmsavemap", SaveMapText:GetValue() .. "t" )
    else
    RunConsoleCommand( "wmsavemap", SaveMapText:GetValue() )
    end
RunConsoleCommand( "wmappendfile", SaveMapText:GetValue(), VariantName:GetValue(), "Variant Name" )
RunConsoleCommand( "wmappendfile", SaveMapText:GetValue(), VariantAuthor:GetValue(), "Variant Author")
RunConsoleCommand( "wmappendfile", SaveMapText:GetValue(), VariantDescription:GetValue(), "Variant Description")
end
end

function AppendCommands()
if LocalPlayer( ):IsAdmin( ) then
local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
DermaPanel:SetPos( 10, 400 ) -- Position on the players screen
DermaPanel:SetSize( ScrW()*0.95, 300 ) -- Size of the frame
DermaPanel:SetTitle( "WarMelons:RTS Editor Help" ) -- Title of the frame
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true ) -- Draggable by mouse?
DermaPanel:ShowCloseButton( true ) -- Show the close button?
DermaPanel:MakePopup() -- Show the frame


local MidPanelList = vgui.Create("DListView", DermaPanel)
MidPanelList:SetPos(25, 30)
MidPanelList:SetSize(ScrW()*0.90, 250)
MidPanelList:SetMultiSelect(false)

--local col3 = vgui.Create("DListView_Column", MidPanelList)
--col3:SetName("Explanation")
local col1 = MidPanelList:AddColumn("Command")
local col2 = MidPanelList:AddColumn("Value")
MidPanelList:AddColumn("Explanation")
col1:SetFixedWidth(125)
col2:SetFixedWidth(75)
col1:PerformLayout()
col2:PerformLayout()
MidPanelList:SetSortable(true)
MidPanelList.OnClickLine = function(parent,selected,isselected)
InsertString1Text:SetValue(selected:GetValue(1))
InsertString2Text:SetValue(selected:GetValue(2))
end  
--local scroller = vgui.Create("DHorizontalScroller", DermaPanel)
--scroller:AddPanel(MidPanelList)

MidPanelList:AddLine("Source/Neo", "None", "Removes all buttons and func_ entities so that SourceForts or NeoForts maps are playable") // Add lines
MidPanelList:AddLine("WM_Freespawns", "1 for true", "Overides the server setting WM_FreeSpawns for this map only. Useful on maps where spawns are already set.")
MidPanelList:AddLine("WM_PlayersPerTeam", "Integer", "Overrides the server setting WM_PlayersPerTeam for this map only. Useful for team maps")
MidPanelList:AddLine("WM_StartingNRG", "None", "Overrides the server setting WM_StartingNRG for this map only. Useful on maps where spawns are already set.")
MidPanelList:AddLine("WM_RoundTime", "Minutes", "Overrides the server setting WM_RoundTime.")
MidPanelList:AddLine("ADSpawnFile", "name", "Spawns an advanced dupe on first player joining.")
MidPanelList:AddLine("SpawnProps", "file number", "Spawns props from a saved file (linking can do this for you)")
MidPanelList:AddLine("SpawnMelons", "file number", "Spawns melons from a saved file (linking can do this for you)")
MidPanelList:AddLine("WM_RezPerHarvest", "Integer", "MODIFIES the amount of resources harvesters recieve for this map only.")
MidPanelList:AddLine("WM_CappointNRG", "Integer", "MODIFIES the amount of resources capture points give for this map only.")
else


end
end
local opened = 0
xp,yp = 10, 310    
local EncyclopediaEntry
function Encyclopedia(ply, cmd, arg)
opened = 0
local title = ""
local seltex = "wmrtslogoAA5"
local seltexID = surface.GetTextureID( seltex )
local EntryID = 1
EncPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
EncPanel:SetPos( 10, 10 ) -- Position on the players screen
EncPanel:SetSize( ScrW()*0.4, 300 ) -- Size of the frame
EncPanel:SetTitle( "WarMelons:RTS Encyclopedia (F2)" ) -- Title of the frame
EncPanel:SetDraggable( true ) -- Draggable by mouse?
EncPanel:ShowCloseButton( true ) -- Show the close button?
EncPanel:MakePopup() -- Show the frame

local MidPanelList = vgui.Create("DListView",EncPanel)
MidPanelList:SetPos(25, 30)
MidPanelList:SetSize(ScrW()*0.35, 240)
MidPanelList:SetMultiSelect(false)

--local col3 = vgui.Create("DListView_Column", MidPanelList)
--col3:SetName("Explanation")
local col1 = MidPanelList:AddColumn("Topic")
local col2 = MidPanelList:AddColumn("Category")
local col3 = MidPanelList:AddColumn("ID")
col1:PerformLayout()
col2:PerformLayout()
col3:SetFixedWidth(0)
col3:PerformLayout()
MidPanelList:SetSortable(true)
MidPanelList.OnClickLine = function(parent,selected,isselected)
EEPanelCall(selected:GetValue(1))
end  
--local scroller = vgui.Create("DHorizontalScroller", DermaPanel)
--scroller:AddPanel(MidPanelList)

MidPanelList:AddLine("Bomb", "Melons")
MidPanelList:AddLine("Cannon", "Melons")
MidPanelList:AddLine("Fighter", "Melons")
MidPanelList:AddLine("Flak", "Melons")
MidPanelList:AddLine("Harvester", "Melons")
MidPanelList:AddLine("Laser", "Melons")
MidPanelList:AddLine("Light Fighter", "Melons")
MidPanelList:AddLine("Machine Gun", "Melons")
MidPanelList:AddLine("Medic", "Melons")
MidPanelList:AddLine("Mortar", "Melons")
MidPanelList:AddLine("Plasma Cannon", "Melons")
MidPanelList:AddLine("Sniper", "Melons")
MidPanelList:AddLine("Spotter Melons", "Melons")
MidPanelList:AddLine("Striker", "Melons")
MidPanelList:AddLine("Battlefield Command", "Super Weapon")
MidPanelList:AddLine("Chaos Cannon", "Super Weapon")
MidPanelList:AddLine("Mega Bomb", "Super Weapon")
MidPanelList:AddLine("Microwave Laser", "Super Weapon")
MidPanelList:AddLine("Mind Control", "Super Weapon")
MidPanelList:AddLine("Regeneration Core", "Super Weapon")
MidPanelList:AddLine("Barracks", "Structures")
MidPanelList:AddLine("CapPoint Fortification", "Structures")
MidPanelList:AddLine("Heavy Barracks", "Structures")
MidPanelList:AddLine("Munitions Factory", "Structures")
MidPanelList:AddLine("Outpost", "Structures")
MidPanelList:AddLine("Spawn Point", "Structures")
MidPanelList:AddLine("Capture Point", "Map Features")
MidPanelList:AddLine("Communications Uplink", "Map Features")
MidPanelList:AddLine("No Build Zone", "Map Features")
MidPanelList:AddLine("Resource Node", "Map Features")
MidPanelList:AddLine("Building a Boat", "Concepts")
MidPanelList:AddLine("Capture Point Control", "Concepts")
MidPanelList:AddLine("Interplanetary/Space Warfare", "Concepts")
MidPanelList:AddLine("Melon Limit", "Concepts")
MidPanelList:AddLine("Melons", "Concepts")
MidPanelList:AddLine("Resource Harvesting", "Concepts")
MidPanelList:AddLine("Advanced Duplicator", "Tools")
MidPanelList:AddLine("Selecting Melons", "Commanding")
MidPanelList:AddLine("Control Groups", "Commanding")
MidPanelList:AddLine("Ordering Melons", "Commanding")
MidPanelList:AddLine("Patrols", "Commanding")
MidPanelList:AddLine("Waypoints", "Commanding")
MidPanelList:AddLine("Getting Started", "Commanding")
MidPanelList:AddLine("WM_Battlepit_v1", "Maps")
MidPanelList:AddLine("WM_Castles", "Maps")
MidPanelList:AddLine("WM_Dawn", "Maps")
MidPanelList:AddLine("WM_Desertia", "Maps")
MidPanelList:AddLine("WM_FogofWar", "Maps")
MidPanelList:AddLine("WM_Installation", "Maps")
MidPanelList:AddLine("WM_Ogulation", "Maps")
MidPanelList:AddLine("WM_Permafrost", "Maps")
MidPanelList:AddLine("WM_Quadulus", "Maps")
MidPanelList:AddLine("WM_SvarMemorial_01", "Maps")
MidPanelList:AddLine("WM_The-Farm-2009v1", "Maps")
MidPanelList:AddLine("WM_Quadulus", "Maps")
MidPanelList:AddLine("WM_Quadulus", "Maps")
if arg[1] ~= nil then
EEPanelCall(arg[1])
end
end

function EEPanelCall(Replacer)
local Replacer2 = string.lower(Replacer)
local ini = file.Read("../data/WM-RTS/help/picturetemplate.txt")
if file.Exists("../data/WM-RTS/help/" .. Replacer2 .. ".jpg") then
file.Write("WM-RTS/picturetemplate.txt", string.gsub(ini, "XXX", Replacer2))
else
file.Write("WM-RTS/picturetemplate.txt", string.gsub(ini, "XXX", "wmrts"))
end
    if opened == 1 then
    xp,yp = EncyclopediaEntry:GetPos()
    EncyclopediaEntry:Close()
    EncyclopediaEntry:Remove()
    end
EEPanel(Replacer,xp, yp)
end

function HighScores()
if LocalPlayer( ):IsAdmin( ) then
local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
DermaPanel:SetPos( 10, 400 ) -- Position on the players screen
DermaPanel:SetSize( ScrW()*0.95, 300 ) -- Size of the frame
DermaPanel:SetTitle( "WarMelons:RTS Highscores" ) -- Title of the frame
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true ) -- Draggable by mouse?
DermaPanel:ShowCloseButton( true ) -- Show the close button?
DermaPanel:MakePopup() -- Show the frame


local MidPanelList = vgui.Create("DListView", DermaPanel)
MidPanelList:SetPos(25, 30)
MidPanelList:SetSize(ScrW()*0.90, 250)
MidPanelList:SetMultiSelect(false)

--local col3 = vgui.Create("DListView_Column", MidPanelList)
--col3:SetName("Explanation")
local col1 = MidPanelList:AddColumn("Name")
local col2 = MidPanelList:AddColumn("Best Time")
local col3 = MidPanelList:AddColumn("Score")
col1:PerformLayout()
col2:PerformLayout()
col3:PerformLayout()
MidPanelList:SetSortable(true)
--local scroller = vgui.Create("DHorizontalScroller", DermaPanel)
--scroller:AddPanel(MidPanelList)

    if file.Exists("WM-RTS/wmserverhighscores-cur.txt") then
    local ini = file.Read("WM-RTS/wmserverhighscores-cur.txt")
    Msg("It Exists ")
    local exploded = string.Explode("\n", ini);
        for k, v in pairs (exploded) do
            --if string.find(v, WMMapName .. "[" .. WMMapVariant .. "]") ~= nil then
            if string.find(v, WMMapName) ~= nil && string.find(v, WMMapVariant) ~= nil then
            Msg("found it")
                for x=1, 10 do
                MidPanelList:AddLine(exploded[k+x], string.ToMinutesSeconds(tostring(exploded[k+x+10])), exploded[k+x+20] )
                end
            end
        end
    else
    
    end

MidPanelList:SortByColumn(2)

end
end

function EEPanel(Name, XPos, YPos)
opened = 1
if Name == nil then
Name = "Getting Started"
end


if XPos == nil || YPos == nil then
XPos = 10
YPos = 310
end

EncyclopediaEntry = vgui.Create( "DFrame", EncPanel ) -- Creates the frame itself
EncyclopediaEntry:SetPos( XPos, YPos ) -- Position on the players screen
EncyclopediaEntry:SetSize( ScrW()*0.9, ScrH()*0.5 ) -- Size of the frame
EncyclopediaEntry:SetTitle( Name )
EncyclopediaEntry:SetVisible( true )
EncyclopediaEntry:SetSizable(true)
EncyclopediaEntry:SetDraggable( true ) -- Draggable by mouse?
EncyclopediaEntry:ShowCloseButton( false ) -- Show the close button?
EncyclopediaEntry:MakePopup() -- Show the frame
local FinalLoc = ""
local Name2 = string.lower(Name)
    if OriginalHelp:GetFloat() == 0 then
    local tstring = "../data/WM-RTS/help/*.txt"
    local list = file.Find(tstring)
    PrintTable(list)
     for k, v in pairs(list) do
       if string.find(v, "]" .. Name2) ~= nil then
       Msg("Found string")
            local date
            if date == nil then 
            Msg("added a date")
           date = file.Time(tstring) 
           FinalLoc = v
           end
       Msg(string.find(v, Name2))
       Msg(v .. " ")
       tstring = "../data/WM-RTS/help/" .. v
           if file.Time(tstring) > date then
           date = file.Time(tstring)
           FinalLoc = v
           end
        end
      end
    else
    FinalLoc =  "[0]" .. Name2 .. ".txt"
    end
	html = vgui.Create( "HTML", EncyclopediaEntry )
	html:SetSize( EncyclopediaEntry:GetWide()*0.5, EncyclopediaEntry:GetTall() - 40 )
	html:SetPos( 10, 30 )
	if file.Exists("../data/WM-RTS/help/" .. FinalLoc) then
	html:SetHTML( file.Read("../data/WM-RTS/help/" .. FinalLoc ) )
    else
    html:SetHTML( file.Read("../data/WM-RTS/help/encyclopediaerror.txt" ) )
    end
  function html:OpeningURL( url, target ) 
   	 
 	local command = url:gsub( "lua://Entry/", "" ) 
 	command = string.Replace( command, "%20", " ")
 	if ( command ~= "" ) then 
 	 
 		EEPanelCall(command)
 		return true; 
 		 
 	end 
 	 
   end 

 	html2 = vgui.Create( "HTML", EncyclopediaEntry )
	html2:SetSize( EncyclopediaEntry:GetWide()*0.45 + 10, EncyclopediaEntry:GetTall() - 40 )
	html2:SetPos( EncyclopediaEntry:GetWide()*0.53, 30 )
	html2:SetHTML( file.Read("WM-RTS/picturetemplate.txt") )
--	html2:OpenURL("data/WM-RTS/picturetemplate.txt")
	
--local PicPanel = vgui.Create( "DImage", EncyclopediaEntry )
--PicPanel:SetPos( EncyclopediaEntry:GetWide()*0.5, 5 )   
--PicPanel:SetSize( EncyclopediaEntry:GetWide()*0.4, EncyclopediaEntry:GetTall() - 30 )   
--PicPanel:SetImage("selectonemelon")
end

function WMCheckServerMaps()
local ServerMapPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
ServerMapPanel:SetPos( XPos, YPos ) -- Position on the players screen
ServerMapPanel:SetSize( ScrW()*0.5, ScrH()*0.5 ) -- Size of the frame
ServerMapPanel:SetTitle( "Available Maps and Variants")
ServerMapPanel:SetVisible( true )
ServerMapPanel:SetSizable(true)
ServerMapPanel:SetDraggable( true ) -- Draggable by mouse?
ServerMapPanel:ShowCloseButton( true ) -- Show the close button?
ServerMapPanel:MakePopup() -- Show the frame

 	local html5 = vgui.Create( "HTML", ServerMapPanel )
	html5:SetSize( ScrW()*0.45, ScrH()*0.45 )
	html5:SetPos( 10, 35 )
	html5:SetHTML( file.Read("WM-RTS/wmservermaplist-cur.txt") )
end

function WMLoadScenario()
local LoadScenarioPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
LoadScenarioPanel:SetPos( XPos, YPos ) -- Position on the players screen
LoadScenarioPanel:SetSize( ScrW()*0.9, ScrH()*0.5 ) -- Size of the frame
LoadScenarioPanel:SetTitle( "Load Scenario")
LoadScenarioPanel:SetVisible( true )
LoadScenarioPanel:SetSizable(true)
LoadScenarioPanel:SetDraggable( true ) -- Draggable by mouse?
LoadScenarioPanel:ShowCloseButton( true ) -- Show the close button?
LoadScenarioPanel:MakePopup() -- Show the frame
LoadScenarioPanel.Label1 = vgui.Create( "Label" )
LoadScenarioPanel.Label1:SetPos(305, 25)

local ScenarioComboBox = vgui.Create( "DComboBox", LoadScenarioPanel )  
ScenarioComboBox:SetPos( 10, 35 )  
ScenarioComboBox:SetSize( 300, ScrH()*0.45 )  
ScenarioComboBox:SetMultiple( false )
local serversscens = string.Explode("\n<br>\n", file.Read("WM-RTS/wmservermaplist-cur.txt"))
PrintTable(serversscens)
    for k, v in pairs (file.Find("WM-RTS/scenarios/*.txt")) do
        for x, y in pairs (serversscens) do
            if tostring(y) == tostring(v) then
            local comboitem = ScenarioComboBox:AddItem( y )
                function comboitem:DoClick()
                local ini = file.Read("WM-RTS/scenarios/" .. self:GetText())
                local exploded = string.Explode("\n", ini);
                 for a, b in pairs (exploded) do
                     if string.find(b, "Variant Author") == 1 then
                     --LoadScenarioPanel.Label2:SetText(exploded[a+1])
                     elseif string.find(b, "Variant Description") == 1 then
                     --LoadScenarioPanel.Label4:SetText(exploded[a+1])
                     elseif string.find(b, "Variant Name") == 1 then 
                     --LoadScenarioPanel.Label1:SetText(exploded[a+1])           
                     end
                 end
                end
            end
        end
    end



end

function WMBountyMenu()

local BountyInfoPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
BountyInfoPanel:SetPos( 400, 50 ) -- Position on the players screen
BountyInfoPanel:SetSize( 210, 300 ) -- Size of the frame
BountyInfoPanel:SetTitle( "Bounty Menu")
BountyInfoPanel:SetVisible( true )
BountyInfoPanel:SetSizable(true)
BountyInfoPanel:SetDraggable( true ) -- Draggable by mouse?
BountyInfoPanel:ShowCloseButton( true ) -- Show the close button?
BountyInfoPanel:MakePopup() -- Show the frame

local Label1 = vgui.Create("DLabel", BountyInfoPanel)
Label1:SetPos(100,30)
Label1:SetText("Team 1: " .. CTeamBounty[1])
Label1:SetTextColor(Color(255,0,0,255))
Label1:SizeToContents()

local Label2 = vgui.Create("DLabel", BountyInfoPanel)
Label2:SetPos(100,60)
Label2:SetText("Team 2: " .. CTeamBounty[2])
Label2:SetTextColor(Color(0,0,255,255))
Label2:SizeToContents()

local Label3 = vgui.Create("DLabel", BountyInfoPanel)
Label3:SetPos(100,90)
Label3:SetText("Team 3: " .. CTeamBounty[3])
Label3:SetTextColor(Color(0,255,0,255))
Label3:SizeToContents()

local Label4 = vgui.Create("DLabel", BountyInfoPanel)
Label4:SetPos(100,120)
Label4:SetText("Team 4: " .. CTeamBounty[4])
Label4:SetTextColor(Color(255,255,0,255))
Label4:SizeToContents()

local Label5 = vgui.Create("DLabel", BountyInfoPanel)
Label5:SetPos(100, 150)
Label5:SetText("Team 5: " .. CTeamBounty[5])
Label5:SetTextColor(Color(255,0,255,255))
Label5:SizeToContents()

local Label6 = vgui.Create("DLabel", BountyInfoPanel)
Label6:SetPos(100,180)
Label6:SetText("Team 6: " .. CTeamBounty[6])
Label6:SetTextColor(Color(0,255,255,255))
Label6:SizeToContents()

local Label7 = vgui.Create("DLabel", BountyInfoPanel)
Label7:SetPos(100,210)
Label7:SetText("Team 7: " .. CTeamBounty[7] )
Label7:SetTextColor(Color(0,0,0,255))
Label7:SizeToContents()

   local BountySlider = vgui.Create( "DNumSlider", BountyInfoPanel )   
   BountySlider:SetPos( 25, 240)   
   BountySlider:SetSize( 150, 100 ) -- Keep the second number at 100   
   BountySlider:SetText( "Amount to Raise" )   
   BountySlider:SetMin( 0 ) -- Minimum number of the slider   
   BountySlider:SetMax( LocalPlayer():GetNetworkedInt("nrg") ) -- Maximum number of the slider   
   BountySlider:SetDecimals( 0 ) -- Sets a decimal. Zero means it's an integer  
   
local BountyButton1 = vgui.Create("DButton", BountyInfoPanel)
BountyButton1:SetText( "Raise Bounty" )
BountyButton1:SetPos( 10, 27)
BountyButton1:SetSize(75, 20)
BountyButton1:SetTextColor(Color(255,0,0,255))
BountyButton1.DoClick = function()
         RunConsoleCommand( "wmbounty", "1", BountySlider:GetValue() )
     end   

local BountyButton2 = vgui.Create("DButton", BountyInfoPanel)
BountyButton2:SetText( "Raise Bounty" )
BountyButton2:SetPos( 10, 57)
BountyButton2:SetSize(75, 20)
BountyButton2:SetTextColor(Color(0,0,255,255))
BountyButton2.DoClick = function()
         RunConsoleCommand( "wmbounty", "2", BountySlider:GetValue() )
     end   

local BountyButton3 = vgui.Create("DButton", BountyInfoPanel)
BountyButton3:SetText( "Raise Bounty" )
BountyButton3:SetPos( 10, 87)
BountyButton3:SetSize(75, 20)
BountyButton3:SetTextColor(Color(0,255,0,255))
BountyButton3.DoClick = function()
         RunConsoleCommand( "wmbounty", "3", BountySlider:GetValue() )
     end   
local BountyButton4 = vgui.Create("DButton", BountyInfoPanel)
BountyButton4:SetText( "Raise Bounty" )
BountyButton4:SetPos( 10, 117)
BountyButton4:SetSize(75, 20)
BountyButton4:SetTextColor(Color(255,255,0,255))
BountyButton4.DoClick = function()
         RunConsoleCommand( "wmbounty", "4", BountySlider:GetValue() )
     end   
     
local BountyButton5 = vgui.Create("DButton", BountyInfoPanel)
BountyButton5:SetText( "Raise Bounty" )
BountyButton5:SetPos( 10, 147)
BountyButton5:SetSize(75, 20)
BountyButton5:SetTextColor(Color(255,0,255,255))
BountyButton5.DoClick = function()
         RunConsoleCommand( "wmbounty", "5", BountySlider:GetValue() )
     end   
     
local BountyButton6 = vgui.Create("DButton", BountyInfoPanel)
BountyButton6:SetText( "Raise Bounty" )
BountyButton6:SetPos( 10, 177)
BountyButton6:SetSize(75, 20)
BountyButton6:SetTextColor(Color(0,255,255,255))
BountyButton6.DoClick = function()
         RunConsoleCommand( "wmbounty", "6", BountySlider:GetValue() )
     end  
                
local BountyButton7 = vgui.Create("DButton", BountyInfoPanel)
BountyButton7:SetText( "Raise Bounty" )
BountyButton7:SetPos( 10, 207)
BountyButton7:SetSize(75, 20)
BountyButton7:SetTextColor(Color(0,0,0,255))
BountyButton7.DoClick = function()
         RunConsoleCommand( "wmbounty", "7", BountySlider:GetValue() )
     end     
     
end

function WMVariantInfo()
local VariantInfoPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
VariantInfoPanel:SetPos( 10, 300 ) -- Position on the players screen
VariantInfoPanel:SetSize( ScrW()*0.9, ScrH()*0.5 ) -- Size of the frame
VariantInfoPanel:SetTitle( "Variant Info")
VariantInfoPanel:SetVisible( true )
VariantInfoPanel:SetSizable(true)
VariantInfoPanel:SetDraggable( true ) -- Draggable by mouse?
VariantInfoPanel:ShowCloseButton( true ) -- Show the close button?
VariantInfoPanel:MakePopup() -- Show the frame

 	local htmlinfo = vgui.Create( "HTML", VariantInfoPanel )
	htmlinfo:SetSize( VariantInfoPanel:GetWide()*0.45 + 10, VariantInfoPanel:GetTall() - 40 )
	htmlinfo:SetPos( VariantInfoPanel:GetWide()*0.53, 30 )
	htmlinfo:SetHTML( Text )

end


function WMInvite()
local InviteMenu = vgui.Create("DFrame")
InviteMenu:SetPos( 500, 200 ) -- Position on the players screen
InviteMenu:SetSize( 125, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95)) -- Size of the frame
InviteMenu:SetTitle( "Invite Players")
InviteMenu:SetVisible( true )
InviteMenu:SetDraggable( true ) -- Draggable by mouse?
InviteMenu:ShowCloseButton( true ) -- Show the close button?
InviteMenu:MakePopup() -- Show the frame

local InviteComboBox = vgui.Create( "DComboBox", InviteMenu )  
 InviteComboBox:SetPos( 10, 35 )  
 InviteComboBox:SetSize( 105, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95) - 75 )  
 InviteComboBox:SetMultiple( false )
 for k, v in pairs (player.GetAll()) do
    if v:GetName() ~= LocalPlayer():GetName() && v:Team() ~= LocalPlayer():Team() then
    InviteComboBox:AddItem( v:GetName() )
    end
 end
 function InviteComboBox:SelectItem( item, onlyme ) 
   
 	if ( !onlyme && item:GetSelected() ) then return end 
 	 
 	self.m_pSelected = item 
 	if item:GetSelected() == true then
 	item:SetSelected( false )
 	  for k, v in pairs (self.SelectedItems) do
 	      if v == item then
 	      table.remove(self.SelectedItems, k)
 	      end
 	  end
    
    else
    item:SetSelected( true )
 	table.insert( self.SelectedItems, item ) 
    end
 end 

local JustInvited = false 
local InviteButton = vgui.Create("DButton", InviteMenu)
InviteButton:SetText( "Send Invitations" )
InviteButton:SetPos( 17, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95) - 35 )
InviteButton:SetSize(90, 30)
InviteButton.DoClick = function()
     if InviteComboBox:GetSelectedItems() and InviteComboBox:GetSelectedItems()[1] then
     Msg(InviteComboBox:GetSelectedItems()[1]:GetValue())
     if JustInvited == false then
     InviteButton:SetText("Invitations Sent")
     timer.Simple(3,function() InviteMenu:Remove() end)  
     end
     JustInvited = true
     Msg("/n\n")
         for k, v in pairs (InviteComboBox:GetSelectedItems()) do
         RunConsoleCommand( "wmsendinvite", v:GetValue() )
         end
     end   
 end  



end

function WMDonate()

local DermaPanel = vgui.Create( "DFrame" ) -- Creates the frame itself
DermaPanel:SetPos( 10, 400 ) -- Position on the players screen
DermaPanel:SetSize( 165, 50 + ScrH()*math.Clamp((0.15+(table.Count(player.GetAll())*0.025 )), 0.1, 0.95) ) -- Size of the frame
DermaPanel:SetTitle( "NRG Donation" ) -- Title of the frame
DermaPanel:SetVisible( true )
DermaPanel:SetDraggable( true ) -- Draggable by mouse?
DermaPanel:ShowCloseButton( true ) -- Show the close button?
DermaPanel:MakePopup() -- Show the frame

local DonateComboBox = vgui.Create( "DComboBox", DermaPanel )  
 DonateComboBox:SetPos( 10, 35 )  
 DonateComboBox:SetSize( 145, 50 + ScrH()*math.Clamp((0.15+(table.Count(player.GetAll())*0.025 )), 0.1, 0.95) - 150 )  
 DonateComboBox:SetMultiple( false )
 for k, v in pairs (player.GetAll()) do
    if v:GetName() ~= LocalPlayer():GetName() then
    DonateComboBox:AddItem( v:GetName() )
    end
 end
 function DonateComboBox:SelectItem( item, onlyme ) 
   
 	if ( !onlyme && item:GetSelected() ) then return end 
 	 
 	self.m_pSelected = item 
 	if item:GetSelected() == true then
 	item:SetSelected( false )
 	  for k, v in pairs (self.SelectedItems) do
 	      if v == item then
 	      table.remove(self.SelectedItems, k)
 	      end
 	  end
    
    else
    item:SetSelected( true )
 	table.insert( self.SelectedItems, item ) 
    end
 end 
 
   local DonateSlider = vgui.Create( "DNumSlider", DermaPanel )   
   DonateSlider:SetPos( 7, 50 + ScrH()*math.Clamp((0.15+(table.Count(player.GetAll())*0.025 )), 0.1, 0.95) - 105)   
   DonateSlider:SetSize( 150, 100 ) -- Keep the second number at 100   
   DonateSlider:SetText( "Nrg to Donate" )   
   DonateSlider:SetMin( 0 ) -- Minimum number of the slider   
   DonateSlider:SetMax( LocalPlayer():GetNetworkedInt("nrg") ) -- Maximum number of the slider   
   DonateSlider:SetDecimals( 0 ) -- Sets a decimal. Zero means it's an integer  
   
local DonateButton = vgui.Create("DButton", DermaPanel)
DonateButton:SetText( "Donate NRG" )
DonateButton:SetPos( 18, 50 + ScrH()*math.Clamp((0.15+(table.Count(player.GetAll())*0.025 )), 0.1, 0.95) - 60)
DonateButton:SetSize(125, 40)
DonateButton.DoClick = function()
         for k, v in pairs (DonateComboBox:GetSelectedItems()) do
         RunConsoleCommand( "wmsendnrg", v:GetValue(), DonateSlider:GetValue() )
         end
    DermaPanel:Remove()
     end   
   
end

function ImPopular( inf )
local team = inf:ReadShort()
local invitingply = inf:ReadEntity()
local plyname = invitingply:GetName()
	local colors = {}
	colors[0] = "Admin"
	colors[1] = "Red"
	colors[2] = "Blue"
	colors[3] = "Green"
	colors[4] = "Yellow"
	colors[5] = "Magenta"
	colors[6] = "Cyan"
	
    local InvitedMenu = vgui.Create("DFrame")
    InvitedMenu:SetPos( 300, 150 ) -- Position on the players screen
    InvitedMenu:SetSize( 360, 100) -- Size of the frame
    InvitedMenu:SetTitle( "Incoming Invitation")
    InvitedMenu:SetVisible( true )
    InvitedMenu:SetDraggable( true ) -- Draggable by mouse?
    InvitedMenu:ShowCloseButton( false ) -- Show the close button?
    InvitedMenu:MakePopup() -- Show the frame
    local InviteMessage = plyname .. " has invited you to team " .. invitingply:Team() .. " (" .. colors[invitingply:Team()] .. ")."
    Msg(string.len(InviteMessage))
    InvitedMenu.Label1 = vgui.Create("Label", InvitedMenu)
    InvitedMenu.Label1:SetText(InviteMessage)
    InvitedMenu.Label1:SetPos(140 - string.len(InviteMessage), 25)
    InvitedMenu.Label1:SizeToContents()
    local AcceptButton = vgui.Create("DButton", InvitedMenu)
    AcceptButton:SetText( "Accept" )
    AcceptButton:SetPos( 5 , 50)
    AcceptButton:SetSize(110, 40 )
    AcceptButton.DoClick = function()
     RunConsoleCommand( "wmacceptinvite")
     InvitedMenu:Remove()
     end
    
     local DeclineButton = vgui.Create("DButton", InvitedMenu)
    DeclineButton:SetText( "Decline" )
    DeclineButton:SetPos( 125 , 50)
    DeclineButton:SetSize(110, 40 )
    DeclineButton.DoClick = function()
    LocalPlayer():ConCommand("wmdeclineinvite")
     InvitedMenu:Remove()
     end
     
    local DeclineButton = vgui.Create("DButton", InvitedMenu)
    DeclineButton:SetText( "Ignore All Invitations" )
    DeclineButton:SetPos( 245 , 50)
    DeclineButton:SetSize(110, 40 )
    DeclineButton.DoClick = function()
    LocalPlayer():ConCommand("wmdeclineinvite")
    RunConsoleCommand( "WM_IgnoreInvites", "1")
     InvitedMenu:Remove()
     end   

timer.Simple(15, function() RunConsoleCommand( "wmdeclineinvite", invitingply ); InvitedMenu:Remove() end)
end
usermessage.Hook("InviteTrigger", ImPopular) 

function WMKickTeammateMenu()


local InviteMenu = vgui.Create("DFrame")
InviteMenu:SetPos( 500, 200 ) -- Position on the players screen
InviteMenu:SetSize( 125, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95)) -- Size of the frame
InviteMenu:SetTitle( "Kick Teammates")
InviteMenu:SetVisible( true )
InviteMenu:SetDraggable( true ) -- Draggable by mouse?
InviteMenu:ShowCloseButton( true ) -- Show the close button?
InviteMenu:MakePopup() -- Show the frame

local InviteComboBox = vgui.Create( "DComboBox", InviteMenu )  
 InviteComboBox:SetPos( 10, 35 )  
 InviteComboBox:SetSize( 105, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95) - 75 )  
 InviteComboBox:SetMultiple( false )
 for k, v in pairs (team.GetPlayers(LocalPlayer():Team())) do
    if v:GetName() ~= LocalPlayer():GetName() then
    InviteComboBox:AddItem( v:GetName() )
    end
 end
 function InviteComboBox:SelectItem( item, onlyme ) 
   
 	if ( !onlyme && item:GetSelected() ) then return end 
 	 
 	self.m_pSelected = item 
 	if item:GetSelected() == true then
 	item:SetSelected( false )
 	  for k, v in pairs (self.SelectedItems) do
 	      if v == item then
 	      table.remove(self.SelectedItems, k)
 	      end
 	  end
    
    else
    item:SetSelected( true )
 	table.insert( self.SelectedItems, item ) 
    end
 end 

local InviteButton = vgui.Create("DButton", InviteMenu)
InviteButton:SetText( "Kick Teammate(s)" )
InviteButton:SetPos( 17, ScrH()*math.Clamp((0.12+(table.Count(player.GetAll())*0.05 )), 0.1, 0.95) - 35 )
InviteButton:SetSize(90, 30)
InviteButton.DoClick = function()
     if InviteComboBox:GetSelectedItems() and InviteComboBox:GetSelectedItems()[1] then
     Msg(InviteComboBox:GetSelectedItems()[1]:GetValue())
     InviteButton:SetText("Player(s) kicked")
     timer.Simple(3,function() InviteMenu:Remove() end)  
     end
         for k, v in pairs (InviteComboBox:GetSelectedItems()) do
         RunConsoleCommand( "wmkickteammate", v:GetValue() )
         end
     end   
end  

function WMPhantomDiscountMenu()

local PhantomDiscountMenu = vgui.Create("DFrame")
PhantomDiscountMenu:SetPos( 500, 200 )
PhantomDiscountMenu:SetSize( 190, 150) -- Size of the frame
PhantomDiscountMenu:SetTitle( "Set Discount")
PhantomDiscountMenu:SetVisible( true )
PhantomDiscountMenu:SetDraggable( true )
PhantomDiscountMenu:ShowCloseButton( true )
PhantomDiscountMenu:MakePopup()

   local DiscountMaxSlider = vgui.Create( "DNumSlider", PhantomDiscountMenu )   
   DiscountMaxSlider:SetPos( 20, 30)   
   DiscountMaxSlider:SetSize( 150, 100 ) -- Keep the second number at 100   
   DiscountMaxSlider:SetText( "Maximum Discount" )   
   DiscountMaxSlider:SetMin( 0 ) -- Minimum number of the slider   
   DiscountMaxSlider:SetMax( GetGlobalInt("WMPhantomDiscount") ) -- Maximum number of the slider   
   DiscountMaxSlider:SetDecimals( 1 ) -- Sets a decimal. Zero means it's an integer  

   local DiscountMinSlider = vgui.Create( "DNumSlider", PhantomDiscountMenu )   
   DiscountMinSlider:SetPos( 20, 75)   
   DiscountMinSlider:SetSize( 150, 100 ) -- Keep the second number at 100   
   DiscountMinSlider:SetText( "Minimum Discount" )   
   DiscountMinSlider:SetMin( 0 ) -- Minimum number of the slider   
   DiscountMinSlider:SetMax( GetGlobalInt("WMPhantomDiscount") ) -- Maximum number of the slider   
   DiscountMinSlider:SetDecimals( 1 ) -- Sets a decimal. Zero means it's an integer  

local DiscountButton = vgui.Create("DButton", PhantomDiscountMenu)
DiscountButton:SetText( "Set Discount" )
DiscountButton:SetPos( 50, 120)
DiscountButton:SetSize(75, 25)
DiscountButton:SetTextColor(Color(0,0,0,255))
DiscountButton.DoClick = function()
         RunConsoleCommand( "wmphantomdiscount", DiscountMinSlider:GetValue(), DiscountMaxSlider:GetValue() )
     end   


end

function WMLineTest()

local PhantomDiscountMenu = vgui.Create("DFrame")
PhantomDiscountMenu:SetPos( 500, 200 )
PhantomDiscountMenu:SetSize( 190, 150) -- Size of the frame
PhantomDiscountMenu:SetTitle( "Set Discount")
PhantomDiscountMenu:SetVisible( true )
PhantomDiscountMenu:SetDraggable( true )
PhantomDiscountMenu:ShowCloseButton( true )
PhantomDiscountMenu:MakePopup()
PhantomDiscountMenu.Paint = function()
surface.DrawLine(0,0,700,700)
end
end

concommand.Add("wmvariantinfomenu", VariantInfoMenu)
concommand.Add("wmmenu", ScenarioandVariantControl);
concommand.Add("wmappendhelp", AppendCommands);
concommand.Add("wmencyclopedia", Encyclopedia);
concommand.Add("wmcheckmaps", WMCheckServerMaps);
concommand.Add("wminvite", WMInvite);
concommand.Add("wmhighscore", HighScores);
concommand.Add("wmdonate", WMDonate);
concommand.Add("wmvariantinfo", WMVariantInfo);
concommand.Add("wmloadscenario", WMLoadScenario);
concommand.Add("wmkickteammatemenu", WMKickTeammateMenu);
concommand.Add("wmphantomdiscountmenu", WMPhantomDiscountMenu);
concommand.Add("wmline", WMLineTest);