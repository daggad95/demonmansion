extends Node2D

const MIN_VALUE = 5
const MAX_VALUE = 15
const WEAPON = preload("res://scenes/weapon/Weapon.gd")

var AMMO_MAP = {
	WEAPON.Ammo.RIFLE: {
		"texture": preload("res://assets/Ammo/rifle.png"),
		"amount": 40
	},
	WEAPON.Ammo.SNIPER: {
		"texture": preload("res://assets/Ammo/sniper.png"),
		"amount": 10
	},
	WEAPON.Ammo.SHOTGUN: {
		"texture": preload("res://assets/Ammo/shotgun.png"),
		"amount": 20
	}
}
var ammo_type

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	ammo_type = rng.randi_range(0, len(WEAPON.Ammo)-2)
	$Sprite.set_texture(AMMO_MAP[ammo_type]['texture'])

func init(position):
	self.position = position

func _on_Area2D_body_entered(body):
	if body.is_in_group('player'):
		body.add_ammo(ammo_type, AMMO_MAP[ammo_type]['amount'])
	queue_free()
