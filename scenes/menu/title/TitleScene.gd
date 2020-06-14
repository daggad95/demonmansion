extends Control
export var skip_menu = false
onready var PlayerData = get_node("/root/PlayerData")
onready var controllers = get_node("/root/Controllers").get_controllers()
const SelectionScreen = preload("res://scenes/menu/character_selection/SelectionScreen/SelectionScene.gd")

onready var options = find_node("OptionsContainer")

var selection_screen = preload("res://scenes/menu/character_selection/SelectionScreen/SelectionScene.tscn")
var active_idx = 0

func _ready():
	skip_menu = false
	if skip_menu:
		PlayerData.set_single_player_data({
			"controller": controllers[0],
			"name": "DAAG",
			"id": 0,
			"textures": SelectionScreen.get_sprite_dict()["spritesheets"][0]
		})
		get_tree().change_scene("res://scenes/Game.tscn")
	link_controllers()
	init()
	
func link_controllers():
	var controllers = get_node("/root/Controllers").get_controllers()
	for controller in controllers:
		controller.connect("menu_up", self, "_on_menu_up")
		controller.connect("menu_down", self, "_on_menu_down")
		controller.connect("menu_select", self, "_on_select")
		controller.connect("menu_back", self, "_on_back")
	
func init():
	options.get_child(active_idx).get_child(1).set_visible(true)

func _on_menu_up():
	switch_box("up")

func _on_menu_down():
	switch_box("down")
	
func _on_select():
	if(active_idx == 0):
		get_tree().change_scene_to(selection_screen)
	elif(active_idx == 1):
		get_tree().quit()
		
func _on_back():
	#print("back")
	pass
	
func switch_box(dir):
	var prev_idx = active_idx
	if(dir == "up"):
		if(active_idx > 0):
			active_idx -= 1
	elif(dir == "down"):
		if(active_idx < options.get_child_count() - 1):
			active_idx += 1
	options.get_child(prev_idx).get_child(1).set_visible(false)
	options.get_child(active_idx).get_child(1).set_visible(true)
		
		
