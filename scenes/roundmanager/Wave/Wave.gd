extends Node2D
const EnemyType = preload("res://scenes/enemy/EnemyFactory.gd").EnemyType
signal end_wave
signal num_enemies_change
export var timeout : int
export var spawn_delay: int
export var zombies : int
export var imps : int
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var num_enemies = 0

func start(spawners):
	for spawner in spawners:
		spawner.spawn_delay = spawn_delay
		spawner.connect("enemy_dead", self, "_on_enemy_dead")
	
	_queue_enemies(EnemyType.ZOMBIE, zombies, spawners)
	_queue_enemies(EnemyType.IMP, imps, spawners)
	emit_signal("num_enemies_change", num_enemies)
	
	$WaveTimer.start(timeout)

func _queue_enemies(enemy_type, count, spawners):
	for i in range(count):
		var rand_point = rng.randi_range(0, len(spawners)-1)
		spawners[rand_point].spawn_queue.append(enemy_type)
		num_enemies += 1

func _on_enemy_dead():
	num_enemies -= 1
	emit_signal("num_enemies_change", num_enemies)
	
	if num_enemies == 0:
		_on_wave_end()
		
func _on_wave_end():
	emit_signal("end_wave")
	$WaveTimer.stop()
	queue_free()
