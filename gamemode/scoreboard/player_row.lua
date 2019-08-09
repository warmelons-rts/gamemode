include( "player_infocard.lua" )

surface.CreateFont( "ScoreboardPlayerName", {
	font = "coolvetica", 
	size = 19, 
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
surface.CreateFont( "ScoreboardPlayerNameBig", {
	font = "coolvetica", 
	size = 22, 
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

local texGradient = surface.GetTextureID( "gui/center_gradient" )

local texRatings = {}
texRatings[ 'none' ] 		= surface.GetTextureID( "gui/silkicons/user" )
texRatings[ 'smile' ] 		= surface.GetTextureID( "gui/silkicons/emoticon_smile" )
texRatings[ 'bad' ] 		= surface.GetTextureID( "gui/silkicons/exclamation" )
texRatings[ 'love' ] 		= surface.GetTextureID( "gui/silkicons/heart" )
texRatings[ 'artistic' ] 	= surface.GetTextureID( "gui/silkicons/palette" )
texRatings[ 'star' ] 		= surface.GetTextureID( "gui/silkicons/star" )
texRatings[ 'builder' ] 	= surface.GetTextureID( "gui/silkicons/wrench" )

surface.GetTextureID( "gui/silkicons/emoticon_smile" )
local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Size = 36
	self:OpenInfo( false )
	
	self.infoCard	= vgui.Create( "ScorePlayerInfoCard", self )
	
	self.lblName 	= vgui.Create( "DLabel", self )
	self.lblPic	= vgui.Create( "DLabel", self )
	self.lblFrags 	= vgui.Create( "DLabel", self )
	self.lblDeaths 	= vgui.Create( "DLabel", self )
	self.lblPing 	= vgui.Create( "DLabel", self )
	self.lblScore 	= vgui.Create( "DLabel", self )
	
	// If you don't do this it'll block your clicks
	self.lblName:SetMouseInputEnabled( false )
	self.lblFrags:SetMouseInputEnabled( false )
	self.lblDeaths:SetMouseInputEnabled( false )
	self.lblPing:SetMouseInputEnabled( false )
	self.lblScore:SetMouseInputEnabled( false )	
	self.imgAvatar = vgui.Create( "AvatarImage", self )
	
	self:SetCursor( "hand" )

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	--local color = Color( 100, 150, 245, 255 )

	--if ( self.Armed ) then
	--	color = Color( 110, 160, 245, 255 )
	--end
	
	--if ( self.Selected ) then
	--	color = Color( 50, 100, 245, 255 )
	--end
	local color = Color( 50, 50, 50, 255 )
	if ( !IsValid( self.Player ) ) then return end
	
	if ( self.Player:Team() == 0 ) then
		color = Color( 50, 50, 50, 255 )
	elseif self.Player:Team() == 1 then
		color = Color( 255, 0, 0, 255 )
	elseif self.Player:Team() == 2 then
		color = Color(0, 0, 255, 255)
	elseif self.Player:Team() == 3 then
		color = Color(0, 255, 0, 255)
	elseif self.Player:Team() == 4 then
		color = Color(255, 255, 0, 255)
	elseif self.Player:Team() == 5 then
		color = Color(255, 0, 255, 255)
	elseif self.Player:Team() == 6 then
		color = Color(0, 255, 255, 255)
	else
		color = Color( 255, 255, 255, 255 )
	end
	
	--if ( self.Player == LocalPlayer() ) then
	
	--	color.r = color.r + math.sin( CurTime() * 8 ) * 10
	---	color.g = color.g + math.sin( CurTime() * 8 ) * 10
	--	color.b = color.b + math.sin( CurTime() * 8 ) * 10
	
	--end

	if ( self.Open || self.Size != self.TargetSize ) then
	
		draw.RoundedBox( 4, 0, 16, self:GetWide(), self:GetTall() - 16, color )
		draw.RoundedBox( 4, 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2, Color( 250, 250, 245, 255 ) )
		
		surface.SetTexture( texGradient )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 2, 16, self:GetWide()-4, self:GetTall() - 16 - 2 ) 
	
	end
	
	draw.RoundedBox( 4, 0, 0, self:GetWide(), 36, color )
	
	surface.SetTexture( texGradient )
	surface.SetDrawColor( 255, 255, 255, 50 )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), 36 ) 
	
	// This should be an image panel!
	surface.SetTexture( self.texRating )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( self:GetWide() - 16 - 8, 36 / 2 - 8, 16, 16 ) 	

	surface.SetTexture( texRatings[ 'star' ] )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 37, 36 / 2 - 8, 16, 16 ) 
	
	return true

