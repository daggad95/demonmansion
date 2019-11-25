extends Area2D

onready var game_node = get_tree().get_root().get_node("Game")
onready var player_count = game_node.get_player_count()
onready var store_window = get_node("CanvasLayer/MarginContainer")

#const Pistol = preload("res://scenes/weapon/Pistol.gd")
#const Shotgun = preload("res://scenes/weapon/Shotgun.gd")
#const AssaultRifle = preload("res://scenes/weapon/AssaultRifle.gd")
#const Sniper = preload("res://scenes/weapon/Sniper.gd")
#const WEAPONS = [Pistol, Shotgun, AssaultRifle, Sniper]

const PlayerPanel = preload("res://scenes/menu/store/PlayerPanel.tscn")


var player_panels = []

signal store_opened
signal store_closed

func _ready():
	create_store_window()
	
	
func _process(delta):
	var is_player_overlapping = false
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			is_player_overlapping = true
	if !is_player_overlapping and store_window.is_visible():
		store_window.set_visible(false)
		emit_signal("store_closed")
			

func create_store_window():
	var store_window_container = $CanvasLayer/MarginContainer
	var store_window = $CanvasLayer/MarginContainer/HBoxContainer
	store_window_container.set_visible(false)
	
	var players = game_node.get_players()
	for i in range(player_count):
		
		var player = players[i]
		self.connect("store_opened", player, "_on_store_opened")
		self.connect("store_closed", player, "_on_store_closed")
		
		var panel = PlayerPanel.instance()
		panel.init(player)
		store_window.add_child(panel)
		



func _on_open_store(player):
	if overlaps_body(player):
		if store_window.is_visible():
			emit_signal("store_closed")
		else:
			emit_signal("store_opened")
		store_window.set_visible(!store_window.is_visible())
	else:
		player.showMessage()
