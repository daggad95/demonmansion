extends Node

# handle actions on the model

var model
var state_name

func enter(model):
	self.model = model
	
func handle_input(input_name):
	pass

func process(delta):
	pass
	
func exit():
	pass
	
func get_name():
	return state_name
