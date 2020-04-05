extends MarginContainer
enum StoreItemType { WEAPON, AMMO }

onready var button = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/Button
onready var price_label = $CenterContainer/VBoxContainer/PriceLabel
onready var item_texture = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/MarginContainer/ItemTexture
onready var name_label = $CenterContainer/VBoxContainer/Label
onready var highlight_rect = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/Highlight
var item_type

func get_button():
	return button

func get_type():
	return item_type

func select():
	_highlight(true)

func deselect():
	_highlight(false)

func _highlight(set_highlight):
	if set_highlight:
		highlight_rect.set_modulate(Color(1, 1, 1, 0.5))
	else:
		highlight_rect.set_modulate(Color(1, 1, 1, 0))
