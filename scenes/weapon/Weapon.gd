extends Sprite
class_name Weapon
const Z_INDEX_FRONT = 100
const Z_INDEX_BACK = 1
const Projectile = preload("res://scenes/projectile/Projectile.tscn")
enum Ammo {RIFLE, SNIPER, SHOTGUN, NONE}
enum {FORWARD, LEFT, RIGHT, BACKWARD}
signal reload_finish

export var clip_size   = 0
export var weapon_name = '<UNDEFINED>'
export var price       = 0
export var reload_time = 0
export var two_handed = false
export var spread = 0
export var num_projectiles = 1
export var ammo_type = Ammo.NONE
export var automatic = false
export var right_position : Vector2
export var forward_position : Vector2
export var fire_rate = 0 # per second
export var damage = 0
export var proj_range = 0
export var proj_speed = 0
export var penetration = 0
export var damage_dropoff = 0
var clip = 0
var reloading = false
var aim_dir = Vector2(1,0)
var img_offset = Vector2(-56, 0)
var can_fire = true
var reload_amount = 0
var current_dir = RIGHT

func get_weapon_props():
	return {
		'clip_size': clip_size,
		'weapon_name': weapon_name,
		'price': price,
		'reload_time': reload_time,
		'fire_rate': fire_rate,
		'spread': spread,
		'num_projectiles': num_projectiles,
		'automatic': automatic,
		'ammo_type': ammo_type,
		'texture': $Sprite.texture
	}

func _ready():
	clip = clip_size

func shoot(aim_dir, ammo):
	self.aim_dir = aim_dir
	if clip > 0 and can_fire:
		for i in range(0, num_projectiles):
			var projectile = _gen_projectile()
			get_tree().get_root().add_child(_process_projectile(projectile))
		clip -= 1
		can_fire = false
		$FireTimer.start(1.0/fire_rate)
		return true
	else:
		if not reloading and clip == 0:
			if ammo_type == Ammo.NONE:
				reload_amount = clip_size
			else:
				reload_amount = min(clip_size, ammo[ammo_type])
				ammo[ammo_type] -= reload_amount

			if reload_amount > 0:
				reloading = true
				$ReloadTimer.start(reload_time)
		return false
		
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

func set_dir(dir):
	if dir == LEFT:
		$Sprite.set_position(Vector2(-right_position.x, right_position.y))
		$Sprite.set_flip_h(false)
		$Sprite.set_z_index(-1)
		
	elif dir == RIGHT:
		$Sprite.set_position(right_position)
		$Sprite.set_flip_h(true)
		$Sprite.set_z_index(1)
		
	elif dir == FORWARD:
		if two_handed:
			$Sprite.set_position(forward_position)
		else:
			$Sprite.set_position(Vector2(-right_position.x, right_position.y))
			
		$Sprite.set_flip_h(false)
		$Sprite.set_z_index(1)
		
	elif dir == BACKWARD:
		if two_handed:
			$Sprite.set_position(forward_position)
			
		else:
			$Sprite.set_position(right_position)
		$Sprite.set_flip_h(true)
		$Sprite.set_z_index(-1)
		
	current_dir = dir

func _process_projectile(projectile):
	projectile.rotate_dir(rand_range(-spread/2, spread/2))
	projectile.scale_speed(rand_range(0.9, 1.1))
	return projectile

func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		proj_speed,  
		proj_range, 
		penetration,   
		damage,  
		damage_dropoff, 
		global_position - position)
	return projectile

func _on_ReloadTimer_timeout():
	clip = reload_amount
	print("reload finish!")
	emit_signal('reload_finish')
	reloading = false

func _on_FireTimer_timeout():
	can_fire = true
