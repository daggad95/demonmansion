extends KinematicBody2D

var speed
var map

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 75
	map = get_parent().get_node("Map")
	
func _physics_process(delta):
	var target_dir = map.get_vector_to_target(position)
	var target_vel = target_dir.normalized() * speed
	move_and_slide(target_vel)
