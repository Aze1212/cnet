--[[-------------------------------------------------------------------]]--[[
							  
	Copyright wiltOS Technologies LLC, 2022
	
	Contact: www.wiltostech.com
		----------------------------------------]]--








































































wOS = wOS or {}
wOS.ALCS = wOS.ALCS or {}
wOS.ALCS.DataDesc = wOS.ALCS.DataDesc or {}
wOS.ALCS.DataDesc.Translation = wOS.ALCS.DataDesc.Translation or {}

net.Receive( "wOS.ALCS.DataDesc.Sync", function( len )
	local ent = net.ReadEntity()
	if not IsValid( ent ) then return end
	if not ent.IsLightsaber then return end
	local size = net.ReadUInt( 16 )
	local data = net.ReadData( size )
	data = util.Decompress( data )
	data = util.JSONToTable( data )
	ent:ApplyDataDesc( data )
end )

net.Receive( "wOS.ALCS.DataDesc.Define", function( len ) 
	local id = net.ReadUInt( 16 )
	local desc = net.ReadString()
    if #desc < 1 then return end
	wOS.ALCS.DataDesc.Translation[ id ] = desc
end )

net.Receive( "wOS.ALCS.DataDesc.InitAll", function( len ) 
	local descs = net.ReadTable()
	wOS.ALCS.DataDesc.Translation = {}
	for desc, id in pairs( descs ) do
		wOS.ALCS.DataDesc.Translation[id] = desc
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncColor", function( len ) 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadColor()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncColor_Table", function( len ) 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadColor()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncBool", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadBool()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncBool_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadBool()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncInt", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadInt( 32 )
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncInt_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadInt( 32 )
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncString", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadString()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncString_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadString()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncVector", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadVector()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncVector_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadVector()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncFloat", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadFloat()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncFloat_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadFloat()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncAngle", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadAngle()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncAngle_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadAngle()
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncUInt", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadUInt( 16 )
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )
net.Receive("wOS.ALCS.DataDesc.SyncUInt_Table", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local entries = net.ReadUInt( 8 )
			local data = {}
			for k=1, entries do
				local dat = net.ReadUInt( 16 )
				table.insert( data, dat )
			end
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then continue end
			ent:ApplyDataDesc( desc, data )
		end
	end
end )

net.Receive("wOS.ALCS.DataDesc.SyncVarArg", function() 
	local total_descs = net.ReadUInt( 8 )
	for i=1, total_descs do
		local total_ents = net.ReadUInt( 8 )
		for j=1, total_ents do
			local ent = net.ReadEntity()
			local id = net.ReadUInt( 16 )
			local dat = net.ReadTable()
			local desc = wOS.ALCS.DataDesc.Translation[id]
			if not desc then continue end
			if not IsValid( ent ) then return end
			if not ent.IsLightsaber then return end	
			ent:ApplyDataDesc( desc, dat )
		end
	end
end )