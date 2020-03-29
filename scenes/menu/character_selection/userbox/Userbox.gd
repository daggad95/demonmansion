extends MarginContainer

onready var PlayerName = $VBoxContainer/PlayerNameContainer/PlayerName
var controller 

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerName.link_controller(controller)

func link_controller(controller):
	self.controller = controller
	


