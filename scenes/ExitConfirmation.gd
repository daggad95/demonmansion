extends ConfirmationDialog

var titleButton

func _ready():
	titleButton = add_button("Main Menu", false, "title")
	titleButton.connect("pressed", self, "_on_TitleButton_pressed")

func _on_Game_esc_pressed():
	popup()
	
func _on_TitleButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/menu/title/TitleScene.tscn")
