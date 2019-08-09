/*================================================
                Name: Advanced Angle Rotator
                Author: Liam Brown
================================================*/

//Special Thanks to Kickin Balls for the ideas

TOOL.Category = "Construction"
TOOL.Name = "#Advanced Angle Rotator"
TOOL.Command = nil
TOOL.ConfigName	= ""

TOOL.ClientConVar["Pitch"] = (0)
TOOL.ClientConVar["Yaw"] = (0)
TOOL.ClientConVar["Roll"] = (0)
TOOL.ClientConVar["Freeze"] = (0)
TOOL.ClientConVar["UnFreeze"] = (0)

AAR = {}
AAR.StoredAngle = {}

if CLIENT then
	language.Add("Tool_adv_angle_rotator_name", "Advanced Angle Rotator")
	language.Add("Tool_adv_angle_rotator_desc", "Edit a props angles")
	language.Add("Tool_adv_angle_rotator_0", "Left click edits angles, Right click copy's the angles and reload resets angles")
end

function TOOL.BuildCPanel(Panel)
	Panel:AddControl("Header", {Text = "#Tool_adv_angle_rotator_name", Description = "#Tool_adv_angle_rotator_desc"})
	Panel:AddControl("CheckBox", {Label = "#Freeze", Command = "adv_angle_rotator_Freeze"})
    Panel:AddControl("CheckBox", {Label = "#Unfreeze", Command = "adv_angle_rotator_UnFreeze"})
	Panel:AddControl("Slider",  {Label	= "#Pitch", Type = "Integer", Min = 0, Max = 360, Command = "adv_angle_rotator_Pitch"})
	Panel:AddControl("Slider",  {Label	= "#Yaw", Type = "Integer", Min = 0, Max = 360, Command = "adv_angle_rotator_Yaw"})
	Panel:AddControl("Slider",  {Label	= "#Roll", Type = "Integer", Min = 0, Max = 360, Command = "adv_angle_rotator_Roll"})
end

function TOOL:LeftClick(tr)
	if !tr.Entity || tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.HitWorld || tr.HitSky then 
	    return false
	elseif CLIENT then
	    return true
	end
    
	local Reset = tr.Entity:GetAngles()
	local Physics = tr.Entity:GetPhysicsObject()
	    AAR.StoredAngle[tr.Entity:EntIndex()] = (Reset)
	local ply = self:GetOwner()	
	local Pitch	= self:GetClientNumber("Pitch") 
	local Yaw = self:GetClientNumber("Yaw")
	local Roll = self:GetClientNumber("Roll")
	local Freeze = self:GetClientNumber("Freeze")
	local UnFreeze = self:GetClientNumber("UnFreeze")
	
	if (Freeze == 1) && (UnFreeze == 1) then
	    ply:ConCommand("adv_angle_rotator_UnFreeze 0\n")
		ply:ConCommand("adv_angle_rotator_Freeze 0\n")
	elseif (Freeze == 1) && (UnFreeze == 0) then
		Physics:EnableMotion(false)
		Physics:Wake()
	elseif (Freeze == 0) && (UnFreeze == 1) then
		Physics:EnableMotion(true)
		Physics:Wake()
	end
	
	tr.Entity:SetAngles(Angle(Pitch, Yaw, Roll))
	return true
end

function TOOL:RightClick(tr)
	if !tr.Entity || tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.HitWorld || tr.HitSky then 
	    return false
	elseif CLIENT then
	    return true
	end

	local ply = self:GetOwner()
	local Copy = tr.Entity:GetAngles()
	
	ply:ConCommand("adv_angle_rotator_Pitch "..Copy.p.."\n")
	ply:ConCommand("adv_angle_rotator_Yaw "..Copy.y.."\n")
	ply:ConCommand("adv_angle_rotator_Roll "..Copy.r.."\n")
	return true
end

function TOOL:Reload(tr)
	if !tr.Entity || tr.Entity:IsPlayer() || tr.Entity:IsNPC() || tr.HitWorld || tr.HitSky then 
	    return false
    end
	
	local ply = self:GetOwner()
	local Reset = tr.Entity:GetAngles()
	
	if AAR.StoredAngle[tr.Entity:EntIndex()] ~= nil then
	    Reset = AAR.StoredAngle[tr.Entity:EntIndex()]
	    tr.Entity:SetAngles(Reset)
	elseif AAR.StoredAngle[tr.Entity:EntIndex()] == nil then
	    return false
	end
	
	if CLIENT then
	    return true
	end
	
	return true
end