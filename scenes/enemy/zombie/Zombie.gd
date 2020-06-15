extends Enemy
const ZombieAI = preload("res://scenes/enemy/zombie/ZombieAI.gd")
export var attack_range = 20
export var hit_damage = 10
export var attack_delay = 1
signal begin_sliding
signal end_sliding
signal hit_target

func _ready():
	speed = 20
	var ai = ZombieAI.new(self, ZombieAI.CHASE_PLAYER)
	add_child(ai)
