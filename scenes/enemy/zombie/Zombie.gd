extends Enemy
const ZombieAI = preload("res://scenes/enemy/zombie/ZombieAI.gd")
onready var attack_range = 20
onready var near_target  = false
onready var hit_damage = 10
onready var can_hit = true
onready var pause_after_hit = 1
var ai
export var animation_moving = false

export var moving = false

func _ready():
	speed = 20
	ai = ZombieAI.new()
	ai.init(self, ZombieAI.ChasePlayer.new())
	add_child(ai)
	

func _finish_attack():
	state_machine.travel("Walk")
	$Timers/AttackTimer.start()
	
	if position.distance_to(target.position) <= attack_range:
		target.take_damage(hit_damage)
		target.apply_status_effect(
			EffectType.KNOCKBACK, 
			{
				"dir": position.direction_to(target.position),
				"speed": 100,
				"duration": 0.2
			}
		)

func _on_AttackTimer_timeout():
	can_hit = true
