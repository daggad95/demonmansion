extends Enemy
onready var attack_range = 20
onready var near_target  = false
onready var hit_damage = 10
onready var can_hit = true
onready var pause_after_hit = 1
export var moving = false

func _ready():
	speed = 20

func _attack():
	state_machine.travel("Attack")
	can_hit = false

func _finish_attack():
	state_machine.travel("Walk")
	$Timers/AttackTimer.start()
	
func _process(delta):
	var move_distance = speed * delta
	
	target = _get_nearest_player()
	if (
		position.distance_to(target.position) < attack_range 
		and can_hit
	):
		_attack()
	else:
		if moving:
			_chase_target()
		else:
			_brake()
		
	_shared_update(delta)


func _on_AttackTimer_timeout():
	can_hit = true
