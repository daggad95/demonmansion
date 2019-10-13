extends Node2D
const Map = preload("res://scenes/map/Map.tscn")
const Player = preload("res://scenes/player/Player.tscn")
const Zombie = preload("res://scenes/enemy/Zombie.tscn")
const FireSpirit = preload("res://scenes/enemy/FireSpirit.tscn")
const GameCamera = preload("res://scenes/camera/GameCamera.tscn")
const NUM_PLAYERS = 3
const NUM_ENEMIES = 10

var players = []
var camera

signal esc_pressed
signal store_button_pressed

func _ready():
	for i in range(NUM_ENEMIES):
		var enemy = FireSpirit.instance()
		enemy.init(Vector2(50*i + 50, 200), $Map, players)
		add_child(enemy)
		
func _enter_tree():	
	camera = GameCamera.instance()
	camera.init(self, players)
	add_child(camera)

	for i in range(NUM_PLAYERS):
		var player = Player.instance()
		player.init(Vector2(100*i + 100, 100), "Player%d" % (i+1), i+1)
		player.connect("player_moved", $Map, "_on_player_moved")
		player.connect("player_moved", camera, "_on_player_moved")
		player.connect("open_store", $Store, "_on_open_store")
		players.append(player)
		add_child(player)
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("esc_pressed")
		get_tree().paused = true
    
	elif Input.is_action_pressed("store_button"):
		emit_signal("store_button_pressed")
		# get_tree().paused = true
	
	$CanvasLayer/Label.set_text(str(Engine.get_frames_per_second()))
	

func _on_ExitConfirmation_popup_hide():
	get_tree().paused = false
	print("confirmation hidden")
	
func _on_ExitConfirmation_confirmed():
	get_tree().quit()

func get_player_count():
	return NUM_PLAYERS
	
func get_players():
	return players
	
