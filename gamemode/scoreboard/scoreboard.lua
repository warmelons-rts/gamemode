include( "player_row.lua" )
include( "player_frame.lua" )

surface.CreateFont( "ScoreboardHeader", {
	font = "coolvetica", 
	size = 32, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
})
surface.CreateFont( "ScoreboardSubtitle", {
	font = "coolvetica", 
	size = 14, 
	weight = 500, 
	blursize = 0, 
	scanlines = 0, 
	antialias = true, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = false, 
	additive = false, 
	outline = false,
})
local texGradient 	= surface.GetTextureID( "gui/center_gradient" )
local texLogo 		= surface.GetTextureID( "wmm/wmrtslogoak6" )
--local texLogo		= surface.GetTextureID( "gui/gmod_logo" )
--Rabble
local PANEL = {}

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
	print("scoreboard.lua: Init:46: "..tostring(self))
	SCOREBOARD = self

	self.Hostname = vgui.Create( "Label", self )
	self.Hostname:SetText( GetGlobalString( "ServerName" ) )
	
	self.Description = vgui.Create( "Label", self )
	self.Description:SetText( GAMEMODE.Name .. " - " .. GAMEMODE.Author .. " Map: /* .. WMMapName .. */ Variant: " .. GetGlobalString("WMVariant"))//WMMapName is not working.
	
	self.lblScore = vgui.Create( "Label", self )
	self.lblScore:SetText( "Score" )
	
	self.lblPing = vgui.Create( "Label", self )
	self.lblPing:SetText( "Ping" )
	
	self.lblKills = vgui.Create( "Label", self )
	self.lblKills:SetText( "Team" )
	
	self.lblDeaths = vgui.Create( "Label", self )
	self.lblDeaths:SetText( " NRG" )
	
	self.PlayerFrame = vgui.Create( "PlayerFrame", self )
	
	self.PlayerRows = {}
	print("scoreboard.lua: Init:70: "..tostring(self))
	self:UpdateScoreboard()
	print("scoreboard.lua: Init:72: "..tostring(self))
	// Update the scoreboard every 1 second
	timer.Create( "ScoreboardUpdater", 1, 0, self.UpdateScoreboard() )//This is where it goes bad.
	print("scoreboard.lua: Init:75: "..tostring(self))
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:AddPlayerRow( ply )
	print("scoreboard.lua: AddPlayerRow:82: "..tostring(self))
	local button = vgui.Create( "ScorePlayerRow", self.PlayerFrame:GetCanvas() )
	button:SetPlayer( ply )
	self.PlayerRows[ ply ] = button
	print("scoreboard.lua: AddPlayerRow:86: "..tostring(self))
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:GetPlayerRow( ply )
	print("scoreboard.lua: GetPlayerRow:93: "..tostring(self))
	return self.PlayerRows[ ply ]
end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
	//print("scoreboard.lua: Paint:102: "..tostring(self))
	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 170, 170, 170, 255 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() ) 
	
	// White Inner Box
	draw.RoundedBox( 4, 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4, Color( 230, 230, 230, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self:GetTall() - self.Description.y - 4 )
	
	// Sub Header
	draw.RoundedBox( 4, 5, self.Description.y - 3, self:GetWide() - 10, self.Description:GetTall() + 5, Color( 150, 200, 50, 200 ) )
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 4, self.Description.y - 4, self:GetWide() - 8, self.Description:GetTall() + 8 ) 
	
	// Logo!
	surface.SetTexture( texLogo )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( -4, -10, 128, 128 ) 
	
	
	
	//draw.RoundedBox( 4, 10, self.Description.y + self.Description:GetTall() + 6, self:GetWide() - 20, 12, Color( 0, 0, 0, 50 ) )
	//print("scoreboard.lua: Paint:128: "..tostring(self))
end


