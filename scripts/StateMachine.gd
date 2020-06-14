extends Node

var model
var current_state
var states : Dictionary

func handle_input(input_name):
	var new_state = current_state.handle_input(input_name)
	if(new_state != null):
		change_state(new_state)

func change_state(state_name):
	if(current_state != null):
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()

func init(model, init_state):
	self.model = model
	change_state(init_state)
	
func _process(delta):
	var new_state = current_state.process(delta)

	if(new_state != null):
		change_state(new_state)
