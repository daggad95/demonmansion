extends Sprite

class_name Weapon

var clip_size   = 0
var clip        = 0
var weapon_name = '<UNDEFINED>'
var price       = 0
var projectile  = null

func shoot():
	pass

func get_name():
	return weapon_name

func get_price():
	return price