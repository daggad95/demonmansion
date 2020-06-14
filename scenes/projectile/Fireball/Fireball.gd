extends "res://scenes/projectile/BaseProjectile/BaseProjectile.gd"

func _ready():
	$AnimationPlayer.play("Fireball")

