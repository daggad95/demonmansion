extends Area2D

onready var game_node = get_tree().get_root().get_node("Game")
onready var player_count = game_node.get_player_count()
onready var store_window = get_node("CanvasLayer/MarginContainer")

const Pistol = preload("res://scenes/weapon/Pistol.gd")
const Shotgun = preload("res://scenes/weapon/Shotgun.gd")
const AssaultRifle = preload("res://scenes/weapon/AssaultRifle.gd")
const Sniper = preload("res://scenes/weapon/Sniper.gd")
const PlayerPanel = preload("res://scenes/menu/store/PlayerPanel.tscn")
const WEAPONS = [Pistol, Shotgun, AssaultRifle, Sniper]

const TOTAL_WEAPON_COUNT = 4
const PLAYER_PANEL_WIDTH = 250

var player_panels = []

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
	var store_window = $CanvasLayer/MarginContainer/HBoxContainer
#	store_window.hide()	

	# Scale the store window width by the number of players
#	$CanvasLayer/MarginContainer.margin_left = -1 * (PLAYER_PANEL_WIDTH/2) * player_count
#	$CanvasLayer/MarginContainer.margin_right = (PLAYER_PANEL_WIDTH/2) * player_count

	# Add the instance as a child node before customizing properties of the instance.
	# Otherwise custom properties are applied equally to all instances of the child node.
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


func _on_open_store(player):
	pass
#	if overlaps_body(player):
#
#		store_window.visible = !store_window.visible
#		var players = game_node.get_players()
#
#		for i in range(player_count):
#			var current_player = players[i]
#			var panel = player_panels[i]
#			var player_inventory = panel.get_node("VBoxContainer/PlayerInventoryContainer/VBoxContainer/ScrollContainer/CenterContainer/PlayerInventory")
#			for child in player_inventory.get_children():
#				child.queue_free()
#
#			# Check each weapon in the game
#			for weapon in WEAPONS:
#				# Get the current weapon properties as a dictionary
#				var weapon_props = weapon.get_weapon_props()
#				if current_player.has_weapon(weapon_props['weapon_name']):
#
#					var weapon_container = CenterContainer.new()
#					var wep_texture_rect = TextureRect.new()
#					wep_texture_rect.set_texture(load(weapon_props['texture']))
#
#					var wep_texture_rect_size = wep_texture_rect.get_texture().get_size()
#					weapon_container.set_custom_minimum_size(Vector2(50,50))
#					weapon_container.add_child(wep_texture_rect)
#					player_inventory.add_child(weapon_container)
#
#	else:
#		player.showMessage()
