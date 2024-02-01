local ITEM = {} 
ITEM.Rarity = 100

ITEM.Name = "Dual Blade 3 Hilt"

ITEM.Description = "Lightsaber Hilt"

ITEM.Type = WOSTYPE.HILT

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

ITEM.Model = "models/sgg/starwars/weapons/w_saber_dual_3_hilt.mdl"

--The chance for the item to appear randomly. 0 = will not spawn, 100 = incredibly high chance
ITEM.Rarity = 0

ITEM.MaxStack = 5

ITEM.OnEquip = function( wep )
	wep.UseHilt = "models/sgg/starwars/weapons/w_saber_dual_3_hilt.mdl"
	wep.UseLength = 28
end

wOS:RegisterItem( ITEM )