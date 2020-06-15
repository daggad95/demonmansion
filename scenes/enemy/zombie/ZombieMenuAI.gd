extends "res://scripts/StateMachine.gd"
const State = preload("res://scripts/State.gd")
enum {WALK, IDLE}

func _init(model, init_state):
	states = {
		WALK: Walk.new().init(model),
		IDLE: Idle.new().init(model)
	}
	init(model, init_state)

class Walk extends State:
	var timer
	var destination
	var movement_speed = 10
	
	func init(model, shared_state={}):
		timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		return .init(model)
		
	func enter():
		timer.start(5 + randf() * 2)
		_set_dest()
		model.get_node("SpriteAnimations").play("Walk")
		
	func process(delta):
		if timer.is_stopped():
			return IDLE
		if model.position.distance_to(destination) < 5:
			_set_dest()
		
		model.move_and_slide(model.position.direction_to(destination) * movement_speed)
		
	func _set_dest():
		destination = model.bounding_box.position + Vector2(
			rand_range(0, model.bounding_box.size.x), 
			rand_range(0, model.bounding_box.size.y))

class Idle extends State:
	var timer
	
	func init(model, shared_state={}):
		timer = Timer.new()
		timer.one_shot = true
		add_child(timer)
		return .init(model)
		
	func enter():
		timer.start(1 + randf() * 3)
		model.get_node("SpriteAnimations").play("Idle")
		
	func process(delta):
		if timer.is_stopped():
			return WALK
