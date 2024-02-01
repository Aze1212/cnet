local ITEM = {} 
ITEM.Rarity = 100

--The name of the item ( is also an identifier for spawning the item )
ITEM.Name = "Crystal ( Cyan )"

--The description that appears with the item name
ITEM.Description = "Basic Crystal"

--The category it belongs to
ITEM.Type = WOSTYPE.CRYSTAL

--Add user groups that are allowed to use this tree. If anyone is allowed, set this to FALSE ( TREE.UserGroups = false )
ITEM.UserGroups = false

--Does this item disappear from the inventory after it's been applied?
ITEM.BurnOnUse = false

--The model of the item on the floor / inventory
ITEM.Model = "models/venator/venator_kybercrystal_wos_cyan.mdl"

--The chance for the item to appear randomly. 0 = will not spawn, 100 = incredibly high chance
ITEM.Rarity = 15

ITEM.OnEquip = function( wep )
	wep.UseColor = Color(31, 187, 255, 255)
end

wOS:RegisterItem( ITEM )