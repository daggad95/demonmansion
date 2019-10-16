extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var game_node = get_tree().get_root().get_node("Game")
onready var player_count = game_node.get_player_count()
onready var store_window = get_node("CanvasLayer/MarginContainer")

const player_panel = preload("res://scenes/menu/store/PlayerPanel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	create_store_window()
	
func _process(delta):
	var is_player_overlapping = false
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			is_player_overlapping = true
	if !is_player_overlapping:
		store_window.hide()
			

func create_store_window():
	store_window.hide()
	print("player count: ", player_count)
	$CanvasLayer/MarginContainer.margin_left = -125 * player_count
	$CanvasLayer/MarginContainer.margin_right = 125 * player_count
	
	# Add the instance as a child node BEFORE customizing properties of the instance.
	# Otherwise custom properties are applied equally to ALL instances of the child node.
	var players = game_node.get_players()
	print(players)
	for i in range(player_count):
		var player = players[i]
		var panel = player_panel.instance()
		self.get_node("CanvasLayer/MarginContainer/HBoxContainer").add_child(panel)
		panel.rect_position.x = 250 * i
		panel.get_node("VBoxContainer/PlayerName").text = player.get_name()
		
		# Uses duplicate() to avoid passing by reference
		var player_texture = player.get_sprite().duplicate().get_texture()
		var player_texture_image = player_texture.get_data()
		
		# Create a new image and copy the texture to it
		var img = Image.new()
		img.create(32, 32, false, Image.FORMAT_RGBA8)
		var src_rect = Rect2(Vector2(32, 0), Vector2(64, 32))
		img.blit_rect(player_texture_image, src_rect, Vector2(0, 0))
		
		# Create an ImageTexture from the new image
		var img_texture = ImageTexture.new()
		img_texture.create_from_image(img, 7)
		panel.get_node("VBoxContainer/PlayerTexture").set_texture(img_texture)
		

func _on_open_store(player):
	if overlaps_body(player):
		store_window.visible = !store_window.visible
	else:
		player.showMessage()
