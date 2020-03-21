extends Node2D


const MIN_VALUE = 5
const MAX_VALUE = 15
var value

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	value = rng.randi_range(MIN_VALUE, MAX_VALUE)

func init(position):
	self.position = position

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		body.add_money(value)
		self.queue_free()
