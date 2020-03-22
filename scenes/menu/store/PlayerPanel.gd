extends Control

# Background frame for store inventories, weapons drawn over
const ItemSlot = preload("res://scenes/menu/store/ItemSlot.tscn")
const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")
const pinventory_grid = 'PlayerInventoryContainer/CenterContainer/PlayerInventoryGrid'
const sinventory_grid = 'StoreInventoryContainer/CenterContainer/StoreInventoryGrid'

# Keep track of num weapons in inventories for padding num item slots
var pinventory_wep_count = 0
var sinventory_wep_count = 0


func init(player):
	var pname_label = $PlayerNameContainer/PlayerName
	var ptexture = $PlayerTextureContainer
	pname_label.set_text(player.get_name())
	
	# Find the player sprite and add it to the player panel
#	var player_sprite = player.get_node("Sprite").duplicate()
#	ptexture.add_child(player_sprite)
#	player_sprite.set_frame(1)
#	player_sprite.offset.x = 150
#	player_sprite.set_scale(Vector2(1, 1))

	init_player_inventory(player)
	init_store_inventory(player)
	
	var money_format_string = "Money: %s"
	var money_actual_string = money_format_string % str(player.get_money())
	get_node("PlayerMoneyContainer/PlayerMoneyLabel").set_text(money_actual_string)


# Add player weapons to the player inventory
func init_player_inventory(player):
	# reset the view if a wep is added
	get_node("PlayerInventoryContainer").set_v_scroll(0)
	
	# Clear the current player inventory
	for item_slot_container in get_node(pinventory_grid).get_children():
		item_slot_container.queue_free()
		pinventory_wep_count -= 1

	# Create an item slot for each weapon in player inventory
	for weapon in player.get_inventory():
		var props = WEAPON_FACTORY.get_props(weapon.get_name())
		var weapon_name = props['weapon_name']
		create_item_slot(player, props, get_node(pinventory_grid), 'player')
		pinventory_wep_count += 1
	
	# Pad the player inventory section with empty item slots
	while pinventory_wep_count < 9:
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot_container.add_child(item_slot)
		get_node(pinventory_grid).add_child(item_slot_container)
		pinventory_wep_count += 1
	
	
# Add one of each weapon to the store inventory
func init_store_inventory(player):
	
	# Clear the current store inventory
	for item_slot_container in get_node(sinventory_grid).get_children():
		item_slot_container.queue_free()
		sinventory_wep_count -= 1
	
	# Create an item slot for each weapon that player doesn't have
	for weapon_name in WEAPON_FACTORY.get_weapon_names():
		if !player.has_weapon(weapon_name):
			var props = WEAPON_FACTORY.get_props(weapon_name)
			create_item_slot(player, props, get_node(sinventory_grid), 'store')
			sinventory_wep_count += 1
			
	# Pad the store inventory section with empty item slots
	while sinventory_wep_count < 9:
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot_container.add_child(item_slot)
		get_node(sinventory_grid).add_child(item_slot_container)
		sinventory_wep_count += 1


func create_item_slot(player, props, inventory, inventory_type):
	print(inventory_type)
	var item_slot_container = CenterContainer.new()
	var item_slot = ItemSlot.instance()
	
	item_slot.connect("added_money_to_player", self, "on_added_money_to_player")
	item_slot.connect("player_inventory_changed", self, "on_player_inventory_changed")
	
	item_slot.init(player, props['weapon_name'], inventory_type)
	item_slot_container.add_child(item_slot)
	inventory.add_child(item_slot_container)
	
	# Update the texture of this item slot with what the player owns
	var weapon_texture_path_format = "res://assets/store/%s.png"
	var weapon_texture_path = weapon_texture_path_format % props['weapon_name']
	
	# Make sure the weapons are 80x80 and imported as textures
	var weapon_stex = load(weapon_texture_path)
	item_slot.get_node("WeaponTextureRect").set_texture(weapon_stex)
	item_slot.get_node("PriceLabel").set_text(String(props['price']))

	
func on_player_inventory_changed(player, weapon_name):
	init_player_inventory(player)
	init_store_inventory(player)


func on_added_money_to_player(player, money_amount):
	get_node("PlayerMoneyContainer/PlayerMoneyLabel").set_text("Money: " + str(player.get_money()))
