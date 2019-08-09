include( "scoreboard/scoreboard.lua" )

local pScoreBoard = nil


/*---------------------------------------------------------
   Name: gamemode:CreateScoreboard( )
   Desc: Creates/Recreates the scoreboard
---------------------------------------------------------*/
function GM:CreateScoreboard()
	print("cl_scoreboard.lua: CreateScoreboard:11: "..tostring(pScoreBoard))
	if ( pScoreBoard ) then
	
		pScoreBoard:Remove()
		pScoreBoard = nil
	
	end
	print("cl_scoreboard.lua: CreateScoreboard:18: "..tostring(pScoreBoard)..". This should be 'nil'")
	pScoreBoard = vgui.Create( "ScoreBoard" )//This is not being created. pScoreBoard stays nil. Which causes the problem in scoreboard.lua line 216
	print("cl_scoreboard.lua: CreateScoreboard:20: "..tostring(pScoreBoard)..". This should NOT be 'nil'")
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardShow( )
   Desc: Sets the scoreboard to visible
---------------------------------------------------------*/
function GM:ScoreboardShow()

	GAMEMODE.ShowScoreboard = true
	gui.EnableScreenClicker( true )
	print("cl_scoreboard.lua: CreateScoreboard:31: "..tostring(pScoreBoard))
	if ( !pScoreBoard ) then
		self:CreateScoreboard()
	end
	print("cl_scoreboard.lua: CreateScoreboard:35: "..tostring(pScoreBoard))
	pScoreBoard:SetVisible( true )
	pScoreBoard:UpdateScoreboard( true )
	
end

/*---------------------------------------------------------
   Name: gamemode:ScoreboardHide( )
   Desc: Hides the scoreboard
---------------------------------------------------------*/
function GM:ScoreboardHide()

	

	GAMEMODE.ShowScoreboard = false
	gui.EnableScreenClicker( false )
	
	if ( pScoreBoard ) then pScoreBoard:SetVisible( false ) end
	
end

function GM:HUDDrawScoreBoard()

	// Do nothing (We're vgui'd up)
	
end

