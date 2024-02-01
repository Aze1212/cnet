util.AddNetworkString("NCS_REQUISITION_ADMIN")
util.AddNetworkString("NCS_REQUISITION_AddSpawn")
util.AddNetworkString("NCS_REQUISITION_AddVehicle")
util.AddNetworkString("NCS_REQUISITION_BatchSend")
util.AddNetworkString("NCS_REQUISITION_SaveSettings")
util.AddNetworkString("NCS_REQUISITION_RetrieveModel")

local function SendNotification(P, MSG)
    local PREFIX = NCS_REQUISITION.CFG.PRE_STRING
    local COL = NCS_REQUISITION.CFG.PRE_COLOR

    NCS_SHARED.AddText(P, Color(COL.r, COL.g, COL.b), "["..PREFIX.."] ", color_white, MSG)
end

local OVERFLOW = {}
net.Receive("NCS_REQUISITION_RetrieveModel", function(_, P)
    if OVERFLOW[P] and OVERFLOW[P] > CurTime() then return end

    local CLASS = net.ReadString()

    local F_ENT

    if simfphys and list.Get( "simfphys_vehicles" )[CLASS] then
        F_ENT = simfphys.SpawnVehicleSimple( CLASS, Vector(0,0,0), Angle(0,0,0) )
    elseif list.Get("Vehicles")[CLASS] then
        local D = list.Get("Vehicles")[CLASS]

        if !D.Class or !D.Model then return end

        F_ENT = ents.Create(D.Class)
        F_ENT:SetModel(D.Model)
        F_ENT:Spawn()
    else
        F_ENT = ents.Create(CLASS) -- Get the Model of the Vehicle!
        F_ENT:Spawn()
    end

    local MODEL = F_ENT:GetModel()
    
    F_ENT:Remove()

    net.Start("NCS_REQUISITION_RetrieveModel")
        net.WriteString(MODEL)
    net.Send(P)
    
    OVERFLOW[P] = CurTime() + 1
end )

net.Receive("NCS_REQUISITION_SaveSettings", function(_, P)
    NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
        if !SUCCESS then return end

        local LEN = net.ReadUInt(32)
        local DATA = net.ReadData(LEN)

        local DECOMP = util.JSONToTable(util.Decompress(DATA))

        if !DECOMP.admins["superadmin"] then
            DECOMP.admins["superadmin"] = "World"
        end

        NCS_REQUISITION.CFG = DECOMP

        local S_PATH = "rdv/requisition/settings.json"
        
        file.Write(S_PATH, util.TableToJSON(DECOMP))

        local S_COMPRESS = util.Compress(util.TableToJSON(NCS_REQUISITION.CFG))
        local S_BYTES = #S_COMPRESS

        net.Start("NCS_REQUISITION_SaveSettings")
            net.WriteUInt(LEN, 32)
            net.WriteData(DATA, LEN)
        net.Send(P)
    end )
end )

hook.Add("NCS_SHARED_PlayerReadyForNetworking", "NCS_REQUISITION_SendStuff", function(P)
    -- Vehicles
    
    NCS_REQUISITION.VEHICLES = NCS_REQUISITION.VEHICLES or {}

    local V_COMPRESS = util.Compress(util.TableToJSON(NCS_REQUISITION.VEHICLES))
    local V_BYTES = #V_COMPRESS

    -- Spawns

    NCS_REQUISITION.SPAWNS = NCS_REQUISITION.SPAWNS or {}

    local H_COMPRESS = util.Compress(util.TableToJSON(NCS_REQUISITION.SPAWNS))
    local H_BYTES = #H_COMPRESS

    net.Start("NCS_REQUISITION_BatchSend")
        net.WriteUInt(V_BYTES, 32)
        net.WriteData(V_COMPRESS, V_BYTES)
        net.WriteUInt(H_BYTES, 32)
        net.WriteData(H_COMPRESS, H_BYTES)
    net.Send(P)

    local S_COMPRESS = util.Compress(util.TableToJSON(NCS_REQUISITION.CFG))
    local S_BYTES = #S_COMPRESS

    net.Start("NCS_REQUISITION_SaveSettings")
        net.WriteUInt(S_BYTES, 32)
        net.WriteData(S_COMPRESS, S_BYTES)
    net.Send(P)
end )

