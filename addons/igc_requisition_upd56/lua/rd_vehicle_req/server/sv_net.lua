util.AddNetworkString("NCS_REQUISITION.GRANT")
util.AddNetworkString("NCS_REQUISITION_CLEAR")
util.AddNetworkString("NCS_REQUISITION.DENY")
util.AddNetworkString("NCS_REQUISITION.MENU")
util.AddNetworkString("NCS_REQUISITION.START")
util.AddNetworkString("NCS_REQUISITION_ASK")
util.AddNetworkString("NCS_REQUISITION.RETURN")
util.AddNetworkString("NCS_REQUISITION_INITIAL")

NCS_REQUISITION.ACTIVE = {}

local vehTable = {}
local curVehicleCount = 0

--[[---------------------------------]]--
--  Requsition Request Received
--[[---------------------------------]]--

hook.Add("EntityRemoved", "NCS_REQUISITION_UpdateMax", function(ent)
    if ent.ReqUID and vehTable[ent.ReqUID] then
        vehTable[ent.ReqUID] = ( vehTable[ent.ReqUID] - 1 )

        curVehicleCount = math.max((curVehicleCount - 1), 0)
    end
end )

local function SpawnVehicle(P, VEH_UID, H_TAB, V_TAB)
    vehTable[VEH_UID] = vehTable[VEH_UID] or 0

    if IsValid(P.CurrentRequestedVehicle) then
        P.CurrentRequestedVehicle:Remove()
    end

    local TAB = NCS_REQUISITION.ACTIVE[P:EntIndex()]
    local CFG = NCS_REQUISITION.CFG

    local VAL = hook.Run("NCS_REQUISITION_PreVehicleSpawned", P, TAB)

    if (VAL == false) then
        return
    end

    -- Check Details, like Max Vehicle Count.
    local DATA = NCS_REQUISITION.VEHICLES[VEH_UID]

    if DATA.MAX and ( DATA.MAX > 0 ) and ( vehTable[VEH_UID] + 1 ) > DATA.MAX then
        NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "VR_tooManyVehicles"))

        return
    end

    if curVehicleCount and CFG.MAX_VEH and ( CFG.MAX_VEH > 0 ) and ( ( curVehicleCount + 1 ) > CFG.MAX_VEH ) then
        NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "VR_tooManyVehicles"))

        return
    end

    -- Spawn the vehicle, supports Simphys too.

    local VEH_ENT

    if simfphys and list.Get( "simfphys_vehicles" )[V_TAB.CLASS] then
        VEH_ENT = simfphys.SpawnVehicleSimple( V_TAB.CLASS, H_TAB.POS, H_TAB.ANG )
    elseif list.Get("Vehicles")[V_TAB.CLASS] then
        local D = list.Get("Vehicles")[V_TAB.CLASS]

        if !D.Class or !D.Model then return end

        VEH_ENT = ents.Create(D.Class)
        VEH_ENT:SetModel(D.Model)
        VEH_ENT:SetPos(H_TAB.POS)

        VEH_ENT:SetKeyValue("vehiclescript",list.Get( "Vehicles" )[ V_TAB.CLASS ].KeyValues.vehiclescript) 
        VEH_ENT:SetAngles(H_TAB.ANG)

        VEH_ENT:Spawn()
        VEH_ENT:Activate()
    else
        VEH_ENT = ents.Create(V_TAB.CLASS)
        VEH_ENT:SetPos(H_TAB.POS)
        VEH_ENT:SetAngles(H_TAB.ANG)
        VEH_ENT:Spawn()
    end

    if TAB.SKIN then
        VEH_ENT:SetSkin(TAB.SKIN)
    end

    if V_TAB.LOADOUTS and V_TAB.LOADOUTS[TAB.LOADOUT] then
        local DATA = V_TAB.LOADOUTS[TAB.LOADOUT].OPTIONS

        if DATA then
            for k, v in ipairs(VEH_ENT:GetBodyGroups()) do
                if DATA[v.id] then
                    VEH_ENT:SetBodygroup(v.id, DATA[v.id])
                end
            end
        end
    end

    vehTable[VEH_UID] = vehTable[VEH_UID] + 1
    curVehicleCount = curVehicleCount + 1

    VEH_ENT.ReqUID = VEH_UID

    if !IsValid(VEH_ENT) then return end

    if VEH_ENT.CPPISetOwner then
        VEH_ENT:CPPISetOwner(P)
    end

    P.CurrentRequestedVehicle = VEH_ENT

    hook.Run("NCS_REQUISITION_VehicleSpawned", P, VEH_ENT, TAB)
