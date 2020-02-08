extends Control
const bullet_texture = preload("res://assets/projectiles/bullet.png")
onready var healthbar = get_node("HealthBar")
onready var ammo = get_node("Ammo")

func init(player):

##	self.set_size(Vector2(50, 100))
##	self.set_position(Vector2(300, 0))
	player.connect('damage_taken', self, '_on_player_damage_taken')
	player.connect('fired_weapon', self, '_on_player_fired_weapon')
#
	if player.get_id() == 1:
		anchor_right = 0.25
		anchor_bottom = 0.01
#
#	elif player.get_id() == 2:
#		anchor_right = 1
#		anchor_left = 0.75
#		anchor_bottom = 0.2
	pass


func _ready():
	pass
#	print(healthbar.get_node('HealthBarBG').get_size())
#	healthbar.get_node('HealthBarFG').set_custom_minimum_size(
#		Vector2(300, 0))
	_fill_ammo(40)

#	anchor_right = 0.25
#	anchor_bottom = 0.05
	
#	anchor_right = 1
#	anchor_left  = 0.75
#	anchor_bottom = 0.05

func _fill_ammo(clip_size):
	for i in range(clip_size):
		var bullet = TextureRect.new()
		bullet.set_texture(bullet_texture)
		bullet.set_v_size_flags(SIZE_EXPAND_FILL)
		bullet.set_h_size_flags(SIZE_EXPAND_FILL)
		bullet.set_expand(true)
		bullet.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
		ammo.add_child(bullet)

func _on_player_damage_taken(health, max_health, damage):
	var health_ratio = health / max_health
	healthbar.get_node('HealthBarFG').anchor_right = health_ratio
	healthbar.get_node('HealthBarFG').margin_right = health_ratio

func _on_player_fired_weapon(weapon):
	ammo.get_children().pop_back().queue_free()