end

/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:SetPlayer( ply )

	self.Player = ply
	
	self.infoCard:SetPlayer( ply )
	self.imgAvatar:SetPlayer( ply )
	self:UpdatePlayerData()

end


/*---------------------------------------------------------
   Name: UpdatePlayerData
---------------------------------------------------------*/
function PANEL:UpdatePlayerData()

	if ( !self.Player ) then return end
	if ( !self.Player:IsValid() ) then return end

	self.lblName:SetText( self.Player:Nick() )
	self.lblFrags:SetText( self.Player:Team() )
	self.lblDeaths:SetText( math.floor(self.Player:GetNetworkedInt("nrg")) )
	self.lblPing:SetText( self.Player:Ping() )
	self.lblScore:SetText( math.floor(team.GetScore(self.Player:Team())))
	// Work out what icon to draw
	self.texRating = surface.GetTextureID( "gui/silkicons/emoticon_smile" )

	if  self.Player:GetNetworkedBool("WMCaptain") == true then
	self.texRating = texRatings[ 'star' ]
	else
	self.texRating = texRatings[ 'none' ]
    end

end



/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()

	self.lblName:SetFont( "ScoreboardPlayerNameBig" )
	self.lblFrags:SetFont( "ScoreboardPlayerName" )
	self.lblDeaths:SetFont( "ScoreboardPlayerName" )
	self.lblPing:SetFont( "ScoreboardPlayerName" )
	self.lblScore:SetFont( "ScoreboardPlayerName" )
	self.lblName:SetFGColor( color_black )
	self.lblFrags:SetFGColor( color_black )
	self.lblDeaths:SetFGColor( color_black )
	self.lblPing:SetFGColor( color_black )
	self.lblScore:SetFGColor( color_black )
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:DoClick( x, y )

	if ( self.Open ) then
		surface.PlaySound( "ui/buttonclickrelease.wav" )
	else
		surface.PlaySound( "ui/buttonclick.wav" )
	end

	self:OpenInfo( !self.Open )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:OpenInfo( bool )

	if ( bool ) then
		self.TargetSize = 150
	else
		self.TargetSize = 36
	end
	
	self.Open = bool

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.Size != self.TargetSize ) then
	
		self.Size = math.Approach( self.Size, self.TargetSize, (math.abs( self.Size - self.TargetSize ) + 1) * 10 * FrameTime() )
		self:PerformLayout()
		SCOREBOARD:InvalidateLayout()
	//	self:GetParent():InvalidateLayout()
	
	end
	
	if ( !self.PlayerUpdate || self.PlayerUpdate < CurTime() ) then
	
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
		
	end

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self.imgAvatar:SetPos( 2, 2 )
	self.imgAvatar:SetSize( 32, 32 )

	self:SetSize( self:GetWide(), self.Size )
	
	self.lblName:SizeToContents()
	self.lblName:SetPos( 24, 5 )
	self.lblName:MoveRightOf( self.imgAvatar, 20 )
	
	local COLUMN_SIZE = 50
	
	self.lblPing:SetPos( self:GetWide() - COLUMN_SIZE * 1, 0 )
	self.lblDeaths:SetPos( self:GetWide() - (COLUMN_SIZE * 2) - 25, 0 )
	self.lblFrags:SetPos( self:GetWide() - COLUMN_SIZE * 5, 0 )
	self.lblScore:SetPos( self:GetWide() - COLUMN_SIZE * 4, 0 )
	if ( self.Open || self.Size != self.TargetSize ) then
	
		self.infoCard:SetVisible( true )
		self.infoCard:SetPos( 4, self.imgAvatar:GetTall() + 10 )
		self.infoCard:SetSize( self:GetWide() - 8, self:GetTall() - self.lblName:GetTall() - 10 )
	
	else
	
		self.infoCard:SetVisible( false )
	
	end
	
	

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:HigherOrLower( row )

	if ( !self.Player:IsValid() || self.Player:Team() == TEAM_CONNECTING ) then return false end
	if ( !row.Player:IsValid() || row.Player:Team() == TEAM_CONNECTING ) then return true end
	
	if ( self.Player:Team() == row.Player:Team() ) then
	
		return self.Player:GetNetworkedInt("nrg") > row.Player:GetNetworkedInt("nrg")
	
	end

	return self.Player:Team() < row.Player:Team()

end

vgui.Register( "ScorePlayerRow", PANEL, "Button" )