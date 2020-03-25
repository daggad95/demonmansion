extends Area2D
const PLAYER_COLLISION = 5
const ENEMY_COLLISION = 6

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

func init(
	init_direction, 
	init_speed, 
	init_range, 
	init_pen, 
	init_damage,
	init_damage_dropoff,
	init_pos, 
	player_projectile=true):
		
	position = init_pos
	direction = init_direction
	speed = init_speed
	prange = init_range
	max_pen = init_pen
	damage = init_damage
	damage_dropoff = init_damage_dropoff
	dist_travelled = 0
	collided = []
	
	set_collision_layer(0)
	if player_projectile:
		set_collision_mask(ENEMY_COLLISION)
	else:
		set_collision_mask(PLAYER_COLLISION)

	sprite = $DefaultSprite
	$DefaultSprite.show()

func init_burn(damage, duration):
	burn_damage = damage
	burn_duration = duration
	inflict_burn = true

func set_sprite(sprite_name):
	$DefaultSprite.hide()
	
	if sprite_name == 'fireball':
		sprite = $FireballSprite
		$FireballSprite.show()
		$AnimationPlayer.play('fireball')

func rotate_sprite(dir):
	sprite.rotate(dir - PI/2)

func rotate_dir(dir):
	direction = direction.rotated(dir)

func scale_speed(factor):
	speed = speed * factor
	
func _handle_collisions():
	for body in get_overlapping_bodies():
		if not body in collided:
			if body.is_in_group('player') or body.is_in_group('enemy'):
				body.take_damage(damage - damage * damage_dropoff * float(dist_travelled)/prange)
				
				if inflict_burn:
					body.inflict_burn(burn_damage, burn_duration)
					
				collided.append(body)
				max_pen -= 1
			else:
				queue_free()

func _physics_process(delta):
	_handle_collisions()
	
	if dist_travelled < prange and max_pen > 0:
		var velocity = direction.normalized() * speed * delta
		position += velocity
		dist_travelled += velocity.length()
	else:
		queue_free()
