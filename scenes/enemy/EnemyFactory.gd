extends Node
const Zombie = preload("res://scenes/enemy/zombie/Zombie.tscn")
enum EnemyType {ZOMBIE, IMP}

func create(enemy_type, args = {}):
	var game = get_tree().get_root().get_node('Game')
	
	var players
	var map
	if game == null:
		players = null
		map = null
	else:
		players = game.get_players()
		map = game.get_map()
	
	var enemy
	if enemy_type == EnemyType.ZOMBIE:
		enemy = Zombie.instance()
		if "ai_kind" in args:
			enemy.set_ai(args["ai_kind"])
		if "bounds" in args:
			enemy.bounding_box = args["bounds"]
		
	enemy.init(map, players)
	return enemy
