extends "res://scripts/StateMachine.gd"
const State = preload("res://scripts/State.gd")
enum {CHASE_PLAYER, ATTACK_PLAYER, DEAD}

func _init(model, init_state):
	states = {
		CHASE_PLAYER: ChasePlayer.new().init(model),
		ATTACK_PLAYER: AttackPlayer.new().init(model),
		DEAD: Dead.new().init(model)
	}
	init(model, init_state)

class ChasePlayer extends State:	
	func enter():
		state_name = "ChasePlayer"
		model.get_node("AnimationPlayer").play("Walk")
		
	func process(delta):
		model.target = model._get_nearest_player()
		
		if model.dead:
			return DEAD
			
		if (
			model.position.distance_to(model.target.position) < model.attack_range
			and model.can_hit
		):
			return ATTACK_PLAYER
		else:
			if model.animation_moving:
				model.chase_target()
			else:
				model.brake()

class AttackPlayer extends State:
	func enter():
		state_name = "AttackPlayer"
		model.get_node("AnimationPlayer").play("Attack")
		model.attacking = true
		model.can_hit = false

	func process(delta):
		model.brake()
		
		if model.dead:
			return DEAD
		
		if not model.attacking:
			return CHASE_PLAYER

class Dead extends State:
	func enter():
		state_name = "Dead"
		model.die()
		model.get_node("AnimationPlayer").play("Die")
	
	func process(delta):
		model.brake()