end

local function AutoGrant(R_PLAYER, SHIP, H_TAB, V_TAB)
    local ACTIVE = NCS_REQUISITION.ACTIVE[R_PLAYER:EntIndex()]

    if V_TAB.PRICE then
        local canAfford = NCS_REQUISITION.CanAfford(R_PLAYER, nil, V_TAB.PRICE)

        if ( !canAfford ) then
            local LcannotAfford = NCS_REQUISITION.GetLang(nil, "VR_cannotAfford")

            NCS_REQUISITION.SendNotification(R_PLAYER, LcannotAfford)

            NCS_REQUISITION.ACTIVE[R_PLAYER:EntIndex()] = nil

            return false
        end

        NCS_REQUISITION.AddMoney(R_PLAYER, nil, -V_TAB.PRICE)
    end
    
    SpawnVehicle(R_PLAYER, SHIP, H_TAB, V_TAB)

    local LautoGranted = NCS_REQUISITION.GetLang(nil, "VR_autoGranted")

    NCS_REQUISITION.SendNotification(R_PLAYER, LautoGranted)

    NCS_SHARED.PlaySound(R_PLAYER, "reality_development/ui/ui_accept.ogg")

    -- Remove
    timer.Stop("VR_"..R_PLAYER:SteamID64())

    NCS_REQUISITION.ACTIVE[R_PLAYER:EntIndex()] = nil
end

net.Receive("NCS_REQUISITION.START", function(len, P)
    local V_UID = net.ReadString()
    local H_UID = net.ReadString()
    local V_INFO = net.ReadTable()

    local H_TAB = NCS_REQUISITION.SPAWNS[H_UID]
    local V_TAB = NCS_REQUISITION.VEHICLES[V_UID]

    if H_TAB and V_TAB then
        local DATA = NCS_REQUISITION.VEHICLES[V_UID]
        local CFG = NCS_REQUISITION.CFG

        if DATA.MAX and ( DATA.MAX > 0 ) and vehTable[V_UID] and ( vehTable[V_UID] + 1 ) > DATA.MAX then
            NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "VR_tooManyVehicles"))

            return
        end

        if curVehicleCount and CFG.MAX_VEH and ( CFG.MAX_VEH > 0 ) and ( ( curVehicleCount + 1 ) > CFG.MAX_VEH ) then
            NCS_REQUISITION.SendNotification(P, NCS_REQUISITION.GetLang(nil, "VR_tooManyVehicles"))
    
            return
        end

        --
        --  Handle Map Check
        --

        if H_TAB.MAP and H_TAB.MAP ~= game.GetMap() then
            return
        end

        --
        --  Handle Distance Check
        --

        local POS = H_TAB.POS

        if NCS_REQUISITION.CFG.MAX_DIST then
            local DISTANCE = (string.Explode(".", POS:Distance(P:GetPos()) / 52.49))[1]

            if tonumber(DISTANCE) >= (NCS_REQUISITION.CFG.MAX_DIST or 500) then
                return
            end
        end

        --
        --  Handle Blacklists
        --
        if V_TAB.SPAWNS and !table.IsEmpty(V_TAB.SPAWNS) then
            if !V_TAB.SPAWNS[H_UID] then 
                return 
            end
        end

        --
        --  Handle Skins
        --

        local SKIN = 0

        if V_INFO.SKIN then
            SKIN = V_INFO.SKIN
        elseif V_TAB.SKIN then
            SKIN = V_TAB.SKIN
        end
        
        --
        --  Handle Loadouts
        --

        local LOADOUT = false

        if V_INFO.LOADOUT then
            LOADOUT = V_INFO.LOADOUT
        end

        --
        --  Handle Active Requests
        --

        if NCS_REQUISITION.ACTIVE and NCS_REQUISITION.ACTIVE[P:EntIndex()] then
            local LrequestOpen = NCS_REQUISITION.GetLang(nil, "VR_requestOpen")

            NCS_REQUISITION.SendNotification(P, LrequestOpen)

            return
        end

        --
        --  Handle Checking Availability
        --

        local CAN_REQUEST, REASON = NCS_REQUISITION.CanRequest(P, V_UID, H_UID)

        if (CAN_REQUEST == false) then
            local cannotRequest = NCS_REQUISITION.GetLang(nil, "VR_cannotRequest")

            NCS_REQUISITION.SendNotification(P, (REASON or cannotRequest))
            return
        end
        
        --
        --  Handle Hangar in use
        --

        if NCS_REQUISITION.IsHangarInUse(H_UID) then
            local hangarOccupied = NCS_REQUISITION.GetLang(nil, "VR_hangarOccupied")

            NCS_REQUISITION.SendNotification(P, hangarOccupied)
            return 
        end

        --
        --  Create Request
        --

        if !TIME then TIME = ( NCS_REQUISITION.CFG.DEN_TIME or 60 ) end
    
        timer.Create("VR_"..P:SteamID64(), TIME, 1, function()
            if NCS_REQUISITION.ACTIVE[P:EntIndex()] then
                NCS_REQUISITION.ACTIVE[P:EntIndex()] = nil
            end
        end )

        NCS_REQUISITION.ACTIVE[P:EntIndex()] = {
            VEHICLE = V_UID,
            SPAWN = H_UID,
            OWNER = P,
            SKIN = (SKIN or 0),
            LOADOUT = LOADOUT,
        }
        
        --
        --  Request or Auto Grant
        --
        
        if ( V_TAB.AutoGrant and NCS_REQUISITION.CanGrant(P, V_UID, H_UID) ) then
            AutoGrant(P, V_UID, H_TAB, V_TAB)

            return
        end
        
        if V_TAB.REQUEST then
            --
            --  Create Filter and Network
            --

            local COUNT = 0

            local FILTER = RecipientFilter()

            for k, v in ipairs(player.GetAll()) do
                if ( v == P ) and !NCS_REQUISITION.CFG.SG_PERM then
                    continue
                end

                if NCS_REQUISITION.CanGrant(v, V_UID, H_UID) then
                    COUNT = COUNT + 1

                    FILTER:AddPlayer(v)
                end
            end

            if COUNT <= 0 and ( V_TAB.SpawnAlone == true ) then
                AutoGrant(P, V_UID, H_TAB, V_TAB)
            elseif COUNT >= 1 then
                net.Start("NCS_REQUISITION_ASK")
                    net.WriteString(V_UID)
                    net.WriteString(H_UID)
                    net.WriteUInt(P:EntIndex(), 8)
                net.Send(FILTER)
            end

            local NAME = ( V_TAB.NAME or V_UID )
            --[[
            print(P:Name().." has started a vehicle request at "..os.time()..". Here's what we know about it:\n\n")
            print("Grantee Filter:")
            PrintTable(FILTER:GetPlayers())
            
            print("\n\nGrantee Teams List (Vehicle):")
            if V_TAB.GTEAMS then
            PrintTable(V_TAB.GTEAMS)
            else
                print("No Grantee Teams!")
            end
            
            print("\n\nGrantee Teams List (Vehicle):")
            if H_TAB.GTEAMS then
                PrintTable(H_TAB.GTEAMS)
            else
                print("No Grantee Teams!")
            end
            
            print("\n\nSelf Grant Perms:")
            print( (NCS_REQUISITION.CFG.SG_PERM and "True" ) or "false" )
            --]]
            
            local startedRequest = NCS_REQUISITION.GetLang(nil, "VR_startedRequest", {
                NAME,
            })

            NCS_REQUISITION.SendNotification(P, startedRequest)
        else

            --
            --  Auto Grant
            --

            AutoGrant(P, V_UID, H_TAB, V_TAB)
        end
    end
