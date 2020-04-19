extends Control

# Buttons are instancess of base_MainMenuButton.tscn so that the properties of every main menu 
# button can be changed by changing the properies of base_MainMenuButton.tscn

func _on_NewGame_pressed():
	get_tree().change_scene("res://scenes/menu/character_selection/SelectionScreen/SelectionScene.tscn")

# Currently starts a new game immediately
func _on_Continue_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://scenes/menu/options/OptionsScene.tscn")
	
func _on_ConfirmationDialog_confirmed():
	get_tree().quit()

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		$ExitConfirmation.popup()
