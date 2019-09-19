extends Sprite
class_name Weapon
const Projectile = preload("res://scenes/projectile/Projectile.tscn")

var clip_size   = 0
var clip        = 0
var weapon_name = '<UNDEFINED>'
var price       = 0
var projectile  = null
var aim_dir = Vector2(1,1)

func _input(event):
	if event is InputEventMouseButton:
		var viewport_pos = get_viewport().get_canvas_transform()[2]
		print(viewport_pos, viewport_pos+event.position, global_position)

func shoot():
	var projectile = Projectile.instance()
	var mouse_position = get_viewport().get_mouse_position()
	projectile.init(aim_dir, 200, position)
	add_child(projectile)

func get_name():
	return weapon_name

func get_price():
	return price