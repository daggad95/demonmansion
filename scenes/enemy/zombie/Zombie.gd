extends Enemy

const ZombieGameAI = preload("res://scenes/enemy/zombie/ZombieGameAI.gd")
const ZombieMenuAI = preload("res://scenes/enemy/zombie/ZombieMenuAI.gd")

enum ZombieAiType { MAIN_MENU, GAME }

export var attack_range = 20
export var hit_damage = 10
export var attack_delay = 1

var bounding_box

signal begin_sliding
signal end_sliding
signal hit_target

func _ready():
	speed = 20

func set_ai(ai_kind):
	if ai_kind == ZombieAiType.GAME:
		add_child(ZombieGameAI.new(self, ZombieGameAI.CHASE_PLAYER))
	else:
		add_child(ZombieMenuAI.new(self, ZombieMenuAI.IDLE))
	
