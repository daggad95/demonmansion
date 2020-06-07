extends Area2D
const PLAYER_COLLISION = 5
const ENEMY_COLLISION = 6

onready var SEFactory = get_node("/root/StatusEffectFactory")
onready var EffectType = SEFactory.EffectType

var direction
var speed
var prange
var damage
var dist_travelled
var burn_damage
var burn_duration
var inflict_burn = false

# calculated as percentage of max damage
# at max range. e.g. damage dropoff of 0.75 means
# at max projectile range 75% of damage will be lost.
var damage_dropoff 

# number of bodies the projectile can penetrate
# this is decremented every time a body is hit
# and the projectile is removed when this hits 0
var max_pen

# list of bodies the projectile has collided with
var collided 
var sprite = null
var init_velocity

func init(
	init_direction, 
	init_speed, 
	init_range, 
	init_pen, 
	init_damage,
	init_damage_dropoff,
	init_pos,
	init_velocity,
	player_projectile=true):
		
	position = init_pos
	direction = init_direction
	speed = init_speed
	prange = init_range
	max_pen = init_pen
	damage = init_damage
	damage_dropoff = init_damage_dropoff
	dist_travelled = 0
	self.init_velocity = init_velocity
	collided = []
	
	set_collision_layer(0)
	if player_projectile:
		set_collision_mask(ENEMY_COLLISION)
	else:
		set_collision_mask(PLAYER_COLLISION)
	
	$CollisionShape.shape.set_extents(Vector2(10, max(10, speed/10)))
	rotation_degrees = rad2deg(Vector2(0,0).direction_to(direction).angle()) - 90
	
func _handle_collisions():
	for body in get_overlapping_bodies():
		if not body in collided:
			if body.is_in_group('player') or body.is_in_group('enemy'):
				body.take_damage(damage - damage * damage_dropoff * float(dist_travelled)/prange)
				body.apply_status_effect(EffectType.KNOCKBACK, {"dir": direction.normalized()})
					
				collided.append(body)
				max_pen -= 1
			else:
				queue_free()

func _physics_process(delta):
	_handle_collisions()
	
	if dist_travelled < prange and max_pen > 0:
		var velocity = (init_velocity + direction.normalized() * speed) * delta
		position += velocity
		dist_travelled += velocity.length()
	else:
		queue_free()
