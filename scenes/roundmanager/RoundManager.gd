extends Node
const Round = preload("res://scenes/roundmanager/Round/Round.gd")
var spawners
var rounds = []
var current_round = 0
onready var message : Label = $CanvasLayer/VBoxContainer/Message
onready var wave_text : Label = $CanvasLayer/VBoxContainer/MarginContainer/WaveText
onready var remaining_text : Label = $CanvasLayer/VBoxContainer/RemainingText

func init(spawners):
	self.spawners = spawners
	
	for child in get_children():
		if child is Round:
			rounds.append(child)
	_next_round()

func _next_round():
	var next_round = rounds.pop_front()
	
	current_round += 1
	next_round.connect("wave_change", self, "_on_wave_change")
	next_round.connect("end_round", self, "_on_end_round")
	next_round.start(self, spawners)
	message.text = "Round %d" % current_round
	$AnimationPlayer.play("MessageAnimation")

func _on_wave_change(wave, total_waves):
	wave_text.text = "Wave %d/%d" % [wave, total_waves]

func _on_remaining_change(remaining):
	remaining_text.text= "Remaining: %d" % remaining

func _on_end_round():
	print("end round")
	if len(rounds) > 0:
		_next_round()
	else:
		message.text = "YOU WIN!!!"
		$AnimationPlayer.play("MessageAnimation")
