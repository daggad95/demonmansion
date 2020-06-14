extends "res://scripts/StateMachine.gd"
const State = preload("res://scripts/State.gd")

func init(model, init_state):
	.init(model, init_state)
	model.connect("damaged", self, "_on_damage_taken")

func _on_damage_taken():
	if model.health > 0:
		change_state(TakeDamage.new())
	else:
		change_state(Dead.new())

class Idle extends State:
	var atree
	var asm
	
	func enter(model):
		.enter(model)
		state_name = "Idle"
		
		atree = model.get_node("AnimationTree") 
		asm = atree["parameters/playback"] #animation state machine
		asm.travel("Idle")
	
	func process(delta):
		print("asm: ", asm.get_current_node())

class ChasePlayer extends State:
	func enter(model):
		.enter(model)
		state_name = "ChasePlayer"
		
		var atree : AnimationTree = model.get_node("AnimationTree") 
		var asm = atree["parameters/playback"] #animation state machine
		asm.start("Walk")
		
	func process(delta):
		model.target = model._get_nearest_player()
		if (
			model.position.distance_to(model.target.position) < model.attack_range
			and model.can_hit
		):
			return AttackPlayer.new()
		else:
			if model.animation_moving:
				model.chase_target()
			else:
				model.brake()
		return null

class AttackPlayer extends State:
	var atree 
	var asm 
	
	func enter(model):
		.enter(model)
		state_name = "AttackPlayer"
		
		atree = model.get_node("AnimationTree") 
		asm = atree["parameters/playback"] #animation state machine
		asm.travel("Attack")
	
	func process(delta):
		model.brake()
		
		if asm.get_current_node() == "Walk":
			model.can_hit = false
			return ChasePlayer.new()
			
		return null

class TakeDamage extends State:
	var atree 
	var asm 
	
	func enter(model):
		.enter(model)
		state_name = "TakeDamage"
		
		atree = model.get_node("AnimationTree") 
		asm = atree["parameters/playback"] #animation state machine
		asm.travel("Damage")
	
	func process(delta):
		if model.can_control_movement:
			return ChasePlayer.new()

class Dead extends State:
	var atree 
	var asm 
	
	func enter(model):
		.enter(model)
		state_name = "Dead"
		
		atree = model.get_node("AnimationTree") 
		asm = atree["parameters/playback"] #animation state machine
		asm.travel("Die")
		model.die()
	
	func process(delta):
		model.brake()
