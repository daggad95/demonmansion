extends Control

const Userbox = preload("res://scenes/menu/character_selection/userbox/Userbox.tscn")
const countdown_start = 1

onready var PlayerData = get_node("/root/PlayerData")
onready var hbox_userboxes = $vbox_main/margin_userboxes/hbox_userboxes
onready var bottom_label = $vbox_main/hbox_bottombar/panel_waiting/label_waiting

var joined_count = 0
var ready_count = 0
var countdown = countdown_start
var timer

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/menu/title/TitleScene.tscn")

func _ready():
	var controllers = get_node("/root/Controllers").get_controllers()
	var sprite_dict = get_sprite_dict()
	var ready_icons = get_ready_icons()
	
	for idx in range(4):
		var new_userbox = Userbox.instance()
		new_userbox.init(sprite_dict, ready_icons)
		if(idx < len(controllers)):
			new_userbox.link_controller(controllers[idx])
			new_userbox.set_id(idx)
			new_userbox.connect("player_joined",self,"_on_player_joined")
			new_userbox.connect("player_ready",self,"_on_player_ready")
			new_userbox.connect("player_unready",self,"_on_player_unready")
			new_userbox.connect("countdown_cancelled",self,"_on_countdown_cancelled")
			new_userbox.connect("player_exited",self,"_on_player_exited")
		hbox_userboxes.add_child(new_userbox)
	
	timer = Timer.new()
	timer.connect("timeout",self,"_on_timer_timeout")
	timer.set_wait_time(1)
	self.add_child(timer)
	
# Get a dictionary of two lists
func get_sprite_dict():
	# "icons":list of subregions, "spritesheets": list of full sized textures
	var texture_dict = {}
	var icons = []
	var spritesheets = []
	
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
			
			var spritesheet = load(path + file_name)
			spritesheets.append(spritesheet)
	
	texture_dict["icons"] = icons
	texture_dict["spritesheets"] = spritesheets
	return texture_dict

func get_ready_icons():
	var ready_icons = []
	
	var ready_icon
	ready_icon = AtlasTexture.new()
	ready_icon.set_atlas(load("res://assets/UI/UI001.png"))
	ready_icon.set_region(Rect2(137,436,12,12))
	ready_icons.append(ready_icon)
	
	var not_ready_icon
	not_ready_icon = AtlasTexture.new()
	not_ready_icon.set_atlas(load("res://assets/UI/UI001.png"))
	not_ready_icon.set_region(Rect2(138,468,12,12))
	ready_icons.append(not_ready_icon)
	
	return ready_icons

func _on_timer_timeout():
	print("timeout")
	countdown -= 1
	bottom_label.set_text("Game starting in... " + str(countdown))
	if countdown == -1:
		get_tree().change_scene("res://scenes/Game.tscn")
		
func _on_countdown_cancelled():
	print("countdown cancelled")
	bottom_label.set_text("Waiting for players...")
	timer.stop()

func _on_player_joined(id):
	print("player joined: ", joined_count)
	joined_count += 1
	PlayerData.player_count += 1

func _on_player_ready(player_data):
	print("player ready: ", ready_count)
	PlayerData.set_single_player_data(player_data)
	ready_count += 1
	if ready_count == joined_count:
		PlayerData.print_player_data()
		bottom_label.set_text("Game starting in... " + str(countdown_start))
		countdown = countdown_start
		timer.start()
	
func _on_player_unready():
	ready_count -= 1
	
func _on_player_exited(id):
	print("player exited")
	joined_count -= 1
	PlayerData.delete_single_player_data(id)
