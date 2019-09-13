extends RigidBody2D

var speed = 25
var steer_rate = 50
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_parent().get_node("Map")
	
func _physics_process(delta):
	var target_dir = map.get_vector_to_target(position)
	var target_vel = target_dir.normalized() * speed
	linear_velocity = Vector2(0, 0)
	rotation = 0
	var f = (target_vel - linear_velocity).normalized() * steer_rate
	add_central_force(f)