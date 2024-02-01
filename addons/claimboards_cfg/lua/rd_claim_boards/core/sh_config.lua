local OBJ = RDV.CLAIMBOARDS.Config()

--[[---------------------------------]]--
--  Prefix
--[[---------------------------------]]--

OBJ:SetPrefix({
    Appension = "Claim Board",
    Color = Color(255,0,0)
})

--[[---------------------------------]]--
--  Reset Settings
--[[---------------------------------]]--

OBJ:SetArrest(false) -- Should the Claimboards be reset if the claimer is arrested?

OBJ:SetDeath(false) -- Should the Claimboards be reset if the claimer is killed?

--[[---------------------------------]]--
--  Header Settings
--[[---------------------------------]]--

OBJ:SetCustomHeaders(false)

OBJ:SetDefaultHeaders({
    "FFA",
    "Mando",
    "Tryouts",
    "TDM"
})

--[[---------------------------------]]--
--  Battalions
--[[---------------------------------]]--

OBJ:AddBattalion("CT", {
    "CT Non Commissioned Officer",
    "CT Commissioned Officer",
    "CT Commmander",
    "CT ARC"
}, Color(255, 255, 255))

OBJ:AddBattalion("501st", {
    "501st Non Commissioned Officer",
    "501st Commissioned Officer",
    "501st Commmander",
    "501st ARC"
}, Color(0, 34, 255))

OBJ:AddBattalion("212th", {
    "212th Non Commissioned Officer",
    "212th Commissioned Officer",
    "212th Commmander",
    "212th ARC"
}, Color(255, 153, 0))

OBJ:AddBattalion("41st", {
    "41st Non Commissioned Officer",
    "41st Commissioned Officer",
    "41st Commmander",
    "41st ARC"
}, Color(10, 64, 0))

OBJ:AddBattalion("CG", {
    "CG Non Commissioned Officer",
    "CG Commissioned Officer",
    "CG Commmander",
    "CG ARC"
}, Color(255, 0, 30))

OBJ:AddBattalion("RC", {
    "CS Commando",
    "CS Squad Leader"
}, Color(0, 0, 0))

OBJ:AddBattalion("7th Flotilla", {
    "Navy Junior Officer",
    "Navy Officer",
    "Navy Senior Officer",
    "Admirality"
}, Color(110, 110, 110))

--[[---------------------------------]]--
--  Admins
--[[---------------------------------]]--

OBJ:SetAdmins({
    "superadmin",
})

--[[---------------------------------]]--
--  Commands
--[[---------------------------------]]--

OBJ:SetCommands({
    Unclaim = "!unclaim", -- Unclaims the sign the Admin is looking at.
    UnclaimAll = "!unclaim_all", -- Unclaims all signs of a selected player.
})