
local convar = CreateClientConVar("radar_scale", "300", true)
local convar2 = CreateClientConVar("radar_enabled", "0", false)
local convar3 = CreateClientConVar("radar_radius", "8000", true)
local convar4 = CreateClientConVar("radar_bg_alpha", "200", true)
local convar6 = CreateClientConVar("radar_teamcolors", "1", true)
local convar7 = CreateClientConVar("radar_dot_center_size", "8", true)
local convar8 = CreateClientConVar("radar_dot_size", "4", true)
local convar9 = CreateClientConVar("radar_bg_color", "20 100 255 ", true)
local convar10 = CreateClientConVar("radar_dot_color", "255 255 0 225", true)
local convar11 = CreateClientConVar("radar_dot_center_color", "255 255 0 225", true)
local convar12 = CreateClientConVar("radar_admin_color", "0 255 0 225", true)
local convar13 = CreateClientConVar("radar_text_color", "255 255 0 225", true)
local convar17 = CreateClientConVar("radar_target_overview", "1", true)
local convar18 = CreateClientConVar("radar_auto_adjust", "0", true)
local convar19 = CreateClientConVar("radar_x_pos", ""..ScrW()/40, true)
local convar20 = CreateClientConVar("radar_y_pos", ""..ScrH()/40, true)

local Radar_Target = nil

function TheMenu( Panel )
	Panel:Clear()
	Panel:AddControl( "Label" , { Text = "Radar Setting", Description = "Customize joo h4x!"} )

	Panel:AddControl( "CheckBox", {
		Label = "Radar",
		Command = "radar_enabled",
		}
	)

	Panel:AddControl( "CheckBox", {
		Label = "Radar Auto Adjust",
		Command = "radar_auto_adjust",
		}
	)

	Panel:AddControl( "CheckBox", {
		Label = "Radar Team Colors",
		Command = "radar_teamcolors",
		}
	)

	Panel:AddControl( "Slider", {
		Label = "Radar Zoom",
		Command = "radar_radius",
		type = "number",
		min = 200,
		max = 15000,
		}
	)
	Panel:AddControl( "Slider", {
		Label = "Radar Size",
		Command = "radar_scale",
		type = "number",
		min = 200,
		max = 999,
		}
	)
	Panel:AddControl( "Slider", {
		Label = "Radar dot size",
		Command = "radar_dot_size",
		type = "number",
		min = 2,
		max = 20,
		}
	)
	Panel:AddControl( "Slider", {
		Label = "Radar X Position",
		Command = "radar_x_pos",
		type = "number",
		min = 0,
		max = ScrW(),
		}
	)
	Panel:AddControl( "Slider", {
		Label = "Radar Y Position",
		Command = "radar_y_pos",
		type = "number",
		min = 0,
		max = ScrH(),
		}
	)
	

end
  
function createthemenu()
	spawnmenu.AddToolCategory("Options", "WMRTSToolCategory", "WM:RTS Options")
	spawnmenu.AddToolMenuOption( "Options", "WMRTSToolCategory", "CustomMenu", "Radar Settings", "", "", TheMenu)
end

hook.Add( "PopulateToolMenu", "Radar Menuz", createthemenu )

local function RadarTarget(ply, cmd, args)
	local TargetName = TargetName
	if args[1] and args[1] != "" then
		for k, v in pairs(player.GetAll()) do
			if string.find(string.lower(v:Nick()), string.lower(args[1])) != nil then
				Radar_Target = v
				ply:PrintMessage( HUD_PRINTCONSOLE, "Radar watching "..v:Nick() )
			end
		end
	end
end
concommand.Add( "radar_target", RadarTarget )

local function RadarTargetRes(ply, cmd, args)
	Radar_Target = nil
end
concommand.Add( "radar_target_reset", RadarTargetRes )

