extends Control
enum {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}
const WEAPON = preload("res://scenes/weapon/Weapon.gd")
const bullet_texture = preload("res://assets/projectiles/bullet.png")
onready var healthbar = get_node("VBoxContainer/HealthBar")
onready var ammo = get_node("VBoxContainer/HBoxContainer/Ammo")
onready var money = get_node("VBoxContainer/HBoxContainer/Money")
var ammo_text = ''
var money_text = ''
var flip_x = false
var location = TOP_LEFT
var default_viewport_size = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height"))

func init(player):
	player.connect('health_change', self, '_on_player_health_change')
	player.connect('fired_weapon', self, '_on_ammo_update')
	player.connect('switch_weapon', self, '_on_ammo_update')
	player.connect('reloaded', self, '_on_ammo_update')
	player.get_equipped_weapon().connect('reload_finish', self, '_on_ammo_update')
	player.connect('money_change', self, '_on_money_update')
	
	_set_ammo_text(player.get_equipped_weapon(), player.get_ammo())
	_set_money_text(player.get_money())
	
	if player.get_id() == 1:
		location = TOP_LEFT
	elif player.get_id() == 2:
		location = TOP_RIGHT
		flip_x = true
		get_node("VBoxContainer/HBoxContainer").set_alignment(BoxContainer.ALIGN_END)
	elif player.get_id() == 3:
		location = BOTTOM_LEFT
		_flip_y()
	elif player.get_id() == 4:
		location = BOTTOM_RIGHT
		flip_x = true
		get_node("VBoxContainer/HBoxContainer").set_alignment(BoxContainer.ALIGN_END)
		_flip_y()
		

func _ready():
	get_tree().get_root().connect("size_changed", self, "_update_position")
	_update_ammo_label()
	_update_money_label()
	set_scale(Vector2(2, 2))
	_update_position()

func _on_player_health_change(health, max_health):
	var health_ratio = health / max_health
	
	var min_size = healthbar.get_node('HealthBarFG').get_custom_minimum_size()
	var new_size = Vector2(rect_size.x * health_ratio, min_size.y)
	healthbar.get_node('HealthBarFG').set_custom_minimum_size(new_size)
	healthbar.get_node('HealthBarFG').rect_size = new_size
	
	if flip_x:
		var old_pos = healthbar.get_node('HealthBarFG').get_position()
		var new_position = Vector2(rect_size.x - new_size.x, old_pos.y)
		healthbar.get_node('HealthBarFG').set_position(new_position)


func _update_position():
	var viewport_size = get_viewport().get_visible_rect().size
	set_scale(Vector2(viewport_size / default_viewport_size))
	
	if location == TOP_LEFT:
		rect_position.x = 0
	elif location == TOP_RIGHT:
		rect_position.x = viewport_size.x - rect_size.x * rect_scale.x
	elif location == BOTTOM_LEFT:
		rect_position.x = 0
		rect_position.y = viewport_size.y - rect_size.y * rect_scale.y
	elif location == BOTTOM_RIGHT:
		rect_position.x = viewport_size.x - rect_size.x * rect_scale.x
		rect_position.y = viewport_size.y - rect_size.y * rect_scale.y
	
func _on_money_update(money):
	_set_money_text(str(money))
	_update_money_label()

func _update_money_label():
	money.set_text(money_text)

func _set_money_text(money):
	money_text = "${money}".format({"money": money})

func _update_ammo_label():
	ammo.set_text(ammo_text)

func _set_ammo_text(weapon, ammo):
	var ammo_amount
	var ammo_type = weapon.get_weapon_props()['ammo_type']
	
	if ammo_type == WEAPON.Ammo.NONE:
		ammo_amount = "∞"
	else:
		ammo_amount = ammo[ammo_type]
	ammo_text = ("{clip}/{ammo}".format(
		{"clip": weapon.get_clip(), "ammo": ammo_amount}))

func _on_ammo_update(weapon, ammo):
	_set_ammo_text(weapon, ammo)
	_update_ammo_label()

func _flip_y():
	var temp = get_node("VBoxContainer").get_child(0)
	get_node("VBoxContainer").remove_child(temp)
	get_node("VBoxContainer").add_child(temp)
