extends Control

# Background frame for store inventories, weapons drawn over
const ItemSlot = preload("res://scenes/menu/store/ItemSlot.tscn")

const Pistol = preload("res://scenes/weapon/Pistol.gd")
const Shotgun = preload("res://scenes/weapon/Shotgun.gd")
const AssaultRifle = preload("res://scenes/weapon/AssaultRifle.gd")
const Sniper = preload("res://scenes/weapon/Sniper.gd")

const WEAPONS = [Pistol, Shotgun, AssaultRifle, Sniper]

func init(player):
	var pname_label = $PlayerNameContainer/PlayerName
	var ptexture = $PlayerTextureContainer
	# Added a CenterContainer to center the grid horizontally in the scroll container
	var pinventory_grid = $PlayerInventoryContainer/CenterContainer/PlayerInventoryGrid
	
	pname_label.set_text(player.get_name())
	
	# Find the player sprite and add it to the player panel
#	var player_sprite = player.get_node("Sprite").duplicate()
#	ptexture.add_child(player_sprite)
#	player_sprite.set_frame(1)
#	player_sprite.offset.x = 150
#	player_sprite.set_scale(Vector2(1, 1))

	# Add player weapons to the player inventory
	for weapon in player.get_inventory():
		var props = weapon.get_weapon_props()
		var weapon_name = props['weapon_name']
		
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot.init(player, weapon, "player")
		
		item_slot_container.add_child(item_slot)
		pinventory_grid.add_child(item_slot_container)
		
		# Update the texture of this item slot with what the player owns
		var weapon_texture_path_format = "res://assets/store/%s.png"
		var weapon_texture_path = weapon_texture_path_format % weapon_name
		
		# Make sure the weapons are 80x80 and imported as textures
		var weapon_stex = load(weapon_texture_path)
		item_slot.get_node("WeaponTextureRect").set_texture(weapon_stex)

	# Pad the player inventory section with empty item slots
	while pinventory_grid.get_child_count() < 15:
		var item_slot_container = CenterContainer.new()
		var item_slot = ItemSlot.instance()
		item_slot_container.add_child(item_slot)
		pinventory_grid.add_child(item_slot_container)
		
	for weapon in WEAPONS:
		var props = weapon.get_weapon_props()
		print(props["weapon_name"])
		# pass weapon name, get weapon information or weapon instance
	
	
	
	
	
	
	
	
	
