extends Node

enum Type {BASE, FIREBALL}
const BaseProjectile = preload("res://scenes/projectile/BaseProjectile/BaseProjectile.tscn")
const Fireball = preload("res://scenes/projectile/Fireball/Fireball.tscn")

func create(projectile_type):
	if projectile_type == Type.BASE:
		return BaseProjectile.instance()
	elif projectile_type == Type.FIREBALL:
		return Fireball.instance()
