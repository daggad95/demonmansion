extends Enemy
onready var attack_range = 75
onready var near_target  = false
onready var hit_damage = 10
onready var can_hit = true
onready var pause_after_hit = 1

func _ready():
	speed = 20
	
func _process(delta):
	var move_distance = speed * delta
	
	target = _get_nearest_player()
	_chase_target()
	_shared_update(delta)
