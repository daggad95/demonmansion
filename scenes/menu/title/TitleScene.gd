extends Control
export var skip_menu = false
onready var PlayerData = get_node("/root/PlayerData")
onready var controllers = get_node("/root/Controllers").get_controllers()
const SelectionScreen = preload("res://scenes/menu/character_selection/SelectionScreen/SelectionScene.gd")

# Buttons are instancess of base_MainMenuButton.tscn so that the properties of every main menu 
# button can be changed by changing the properies of base_MainMenuButton.tscn

func _ready():
	if skip_menu:
		PlayerData.set_single_player_data({
			"controller": controllers[0],
			"name": "DAAG",
			"id": 0,
			"textures": SelectionScreen.get_sprite_dict()["spritesheets"][0]
		})
		get_tree().change_scene("res://scenes/Game.tscn")

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
