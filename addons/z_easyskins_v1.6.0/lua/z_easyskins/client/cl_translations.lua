-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

local translations = {}
local translationFiles = file.Find( "z_easyskins/languages/*.lua", "LUA" )
local languages = {}
local langConvarName = "cl_easyskins_lang"

if !ConVarExists( langConvarName ) then
	CreateClientConVar( langConvarName, "EN", true, false )
end

-- intialize languages  
for _,translation in pairs(translationFiles) do 
	
	-- get the lang code from file name
	local langCode = string.match(translation,"cl_(%a+).lua")
	langCode = langCode:upper()
	
	-- add the code to the range of languages
	table.insert(languages,langCode)
 
	-- store the translations in the var
	local f = "z_easyskins/languages/"..translation
	translations[langCode] = include( f )
	
end

function CL_EASYSKINS.GetLanguages()
	return languages
end

function CL_EASYSKINS.GetPlayerLanguage()
	
	langConvar = GetConVar( langConvarName )
	return langConvar:GetString()
	
end

function CL_EASYSKINS.SetPlayerLanguage(lang)
	
	langConvar = GetConVar( langConvarName )
	langConvar:SetString( lang )
	
end

function CL_EASYSKINS.Translate(str)

	local playerLang = CL_EASYSKINS.GetPlayerLanguage()
	local translations = translations[playerLang] or translations["EN"]
	
	return translations[str] or str

end