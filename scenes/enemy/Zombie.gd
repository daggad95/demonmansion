extends Enemy
onready var attack_range = 75
onready var near_target  = false
onready var hit_damage = 10
onready var can_hit = true
onready var pause_after_hit = 1

func _physics_process(delta):
	rotation = 0
	applied_force = Vector2(0, 0)
	target = _get_nearest_player()
	
	if position.distance_to(target.get_position()) > attack_range:
		if near_target:
			near_target = false
			speed *= 0.5
		_chase_target()
	else:
		if not near_target:
			near_target = true
			speed *= 2
		_close_in()
	
	if can_hit:
		for body in $Bubble.get_overlapping_bodies():
			if body.is_in_group('player'):
				body.take_damage(hit_damage)
				can_hit = false
				$HitTimer.start(pause_after_hit)
		
func _on_HitTimer_timeout():
	can_hit = true
