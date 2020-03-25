extends CanvasLayer
const WeaponFactory = preload("res://scenes/weapon/WeaponFactory.gd")
const WeaponStoreItem = preload("res://scenes/store/StoreItem/WeaponStoreItem/WeaponStoreItem.tscn")
const StoreItemType = preload("res://scenes/store/StoreItem/StoreItem.gd").StoreItemType

var player
onready var item_grid = $MainContainer/MarginContainer/VBoxContainer/CenterContainer/GridContainer
onready var player_health_label = $MainContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HealthLabel
onready var player_money_label = $MainContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/MoneyLabel

func link_controller(controller):
	controller.connect("player_interact", self, "_on_open_store")

func link_player(player):
	self.player = player
	player.connect("health_change", self, "_update_player_health")
	player.connect("money_change", self, "_update_player_money")

func _ready():
	for name in WeaponFactory.get_weapon_names():
		var item = WeaponStoreItem.instance()
		item.init(name)
		item.connect("purchase_weapon", self, "_on_purchase_weapon")
		item_grid.add_child(item)
	
	_update_player_health(player.get_health())
	_update_player_money(player.get_money())
	_update_items()
		
	$MainContainer.hide()

func _update_player_health(health):
	player_health_label.set_text("Health: {0}".format([health]))

func _update_player_money(money):
	player_money_label.set_text("Money: {0}".format([money]))
	
func _on_open_store():
	if not $MainContainer.is_visible():
		$MainContainer.show()
		item_grid.get_children()[0].get_button().grab_focus()
	else:
		$MainContainer.hide()

func _on_purchase_weapon(weapon_item):
	var weapon_props = weapon_item.get_weapon_props()
	
	if (not player.has_weapon(weapon_props["weapon_name"]) 
		and player.get_money() >= weapon_props["price"]):
		
		player.add_weapon_to_inventory(weapon_props["weapon_name"])
		player.add_money(-weapon_props["price"])
		_update_items()

func _update_items():
	for item in item_grid.get_children():
		if item.get_type() == StoreItemType.WEAPON:
			var weapon_props = item.get_weapon_props()
			
			if player.has_weapon(weapon_props["weapon_name"]):
				item.set_purchased()
	
	
