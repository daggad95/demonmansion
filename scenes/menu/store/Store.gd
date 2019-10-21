extends Area2D

onready var game_node = get_tree().get_root().get_node("Game")
onready var player_count = game_node.get_player_count()
onready var store_window = get_node("CanvasLayer/MarginContainer")

const Pistol = preload("res://scenes/weapon/Pistol.tscn")
const Shotgun = preload("res://scenes/weapon/Shotgun.tscn")
const AssaultRifle = preload("res://scenes/weapon/AssaultRifle.tscn")
const Sniper = preload("res://scenes/weapon/Sniper.tscn")
const WEAPONS = [Pistol, Shotgun, AssaultRifle, Sniper]

const player_panel = preload("res://scenes/menu/store/PlayerPanel.tscn")
const TOTAL_WEAPON_COUNT = 4
const PLAYER_PANEL_WIDTH = 250

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
	
	var init_weapons = []
	for weapon in WEAPONS:
		init_weapons.append(weapon.instance())		
	
	print("player count: ", player_count)
	$CanvasLayer/MarginContainer.margin_left = -1 * (PLAYER_PANEL_WIDTH/2) * player_count
	$CanvasLayer/MarginContainer.margin_right = (PLAYER_PANEL_WIDTH/2) * player_count
	
	# Add the instance as a child node BEFORE customizing properties of the instance.
	# Otherwise custom properties are applied equally to ALL instances of the child node.
	var players = game_node.get_players()
	for i in range(player_count):
		var player = players[i]
		var panel = player_panel.instance()
		self.get_node("CanvasLayer/MarginContainer/HBoxContainer").add_child(panel)
		panel.rect_position.x = PLAYER_PANEL_WIDTH * i
		panel.get_node("VBoxContainer/PlayerName").text = player.get_name()
		
		var player_sprite = player.get_node("Sprite").duplicate()
		panel.get_node("VBoxContainer/PlayerSpriteContainer").add_child(player_sprite)
		player_sprite.set_frame(1)
		player_sprite.offset.x = PLAYER_PANEL_WIDTH/2
		player_sprite.set_scale(Vector2(1, 1))
		
		for i in range(100):
			for weapon in init_weapons:
				if player.has_weapon(weapon):
					var weapon_container = CenterContainer.new()
					weapon_container.set_custom_minimum_size(Vector2(50, 50))
					var weapon_duplicate = weapon.duplicate()
					weapon_container.add_child(weapon_duplicate)
					weapon_duplicate.set_scale(Vector2(2, 2))
					weapon_duplicate.set_offset(Vector2(30, 12))
					
					
					panel.get_node("VBoxContainer/PlayerInventoryContainer/ScrollContainer/CenterContainer/PlayerInventory").add_child(weapon_container)

		
		var money_format_string = "%s money: %s"
		var money_actual_string = money_format_string % [player.get_name(), str(player.get_money())]
		panel.get_node("VBoxContainer/MoneyLabel").text = money_actual_string
		var health_format_string = "%s health: %s"
		var health_actual_string = health_format_string % [player.get_name(), str(player.get_health())]
		panel.get_node("VBoxContainer/HealthLabel").text = health_actual_string


func _on_open_store(player):
	if overlaps_body(player):
		store_window.visible = !store_window.visible
	else:
		player.showMessage()
