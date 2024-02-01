-- [[ CREATED BY ZOMBIE EXTINGUISHER ]]

/* 
	Gmod and custom fonts are bugged for some OS users, incase the font isn't loaded we use our own fallback
*/

local customFont = file.Read( "resource/fonts/yugothil.ttf", "GAME" )
local isCustomFontLoaded = customFont ~= nil
local font = isCustomFontLoaded and "Yu Gothic Light" or "Trebuchet24"
local weight = 1

function CL_EASYSKINS.GetFont()
	return font
end

surface.CreateFont( "z_easyskins_menu_title", {
	font = font,
	size = 35,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_cat_title", {
	font = font,
	size = 30,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_preview_title", {
	font = "Roboto Cn",
	size = ScreenScale(10),
	weight = 1
} )

surface.CreateFont( "z_easyskins_menu_create_step", {
	font = "Coolvetica",
	size = 30,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_menu_cat_btn", {
	font = font,
	size = 25,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_menu_cat_btn_bold", {
	font = "Roboto Cn",
	size = 25,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_menu_cat_btn_strike", {
	font = font,
	size = 25,
	rotary = true,
	blursize = 2,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_menu_settings_title", {
	font = "Coolvetica",
	size = 25,
	weight = weight,
	additive = true
} )

surface.CreateFont( "z_easyskins_shop_category_title", {
	font = "Roboto Lt",
	size = 23,
	weight = 1,
	additive = true
} )

surface.CreateFont( "z_easyskins_menu_cat_sub_btn", {
	font = "Trebuchet24",
	size = 20,
	weight = weight
} )

surface.CreateFont( "z_easyskins_menu_cat_sub_btn_bold", {
	font = "Roboto Cn",
	size = 20,
	weight = weight
} )

surface.CreateFont( "z_easyskins_material_lbl", {
	font = "Trebuchet24",
	size = 15,
	weight = weight
} )

surface.CreateFont( "z_easyskins_obj_lbl", {
	font = "Trebuchet24",
	size = 12,
	weight = weight
} )

surface.CreateFont( "z_easyskins_obj_lbl_strike", {
	font = "Trebuchet24",
	size = 12,
	rotary = true,
	blursize = 1,
	weight = weight
} )