extends "res://scenes/store/StoreItem/StoreItem.gd"

const WeaponFactory = preload("res://scenes/weapon/WeaponFactory.gd")

var weapon_props 
onready var item_texture = $CenterContainer/VBoxContainer/CenterContainer/MarginContainer/MarginContainer/ItemTexture
onready var label = $CenterContainer/VBoxContainer/Label

func init(weapon_name):
	weapon_props = WeaponFactory.get_props(weapon_name)

func _ready():
	var texture = load(weapon_props["texture"])
	item_texture.set_texture(texture)
	label.set_text(weapon_props["weapon_name"])
