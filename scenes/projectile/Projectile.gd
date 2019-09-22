extends Area2D
const PLAYER_COLLISION = 4
const ENEMY_COLLISION = 2

var direction
var speed
var prange
var damage
var dist_travelled

# number of bodies the projectile can penetrate
# this is decremented every time a body is hit
# and the projectile is removed when this hits 0
var max_pen

# list of bodies the projectile has collided with
var collided 

func init(
	init_direction, 
	init_speed, 
	init_range, 
	init_pen, 
	init_damage,
	offset, 
	player_projectile=true):
		
	position -= offset
	direction = init_direction
	speed = init_speed
	prange = init_range
	max_pen = init_pen
	damage = init_damage
	dist_travelled = 0
	collided = []
	
	if player_projectile:
		set_collision_mask(ENEMY_COLLISION)
		set_collision_layer(ENEMY_COLLISION)
	else:
		set_collision_mask(PLAYER_COLLISION)
		set_collision_layer(PLAYER_COLLISION)
	
func _handle_collisions():
	for body in get_overlapping_bodies():
		if not body in collided:
			body.take_damage(damage)
			collided.append(body)
	
func _physics_process(delta):
	_handle_collisions()
	
	if dist_travelled < prange and max_pen > 0:
		var velocity = direction.normalized() * speed * delta
		position += velocity
		dist_travelled += velocity.length()
	else:
		queue_free()