wOS = wOS or {}
wOS.INV = wOS.INV or {}

hook.Add("wOS.ALCS.PostLoaded", "wOS.ALCS.PostLoadedInvRegistration", function()
    wOS.INV:RegisterInventory({
		Name = "ALCS",
		SlotLimit = wOS.ALCS.Config.Crafting.MaxInventorySlots or 40,
		GetInventory = function(ply) return ply.SaberInventory end,
		GetMatInventory = function(ply) return ply.RawMaterials end,
		Items = "wOS.ItemList",
		Materials = "wOS.RawMaterialList",
		DropHook = "wOS.Crafting.DropItem",
		DropMatHook = "wOS.Crafting.DropMaterial",
		MoveHook = "wOS.Crafting.ChangeSlot",
		UpdateHook = "wOS.Crafting.UpdateInventory",
		UpdateMatHook = "wOS.Crafting.UpdateMaterials",
		UseHook = false,
		DestroyHook = false,
	})
end)
