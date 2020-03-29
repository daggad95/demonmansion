extends Control

const Userbox = preload("res://scenes/menu/character_selection/userbox/Userbox.tscn")
onready var hbox_userboxes = $vbox_main/margin_userboxes/hbox_userboxes

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/menu/title/TitleScene.tscn")

func _ready():
	var controllers = get_node("/root/Controllers").get_controllers()
	for idx in range(len(controllers)):
		var new_userbox = Userbox.instance()
		new_userbox.link_controller(controllers[idx])
		hbox_userboxes.add_child(new_userbox)