/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	print("scoreboard.lua: PerformLayout:135: "..tostring(self))
	self.Hostname:SizeToContents()
	self.Hostname:SetPos( 115, 12 )
	
	self.Description:SizeToContents()
	self.Description:SetPos( 115, 64 )
	
	local iTall = self.PlayerFrame:GetCanvas():GetTall() + self.Description.y + self.Description:GetTall() + 30
	iTall = math.Clamp( iTall, 100, ScrH() * 0.9 )
	local iWide = math.Clamp( ScrW() * 0.8, 500, 700 )
	
	self:SetSize( iWide, iTall )
	self:SetPos( (ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 4 )
	
	self.PlayerFrame:SetPos( 5, self.Description.y + self.Description:GetTall() + 20 )
	self.PlayerFrame:SetSize( self:GetWide() - 10, self:GetTall() - self.PlayerFrame.y - 10 )
	
	local y = 0
	
	local PlayerSorted = {}
	
	for k, v in pairs( self.PlayerRows ) do
	
		table.insert( PlayerSorted, v )
		
	end
	
	table.sort( PlayerSorted, function ( a , b) return a:HigherOrLower( b ) end )
	
	for k, v in ipairs( PlayerSorted ) do
	
		v:SetPos( 0, y )	
		v:SetSize( self.PlayerFrame:GetWide(), v:GetTall() )
		
		self.PlayerFrame:GetCanvas():SetSize( self.PlayerFrame:GetCanvas():GetWide(), y + v:GetTall() )
		
		y = y + v:GetTall() + 1
	print("scoreboard.lua: PerformLayout:173: "..tostring(self))
	end
	
	self.Hostname:SetText( GetGlobalString( "ServerName" ) )
	
	self.lblPing:SizeToContents()
	self.lblKills:SizeToContents()
	self.lblDeaths:SizeToContents()
	self.lblScore:SizeToContents()
	self.lblPing:SetPos( self:GetWide() - 50 - self.lblPing:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	self.lblDeaths:SetPos( self:GetWide() - 50*2 - 25 - self.lblDeaths:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	self.lblKills:SetPos( self:GetWide() - 50*5 - self.lblKills:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	self.lblScore:SetPos( self:GetWide() - 50*4 - self.lblKills:GetWide()/2, self.PlayerFrame.y - self.lblPing:GetTall() - 3  )
	//self.lblKills:SetFont( "DefaultSmall" )
	//self.lblDeaths:SetFont( "DefaultSmall" )
	print("scoreboard.lua: PerformLayout:187: "..tostring(self))
end

/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()
	print("scoreboard.lua: ApplySchemeSettings:194: "..tostring(self))
	self.Hostname:SetFont( "ScoreboardHeader" )
	self.Description:SetFont( "ScoreboardSubtitle" )
	
	self.Hostname:SetFGColor( color_black )
	self.Description:SetFGColor( color_black )
	
	self.lblPing:SetFont( "Default" )
	self.lblKills:SetFont( "Default" )
	self.lblDeaths:SetFont( "Default" )
	self.lblScore:SetFont( "Default" )
    	
	self.lblPing:SetFGColor( color_black )
	self.lblKills:SetFGColor( color_black )
	self.lblDeaths:SetFGColor( color_black )
	self.lblScore:SetFGColor( color_black )
	print("scoreboard.lua: ApplySchemeSettings:210: "..tostring(self))
end

function PANEL:UpdateScoreboard( force )

	print("scoreboard.lua: UpdateScoreboard:215: "..tostring(self)..". This should never be 'nil'")
	if ( !force && !self:IsVisible() ) then return end //self is nil for some reason after the first pass.
	self.Description:SetText( GAMEMODE.Name .. " - " .. GAMEMODE.Author .. " Map:  /*.. WMMapName ..*/  Vairant: " ..  GetGlobalString("WMVariant")) //WMMapName is not working.
	for k, v in pairs( self.PlayerRows ) do
	
		if ( !k:IsValid() ) then
		
			v:Remove()
			self.PlayerRows[ k ] = nil
			
		end
	
	end
	
	local PlayerList = player.GetAll()	
	for id, pl in pairs( PlayerList ) do
		
		if ( !self:GetPlayerRow( pl ) ) then
		
			self:AddPlayerRow( pl )
		
		end
		
	end
	
	// Always invalidate the layout so the order gets updated
	print("scoreboard.lua: UpdateScoreboard:241: "..tostring(self))
	self:InvalidateLayout(false)
	print("scoreboard.lua: UpdateScoreboard:243: "..tostring(self))
end

vgui.Register( "ScoreBoard", PANEL, "Panel" )