local function DrawCam(X,Y,W,H,radius)
if tostring(LocalPlayer():GetActiveWeapon().PrintName) ~= "#GMOD_Camera" then
	local trace = {}
	local hitpos = util.TraceLine(trace).HitPos

	local CamData = {} 
	
	if Radar_Target != nil then

		CamData.angles = Angle(90,Radar_Target:EyeAngles().y,0)

		--[[if convar18:GetFloat() != 0 then
			local trace = {}
			trace.start = Radar_Target:GetPos()
			trace.endpos = trace.start*999999
			trace.filter = {Radar_Target,}
			local tr = util.TraceLine( trace )

			CamData.origin = Radar_Target:GetPos() +Vector(0,0,tr.HitPos)
		else]]
			CamData.origin = Radar_Target:GetPos() +Vector(0,0,radius)
		--end
	else

		CamData.angles = Angle(90,LocalPlayer():EyeAngles().y,0)

		--[[if convar18:GetFloat() != 0 then
			local trace = {}
			trace.start = LocalPlayer():GetPos()
			trace.endpos = trace.start*999999
			trace.filter = {LocalPlayer(),}
			local tr = util.TraceLine( trace )

			CamData.origin = LocalPlayer():GetPos() +Vector(0,0,tr.HitPos)
		else]]
			CamData.origin = LocalPlayer():GetPos() +Vector(0,0,radius)
		--end
	end
	CamData.x = X
	CamData.y = Y
	CamData.w = W
	CamData.h = H
	render.RenderView( CamData )
	
	//Why is this here? For some reason render.RenderView likes to remove my crosshair, so I made my own for when the radar is on.
	
	local x = ScrW() / 2.0
	local y = ScrH() / 2.0 
	
	surface.SetDrawColor( 255, 255, 0, 255 )
	
	surface.DrawLine( x, y, x+10, y )
	surface.DrawLine( x, y, x-10, y )
	surface.DrawLine( x, y, x, y+5 )
	surface.DrawLine( x, y, x, y-5 )
end
end

