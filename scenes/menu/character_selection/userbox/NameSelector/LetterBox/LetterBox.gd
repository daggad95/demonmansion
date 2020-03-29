extends MarginContainer

onready var letter = $Letter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func increment_letter():
	var current_letter = letter.get_text()[0]
	var new_letter = char(int(current_letter.to_ascii()[0]) + 1)
	print(current_letter.to_ascii())
	letter.set_text(new_letter)
	
func decrement_letter():
	pass
