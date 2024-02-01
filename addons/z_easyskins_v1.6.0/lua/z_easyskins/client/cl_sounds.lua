-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local sounds = {
	["buy"] = "z_easyskins/buy.wav",
	["sell"] = "z_easyskins/sell.wav",
	["deny"] = "z_easyskins/deny.wav",
	["press"] = "z_easyskins/btn_press.wav",
	["equip"] = "z_easyskins/equip.wav",
}

-- precache
for _, path in pairs( sounds ) do
	sound.Play( path, Vector(), 20, 100, 0 )
end

function CL_EASYSKINS.PlaySound( id )
	surface.PlaySound( sounds[id] )
end