extends MarginContainer
enum StoreItemType { WEAPON, AMMO }

onready var button = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/Button

func get_button():
	return button
