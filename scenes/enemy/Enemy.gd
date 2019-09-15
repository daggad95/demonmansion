extends RigidBody2D
class_name Enemy

var speed = 75
var steer_rate = 200
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent().get_node("Map")
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
			print(position - enemy.position)
			target_dir += (position - enemy.position)
			target_vel = target_dir.normalized() * speed / 4
	else:
		target_dir = map.get_vector_to_target(position)
		target_vel = target_dir.normalized() * speed
		
	rotation = 0
	applied_force = Vector2(0, 0)
	var f = (target_vel - linear_velocity).normalized() * steer_rate
	add_central_force(f)
