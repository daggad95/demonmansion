extends Node
const Knockback = preload("res://scenes/StatusEffect/KnockBack/Knockback.gd")
enum EffectType {KNOCKBACK}

func create(effect, entity, args={}):
	if effect == EffectType.KNOCKBACK:
		return Knockback.new(entity, args["dir"], args["speed"], args["duration"])
