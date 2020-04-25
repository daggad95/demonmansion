extends "res://scenes/store/StoreItem/StoreItem.gd"

signal purchase_weapon

const WeaponFactory = preload("res://scenes/weapon/WeaponFactory.gd")

var weapon_props 

func init(weapon_name):
	item_type = StoreItemType.WEAPON
	weapon_props = WeaponFactory.get_props(weapon_name)
	
func get_weapon_props():
	return weapon_props

func set_price(price):
	weapon_props["price"] = price

func set_purchased(purchased):
	if purchased:
		set_modulate(Color(1, 0, 0, 1))
	else:
		set_modulate(Color(1, 1, 1, 1))

func _ready():
	var texture = weapon_props["texture"]
	item_texture.set_texture(texture)
	name_label.set_text(weapon_props["weapon_name"])
	price_label.set_text("${0}".format([weapon_props["price"]]))

func _on_Button_pressed():
	emit_signal("purchase_weapon", self)
