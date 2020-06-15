extends "res://scripts/StateMachine.gd"
const State = preload("res://scripts/State.gd")
enum {CHASE_PLAYER, ATTACK_PLAYER, DEAD}

func _init(model, init_state):
	var shared_state = {"can_attack": true}
	
	states = {
		CHASE_PLAYER: ChasePlayer.new().init(model, shared_state),
		ATTACK_PLAYER: AttackPlayer.new().init(model, shared_state),
		DEAD: Dead.new().init(model, shared_state)
	}
	init(model, init_state)
	
	model.connect("damaged", self, "_on_damaged")

func _on_damaged():
	if not model.get_node("DamageAnimation").is_playing():
		model.get_node("DamageAnimation").play("Damage")

class ChasePlayer extends State:
	var sliding 
		
	func enter():
		.enter()
		model.get_node("SpriteAnimations").play("Walk")
		sliding = false
		
	func process(delta):
		model.target = model._get_nearest_player()
		
		if model.dead:
			return DEAD
			
		if (
			model.position.distance_to(model.target.position) < model.attack_range
			and get_shared_state("can_attack") == true
		):
			return ATTACK_PLAYER
			
		if sliding:
			model.chase_target()
		else:
			model.brake()
			
	func _init():
		signal_to_callback_mapping["begin_sliding"] = "_on_begin_sliding"
		signal_to_callback_mapping["end_sliding"] = "_on_end_sliding"
	
	func _on_begin_sliding():
		sliding = true
	
	func _on_end_sliding():
		sliding = false

class AttackPlayer extends State:
	var done_attacking
	var attack_timer
	
	func init(model, shared_state={}):
		attack_timer = Timer.new()
		attack_timer.one_shot = true
		attack_timer.connect("timeout", self, "_on_attack_timer_timeout")
		add_child(attack_timer)
		return .init(model, shared_state)
	
	func enter():
		.enter()
		model.get_node("SpriteAnimations").play("Attack")
		model.get_node("SpriteAnimations").connect(
			"animation_finished", self, "_on_animation_finished"
		)
		done_attacking = false
		set_shared_state("can_attack", false)
	
	func exit():
		.exit()
		model.get_node("SpriteAnimations").disconnect(
			"animation_finished", self, "_on_animation_finished"
		)
		
	func process(delta):
		model.brake()
		
		if model.dead:
			return DEAD
		
		if done_attacking:
			return CHASE_PLAYER
	
	func _init():
		signal_to_callback_mapping["hit_target"] = "_on_hit_target"
	
	func _on_animation_finished(anim_name : String):
		if anim_name == "Attack":
			done_attacking = true
			attack_timer.start(model.attack_delay)
	
	func _on_hit_target():
		pass
	
	func _on_attack_timer_timeout():
		set_shared_state("can_attack", true)

class Dead extends State:
	func enter():
		state_name = "Dead"
		model.die()
		model.get_node("SpriteAnimations").play("Die")

	func process(delta):
		model.brake()
