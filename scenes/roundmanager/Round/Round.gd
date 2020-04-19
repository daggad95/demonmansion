extends Node2D
signal end_round
signal wave_change
var spawners
var current_wave = 0
var num_waves = 0
var waves = []

func start(manager, spawners):
	print("Start Round!")
	self.spawners = spawners
	
	waves = get_children()
	num_waves = len(waves)
	for wave in waves:
		wave.connect("num_enemies_change", manager, "_on_remaining_change")
		
	_next_wave()

func _next_wave():
	current_wave += 1
	
	if len(waves) > 0:
		var wave = waves.pop_front()
		wave.start(spawners)
		wave.connect("end_wave", self, "_next_wave")
		emit_signal("wave_change", current_wave, num_waves)
	else:
		emit_signal("end_round")
