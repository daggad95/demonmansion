extends "res://scenes/areaOfEffect/AreaOfEffect.gd"

func _ready():
	$Sprite.frame = randi() % 6
