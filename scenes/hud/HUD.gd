extends Control
const bullet_texture = preload("res://assets/projectiles/bullet.png")
onready var healthbar = get_node("HealthBar")
onready var ammo = get_node("Ammo")
onready var money = get_node("Money")
var ammo_text = ''
var money_text = ''

func init(player):
	player.connect('damage_taken', self, '_on_player_damage_taken')
	player.connect('fired_weapon', self, '_on_ammo_update')
	player.connect('switch_weapon', self, '_on_ammo_update')
	player.get_equipped_weapon().connect('reload_finish', self, '_on_ammo_update')
	
	_set_ammo_text(player.get_equipped_weapon())
	_set_money_text(player.get_money())

	if player.get_id() == 1:
		anchor_right = 0.25
		anchor_bottom = 0.01

func _ready():
	print(healthbar.get_node('HealthBarBG').get_size())
	healthbar.get_node('HealthBarFG').set_custom_minimum_size(
		Vector2(300, 0))
	_update_ammo_label()
	_update_money_label()

func _on_player_damage_taken(health, max_health, damage):
	var health_ratio = health / max_health
	healthbar.get_node('HealthBarFG').anchor_right = health_ratio
	healthbar.get_node('HealthBarFG').margin_right = health_ratio

func _update_money_label():
	money.set_text(money_text)

func _set_money_text(money):
	money_text = "${money}".format({"money": money})

func _update_ammo_label():
	ammo.set_text(ammo_text)

func _set_ammo_text(weapon):
	ammo_text = ("{clip}/{clip_size}".format(
		{"clip": weapon.get_clip(), "clip_size": weapon.get_clip_size()}))

func _on_ammo_update(weapon):
	_set_ammo_text(weapon)
	_update_ammo_label()
