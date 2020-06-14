extends Enemy
export var animation_moving = false
export var moving = false
const ZombieAI = preload("res://scenes/enemy/zombie/ZombieAI.gd")
onready var attack_range = 20
onready var near_target  = false
onready var hit_damage = 10
onready var can_hit = true
onready var pause_after_hit = 1
var ai
var attacking = false

func _ready():
	speed = 20
	ai = ZombieAI.new(self, ZombieAI.CHASE_PLAYER)
	add_child(ai)
	

func _finish_attack():
	$Timers/AttackTimer.start()
	attacking = false
	
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
