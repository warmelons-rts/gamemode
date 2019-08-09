CreateConVar( "WM_BountyModifier", 0.5)
CreateConVar( "WM_AssassinPenalty", 0.6)
CreateConVar( "WM_AssassinRandomTargets", 1)
CreateConVar( "WM_AssassinTargetInterval", 20)
CreateConVar( "WM_PhantomBonusPerTeam", 0.15)
CreateConVar( "WM_PhantomStrikeInterval", 300)
CreateConVar( "WM_ScenarioPreGame", 8)
CreateConVar( "WM_GlobalBounty", 0)
TeamTargets = {0,0,0,0,0,0,0,0,0}
TeamBounty = {0,0,0,0,0,0,0}
local LastTeamBounty = {0,0,0,0,0,0,0}
WMPhantomTeam = 0
WMPhantomMaxDiscount = 0
WMPhantomMinDiscount = 1
function PhantomChoosing()
local TeamList = {}
    for k,v in pairs (entsFindByClass("lap_spawnpoint")) do
        if !table.HasValue(TeamList, self.Team) then
        table.Insert(TeamList, self.Team)
        end
    end
WMPhantomTeam = math.Random(1, #TeamList)
WMPhantomLastFired = CurTime()
SetGlobalFloat("WMPhantomDiscount", 1 - GetConVarNumber("WM_PhantomBonusPerTeam", 0.15))
WMPhantomMaxDiscount = 1 - GetConVarNumber("WM_PhantomBonusPerTeam", 0.15)
for k, v in pairs (player.GetAll()) do
WMSendPhantomAssignments(v)
end
end

function WMSendPhantomMsg(msg)
local rp = RecipientFilter()
rp:AddAllPlayers()
umsg.Start("WMPhantomMsg", rp)
umsg.Short(msg)
umsg.End()
end

function WMSendPhantomAssignments(ply)
local amiphantom = false
    if ply:Team() == WHPhantomTeam then
    amiphantom = true
    end
umsg.Start("Phantom Ass", ply)
umsg.Bool(amiphantom)
umsg.End()
end


function AssassinTargeting()
Msg(#player.GetAll())
if #player.GetAll() > 2 then
local TeamList = {}
    for k,v in pairs (entsFindByClass("lap_spawnpoint")) do
        if !table.HasValue(TeamList, self.Team) then
        table.Insert(TeamList, self.Team)
        end
    end
end
if #TeamList > 2 then
    if GetConVarNumber("AssasinRandomTargets", 1) == 1 then
    TeamTargets = {0,0,0,0,0,0,0,0,0}
        for k, v in pairs (TeamList) do
        local randomzor = math.random(1, #TeamList)
            while TeamList[randomzor] == v || TeamTarget[TeamList[randomzor]] == v do
            randomzor = math.random(1, #TeamList)
            end
        TeamTargets[v] = randomzor
        end
    else
        if TeamTargets == {0,0,0,0,0,0,0,0,0} then
            for k, v in pairs (TeamList) do
                if TeamList[k+1] ~= nil then
                TeamTargets[v] = TeamList[k+1]
                else
                TeamTargets[v] = TeamList[1]
                end
            end
        else
        local originalpos = {}
        local slimmed = {}
            for k, v in pairs (TeamTargets) do
                if v ~= 0 then
                table.insert(slimmed, v)
                table.insert(originalpos, k)
                end
            end
        table.Insert(slimmed, slimmed[1])
        table.remove(slimed, 1)
            for k, v in pairs (slimmed) do
            TeamTargets[orginalpos[k]] = v
            end
        end
    end
    for k, v in pairs (player.GetAll()) do
    WMSendATarget(v)
    end
end
timer.Simple(GetConVarNumber("AssassinTargetInterval", 20) * 60, AssassinTargeting)
end




function WMSendATarget(ply)
umsg.Start("WMATargetSend", ply)
umsg.Short(TeamTargets[ply:Team()])
umsg.End()
end

function WMBountyUpdate()
for i = 1, 7 do
    if LastTeamBounty[i] ~= TeamBounty[i] then
    LastTeamBounty[i] = TeamBounty[i]
    local rp = RecipientFilter()
    rp:AddAllPlayers()
    SendBounty(i, rp)
    end
end

timer.Simple(10, WMBountyUpdate)
end
timer.Simple(10, WMBountyUpdate)

function SendBounty(team, rp)
umsg.Start("BountySend", rp)
    umsg.Short(team)
    umsg.Long(TeamBounty[team])
umsg.End()
end

function WMSetBounty(ply, cmd, arg)
local arg2 = math.Clamp(tonumber(arg[2]), 0, 10000000)
if arg2 == 0 then return false end
    if GetConVarNumber("WM_BountyModifier", 0.5) >= 0 then
        if ply:GetNWInt("nrg") >= arg2 then
        TeamBounty[tonumber(arg[1])] = TeamBounty[tonumber(arg[1])] + arg2
        ply:SetNetworkedInt("nrg", ply:GetNWInt("nrg") - arg2)
        ply:PrintMessage(HUD_PRINTTALK, "Raised Team " .. arg[1] .. "'s bounty by " .. arg2 .. " NRG.")
        end
    else
    ply:PrintMessage(HUD_PRINTTALK, "Bounties are currently disallowed.")
    end
end

function WMSetPhantomDiscount(ply, cmd, arg)
if ply:Team() == WMPhantomTeam && ply:GetNWBool("WMCaptain") == true then
 local min = math.Clamp(tonumber(arg[1]), 0, WMPhantomDiscount)  
 local max = math.Clamp(tonumber(arg[2]), 0.05, WMPhantomDiscount)
    if min > max then
    ply:PrintMessage(HUD_PRINTTALK, "Minimum cannot be above maximum.") 
    return false
    end
 WMPhantomMaxDiscount = max
 WMPhantomMinDiscount = min
 for k, v in pairs (team.GetPlayers(WMPhantomTeam)) do
 v:PrintMessage(HUD_PRINTTALK, "Phantom discount set to " .. min .. "-" .. max .. "%.") 
 end
else
ply:PrintMessage(HUD_PRINTTALK, "Only the Phantom Team Captain can do this.") 
end
end

concommand.Add("wmphantomdiscount", WMSetPhantomDiscount)
concommand.Add("wmbounty", WMSetBounty)