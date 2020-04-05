extends CanvasLayer

func add_panel(panel):
	var hbox = $MarginContainer/CenterContainer/HBoxContainer
	
	hbox.add_child(panel)
