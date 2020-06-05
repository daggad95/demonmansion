extends Node2D

const Map = preload("res://scenes/map/Map.tscn")
const Player = preload("res://scenes/player/Player.tscn")
const PlayerHUD = preload("res://scenes/hud/PlayerHUD.tscn")
const Zombie = preload("res://scenes/enemy/zombie/Zombie.tscn")
const Imp = preload("res://scenes/enemy/Imp.tscn")
const Ogre = preload("res://scenes/enemy/Ogre.tscn")
const Hellhound = preload("res://scenes/enemy/Hellhound.tscn")
const GameCamera = preload("res://scenes/camera/GameCamera.tscn")
const Ammo = preload("res://scenes/items/Ammo/Ammo.tscn")
const Money = preload("res://scenes/items/Money/Money.tscn")
const Health = preload("res://scenes/items/Health/Health.tscn")
const StorePanel = preload("res://scenes/store/StorePanel/StorePanel.tscn")
const RoundManager = preload("res://scenes/roundmanager/RoundManager.tscn")
const SmokeTrail = preload("res://scenes/effects/SmokeTrail/SmokeTrail.tscn")

export var num_players = 0
export var num_zombies = 0
export var num_fire_spirits = 0
export var num_ogres = 0
export var num_hellhound = 0
export var skip_menu = false

var players = []
var camera
var round_manager

signal esc_pressed
signal store_button_pressed

func get_player_count():
	return num_players
	
func get_players():
	return players

func get_map():
	return $Map
		
func _ready():
	$RoundManager.init($Spawners.get_children())
	camera = GameCamera.instance()
	camera.init(self, players)
	add_child(camera)
	
	var player_data_node = get_node("/root/PlayerData")
	var player_count = player_data_node.player_count
	var controllers = get_node("/root/Controllers").get_controllers()
	var spawns = $PlayerSpawns.get_children()
		
	# player_data: dictionary with id, name, sprite
	for player_data in player_data_node.player_datum:
		if player_data != null:
			var player = Player.instance()
			var id = player_data["id"]
			
			player.init(spawns[id].position, player_data["name"], id, player_data["textures"])
			player.link_controller(player_data["controller"])
			player.connect("player_moved", camera, "_on_player_moved")

			var store = StorePanel.instance()
			store.link_player(player)
			player.link_store(store)
			store.link_controller(player_data["controller"])
			$StoreMenu.add_panel(store)
			
			players.append(player)
			add_child(player)
			
			var player_hud = PlayerHUD.instance()
			player_hud.init(player)
			$HUD.add_player_hud(player_hud)
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("esc_pressed")
		get_tree().paused = true
	elif Input.is_action_just_pressed("spawn_ammo"):
		_spawn_ammo(get_global_mouse_position())
	elif Input.is_action_just_pressed("spawn_health"):
		_spawn_health(get_global_mouse_position())
	elif Input.is_action_just_pressed("spawn_money"):
		_spawn_money(get_global_mouse_position())
	elif Input.is_action_just_pressed("spawn_enemy"):
		_spawn_effect(get_global_mouse_position())
	
	$CanvasLayer/Label.set_text(str(Engine.get_frames_per_second()))

func _on_ExitConfirmation_popup_hide():
	get_tree().paused = false
	print("confirmation hidden")
	
func _on_ExitConfirmation_confirmed():
	get_tree().quit()

func _spawn_enemy(pos):
	var enemy = Imp.instance()
	enemy.init($Map, players)
	enemy.position = pos
	add_child(enemy)

func _spawn_effect(pos):
	var trail = SmokeTrail.instance()
	trail.position = pos
	add_child(trail)
	
func _spawn_ammo(pos):
	var ammo = Ammo.instance()
	ammo.init(pos)
	add_child(ammo)
	
func _spawn_health(pos):
	var health = Health.instance()
	health.init(pos)
	add_child(health)

func _spawn_money(pos):
	var money = Money.instance()
	money.init(pos)
	add_child(money)


