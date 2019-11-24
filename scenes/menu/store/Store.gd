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
	var store_window = $CanvasLayer/MarginContainer
	store_window.set_visible(false)
	
	var players = game_node.get_players()
	for i in range(player_count):
		var player = players[i]
		var panel = PlayerPanel.instance()
		panel.init(player)
		store_window.add_child(panel)
		
#		player_panels.append(panel)
#		self.get_node("CanvasLayer/MarginContainer/HBoxContainer").add_child(panel)
#		panel.get_node("VBoxContainer/PlayerName").text = player.get_name()
#
#		var player_sprite = player.get_node("Sprite").duplicate()
#		panel.get_node("VBoxContainer/PlayerSpriteContainer").add_child(player_sprite)
#		player_sprite.set_frame(1)
#		player_sprite.offset.x = PLAYER_PANEL_WIDTH/2
#		player_sprite.set_scale(Vector2(1, 1))
#
#		var money_format_string = "%s money: %s"
#		var money_actual_string = money_format_string % [player.get_name(), str(player.get_money())]
#		panel.get_node("VBoxContainer/MoneyLabel").text = money_actual_string
#		var health_format_string = "%s health: %s"
#		var health_actual_string = health_format_string % [player.get_name(), str(player.get_health())]
#		panel.get_node("VBoxContainer/HealthLabel").text = health_actual_string
#	print(store_window.get_child(0))
	


func _on_open_store(player):
	if overlaps_body(player):
		store_window.set_visible(!store_window.is_visible())
	else:
		player.showMessage()
