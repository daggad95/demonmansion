extends Node

const WEAPONS = {
	"Sniper": preload("res://scenes/weapon/Sniper/Sniper.tscn"),
	"Shotgun": preload("res://scenes/weapon/Shotgun/Shotgun.tscn"),
	"Assault Rifle": preload("res://scenes/weapon/AssaultRifle/AssaultRifle.tscn"),
	"Pistol": preload("res://scenes/weapon/Pistol/Pistol.tscn")
}

static func create(weapon_name):
	var weapon = WEAPONS[weapon_name].instance()
	return weapon

static func get_props(weapon_name):
	return create(weapon_name).get_weapon_props()

static func get_weapon_names():
	return WEAPONS.keys()
