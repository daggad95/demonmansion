extends Node

# handle actions on the model

var model
var shared_state
var state_name
var signal_to_callback_mapping = {}

func init(model, shared_state={}):
	self.model = model
	self.shared_state = shared_state
	return self

func enter():
	for s in signal_to_callback_mapping.keys():
		model.connect(s, self, signal_to_callback_mapping[s])
	
func handle_input(input_name):
	pass

func process(delta):
	pass
	
func exit():
	for s in signal_to_callback_mapping.keys():
		model.disconnect(s, self, signal_to_callback_mapping[s])

func get_shared_state(var_name):
	if var_name in shared_state:
		return shared_state[var_name]
	else:
		return null

func set_shared_state(var_name, value):
	shared_state[var_name] = value
	
func get_name():
	return state_name
