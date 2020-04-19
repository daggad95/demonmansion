extends MarginContainer

onready var indicator = $VBoxContainer/Indicator
onready var letter = $VBoxContainer/Letter

# Called when the node enters the scene tree for the first time.
func _ready():
	letter.set_text('A')

func increment_letter():
	var current_letter = letter.get_text()[0]
	var new_letter = ''
	if(current_letter == 'Z'):
		new_letter = 'A' 	
	else:
		new_letter = char(int(current_letter.to_ascii()[0]) + 1)
	letter.set_text(new_letter)
	
func decrement_letter():
	var current_letter = letter.get_text()[0]
	var new_letter = ''
	if(current_letter == 'A'):
		new_letter = 'Z' 	
	else:
		new_letter = char(int(current_letter.to_ascii()[0]) - 1)
	letter.set_text(new_letter)
	
func get_letter():
	return letter.text
	
func set_letter(new_letter):
	letter.set_text(new_letter)
	
func show_indicator():
	indicator.set_modulate(Color(1,1,1,1))
	
func hide_indicator():
	indicator.set_modulate(Color(1,1,1,0))
