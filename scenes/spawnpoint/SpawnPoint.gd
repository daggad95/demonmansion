extends Node2D
signal enemy_dead
export var spawn_quantity : int = 2
export var spawn_radius : int = 30
var spawn_queue : Array = []
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var spawn_delay : float = 1 setget set_spawn_delay
onready var EnemyFactory : EnemyFactory =  get_node("/root/EnemyFactory")

func _ready():
	rng.randomize()
	$SpawnTimer.wait_time = spawn_delay

func set_spawn_delay(spawn_delay):
	spawn_delay = spawn_delay
	$SpawnTimer.wait_time = spawn_delay

func shuffle_queue():
	spawn_queue.shuffle()
	
func _on_SpawnTimer_timeout():
	for i in range(spawn_quantity):
		if len(spawn_queue) > 0:
			var enemy = EnemyFactory.create(spawn_queue.pop_front())
			enemy.global_position = (
				global_position 
				+ Vector2(rng.randf(), rng.randf()).normalized() 
				* rng.randi_range(0, spawn_radius)
			) 
			enemy.connect("dead", self, "_on_enemy_dead")
			get_tree().get_root().add_child(enemy)

func _on_enemy_dead():
	emit_signal("enemy_dead")
