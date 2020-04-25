extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	one_shot = true
	$Timer.start(2)

func _on_Timer_timeout():
	queue_free()
