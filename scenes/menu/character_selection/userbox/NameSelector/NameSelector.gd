extends HBoxContainer

var current_letter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func link_controller(controller):
	controller.connect("menu_up", self, "_on_menu_up")
	
func _on_menu_up():
	var letterbox = get_child(current_letter)
	letterbox.increment_letter()
