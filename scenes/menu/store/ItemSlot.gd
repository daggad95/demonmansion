extends Node

var player
var weapon
var inventory_type # "player" or "store"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func init(player, weapon, inventory_type):
	self.player = player
	self.weapon = weapon
	self.inventory_type = inventory_type


func _on_TextureButton_pressed():
	# Empty slots have no weapon, so weapon is null 
	if weapon != null and inventory_type == "store":
		player.add_to_inventory(weapon)
		print("Added to inventory: " + weapon.get_name())
