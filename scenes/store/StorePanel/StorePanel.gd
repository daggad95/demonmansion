extends MarginContainer

signal open
signal close

const WeaponFactory = preload("res://scenes/weapon/WeaponFactory.gd")
const WeaponStoreItem = preload("res://scenes/store/StoreItem/WeaponStoreItem/WeaponStoreItem.tscn")
const AmmoStoreItem = preload("res://scenes/store/StoreItem/AmmoStoreItem/AmmoStoreItem.tscn")
const StoreItemType = preload("res://scenes/store/StoreItem/StoreItem.gd").StoreItemType

enum {RIGHT, LEFT, UP, DOWN}

var store_inventory = [
	{
		"name": "Sniper Ammo",
		"item_type": StoreItemType.AMMO,
		"price": 20,
		"quantity": 10,
		"ammo_type": Weapon.Ammo.SNIPER,
		"icon": "res://assets/Ammo/sniper.png"
	},
	{
		"name": "Rifle Ammo",
		"item_type": StoreItemType.AMMO,
		"price": 20,
		"quantity": 10,
		"ammo_type": Weapon.Ammo.RIFLE,
		"icon": "res://assets/Ammo/rifle.png"
	},
	{
		"name": "Shotgun Ammo",
		"item_type": StoreItemType.AMMO,
		"price": 20,
		"quantity": 10,
		"ammo_type": Weapon.Ammo.SHOTGUN,
		"icon": "res://assets/Ammo/SHOTGUN.png"
	}
]
var player
var is_transparent
var current_item
onready var item_grid = $MarginContainer/VBoxContainer/CenterContainer/GridContainer
onready var player_health_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HealthLabel
onready var player_money_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MoneyLabel
onready var rifle_ammo_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/RifleAmmoLabel
onready var sniper_ammo_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/SniperAmmoLabel
onready var shotgun_ammo_label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/ShotgunAmmoLabel

func link_controller(controller):
	controller.connect("player_interact", self, "_on_open_store")
	controller.connect("menu_right", self, "_on_menu_input", [RIGHT])
	controller.connect("menu_left", self, "_on_menu_input", [LEFT])
	controller.connect("menu_up", self, "_on_menu_input", [UP])
	controller.connect("menu_down", self, "_on_menu_input", [DOWN])
	controller.connect("menu_select", self, "_purchase")

func link_player(player):
	self.player = player
	player.connect("health_change", self, "_update_player_health")
	player.connect("money_change", self, "_update_player_money")
	player.connect("reloaded", self, "_update_player_ammo")

func _ready():
	for name in WeaponFactory.get_weapon_names():
		var item = WeaponStoreItem.instance()
		item.init(name)
		item_grid.add_child(item)
	
	for item_data in store_inventory:
		var item = AmmoStoreItem.instance()
		item.init(item_data)
		item_grid.add_child(item)
	
	_update_player_health(player.get_health())
	_update_player_money(player.get_money())
	_update_player_ammo(null, player.get_ammo())
	_update_items()
	
	is_transparent = false
	_toggle_open()

func _toggle_open():
	if is_transparent:
		set_modulate(Color(1, 1, 1, 1))
		item_grid.get_children()[0].select()
		current_item = 0
		emit_signal("open")
	else:
		set_modulate(Color(1, 1, 1, 0))
		emit_signal("close")
	
	is_transparent = !is_transparent
	
func _update_player_ammo(weapon, ammo):
	rifle_ammo_label.set_text("Rifle Ammo: {0}".format([ammo[Weapon.Ammo.RIFLE]]))
	sniper_ammo_label.set_text("Sniper Ammo: {0}".format([ammo[Weapon.Ammo.SNIPER]]))
	shotgun_ammo_label.set_text("Shotgun Ammo: {0}".format([ammo[Weapon.Ammo.SHOTGUN]]))

func _update_player_health(health):
	player_health_label.set_text("Health: {0}".format([health]))

func _update_player_money(money):
	player_money_label.set_text("Money: {0}".format([money]))
	
func _on_open_store():
	_toggle_open()

func _on_menu_input(dir):
	if is_transparent:
		return 
		
	var next_item
	var num_children = len(item_grid.get_children())
	
	if dir == RIGHT:
		next_item = current_item + 1
	elif dir == LEFT:
		next_item = current_item - 1
	elif dir == UP:
		next_item = current_item - item_grid.get_columns()
	elif dir == DOWN: 
		next_item = current_item + item_grid.get_columns()
	
	if next_item >= 0 and next_item < num_children:
		item_grid.get_children()[current_item].deselect()
		item_grid.get_children()[next_item].select()
		current_item = next_item

func _purchase_weapon(weapon_item):
	var weapon_props = weapon_item.get_weapon_props()
	
	if (not player.has_weapon(weapon_props["weapon_name"]) 
		and player.get_money() >= weapon_props["price"]):
		
		player.add_weapon_to_inventory(weapon_props["weapon_name"])
		player.add_money(-weapon_props["price"])
		_update_items()

func _purchase_ammo(item_data):
	if player.get_money() >= item_data["price"]:
		player.add_ammo(item_data["ammo_type"], item_data["quantity"])
		player.add_money(-item_data["price"])

func _purchase():
	var item = item_grid.get_children()[current_item]
	
	if item.get_type() == StoreItemType.AMMO:
		_purchase_ammo(item.get_item_data())
	else:
		_purchase_weapon(item)
		
func _update_items():
	for item in item_grid.get_children():
		if item.get_type() == StoreItemType.WEAPON:
			var weapon_props = item.get_weapon_props()
			
			if player.has_weapon(weapon_props["weapon_name"]):
				item.set_purchased()
