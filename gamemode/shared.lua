GM.IsSandboxDerived = true

GM.Name 		= "WarMelons:RTS"
GM.Author 		= "Lap, Feha, Ducky and |DK2|Matias"
GM.Email 		= "N/A"
GM.Website 		= "N/A"


function GM:Initialize()
	team.SetUp(0, "Admin", Color (0, 0, 0, 255))
	team.SetUp(1, "Red", Color (255, 0, 0, 255))
	team.SetUp(2, "Blue", Color (0, 0, 255, 255))
	team.SetUp(3, "Green", Color (0, 255, 0, 255))
	team.SetUp(4, "Yellow", Color (255, 255, 0, 255))
	team.SetUp(5, "Magenta", Color (255, 0, 255, 255))
	team.SetUp(6, "Cyan", Color (0, 255, 255, 255))
	team.SetUp(7, "Barbarian", Color (25, 25, 25, 255))
	team.SetUp(8, "Spectator", Color (255, 255, 255, 255))
end

function GM:Think()
	
end
