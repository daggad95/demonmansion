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
		panel.get_node("VBoxContainer/Button").text = str(i)
		

func _on_open_store(player):
	if overlaps_body(player):
		store_window.visible = !store_window.visible
	else:
		player.showMessage()
