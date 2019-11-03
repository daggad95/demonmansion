extends Enemy
var charging
var charge_range = 100
var charge_target

func _on_ready():
	face_right = false
	charging = false
	
func _physics_process(delta):
	_shared_update(delta)
	target = _get_nearest_player()
	
	if position.distance_to(target.get_position()) < charge_range:
		if charging == false:
			charging = true
			speed *= 2
			charge_target = target.get_position()
	else:
		_chase_target()