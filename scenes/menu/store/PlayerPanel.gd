extends Control

# Background frame for store inventories, weapons drawn over
const ItemSlot = preload("res://scenes/menu/store/ItemSlot.tscn")
const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")
const pinventory_grid = 'PlayerInventoryContainer/CenterContainer/PlayerInventoryGrid'
const sinventory_grid = 'StoreInventoryContainer/CenterContainer/StoreInventoryGrid'


func create_item_slot(player, weapon_name, inventory, inventory_type):
	var item_slot_container = CenterContainer.new()
	var item_slot = ItemSlot.instance()
	item_slot.connect("added_weapon_to_player", self, "on_added_weapon_to_player")
	item_slot.init(player, weapon_name, inventory_type)
	
	item_slot_container.add_child(item_slot)
	inventory.add_child(item_slot_container)
	
	# Update the texture of this item slot with what the player owns
	var weapon_texture_path_format = "res://assets/store/%s.png"
	var weapon_texture_path = weapon_texture_path_format % weapon_name
	
	# Make sure the weapons are 80x80 and imported as textures
	var weapon_stex = load(weapon_texture_path)
	item_slot.get_node("WeaponTextureRect").set_texture(weapon_stex)


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
	
		
# Add player weapons to the player inventory
func init_player_inventory(player):
	for weapon in player.get_inventory():
		var props = WEAPON_FACTORY.get_props(weapon.get_name())
		var weapon_name = props['weapon_name']
		create_item_slot(player, weapon_name, get_node(pinventory_grid), 'player')
	
	# Pad the player inventory section with empty item slots
	while get_node(pinventory_grid).get_child_count() < 9:
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot_container.add_child(item_slot)
		get_node(pinventory_grid).add_child(item_slot_container)
	
	
# Add one of each weapon to the store inventory
func init_store_inventory(player):	
	for weapon_name in WEAPON_FACTORY.get_weapon_names():
		if !player.has_weapon(weapon_name):
			var props = WEAPON_FACTORY.get_props(weapon_name)
			create_item_slot(player, weapon_name, get_node(sinventory_grid), 'store')
			
	# Pad the store inventory section with empty item slots
	while get_node(sinventory_grid).get_child_count() < 9:
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot_container.add_child(item_slot)
		get_node(sinventory_grid).add_child(item_slot_container)
	
	
func on_added_weapon_to_player(player, weapon_name):
	for item_slot_container in get_node(pinventory_grid).get_children():
		# queue_free() happens at the end of the frame
		# that's too late for inventory grid padding
		item_slot_container.free()
	init_player_inventory(player)
	
	# Player/Store inventories: 
	# Grid of CenterContainers, each holds one ItemSlot
	# ItemSlot has TextureRect (gun icon) and TextureButton (background frame)
	for item_slot_container in get_node(sinventory_grid).get_children():
		item_slot_container.free()
	init_store_inventory(player)
	
	
	
	