local function ILiekRadar()
if tostring(LocalPlayer():GetActiveWeapon().PrintName) ~= "#GMOD_Camera" then
	//Settings and crap..
	local radar = {}
	radar.w = convar:GetFloat()
	radar.h = convar:GetFloat()
	radar.x = convar19:GetFloat()
	radar.y = convar20:GetFloat()
	radar.radius = convar3:GetFloat()

	radar.alpha = convar4:GetFloat()
	radar.bgcolor = Color(tonumber(string.Explode(" ", convar9:GetString())[1]),tonumber(string.Explode(" ", convar9:GetString())[2]),tonumber(string.Explode(" ", convar9:GetString())[3]),255)
	radar.dotcolor = Color(tonumber(string.Explode(" ", convar10:GetString())[1]),tonumber(string.Explode(" ", convar10:GetString())[2]),tonumber(string.Explode(" ", convar10:GetString())[3]),tonumber(string.Explode(" ", convar10:GetString())[4]))
	radar.centerdotcolor = Color(tonumber(string.Explode(" ", convar11:GetString())[1]),tonumber(string.Explode(" ", convar11:GetString())[2]),tonumber(string.Explode(" ", convar11:GetString())[3]),tonumber(string.Explode(" ", convar11:GetString())[4]))
	radar.admincolor = Color(tonumber(string.Explode(" ", convar12:GetString())[1]),tonumber(string.Explode(" ", convar12:GetString())[2]),tonumber(string.Explode(" ", convar12:GetString())[3]),tonumber(string.Explode(" ", convar12:GetString())[4]))
	radar.textcolor = Color(tonumber(string.Explode(" ", convar13:GetString())[1]),tonumber(string.Explode(" ", convar13:GetString())[2]),tonumber(string.Explode(" ", convar13:GetString())[3]),tonumber(string.Explode(" ", convar13:GetString())[4]))
	
	if convar2:GetFloat() != 0 then
		draw.RoundedBox(4, radar.x-5, radar.y-5, radar.w+10, radar.h+10, Color(0,0,0,radar.alpha))
		DrawCam(radar.x,radar.y,radar.w,radar.h,radar.radius)
	end

	local tblst = player.GetAll()
	
	for _, pl in pairs(tblst) do
		if convar2:GetFloat() != 0 then
		
			local specplayer = LocalPlayer()
			if Radar_Target != nil then
				specplayer = Radar_Target
			else
				specplayer = LocalPlayer()
			end

			local fovcalc = LocalPlayer():GetFOV()/(70/1.13) //radar dots would get offset if the player had different FOVs

			local ztar = specplayer:GetPos().z -(pl:GetPos().z)
			local Nor = (specplayer:GetPos() - pl:GetPos())
			Nor:Rotate( Angle(180,(specplayer:EyeAngles().y)*-1,-180))
			local Norxi = Nor.x * (radar.w / ((radar.radius *(fovcalc  * (ScrW() / ScrH()))) + ztar * (fovcalc  * (ScrW() / ScrH()))))
			local Noryi = Nor.y * (radar.h / ((radar.radius * (fovcalc  * (ScrW() / ScrH()))) + ztar * (fovcalc  * (ScrW() / ScrH()))))

			local cx = radar.x+radar.w/2
			local cy = radar.y+radar.h/2
			local vdiff = pl:GetPos()-specplayer:GetPos()

			if convar6:GetFloat() == 1 then
				if Radar_Target != nil then
					draw.RoundedBox( convar7:GetFloat()/2, cx-(convar7:GetFloat()/2),cy-(convar7:GetFloat()/2), convar7:GetFloat(), convar7:GetFloat(), team.GetColor(Radar_Target:Team()))
					draw.DrawText(""..Radar_Target:Nick(), "DefaultSmall", cx-4, cy-15-(convar8:GetFloat()/2), team.GetColor(Radar_Target:Team()), 1)
				else
					if LocalPlayer():IsAdmin() then
						draw.RoundedBox( convar7:GetFloat()/2, cx-(convar7:GetFloat()/2),cy-(convar7:GetFloat()/2), convar7:GetFloat(), convar7:GetFloat(), radar.admincolor)
					else
						draw.RoundedBox( convar7:GetFloat()/2, cx-(convar7:GetFloat()/2),cy-(convar7:GetFloat()/2), convar7:GetFloat(), convar7:GetFloat(), team.GetColor(LocalPlayer():Team()))
					end
				end
			else
				draw.RoundedBox( convar7:GetFloat()/2, cx-(convar7:GetFloat()/2),cy-(convar7:GetFloat()/2), convar7:GetFloat(), convar7:GetFloat(), radar.centerdotcolor)
			end

			if Norxi < (radar.h / 2) && Noryi < (radar.w / 2) && Norxi > (-radar.h / 2) && Noryi > (-radar.w / 2) then
			
				--surface.DrawLine( cx, cy,cx - Noryi,cy - Norxi ) //You can uncomment this if you want.. It works, just didn't like it.
			
				if pl != LocalPlayer() then
					if pl:IsPlayer() then
						if (pl:Team() == LocalPlayer():Team()) and (pl != LocalPlayer()) then
							if pl:Alive() then
								if convar6:GetFloat() == 1 then
									if pl:IsAdmin() then
										--DefaultSmall
										--ScoreboardText
										draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), Color(0, 255, 0, 225))
										draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), Color(0, 255, 0, 225), 1)
									else
										draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), team.GetColor(pl:Team()))
										draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), team.GetColor(pl:Team()), 1)
									end
								else
									if pl:IsAdmin() then
										draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), Color(0, 255, 0, 225))
										draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), Color(0, 255, 0, 225), 1)
									else
										draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), radar.dotcolor)
										draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), radar.textcolor, 1)
									end
								end
							else
								draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), Color(0, 0, 0, 225))
								draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), Color(0, 0, 0, 225), 1)
							end
						else
							if (pl:Team() != LocalPlayer():Team()) then
								if convar6:GetFloat() == 1 then
									draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), team.GetColor(pl:Team()))
									draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), team.GetColor(pl:Team()), 1)
								else
									draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), Color(255, 0, 0, 225))
									draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), Color(255, 0, 0, 225), 1)
								end
							else
								draw.RoundedBox( convar8:GetFloat()/2, cx - Noryi-(convar8:GetFloat()/2), cy - Norxi-(convar8:GetFloat()/2), convar8:GetFloat(), convar8:GetFloat(), Color(0, 0, 0, 225))
								draw.DrawText(""..pl:Nick(), "DefaultSmall", cx-Noryi-4, cy - Norxi-15-(convar8:GetFloat()/2), Color(0, 0, 0, 225), 1)
							end
						end
					end
				end
			end
		end
	end
	end
end
hook.Add( "HUDPaint", "BANNANANAPHONEEEEEE", ILiekRadar )