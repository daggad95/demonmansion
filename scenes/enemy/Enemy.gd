extends RigidBody2D
class_name Enemy

var speed = 25
var steer_rate = 300
var map
var target
var players
	
func init(init_pos, init_map, init_players):
	position = init_pos
	map = init_map
	players = init_players
	target = players[1]
	add_to_group('enemy')
	
func _physics_process(delta):
	var target_dir
	var target_vel
	var near_enemy = false
	var nearby_enemies = []
	
	if len($Bubble.get_overlapping_bodies()) > 0:
		for body in $Bubble.get_overlapping_bodies():
			if body.is_in_group('enemy') and body != self:
				near_enemy = true
				nearby_enemies.append(body)
				
	if near_enemy:
		target_dir = Vector2(0, 0)
		for enemy in nearby_enemies:
			target_dir += (position - enemy.position)
			target_vel = target_dir.normalized() * speed / 4
	else:
		target_dir = map.get_vector_to_target(target.get_name(), position)
		target_vel = target_dir.normalized() * speed
		
	rotation = 0
	applied_force = Vector2(0, 0)
	var f = (target_vel - linear_velocity).normalized() * steer_rate
	add_central_force(f)
