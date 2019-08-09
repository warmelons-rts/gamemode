TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Superweapons"
TOOL.Command		= nil
TOOL.ConfigName		= ""
TOOL.ClientConVar[ "ttype" ]	= "1"
TOOL.ClientConVar[ "teamnumber" ] = "1"
if (CLIENT) then
	language.Add( "Tool_lap_superweapons_name", "Super Weapons" )
	language.Add( "Tool_lap_superweapons_desc", "Creates a super weapon" )
	language.Add( "Tool_lap_superweapons_0", "Left-click to spawn a super weapon. Right-click to display cost." )
	language.Add( "Undone_lap_superweapons", "Undone super weapons" )
	language.Add( 'SBoxLimit_lap_superweapons', 'Maximum Super Weapons Reached' )
end

local SWTypes = {{},{},{},{},{},{},{}}
SWTypes[1]["name"] = "lap_chaos"
SWTypes[1]["cost"] = 100000
SWTypes[2]["name"] = "lap_mindcontrol"
SWTypes[2]["cost"] = 250000
SWTypes[3]["name"] = "lap_kaboom"
SWTypes[3]["cost"] = 250000
SWTypes[4]["name"] = "lap_microwavelaser"
SWTypes[4]["cost"] = 100000
SWTypes[5]["name"] = "lap_regencore"
SWTypes[5]["cost"] = 150000
SWTypes[6]["name"] = "lap_leader"
SWTypes[6]["cost"] = 150000
SWTypes[7]["name"] = "lap_moldis"
SWTypes[7]["cost"] = 150000

function TOOL:LeftClick (trace)
local type = self:GetClientNumber( "ttype" ) 
if ( SERVER ) then
if ( !self:GetSWEP():CheckLimit( "lap_superweapons" ) ) then return false end
	local ply = self:GetOwner()
	local cost = 0
	local Pos = trace.HitPos
	local Ang = trace.HitNormal
	local cteam = 0
	if ply:Team() ~= 0 then
	cteam = ply:Team()
	else
	cteam = self:GetClientNumber("teamnumber")
	end
	local toolcost = GetConVarNumber( "WM_Toolcost", 1)
	if !SuperWeaponCheck(ply, type) then return false end
    if !InBaseRange(ply, Pos) then return false end
    if !NRGCheck(ply, SWTypes[type]["cost"]) then return false end
if (trace.Hit && !trace.HitNoDraw) then
local heightmod = 0
	 if (type == 4) then
	 heightmod = 25
	 end
	melon = ents.Create(SWTypes[type]["name"])
	melon.Cost = cost
	melon:SetAngles (trace.HitNormal:Angle());
	melon.Team = cteam;
	melon:Spawn();
	melon:SetPos (trace.HitPos + Vector(0,0, melon:OBBMaxs().z + heightmod));
	melon:Activate ();
	melon:GetPhysicsObject():EnableGravity(true);
	trace.Entity:DeleteOnRemove(melon);
	undo.Create("melon");
	ply:AddCount('lap_superweapons', melon)
    undo.AddEntity (melon);
    undo.SetPlayer (self:GetOwner());
	undo.Finish();
	cleanup.Add( ply, "WarMelons", melon )
	return true;
end
end
end


function TOOL:RightClick (trace)
local type = self:GetClientNumber( "ttype" ) 
if (SERVER) then
local ply = self:GetOwner()
local toolcost = GetConVarNumber( "WM_Toolcost", 1 )
WMSendCost(ply, SWTypes[type]["cost"], false)
end
	return false
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl ("Header", { Text="#Tool_lap_superweapons_name", Description="#Tool_lap_superweapons_desc" })
	local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Super Weapons");
    	CPanel:AddPanel(VGUI);
	CPanel:AddControl ("Slider", {
		Label = "Team number (Only applies on Team 0)",
		Command = "lap_superweapons_teamnumber",
		Type = "Integer",
		Min = "1",
		Max = "6"
	} )

	local choices = {Label = "superweapons", MenuButton = "0", Options = {}}
	choices.Options["Microwave Laser"] = {lap_superweapons_ttype = "4"}
	choices.Options["Chaos Cannon"] = {lap_superweapons_ttype = "1"}
	choices.Options["Mind Control"] = {lap_superweapons_ttype = "2"}
	choices.Options["Mega Bomb"] = {lap_superweapons_ttype = "3"}
	choices.Options["Regenerative Core"] = {lap_superweapons_ttype = "5"}
	choices.Options["Battlefield Command"] = {lap_superweapons_ttype = "6"}
	choices.Options["Molecular Disassembler"] = {lap_superweapons_ttype = "7"}
	CPanel:AddControl( "ComboBox", choices )

end

function SuperWeaponCheck(ply, type)
local count = 0
local teem = ply:Team()
	for k, v in pairs(ents.GetAll()) do
		if v.Team == teem && v:GetClass() == SWTypes[type]["name"] then
		count = count + 1
		end
	end
	
	if count >= GetConVarNumber("wm_swtypelimit") then
	umsg.Start("SWTypeLimitMsg", ply)
	umsg.Bool(true)
	umsg.End()
	return false
	else
	return true
	end
end