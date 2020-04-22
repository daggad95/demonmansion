extends Control
onready var health_bar   = find_node("HealthBar")
onready var money_label  = find_node("MoneyLabel")
onready var ammo_label   = find_node("AmmoLabel")
onready var name_label   = find_node("NameLabel")
onready var weapon_box_1 = find_node("WeaponBox1")
onready var weapon_box_2 = find_node("WeaponBox2")
onready var weapon_box_3 = find_node("WeaponBox3")
onready var weapon_box_4 = find_node("WeaponBox4")
onready var weapon_selector = find_node("WeaponSelector")
onready var weapon_boxes = [
	weapon_box_1,
	weapon_box_2,
	weapon_box_3,
	weapon_box_4
]
var player

func init(player):
	self.player = player
	player.connect("health_change", self, "_on_player_health_change")
	player.connect("money_change", self, "_on_player_money_change")
	player.connect("ammo_change", self, "_on_player_ammo_change")
	player.connect("inventory_change", self, "_on_player_inventory_change")
	player.connect("weapon_change", self, "_on_player_weapon_change")
		

func _ready():
	_on_player_health_change(player.health, player.max_health)
	_on_player_money_change(player.money)
	_on_player_ammo_change(player.equipped_weapon.clip, player.equipped_total_ammo_str())
	_on_player_inventory_change(player.inventory)
	_on_player_weapon_change(0)
	name_label.text = player.player_name
	
	if player.player_id == 1 or player.player_id == 3:
		_horizontal_flip()

func _horizontal_flip():
	weapon_selector.get_parent().move_child(weapon_selector, 0)
#	health_bar.fill_mode = health_bar.FILL_RIGHT_TO_LEFT

func _on_player_weapon_change(weapon_idx):
	for idx in range(len(weapon_boxes)):
		if idx != weapon_idx:
			weapon_boxes[idx].modulate = Color(1, 1, 1, 0.5)
		else:
			weapon_boxes[idx].modulate = Color(1, 1, 1, 1)
	
func _on_player_inventory_change(inventory):
	for idx in range(len(inventory)):
		_set_weapon_box_icon(weapon_boxes[idx], inventory[idx])

func _set_weapon_box_icon(weapon_box, weapon):
	var icon = weapon_box.find_node("WeaponIcon")
	
	if weapon != null:
		icon.texture = load(weapon.get_weapon_props()["texture"])
	else:
		icon.texture = null

func _on_player_ammo_change(clip, total):
	ammo_label.text = "Ammo: {0}/{1}".format([clip, total])

func _on_player_money_change(money):
	money_label.text = "Money: $%d" % money

func _on_player_health_change(health, max_health):
	health_bar.value = health
	health_bar.max_value = max_health
