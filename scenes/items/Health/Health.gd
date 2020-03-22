extends "res://scenes/items/Item.gd"


const REGEN_AMOUNT = 25

func init(position):
	self.position = position

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		var health = body.get_health()
		var max_health = body.get_max_health()
		
		if health < max_health:
			body.set_health(health + min(REGEN_AMOUNT, max_health-health))
			self.queue_free()
