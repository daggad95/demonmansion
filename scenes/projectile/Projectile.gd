extends Area2D

var direction
var speed

func init(init_direction, init_speed, offset):
	position -= offset
	direction = init_direction
	speed = init_speed
	
func _physics_process(delta):
	var velocity = direction.normalized() * speed
	position += velocity * delta