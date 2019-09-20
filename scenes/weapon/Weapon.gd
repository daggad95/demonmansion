extends Sprite
class_name Weapon
const Projectile = preload("res://scenes/projectile/Projectile.tscn")

var clip_size   = 0
var clip        = 0
var weapon_name = '<UNDEFINED>'
var price       = 0
var projectile  = null
var aim_dir = Vector2(1,1)
var img_offset = Vector2(-56, 0)

func _input(event):
	if event is InputEventMouseButton:
		var pos_in_viewport = self.get_global_transform_with_canvas()[2] + img_offset
		aim_dir = pos_in_viewport.direction_to(event.position)

func shoot():
	var projectile = Projectile.instance()
	var mouse_position = get_viewport().get_mouse_position()
	projectile.init(aim_dir, 200, position)
	add_child(projectile)

func get_name():
	return weapon_name

func get_price():
	return price