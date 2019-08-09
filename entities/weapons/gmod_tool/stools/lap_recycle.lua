TOOL.Category		= "(WarMelons)"
TOOL.Name			= "#Recycle"
TOOL.Command		= nil
TOOL.ConfigName		= ""

if (CLIENT) then
	language.Add( "Tool_lap_recycle_name", "recycle" )
	language.Add( "Tool_lap_recycle_desc", "Allows you to recycle things to recoup some of its cost" )
	language.Add( "Tool_lap_recycle_0", "Left-click to recycle entities. Right-click to appraise an item" )
end

function TOOL:LeftClick (trace)
local check = 0
    if ( SERVER ) then
    local ply = self:GetOwner()
    	if trace.Entity.Cost ~= nil && trace.Entity:IsValid() then
    	   if trace.Entity.Team ~= nil && trace.Entity.Team == ply:Team() then
    			 if trace.Entity.Built == nil || trace.Entity.Built == 2 then
    			         if trace.Entity.Healthlol == nil || trace.Entity.Healthlol >= trace.Entity.Maxlol then
    			             if trace.Entity.health == nil || trace.Entity.health >= trace.Entity.maxhealth then
    			                 if InOutpostRange(ply, trace.Entity:GetPos()) && EnemyMelonCheck(ply, trace.Entity:GetPos()) then 
                                 local teamcount = 0
                                 teamcount = team.NumPlayers(trace.Entity.Team)
                                	for k, v in pairs (player.GetAll()) do
                                	   if v:Team() == trace.Entity.Team then
                                	   v:SetNWInt( "nrg", v:GetNWInt("nrg") + (trace.Entity.Cost * 0.5 / teamcount) )
                        			   v:PrintMessage(HUD_PRINTTALK, "Entity sold for " .. (math.floor(trace.Entity.Cost * 0.5)) .. " NRG. Your share is: " .. (trace.Entity.Cost * 0.5 / teamcount) )
                                	   end
                                	end
                                 check = 1
                                 trace.Entity:Remove()
                			     end
                			 else
                			 ply:PrintMessage(HUD_PRINTCENTER, "Entity is not at full health!")
                		     end
                		else
                		ply:PrintMessage(HUD_PRINTCENTER, "Entity is not at full health!")
                        end
                    else
                	ply:PrintMessage(HUD_PRINTCENTER, "Entity is not fully built!")
                    end
            else
            ply:PrintMessage(HUD_PRINTCENTER, "That is not your team's!")
            end       
    
    	else
    	return false
    	end
    
    end
    
    if check == 1 then
    return true
    else
    return false
    end
end

function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
	if trace.Entity.Cost ~= nil && trace.Entity:IsValid() then
	    if trace.Entity.Team ~= nil && trace.Entity.Team == ply:Team() then
	    ply:PrintMessage(HUD_PRINTTALK, "Entity's refund value is " .. (math.floor(trace.Entity.Cost * 0.5)) .. " NRG.")
	    return true
	    else
	    return false
	    end
	else
	return false
	end
end
end

function TOOL:RightClick (trace)
if (SERVER) then
local ply = self:GetOwner()
	if trace.Entity.Cost ~= nil && trace.Entity:IsValid() && ply:IsAdmin() then
	ply:PrintMessage(HUD_PRINTTALK, "Entity's cost is " .. (trace.Entity.Cost) .. " NRG.")
	end
end
end

function TOOL.BuildCPanel (CPanel)
	CPanel:AddControl("Header", { Text="#Tool_lap_recycle_name", Description="#Tool_lap_recycles_desc" })
local VGUI = vgui.Create("WMHelpButton",CPanel);
	VGUI:SetTopic("Recycler");
    	CPanel:AddPanel(VGUI);	
CPanel:AddControl("Label", { Text = "To recieve NRG the entity must be:", Description = "To recieve NRG the entity must be:" })
	CPanel:AddControl("Label", { Text = "1.Your team's,", Description = "1.Your team's,"})
	CPanel:AddControl("Label", { Text = "2.In range of a friendly outpost or spawn point,", Description = "2.In range of a friendly outpost or spawn point,"})
	CPanel:AddControl("Label", { Text = "3.Fully built and healed,", Description = "3.Fully built and healed,"})
	CPanel:AddControl("Label", { Text = "4.Out of range of enemy melons,", Description = "4.Out of range of enemy melons,"})
end
