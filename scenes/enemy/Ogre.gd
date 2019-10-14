extends Enemy

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	_shared_update(delta)
	
	target = _get_nearest_player()
	_chase_target()