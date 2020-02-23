# Singleton class autoloaded as "Controllers"
extends Node
const Controller = preload("res://scenes/controllers/Controller.gd")
var controllers = []

func _ready():
	for device in Input.get_connected_joypads():
		print('new controller')
		var new_controller = Controller.new()
		new_controller.init(device)
		controllers.append(new_controller)
		add_child(new_controller)

func get_controllers():
	return controllers
