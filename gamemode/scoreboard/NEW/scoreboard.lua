scoreboard = scoreboard or {}

function scoreboard:show()
	local background = vgui.Create("DPanel")
	background:SetPos(10,30)-- Set the position of the panel
	background:SetSize(200,000)-- Set the size of the panel
	
	local header = vgui.Create("DLabel", background)
	header:SetPos(10,10)-- Set the position of the label
	header:SetText("Warmelons:RTS - A gamemode by Lap, revived by Feha, revived again by |DK|2Matias.")-- Set the text of the label
	header:SizeToContents()-- Size the label to fit the text in it
	header:SetDark(1)-- Set the colour of the text inside the label to a darker one
	--Create the scoreboard here, with an base like DPanel, you can use an DListView for the rows.

	function scoreboard:hide()
		background:Remove()
		-- Here you put how to hide it, eg Base:Remove()
	end
end

function GM:ScoreboardShow()
	scoreboard:show()
end

function GM:ScoreboardHide()
	scoreboard:hide()
end