extends Node2D
const Map = preload("res://scenes/map/Map.tscn")
const Player = preload("res://scenes/player/Player.tscn")
const Enemy = preload("res://scenes/enemy/Enemy.tscn")
const GameCamera = preload("res://scenes/camera/GameCamera.tscn")
const NUM_PLAYERS = 2
const NUM_ENEMIES = 3
var players = []
var camera

signal esc_pressed
signal store_button_pressed

func _ready():
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
	
	for i in range(NUM_ENEMIES):
		var enemy = Enemy.instance()
		enemy.init(Vector2(50*i + 50, 200), $Map, players)
		add_child(enemy)	
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("esc_pressed")
		get_tree().paused = true
    
	elif Input.is_action_pressed("store_button"):
		emit_signal("store_button_pressed")
		# get_tree().paused = true

func _on_ExitConfirmation_popup_hide():
	get_tree().paused = false
	print("confirmation hidden")
	
func _on_ExitConfirmation_confirmed():
	get_tree().quit()