local function ReadData()
    local PATH = "rdv/requisition/spawns/"..game.GetMap()..".json"

    if file.Exists(PATH, "DATA") then
        local TXT = file.Read(PATH, "DATA")

        if !TXT then return end

        local TBL = util.JSONToTable(TXT)

        for k, v in pairs(TBL) do
            if !v.UID then
                TBL[k] = nil
            end

            local DATA = TBL[k]
            
            for k, v in pairs(NCS_REQUISITION.DF_SPAWN) do
                if DATA and ( DATA[k] == nil ) then DATA[k] = v end
            end
        end

        NCS_REQUISITION.SPAWNS = TBL
    end

    local V_PATH = "rdv/requisition/vehicles.json"

    if file.Exists("rdv/requisition/", "DATA") then
        local TXT = file.Read(V_PATH, "DATA")

        if !TXT then return end

        local TBL = util.JSONToTable(TXT)

        for k, v in pairs(TBL) do
            if !v.UID then
                TBL[k] = nil
            end

            local DATA = TBL[k]
            
            for k, v in pairs(NCS_REQUISITION.DF_VEHICLE) do
                if DATA and ( DATA[k] == nil ) then DATA[k] = v end
            end
        end

        NCS_REQUISITION.VEHICLES = TBL
    end

    local S_PATH = "rdv/requisition/settings.json"

    if file.Exists(S_PATH, "DATA") then
        local TXT = file.Read(S_PATH, "DATA")

        if !TXT then return end

        local TBL = util.JSONToTable(TXT)

        for k, v in pairs(TBL) do
            if ( NCS_REQUISITION.CFG[k] ~= nil ) then
                NCS_REQUISITION.CFG[k] = v
            end
        end
    end

    MsgC(Color(255,0,0), "[Requisition]", color_white, " Reading Saved Data!\n")
end
ReadData()

local function SaveData()
    local PATH = "rdv/requisition/spawns/"..game.GetMap()..".json"
    
    file.CreateDir("rdv/requisition/spawns/")

    file.Write(PATH, util.TableToJSON(NCS_REQUISITION.SPAWNS))

    local V_PATH = "rdv/requisition/vehicles.json"
    
    file.Write(V_PATH, util.TableToJSON(NCS_REQUISITION.VEHICLES))
end

net.Receive("NCS_REQUISITION_AddSpawn", function(_, P)
    NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
        if !SUCCESS then return end

        local LEN = net.ReadUInt(32)
        local DATA = net.ReadData(LEN)

        local UID = ( os.time().."_"..P:EntIndex() )

        local DECOMP = util.JSONToTable(util.Decompress(DATA))

        if !DECOMP.CREATOR then
            DECOMP.CREATOR = P:SteamID64()
        end

        if !DECOMP.UID then
            DECOMP.UID = UID
        else
            UID = DECOMP.UID
        end

        if DECOMP.RTEAMS and table.Count(DECOMP.RTEAMS) <= 0 then
            DECOMP.RTEAMS = nil
        end

        if DECOMP.GTEAMS and table.Count(DECOMP.GTEAMS) <= 0 then
            DECOMP.GTEAMS = nil
        end

        DECOMP.MAP = game.GetMap()

        NCS_REQUISITION.SPAWNS[UID] = DECOMP

        local COMPRESS = util.Compress(util.TableToJSON(DECOMP))
        local BYTES = #COMPRESS

        net.Start("NCS_REQUISITION_AddSpawn")
            net.WriteUInt(BYTES, 32)
            net.WriteData(COMPRESS, BYTES)
        net.Broadcast()

        SaveData()
    end )
