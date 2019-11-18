extends Control

func init(player):
	var pname_label = $PlayerNameContainer/PlayerName
	var pinventory_grid = $PlayerInventoryContainer/PlayerInventoryGrid
	
	pname_label.set_text(player.get_name())
	
	for i in range(10):
		for weapon in player.get_inventory():
			var props = weapon.get_weapon_props()
			var weapon_container = CenterContainer.new()
			var wep_texture_rect = TextureRect.new()
			
			wep_texture_rect.set_texture(load(props['texture']))
			weapon_container.set_h_size_flags(SIZE_EXPAND_FILL)
			weapon_container.add_child(wep_texture_rect)
			pinventory_grid.add_child(weapon_container)