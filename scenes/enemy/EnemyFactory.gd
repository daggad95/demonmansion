extends Node
const Zombie = preload("res://scenes/enemy/zombie/Zombie.tscn")
enum EnemyType {ZOMBIE, IMP}

func create(enemy_type):
	var game = get_tree().get_root().get_node('Game')
	var players = game.get_players()
	var map = game.get_map()
	var enemy
	
	if enemy_type == EnemyType.ZOMBIE:
		enemy = Zombie.instance()
		
	enemy.init(map, players)
	return enemy
