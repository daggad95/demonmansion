extends Control

const ItemSlot = preload("res://scenes/menu/store/ItemSlot.tscn")

func init(player):
	var pname_label = $PlayerNameContainer/PlayerName
	var pinventory_grid = $PlayerInventoryContainer/CenterContainer/PlayerInventoryGrid
	
	pname_label.set_text(player.get_name())
	
	for i in range(10):
		for weapon in player.get_inventory():
			var props = weapon.get_weapon_props()
			var weapon_name = props['weapon_name']
			
			var item_slot_container = CenterContainer.new()
			var item_slot = ItemSlot.instance()
			item_slot_container.add_child(item_slot)
			pinventory_grid.add_child(item_slot_container)
			
#			item_slot_container.set_h_size_flags(SIZE_EXPAND_FILL)
