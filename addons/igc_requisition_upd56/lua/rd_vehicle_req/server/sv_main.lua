hook.Add("NCS_SHARED_PlayerReadyForNetworking", "NCS_REQUISITION_RetrieveRequests", function(P)
    local DATA = {}

    for k, v in pairs(NCS_REQUISITION.ACTIVE) do
        local R_PLAYER = v.OWNER

        if !IsValid(R_PLAYER) then continue end

        local VEHICLE = TAB[i].VEHICLE
        local SPAWN = TAB[i].SPAWN

        if NCS_REQUISITION.CanGrant(P, VEHICLE, SPAWN) then
            DATA[k] = v
            DATA[k].OWNER = nil
            DATA[k].SKIN = nil
            DATA[k].TIME = timer.TimeLeft("VR_"..R_PLAYER:SteamID64())
        end
    end

    net.Start("NCS_REQUISITION_INITIAL")
        net.WriteTable(DATA)
    net.Send(P)
end)

hook.Add("PlayerDisconnected", "NCS_REQUISITION_ClearDisconnected", function(P)
    local E_INDEX = P:EntIndex()

    if IsValid(P.CurrentRequestedVehicle) then
        P.CurrentRequestedVehicle:Remove()
    end
    
    if NCS_REQUISITION.ACTIVE[E_INDEX] then
        net.Start("NCS_REQUISITION_CLEAR")
            net.WriteUInt(E_INDEX, 8)
        net.Broadcast()

        NCS_REQUISITION.ACTIVE[E_INDEX] = nil
    end
end)

hook.Add("PlayerSay", "NCS_REQUISITION_SaveCommand", function(P, T)
    if string.lower(T) == NCS_REQUISITION.CFG.savevendors then
        NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
            if !SUCCESS then 
                NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "noPermsAccess"))
                return 
            end

            local SAVED = {}

            for k, v in ipairs(ents.GetAll()) do
                if v:GetClass() == "eps_aircraft_npc" then
                    table.insert(SAVED, {
                        P = v:GetPos(),
                        A = v:GetAngles(),
                    })
                end
            end

            local DATA = util.TableToJSON(SAVED)
                
            file.CreateDir("rdv/requisition/")

            file.Write("rdv/requisition/vendors_"..game.GetMap()..".json", DATA)

            NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "vendorsSaved"))
        end )
        
        return ""
    elseif string.lower(T) == NCS_REQUISITION.CFG.menucommand then
        NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
            if !SUCCESS then 
                NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "noPermsAccess"))

                return 
            end

            net.Start("NCS_REQUISITION_ADMIN")
            net.Send(P)
        end )
        return ""
    end
end )

local function LoadSavedVendors()
    local DATA = {}

    if file.Exists("rdv/requisition/vendors_"..game.GetMap()..".json", "DATA") then
        DATA = file.Read("rdv/requisition/vendors_"..game.GetMap()..".json", "DATA")

        if DATA then
            DATA = util.JSONToTable(DATA)

            for k, v in ipairs(DATA) do
                local E = ents.Create("eps_aircraft_npc")
                E:SetPos(v.P)
                E:SetAngles(v.A)
                E:SetModel(NCS_REQUISITION.CFG.NPC_MODEL)
                E:Spawn()

                E:SetMoveType(MOVETYPE_NONE)
                local P = E:GetPhysicsObject()
                if IsValid(P) then
                    P:EnableMotion(false)
                end
            end
        end
    end
end

LoadSavedVendors()
hook.Add("PostCleanupMap", "NCS_REQUISITION_LoadVendors", LoadSavedVendors)
