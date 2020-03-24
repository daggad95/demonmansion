extends CanvasLayer
const WeaponFactory = preload("res://scenes/weapon/WeaponFactory.gd")
const WeaponStoreItem = preload("res://scenes/store/StoreItem/WeaponStoreItem/WeaponStoreItem.tscn")

onready var item_grid = $MainContainer/MarginContainer/VBoxContainer/CenterContainer/GridContainer


func link_controller(controller):
	controller.connect("player_interact", self, "_on_open_store")

func _ready():
	for child in item_grid.get_children():
		child.queue_free()
	
	for name in WeaponFactory.get_weapon_names():
		var item = WeaponStoreItem.instance()
		item.init(name)
		item_grid.add_child(item)
	$MainContainer.hide()
	
func _on_open_store():
	if not $MainContainer.is_visible():
		$MainContainer.show()
		item_grid.get_children()[0].get_button().grab_focus()
	else:
		$MainContainer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
