include("shared.lua")
AddCSLuaFile()

function ENT:Draw()
    self:DrawModel()
end

surface.CreateFont("NCS_REQUISITION_CoreOverhead", {
    font = "Good Times Rg",
    extended = false,
    size = 40,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true
})

function ENT:Initialize()

    NCS_SHARED.AddOverhead(self, {
        Accent = ( NCS_REQUISITION.CFG.OVR_COLOR ) or color_white,
        Position = true, -- OBBMax or Head Position (you can also use a vector relative to the entities position.)
        Lines = {
            {
                Text = NCS_REQUISITION.GetLang(nil, "VR_addonTitle"), 
                Color = color_white,
                Font = "NCS_REQUISITION_CoreOverhead",
            },
        }
    })
end

