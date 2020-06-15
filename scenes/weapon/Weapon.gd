extends Sprite
class_name Weapon
const Z_INDEX_FRONT = 100
const Z_INDEX_BACK = 1
const PROJ_TYPE = preload("res://scenes/projectile/ProjectileFactory.gd").Type
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
export var crosshair_max_distance = 0
export(PROJ_TYPE) var projectile_type
var clip = 0
var reloading = false
var aim_dir = Vector2(1,0)
var img_offset = Vector2(-56, 0)
var can_fire = true
var reload_amount = 0
var current_dir = RIGHT
var base_position
var base_sprite_position
var base_emission_point
var target_pos = Vector2(0, 0)
var accel = 1000
var velocity = Vector2(0, 0)
var max_speed = 200
onready var proj_factory = get_node("/root/ProjectileFactory")

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
	base_position = position
	base_sprite_position = $Sprite.position
	base_emission_point = $EmissionPoint.position

func shoot(aim_dir, ammo):

	if clip > 0 and can_fire:
		for i in range(0, num_projectiles):
			var projectile = _gen_projectile()
			get_tree().get_root().add_child(_gen_projectile())
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
	
func get_crosshair_max_distance():
	return crosshair_max_distance

func point_towards(point : Vector2):
	var angle = global_position.angle_to_point(point)
	
	if current_dir == RIGHT:
		angle -= PI
	
	rotation_degrees = rad2deg(angle)
	aim_dir = $EmissionPoint.global_position.direction_to(point)

func set_dir(dir):
	if dir == LEFT:
		$Sprite.set_flip_h(false)
#		$Sprite.position = Vector2(
#			-base_sprite_position.x,
#			base_sprite_position.y
#		)
#		position = Vector2(-base_position.x, base_position.y)
		$EmissionPoint.position = Vector2(
			-base_emission_point.x,
			base_emission_point.y
		)

	elif dir == RIGHT:
		$Sprite.set_flip_h(true)
#		$Sprite.position = base_sprite_position
#		position = base_position
		$EmissionPoint.position = base_emission_point
		
	current_dir = dir

func _process(delta):
	var desired_velocity
	
	var distance = position.distance_to(target_pos) 

	desired_velocity = position.direction_to(target_pos) * min(max_speed * (distance / 25), max_speed)
	
	var steer_force = (
		velocity.direction_to(desired_velocity) 
		* min(accel * delta, velocity.distance_to(desired_velocity))
	)
	velocity += steer_force
	position += velocity * delta

func _on_player_moved(name, position):
	if current_dir == RIGHT:
		target_pos = position - Vector2(10, 10)
	else:
		target_pos = position + Vector2(10, -10)
		
func _gen_projectile():
	var projectile = proj_factory.create(projectile_type)
	projectile.init(
		aim_dir, 
		proj_speed,  
		proj_range, 
		penetration,   
		damage,  
		damage_dropoff, 
		$EmissionPoint.global_position,
		velocity)
	return projectile

func _on_ReloadTimer_timeout():
	clip = reload_amount
	print("reload finish!")
	emit_signal('reload_finish')
	reloading = false

func _on_FireTimer_timeout():
	can_fire = true
