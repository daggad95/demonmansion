extends Node
const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")

var player
var weapon_name
var inventory_type # "player" or "store"

func init(player, weapon_name, inventory_type):
	self.player = player
	self.weapon_name = weapon_name
	self.inventory_type = inventory_type


func _on_TextureButton_pressed():
	# Empty slots have no weapon, so weapon is null 
	if weapon_name != null and inventory_type == "store":
		player.add_weapon_to_inventory(WEAPON_FACTORY.create(weapon_name))
