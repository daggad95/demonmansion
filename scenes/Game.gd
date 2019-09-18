extends Node2D
const Map = preload("res://scenes/map/Map.tscn")
const Player = preload("res://scenes/player/Player.tscn")
const Enemy = preload("res://scenes/enemy/Enemy.tscn")
const GameCamera = preload("res://scenes/camera/GameCamera.tscn")
const NUM_PLAYERS = 2
const NUM_ENEMIES = 3
var players = []
var camera

func _ready():
	camera = GameCamera.instance()
	camera.init(self, players)
	add_child(camera)
	
	for i in range(NUM_PLAYERS):
		var player = Player.instance()
		player.init(Vector2(100*i + 100, 100), "Player%d" % (i+1))
		player.connect("player_moved", $Map, "_on_player_moved")
		player.connect("player_moved", camera, "_on_player_moved")
		players.append(player)
		add_child(player)
	
#	for i in range(NUM_ENEMIES):
#		var enemy = Enemy.instance()
#		enemy.init(Vector2(50*i + 50, 200), $Map, players)
#		add_child(enemy)	