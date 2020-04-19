extends Node2D

const Map = preload("res://scenes/map/Map.tscn")
const Player = preload("res://scenes/player/Player.tscn")
const HUD = preload("res://scenes/hud/HUD.tscn")
const Zombie = preload("res://scenes/enemy/Zombie.tscn")
const Ogre = preload("res://scenes/enemy/Ogre.tscn")
const Hellhound = preload("res://scenes/enemy/Hellhound.tscn")
const GameCamera = preload("res://scenes/camera/GameCamera.tscn")
const Ammo = preload("res://scenes/items/Ammo/Ammo.tscn")
const Money = preload("res://scenes/items/Money/Money.tscn")
const Health = preload("res://scenes/items/Health/Health.tscn")
const StorePanel = preload("res://scenes/store/StorePanel/StorePanel.tscn")
const RoundManager = preload("res://scenes/roundmanager/RoundManager.tscn")

export var num_players = 0
export var num_zombies = 0
export var num_fire_spirits = 0
export var num_ogres = 0
export var num_hellhound = 0

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
	var controllers = get_node("/root/Controllers").get_controllers()
	for i in range(len(controllers)):
		var store = StorePanel.instance()
		store.link_player(players[i])
		players[i].link_store(store)
		store.link_controller(controllers[i])

		$StoreMenu.add_panel(store)
	
	$RoundManager.init($Spawners.get_children())
		
func _enter_tree():	
	camera = GameCamera.instance()
	camera.init(self, players)
	add_child(camera)
#
	var controllers = get_node("/root/Controllers").get_controllers()
	for i in range(num_players):
		var player = Player.instance()
		player.init(Vector2(100*i + 100, 100), "Player%d" % (i+1), i+1)
		player.connect("player_moved", camera, "_on_player_moved")
		
		if i < len(controllers):
			player.link_controller(controllers[i])
			
		players.append(player)
		add_child(player)
		
		var hud = HUD.instance()
		hud.init(player)
		$CanvasLayer.add_child(hud)
	
	
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
		_spawn_enemy(get_global_mouse_position())
	
	$CanvasLayer/Label.set_text(str(Engine.get_frames_per_second()))
	

func _on_ExitConfirmation_popup_hide():
	get_tree().paused = false
	print("confirmation hidden")
	
func _on_ExitConfirmation_confirmed():
	get_tree().quit()

func _spawn_enemy(pos):
	var enemy = Zombie.instance()
	enemy.init($Map, players)
	enemy.position = pos
	add_child(enemy)
	
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


