extends Control

const Userbox = preload("res://scenes/menu/character_selection/userbox/Userbox.tscn")
onready var hbox_userboxes = $vbox_main/margin_userboxes/hbox_userboxes

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/menu/title/TitleScene.tscn")

func _ready():
	var controllers = get_node("/root/Controllers").get_controllers()
	var sprite_icons = get_icons()
	
	for idx in range(4):
		var new_userbox = Userbox.instance()
		new_userbox.init(sprite_icons)

		if(idx < len(controllers)):
			new_userbox.link_controller(controllers[idx])
		
		hbox_userboxes.add_child(new_userbox)

func get_icons():
	var icons = []
	var path = "res://assets/sprites/player/"
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file_name = dir.get_next()
		if file_name == "":
			# break the while loop when get_next() returns ""
			break
		elif !file_name.begins_with(".") && !file_name.ends_with(".import"):
			var tex_subregion = AtlasTexture.new()
			tex_subregion.set_atlas(load(path + file_name))
			tex_subregion.set_region(Rect2(0,0,64,128))
			icons.append(tex_subregion)
			
	return icons
