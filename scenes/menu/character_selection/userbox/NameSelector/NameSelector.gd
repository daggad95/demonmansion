extends HBoxContainer

var current_letter = 0
var input_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func confirm_letter():
	input_started = true
	var letterbox = get_child(current_letter)
	letterbox.hide_indicator()
	
	current_letter += 1
	if(current_letter < 4):
		letterbox = get_child(current_letter)
		letterbox.show_indicator()
	else:
		for child in get_children():
			child.hide_indicator()
	
	return (current_letter == 4)

func decrement():
	input_started = true
	var letterbox = get_child(current_letter)
	letterbox.decrement_letter()
		
func increment():
	input_started = true
	var letterbox = get_child(current_letter)
	letterbox.increment_letter()
	
func reset():
	input_started = false
	for child in get_children():
		child.set_letter('A')
		child.hide_indicator()

func get_current_letter():
	return current_letter

func set_current_letter(idx):
	current_letter = idx
	var letterbox = get_child(current_letter)
	letterbox.show_indicator()
	
func is_input_started():
	return input_started

	