end)

--[[---------------------------------]]--
--  Requisition Request Granted
--[[---------------------------------]]--

net.Receive("NCS_REQUISITION.GRANT", function(_, G_PLAYER)
    local E_INDEX = net.ReadUInt(8)
    local R_PLAYER = Entity(E_INDEX)

    if !IsValid(R_PLAYER) then
        return
    end
    
    if ( R_PLAYER == G_PLAYER ) and !NCS_REQUISITION.CFG.SG_PERM then
        return
    end

    local tab = NCS_REQUISITION.ACTIVE[E_INDEX]
    local SEQ = tab.SEQUENTIAL

    local V_TAB = NCS_REQUISITION.VEHICLES[tab.VEHICLE]
    local H_TAB = NCS_REQUISITION.SPAWNS[tab.SPAWN]

    if not V_TAB then
        return
    end

    if tab and NCS_REQUISITION.CanGrant(G_PLAYER, tab.VEHICLE, tab.SPAWN) then
        local spawn_pos = H_TAB.POS
        local SHIP_NAME = NCS_REQUISITION.VEHICLES[tab.VEHICLE].NAME

        net.Start("NCS_REQUISITION_CLEAR")
            net.WriteUInt(E_INDEX, 8)
        net.Broadcast()

        if V_TAB.PRICE then
            if not NCS_REQUISITION.CanAfford(R_PLAYER, nil, V_TAB.PRICE) then
                local LcannotAfford = NCS_REQUISITION.GetLang(nil, "VR_cannotAfford")

                NCS_REQUISITION.SendNotification(R_PLAYER, LcannotAfford)

                NCS_REQUISITION.ACTIVE[E_INDEX] = nil


                return false
            end
                
            NCS_REQUISITION.AddMoney(R_PLAYER, nil, -V_TAB.PRICE)
        end

        SpawnVehicle(R_PLAYER, tab.VEHICLE, H_TAB, V_TAB)

        NCS_REQUISITION.ACTIVE[E_INDEX] = nil


        timer.Stop("VR_"..R_PLAYER:SteamID64())

        if R_PLAYER ~= G_PLAYER then
            local spawnAccRequester = NCS_REQUISITION.GetLang(nil, "VR_spawnAccRequester", {
                SHIP_NAME,
                G_PLAYER:Name(),
            })

            NCS_REQUISITION.SendNotification(R_PLAYER, spawnAccRequester)

            local spawnAccRequester = NCS_REQUISITION.GetLang(nil, "VR_spawnAccAccepter", {
                SHIP_NAME,
                R_PLAYER:Name(),
            })

            NCS_REQUISITION.SendNotification(G_PLAYER, spawnAccAccepter)
        else
            local spawnAccSelf = NCS_REQUISITION.GetLang(nil, "VR_spawnAccSelf", {
                SHIP_NAME,
            })

            NCS_REQUISITION.SendNotification(G_PLAYER, spawnAccSelf)
        end

        NCS_SHARED.PlaySound(R_PLAYER, "reality_development/ui/ui_accept.ogg")

        hook.Run("NCS_REQUISITION_RequestGranted", R_PLAYER, G_PLAYER, tab)
    end
end)

