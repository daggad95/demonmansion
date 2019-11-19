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
	if weapon_name != null and inventory_type == "store":
		var player_has_weapon = false
		for weapon in player.get_inventory():
			if weapon.get_name() == weapon_name:
				player_has_weapon = true
		if !player_has_weapon:
#			var old_inv = "old: "
#			for weapon in player.get_inventory():
#				old_inv = old_inv + weapon.get_name() + " "
#			print(old_inv)
#
			player.add_weapon_to_inventory(weapon_name)
			print("Given ", weapon_name, " to ", player.get_name())
#
#			var new_inv = "new: "
#			for weapon in player.get_inventory():
#				new_inv = new_inv + weapon.get_name() + " "
#			print(new_inv)
		else:
			print("already has weapon")
			
		# Took two hours to debug for some reason
		# This line: player.add_weapon_to_inventory(WEAPON_FACTORY.create(weapon_name)) should
		# have been player.add_weapon_to_inventory(weapon_name).
		# add_weapon_to_inventory() takes a string and instances the weapon there


