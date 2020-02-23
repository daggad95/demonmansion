extends Sprite
class_name Weapon
const Projectile = preload("res://scenes/projectile/Projectile.tscn")
signal reload_finish

var clip_size   = 0
var clip        = 0
var weapon_name = '<UNDEFINED>'
var price       = 0
var reload_time = 0
var reloading = false
var spread = 0
var num_projectiles = 1
var aim_dir = Vector2(1,0)
var img_offset = Vector2(-56, 0)
var automatic = false
var fire_rate = 0 # per second
var can_fire = true

static func get_weapon_props():
	return {
		'clip_size': 0,
		'weapon_name': '<UNDEFINED>',
		'price': 0,
		'reload_time': 0,
		'fire_rate': 0,
		'spread': 0,
		'num_projectiles': 0,
		'automatic': false,
		'texture': ""
	}

func init():
	var weapon_props = get_weapon_props()
	clip_size   	= weapon_props['clip_size']
	clip        	= weapon_props['clip_size']
	weapon_name 	= weapon_props['weapon_name']
	price       	= weapon_props['price']
	reload_time 	= weapon_props['reload_time']
	fire_rate   	= weapon_props['fire_rate']
	spread      	= weapon_props['spread']
	num_projectiles = weapon_props['num_projectiles']
	automatic 		= weapon_props['automatic']

func shoot(aim_dir):
	self.aim_dir = aim_dir
	if clip > 0 and can_fire:
		for i in range(0, num_projectiles):
			var projectile = _gen_projectile()
			get_tree().get_root().add_child(_process_projectile(projectile))
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

func get_clip():
	return clip

func get_clip_size():
	return clip_size

func _process_projectile(projectile):
	projectile.rotate(rand_range(-spread/2, spread/2))
	projectile.scale_speed(rand_range(0.9, 1.1))
	return projectile

func _gen_projectile():
	return null

func _on_ReloadTimer_timeout():
	clip = clip_size
	emit_signal('reload_finish', self)
	reloading = false

func _on_FireTimer_timeout():
	can_fire = true
