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
var current_idx = 0
onready var store_items = find_node("StoreItems")
onready var player_items = find_node("PlayerItems")
onready var player_health_label = find_node("HealthLabel")
onready var player_money_label = find_node("MoneyLabel")
onready var rifle_ammo_label = find_node("RifleAmmoLabel")
onready var sniper_ammo_label = find_node("SniperAmmoLabel")
onready var shotgun_ammo_label = find_node("ShotgunAmmoLabel")

func link_controller(controller):
	controller.connect("player_interact", self, "_on_open_store")
	controller.connect("menu_right", self, "_on_menu_input", [RIGHT])
	controller.connect("menu_left", self, "_on_menu_input", [LEFT])
	controller.connect("menu_up", self, "_on_menu_input", [UP])
	controller.connect("menu_down", self, "_on_menu_input", [DOWN])
	controller.connect("menu_select", self, "_select")

func link_player(player):
	self.player = player
	player.connect("health_change", self, "_update_player_health")
	player.connect("money_change", self, "_update_player_money")
	player.connect("ammo_stock_change", self, "_update_player_ammo")

func _ready():
	for name in WeaponFactory.get_weapon_names():
		var item = WeaponStoreItem.instance()
		item.init(name)
		store_items.add_child(item)
	
	for item_data in store_inventory:
		var item = AmmoStoreItem.instance()
		item.init(item_data)
		store_items.add_child(item)
	
	_update_player_health(player.get_health())
	_update_player_money(player.get_money())
	_update_player_ammo(player.get_ammo())
	_update_items()
	
	is_transparent = false
	_toggle_open()

func _toggle_open():
	if is_transparent:
		set_modulate(Color(1, 1, 1, 1))
		store_items.get_children()[0].select()
		current_idx = 0
		emit_signal("open")
	else:
		set_modulate(Color(1, 1, 1, 0))
		emit_signal("close")
	
	is_transparent = !is_transparent
	
func _update_player_ammo(ammo):
	rifle_ammo_label.set_text("Rifle Ammo: {0}".format([ammo[Weapon.Ammo.RIFLE]]))
	sniper_ammo_label.set_text("Sniper Ammo: {0}".format([ammo[Weapon.Ammo.SNIPER]]))
	shotgun_ammo_label.set_text("Shotgun Ammo: {0}".format([ammo[Weapon.Ammo.SHOTGUN]]))

func _update_player_health(health):
	player_health_label.set_text("Health: {0}".format([health]))

func _update_player_money(money):
	player_money_label.set_text("Money: {0}".format([money]))
	
func _on_open_store():
	_update_player_items()
	_toggle_open()

func _update_player_items():
	for child in player_items.get_children():
		child.queue_free()
		
	for weapon in player.inventory:
		if weapon != null:
			var name = weapon.get_weapon_props()["weapon_name"]
			if name != "Pistol":
				var item = WeaponStoreItem.instance()
				item.init(name)
				item.set_price(item.get_weapon_props()["price"] * 0.5)
				player_items.add_child(item)

func _process(delta):
	if _get_item_from_idx(current_idx) != null:
		_get_item_from_idx(current_idx).select()

func _on_menu_input(dir):
	var next_idx
	var next_item
	
	if is_transparent:
		return 
	
	if dir == RIGHT:
		next_idx = current_idx + 1
	elif dir == LEFT:
		next_idx = current_idx - 1
	elif dir == UP:
		next_idx = current_idx - store_items.get_columns()
	elif dir == DOWN: 
		next_idx = current_idx + store_items.get_columns()
	
	if next_idx < 0:
		next_idx = 0
	
	next_item = _get_item_from_idx(next_idx)
	while next_item == null:
		next_idx -= 1
		next_item = _get_item_from_idx(next_idx)

	_get_item_from_idx(current_idx).deselect()
	_get_item_from_idx(next_idx).select()
	current_idx = next_idx
	

func _get_item_from_idx(idx):
	var num_store_items = len(store_items.get_children())
	var num_player_items = len(player_items.get_children())
	var found = false
	
	if idx >= 0 and idx < num_store_items:
		return store_items.get_children()[idx]
	elif idx >= num_store_items:
		idx -= (num_store_items) + (num_store_items / store_items.get_columns())
		
		if idx >= 0 and idx < num_player_items:
			return player_items.get_children()[idx]

func _purchase_weapon(weapon_item):
	var weapon_props = weapon_item.get_weapon_props()
	
	if (not player.has_weapon(weapon_props["weapon_name"]) 
		and player.get_money() >= weapon_props["price"]):
		
		player.add_weapon_to_inventory(weapon_props["weapon_name"])
		player.add_money(-weapon_props["price"])
		_update_items()
		
func _sell_weapon(weapon_item):
	var weapon_props = weapon_item.get_weapon_props()
	player.add_money(weapon_props["price"])
	player.remove_weapon_from_inventory(weapon_props["weapon_name"])
	_on_menu_input(LEFT)
	_update_player_items()
	_update_items()
	
func _purchase_ammo(item_data):
	if player.get_money() >= item_data["price"]:
		player.add_ammo(item_data["ammo_type"], item_data["quantity"])
		player.add_money(-item_data["price"])

func _select():
	var item = _get_item_from_idx(current_idx)
	
	if current_idx < len(store_items.get_children()):
		if item.get_type() == StoreItemType.AMMO:
			_purchase_ammo(item.get_item_data())
		else:
			_purchase_weapon(item)
	else:
		_sell_weapon(item)
		
func _update_items():
	for item in store_items.get_children():
		if item.get_type() == StoreItemType.WEAPON:
			var weapon_props = item.get_weapon_props()
			
			if player.has_weapon(weapon_props["weapon_name"]):
				item.set_purchased(true)
			else:
				item.set_purchased(false)
	_update_player_items()
