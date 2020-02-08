extends RigidBody2D
signal dead
class_name Enemy

var speed = 50.0
var steer_rate = 300.0
var health = 100.0
var knockback_speed = 50
var knockback_duration = 0.1
var base_hit = 10
var face_right = true
var map
var target
var players

func init(init_pos, init_map, init_players):
	position = init_pos
	map = init_map
	players = init_players
	target = _get_nearest_player()
	add_to_group('enemy')

func take_damage(damage):
	print("taking %d damage" % damage)
	health -= damage
	
	if health <= 0:
		die()

func die():
	emit_signal("dead", self)
	queue_free()

func _get_nearest_player():
	var min_dist = INF
	var nearest
	var dist
	
	for player in players:
		dist = position.distance_to(player.get_position())
		if dist < min_dist:
			min_dist = dist
			nearest = player
	return nearest

func _seek_force():
	var target_dir
	var target_vel

	target_dir = map.get_vector_to_target(target.get_name(), position)
	target_vel = target_dir.normalized() * speed
	return (target_vel - linear_velocity).normalized()

func _separate_force():
	var near_enemy = false
	var nearby_enemies = []
	var target_dir
	var target_vel 
	
	if len($Bubble.get_overlapping_bodies()) > 0:
		for body in $Bubble.get_overlapping_bodies():
			if body.is_in_group('enemy')and body != self:
				near_enemy = true
				nearby_enemies.append(body)
	
	if near_enemy:
		target_dir = Vector2(0, 0)
		for enemy in nearby_enemies:
			target_dir = enemy.global_position.direction_to(global_position)
		target_vel = target_dir.normalized() * speed
		return (target_vel - linear_velocity).normalized()
	else:
		return Vector2(0, 0)

func _avoid_obstacle_from(dir_name, dir):
	var rotation_dir
	
	if dir_name == 'top' or dir_name == 'bot':
		if linear_velocity.x >= 0:
			rotation_dir = 1
		else:
			rotation_dir = -1
	if dir_name == 'bot':
		rotation_dir = -rotation_dir
	
	if dir_name == 'left' or dir_name == 'right':
		if linear_velocity.y <= 0:
			rotation_dir = -1
		else:
			rotation_dir = 1
	if dir_name == 'left':
		rotation_dir = -rotation_dir
		
	$RayCast.set_position(dir)
	$RayCast.set_cast_to(linear_velocity/8)
	$RayCast.force_raycast_update()
	var i = 0
	while $RayCast.is_colliding() and i < 12:
		i += 1
		$RayCast.set_cast_to(linear_velocity.rotated(rotation_dir * PI/12*i))
		$RayCast.force_raycast_update()
	return linear_velocity.rotated(PI/12*i)
	
func _avoid_obstacle_force():
	var target_dir = Vector2(0, 0)
	var target_vel
	var top = Vector2(0, -$CollisionShape2D.get_shape().get_extents().y)
	var bot = Vector2(0, $CollisionShape2D.get_shape().get_extents().y)
	var left = Vector2(-$CollisionShape2D.get_shape().get_extents().x, 0)
	var right = Vector2($CollisionShape2D.get_shape().get_extents().x, 0)
	
	if abs(linear_velocity.x) > abs(linear_velocity.y):
		target_dir += _avoid_obstacle_from('top', top)
		target_dir += _avoid_obstacle_from('bot', bot)
	else:
		target_dir += _avoid_obstacle_from('left', left)
		target_dir += _avoid_obstacle_from('right', right)

	target_vel = target_dir.normalized() * speed
	return (target_vel - linear_velocity).normalized() 
	
func _brake_force():
	var target_vel = Vector2(0, 0)
	return (target_vel - linear_velocity).normalized() * (linear_velocity.length() / speed)
	
func _chase_target():
	var steer_force = Vector2(0, 0)
	steer_force += _seek_force() 
	steer_force += _avoid_obstacle_force() * 2
	steer_force += _separate_force() * 2
	steer_force = steer_force.normalized()
	steer_force *= steer_rate
	
	add_central_force(steer_force)
	
func _close_in():
	add_central_force(_seek_force() * steer_rate)

func _brake():
	if linear_velocity.length() > 5:
		var steer_force = _brake_force() * steer_rate
		add_central_force(steer_force)
	else:
		linear_velocity = Vector2(0, 0)

func _charge(charge_target):
	var target_dir = position.direction_to(charge_target)
	var target_vel = target_dir.normalized() * speed
	var steer_force = (target_vel - linear_velocity).normalized() * steer_rate
	add_central_force(steer_force)

func _shared_update(delta):
	rotation = 0
	applied_force = Vector2(0, 0)
	
	for body in $Bubble.get_overlapping_bodies():
		if body.is_in_group('player'):
			body.apply_knockback(
				position.direction_to(body.get_position()),
				knockback_speed,
				knockback_duration)
			body.take_damage(base_hit)
		
	if linear_velocity.x > 0:
		$Sprite.set_flip_h(!face_right)
	elif linear_velocity.x <  0:
		$Sprite.set_flip_h(face_right)
