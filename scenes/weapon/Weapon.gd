extends Sprite
class_name Weapon
const Projectile = preload("res://scenes/projectile/Projectile.tscn")

var clip_size   = 0
var clip        = 0
var weapon_name = '<UNDEFINED>'
var price       = 0
var reload_time = 0
var reloading = false
var aim_dir = Vector2(0,0)
var img_offset = Vector2(-56, 0)
var automatic = false
var fire_rate = 0 # per second
var can_fire = true

func _input(event):
	if event is InputEventMouseMotion:
		var pos_in_viewport = self.get_global_transform_with_canvas()[2] + img_offset
		aim_dir = pos_in_viewport.direction_to(event.position)

func shoot():
	if clip > 0 and can_fire:
		add_child(_gen_projectile())
		clip -= 1
		can_fire = false
		$FireTimer.start(1.0/fire_rate)
	elif not reloading and clip == 0:
		print('reloading')
		$ReloadTimer.start(reload_time)
		reloading = true

func get_name():
	return weapon_name

func get_price():
	return price

func is_automatic():
	return automatic

func _gen_projectile():
	return null

func _on_ReloadTimer_timeout():
	clip = clip_size
	reloading = false


func _on_FireTimer_timeout():
	can_fire = true