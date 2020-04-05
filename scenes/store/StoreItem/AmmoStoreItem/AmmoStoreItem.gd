extends "res://scenes/store/StoreItem/StoreItem.gd"

signal purchase_ammo

var item_data

func init(item_data):
	self.item_data = item_data
	item_type = StoreItemType.AMMO

func get_item_data():
	return item_data
	
func _ready():
	item_texture.set_texture(load(item_data["icon"]))
	name_label.set_text(item_data["name"])
	price_label.set_text("${0}".format([item_data["price"]]))

func _on_Button_pressed():
	emit_signal("purchase_ammo", self.item_data)
