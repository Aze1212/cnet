--[[---------------------------------]]--
--  Granting a Vehicle
--[[---------------------------------]]--

function NCS_REQUISITION.CanGrant(ply, ship, hangar)
    local HANG = NCS_REQUISITION.SPAWNS[hangar]
    local VEH = NCS_REQUISITION.VEHICLES[ship]

    --[[
    --  Vehicles
    --]]

    local SUCCESS = hook.Run("NCS_REQUISITION_CanGrant", ply, ship, hangar)

    if (SUCCESS ~= nil) then
        return SUCCESS
    end
        
    if VEH.GTEAMS and !table.IsEmpty(VEH.GTEAMS) and !VEH.GTEAMS[team.GetName(ply:Team())] then
        return false
    end

    local B, R = nil, nil

    if RDV and RDV.RANK then
        B = RDV.RANK.GetPlayerRankTree(ply)
        R = RDV.RANK.GetPlayerRank(ply)
    elseif MRS then
        B = MRS.GetPlayerGroup(ply:Team())
        R = MRS.GetPlyRank(ply, B)
    end

    if VEH.GRANKS and table.Count(VEH.GRANKS) > 0 then
        if VEH.GRANKS[B] then
            if ( VEH.GRANKS[B] > R ) then return false end
        else
            return
        end
    end

    if VEH.CanGrant and VEH:CanGrant(ply) == false then
        return false
    end


    --[[
    --  Hangars
    --]]

    if HANG.GTEAMS and !table.IsEmpty(HANG.GTEAMS) and !HANG.GTEAMS[team.GetName(ply:Team())] then
        return false
    end

    if HANG.GRANKS and table.Count(HANG.GRANKS) > 0 then
        if HANG.GRANKS[B] then
            if ( HANG.GRANKS[B] > R ) then return false end
        else
            return
        end
    end

    if HANG.CanGrant and HANG:CanGrant(ply) == false then

        return false
    end

    return true
end

--[[---------------------------------]]--
--  Requesting a Vehicle
--[[---------------------------------]]--

function NCS_REQUISITION.CanRequest(ply, ship, hangar)
    local HANG = NCS_REQUISITION.SPAWNS[hangar]
    local VEH = NCS_REQUISITION.VEHICLES[ship]

    --[[
    --  Vehicles
    --]]
    
    local SUCCESS = hook.Run("NCS_REQUISITION_CanRequest", ply, ship, hangar)

    if (SUCCESS ~= nil) then
        return SUCCESS
    end

    if VEH.RTEAMS and !table.IsEmpty(VEH.RTEAMS) and !VEH.RTEAMS[team.GetName(ply:Team())] then
        return false
    end

    local B, R = nil, nil

    if RDV and RDV.RANK then
        B = RDV.RANK.GetPlayerRankTree(ply)
        R = RDV.RANK.GetPlayerRank(ply)
    elseif MRS then
        B = MRS.GetPlayerGroup(ply:Team())
        R = MRS.GetPlyRank(ply, B)
    end

    if VEH.RANKS and table.Count(VEH.RANKS) > 0 then
        if VEH.RANKS[B] then
            if ( VEH.RANKS[B] > R ) then return false end
        else
            return
        end
    end

    if VEH.CanRequest and VEH:CanRequest(ply) == false then
        return false
    end

    --[[
    --  Hangars
    --]]

    if VEH.SPAWNS and not table.IsEmpty(VEH.SPAWNS) then
        if not VEH.SPAWNS[hangar] then
            return false
        end
    end


    if HANG.RTEAMS and !table.IsEmpty(HANG.RTEAMS) and !HANG.RTEAMS[team.GetName(ply:Team())] then
        return false
    end

    if HANG.RANKS and table.Count(HANG.RANKS) > 0 then
        if HANG.RANKS[B] then
            if ( HANG.RANKS[B] > R ) then return false end
        else
            return
        end
    end

    if HANG.CanRequest and HANG:CanRequest(ply) == false then
        return false
    end

    if VEH.PRICE then
        if not NCS_REQUISITION.CanAfford(ply, nil, VEH.PRICE) then
            return false
        end
    end
        
    return true
end

--[[---------------------------------]]--
--  Checking if a Hangar is clear.
--[[---------------------------------]]--

function NCS_REQUISITION.IsHangarInUse(hangar)
    local LOC = NCS_REQUISITION.SPAWNS[hangar]

    if !LOC then 
        return 
    end

    local FOUND = false

    for k, v in ipairs(ents.GetAll()) do
        if v:GetPos():DistToSqr(LOC.POS) <= (NCS_REQUISITION.CFG.HAN_SIZE ^ 2) then
            if v:IsVehicle() or v:IsNPC() or v:IsNextBot() or v:IsPlayer() then
                FOUND = true
            end
        end
    end

    return FOUND
end

--[[---------------------------------]]--
--  Notification
--[[---------------------------------]]--

function NCS_REQUISITION.SendNotification(PLAYER, MSG)
    local PREFIX = NCS_REQUISITION.CFG.PRE_STRING
    local COL = NCS_REQUISITION.CFG.PRE_COLOR

    NCS_SHARED.AddText(PLAYER, Color(COL.r, COL.g, COL.b), "["..PREFIX.."] ", color_white, MSG)
end


function NCS_REQUISITION.IsAdmin(P, CB)
    if NCS_REQUISITION.CFG.camienabled then
        CAMI.PlayerHasAccess(P, "[NCS] Requisition", function(ACCESS)
            CB(ACCESS)
        end )
    else
        if NCS_REQUISITION.CFG.admins[P:GetUserGroup()] then
            CB(true)
        else
            CB(false)
        end
    end
end