--[[---------------------------------]]--
--  Requsition Request Denied
--[[---------------------------------]]--

net.Receive("NCS_REQUISITION.DENY", function(len, P)
    local E_INDEX = net.ReadUInt(8)

    local NPLAYER = Entity(E_INDEX)

    if !IsValid(NPLAYER) then
        return
    end

    if ( NPLAYER == P ) and !NCS_REQUISITION.CFG.SG_PERM then
        return
    end
    
    local R_TAB = NCS_REQUISITION.ACTIVE[E_INDEX]

    if R_TAB and NCS_REQUISITION.CanGrant(P, R_TAB.VEHICLE, R_TAB.SPAWN) ~= false then
        local SHIP_NAME = NCS_REQUISITION.VEHICLES[R_TAB.VEHICLE].NAME

        net.Start("NCS_REQUISITION_CLEAR")
            net.WriteUInt(E_INDEX, 8)
        net.Broadcast()

        NCS_REQUISITION.ACTIVE[E_INDEX] = nil


        if NPLAYER ~= P then
            local spawnDenRequester = NCS_REQUISITION.GetLang(nil, "VR_spawnDenRequester", {
                SHIP_NAME,
                P:Name(),
            })

            NCS_REQUISITION.SendNotification(NPLAYER, spawnDenRequester)

            local spawnDenDenier = NCS_REQUISITION.GetLang(nil, "VR_spawnDenDenier", {
                SHIP_NAME,
                NPLAYER:Name(),
            })

            NCS_REQUISITION.SendNotification(P, spawnDenDenier)
        else   
            local spawnDenSelf = NCS_REQUISITION.GetLang(nil, "VR_spawnDenSelf", {
                SHIP_NAME,
            })

            NCS_REQUISITION.SendNotification(P, spawnDenSelf)
        end

        NCS_SHARED.PlaySound(NPLAYER, "reality_development/ui/ui_denied.ogg")

        hook.Run("NCS_REQUISITION_RequestDenied", NPLAYER, P, R_TAB)
    end
end)

net.Receive("NCS_REQUISITION.RETURN", function(len, P)
    local VEHICLE = P.CurrentRequestedVehicle

    if VEHICLE and IsValid(VEHICLE) then
        local CLASS = VEHICLE:GetClass()

        hook.Run("NCS_REQUISITION_PreVehicleReturn", P, VEHICLE)

        VEHICLE:Remove()

        local returnedVehicle = NCS_REQUISITION.GetLang(nil, "VR_returnedVehicle")

        NCS_REQUISITION.SendNotification(P, returnedVehicle)

        hook.Run("NCS_REQUISITION_PostVehicleReturn", P, CLASS)
    else
        local noCurrentVehicle = NCS_REQUISITION.GetLang(nil, "VR_noCurrentVehicle")

        NCS_REQUISITION.SendNotification(P, noCurrentVehicle)
    end
end)