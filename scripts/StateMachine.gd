extends Node

var model
var current_state

func init(model, init_state):
	self.model = model
	change_state(init_state)
	
func handle_input(input_name):
	var new_state = current_state.handle_input(input_name)
	if(new_state != null):
		change_state(new_state)

func change_state(state):
	if(current_state != null):
		current_state.exit()
	current_state = state
	current_state.enter(model)
	print(current_state.get_name())
