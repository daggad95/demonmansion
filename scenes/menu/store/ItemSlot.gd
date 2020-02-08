extends Node

const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")

signal added_money_to_player
signal player_inventory_changed

var player
var weapon_name
var inventory_type # "player" or "store"


func init(player, weapon_name, inventory_type):
	self.player = player
	self.weapon_name = weapon_name
	self.inventory_type = inventory_type


# Update the inventories and the player money when a slot is clicked
func _on_TextureButton_pressed():
	
	if weapon_name != null:
		var props = WEAPON_FACTORY.get_props(weapon_name)

		# Selling weapon
		if inventory_type == "player":
			player.remove_weapon_from_inventory(weapon_name)
			player.add_money(props['price'])
			emit_signal("added_money_to_player", player, props['price'])
			emit_signal("player_inventory_changed", player, weapon_name)

		# Buying weapon
		if inventory_type == "store":
			var player_has_weapon = false
			for weapon in player.get_inventory():
				if weapon.get_name() == weapon_name:
					player_has_weapon = true

			if !player_has_weapon and player.get_money() >= props['price']:
				player.add_weapon_to_inventory(weapon_name)
				player.add_money(-1 * props['price'])
				emit_signal("added_money_to_player", player, -1 * props['price'])
				emit_signal("player_inventory_changed", player, weapon_name)
				

func get_player():
	return player
	
func get_weapon_name():
	return weapon_name

