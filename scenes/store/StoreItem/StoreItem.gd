extends MarginContainer
enum StoreItemType { WEAPON, AMMO }

onready var button = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/Button
onready var price_label = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/MarginContainer2/PriceLabel
onready var item_texture = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/MarginContainer/ItemTexture
onready var name_label = $CenterContainer/VBoxContainer/Label
var item_type

func get_button():
	return button

func get_type():
	return item_type
