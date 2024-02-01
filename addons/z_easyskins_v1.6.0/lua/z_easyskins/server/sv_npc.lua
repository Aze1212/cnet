-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local shopEntClass = "ent_easyskins_shop"

local function DespawnShopNpcs()

	for _, ent in pairs(ents.FindByClass( shopEntClass )) do
		
		if ent:IsValid() then	
			ent.ForceRemove = true
			ent:Remove()
		end
		
	end
	
end

util.AddNetworkString("sv_easyskins_SpawnShopNpcs")
function SV_EASYSKINS.SpawnShopNpcs(len, ply)
	
	if !SV_EASYSKINS.DATALOADED then
		timer.Simple(1,function()
			SV_EASYSKINS.SpawnShopNpcs()
		end)
	end
	
	if ply ~= nil and !SH_EASYSKINS.HasAccess(ply) then
		return
	end
	
	DespawnShopNpcs()

	local posTbl = SH_EASYSKINS.SETTINGS.NPCPOSITIONS[SH_EASYSKINS.VAR.MAP] or {}

	for i=1, #posTbl do
	
		local pos = posTbl[i].pos
		local ang = posTbl[i].ang
	
		local shopNpc = ents.Create( shopEntClass )
		shopNpc:SetPos(pos)
		shopNpc:SetAngles(ang)
		shopNpc:SetModel(SH_EASYSKINS.SETTINGS.SHOPMODEL)
		shopNpc:Spawn()
		
	end
	
end
net.Receive("sv_easyskins_SpawnShopNpcs",SV_EASYSKINS.SpawnShopNpcs)
hook.Add("InitPostEntity","sv_easyskins_SpawnShopNpcs",SV_EASYSKINS.SpawnShopNpcs)