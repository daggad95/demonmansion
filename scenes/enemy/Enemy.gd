extends RigidBody2D
class_name Enemy
const VectorArrow = preload("res://scenes/map/VectorArrow.tscn")

var speed = 25
var steer_rate = 300
var health = 100
var seek_weight = 0.5
var separate_weight = 0.5
var map
var target
var players
var arrow

func init(init_pos, init_map, init_players):
	position = init_pos
	map = init_map
	players = init_players
	target = players[0]
	add_to_group('enemy')

func take_damage(damage):
	print("taking %d damage" % damage)
	health -= damage
	
	if health <= 0:
		queue_free()

func _seek_force():
	var target_dir
	var target_vel

	target_dir = map.get_vector_to_target(target.get_name(), position)
	target_vel = target_dir.normalized() * speed
	return (target_vel - linear_velocity).normalized() * steer_rate

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
		return (target_vel - linear_velocity).normalized() * steer_rate
	else:
		return Vector2(0, 0)

func _chase_target():
	add_central_force(_seek_force() * seek_weight)
	add_central_force(_separate_force() * separate_weight)

func _physics_process(delta):
	rotation = 0
	applied_force = Vector2(0, 0)
	
	_chase_target()