end )

util.AddNetworkString("NCS_REQUISITION_DelSpawn")

net.Receive("NCS_REQUISITION_DelSpawn", function(_, P)
    NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
        if !SUCCESS then return end

        local UID = net.ReadString()

        if NCS_REQUISITION.SPAWNS[UID] then
            NCS_REQUISITION.SPAWNS[UID] = nil
        end

        net.Start("NCS_REQUISITION_DelSpawn")
            net.WriteString(UID)
        net.Broadcast()

        SaveData()
    end )
end )


--[[
--  Vehicles
--]]

net.Receive("NCS_REQUISITION_AddVehicle", function(_, P)
    NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
        if !SUCCESS then return end

        local LEN = net.ReadUInt(32)
        local DATA = net.ReadData(LEN)

        local UID = ( os.time().."_"..P:EntIndex() )

        local DECOMP = util.JSONToTable(util.Decompress(DATA))

        if DECOMP.LOADOUTS then
            for k, v in pairs(DECOMP.LOADOUTS) do
                if !v.NAME or v.NAME == "" then
                    return
                end
            end
        end

        if DECOMP.PRICE then
            DECOMP.PRICE = tonumber(DECOMP.PRICE)
        end

        if DECOMP.MAX then
            DECOMP.MAX = tonumber(DECOMP.MAX)

            if DECOMP.MAX and DECOMP.MAX <= 0 then
                DECOMP.MAX = nil
            end
        end

        if !DECOMP.CREATOR then
            DECOMP.CREATOR = P:SteamID64()
        end
        
        if DECOMP.SKIN then
            DECOMP.SKIN = tonumber(DECOMP.SKIN)
        end

        if !DECOMP.UID then
            DECOMP.UID = UID
        else
            UID = DECOMP.UID
        end

        if DECOMP.RTEAMS and table.Count(DECOMP.RTEAMS) <= 0 then
            DECOMP.RTEAMS = nil
        end

        if DECOMP.GTEAMS and table.Count(DECOMP.GTEAMS) <= 0 then
            DECOMP.GTEAMS = nil
        end

        local F_ENT

        if simfphys and list.Get( "simfphys_vehicles" )[DECOMP.CLASS] then
            F_ENT = simfphys.SpawnVehicleSimple( DECOMP.CLASS, Vector(0,0,0), Angle(0,0,0) )
        elseif list.Get("Vehicles")[DECOMP.CLASS] then
            local D = list.Get("Vehicles")[DECOMP.CLASS]

            if !D.Class or !D.Model then return end
            
            F_ENT = ents.Create(D.Class)
            F_ENT:SetModel(D.Model)
            F_ENT:Spawn()
        else
            F_ENT = ents.Create(DECOMP.CLASS) -- Get the Model of the Vehicle!
            F_ENT:Spawn()
        end

        local MODEL = F_ENT:GetModel()

        DECOMP.MODEL = MODEL
        
        F_ENT:Remove()

        NCS_REQUISITION.VEHICLES[UID] = DECOMP

        local COMPRESS = util.Compress(util.TableToJSON(DECOMP))
        local BYTES = #COMPRESS

        net.Start("NCS_REQUISITION_AddVehicle")
            net.WriteUInt(BYTES, 32)
            net.WriteData(COMPRESS, BYTES)
        net.Broadcast()

        SaveData()
    end )
end )

util.AddNetworkString("NCS_REQUISITION_DelVehicle")
net.Receive("NCS_REQUISITION_DelVehicle", function(_, P)
    NCS_REQUISITION.IsAdmin(P, function(SUCCESS)
        if !SUCCESS then return end

        local UID = net.ReadString()

        if NCS_REQUISITION.VEHICLES[UID] then
            NCS_REQUISITION.VEHICLES[UID] = nil
        end

        net.Start("NCS_REQUISITION_DelVehicle")
            net.WriteString(UID)
        net.Broadcast()

        SaveData()
    end )
end )