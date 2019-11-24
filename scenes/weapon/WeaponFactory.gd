extends Node

const Weapons = {
	'Sniper': {
		'script': preload("res://scenes/weapon/Sniper.gd"),
		'scene':  preload("res://scenes/weapon/Sniper.tscn")
	},
	'Shotgun': {
		'script': preload("res://scenes/weapon/Shotgun.gd"),
		'scene':  preload("res://scenes/weapon/Shotgun.tscn")
	},
	'Pistol': {
		'script': preload("res://scenes/weapon/Pistol.gd"),
		'scene':  preload("res://scenes/weapon/Pistol.tscn")
	},
	'Assault Rifle': {
		'script': preload("res://scenes/weapon/AssaultRifle.gd"),
		'scene':  preload("res://scenes/weapon/AssaultRifle.tscn")
	}
}

static func create(weapon_name):
	var weapon = Weapons[weapon_name]['scene'].instance()
	weapon.init()
	return weapon

static func get_props(weapon_name):
	return Weapons[weapon_name]['script'].get_weapon_props()

static func get_weapon_names():
	return Weapons.keys()
