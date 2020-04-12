extends MarginContainer

const StateMachine = preload("res://scripts/StateMachine.gd")
const State = preload("res://scripts/State.gd")

onready var NameSelector = $VBoxContainer/PlayerNameContainer/PlayerName
onready var UpArrow = $VBoxContainer/FrameContainer/VBoxContainer/UpArrow
onready var DownArrow = $VBoxContainer/FrameContainer/VBoxContainer/DownArrow

var controller = null
var current_state = null
var fsm

func init():
	fsm = StateMachine.new()
	fsm.init(self, Empty.new())

func link_controller(controller):
	self.controller = controller
	controller.connect("menu_select", fsm, "handle_input", ["menu_select"])
	controller.connect("menu_back", fsm, "handle_input", ["menu_back"])
	controller.connect("menu_up", fsm, "handle_input", ["menu_up"])
	controller.connect("menu_down", fsm, "handle_input", ["menu_down"])

func show():
	$Background.set_modulate(Color(1,1,1,1))
	$VBoxContainer.set_modulate(Color(1,1,1,1))
	
func hide():
	$Background.set_modulate(Color(1,1,1,0))
	$VBoxContainer.set_modulate(Color(1,1,1,0))
	
func show_player_arrows():
	UpArrow.set_modulate(Color(1,1,1,1))
	DownArrow.set_modulate(Color(1,1,1,1))
	
func hide_player_arrows():
	UpArrow.set_modulate(Color(1,1,1,0))
	DownArrow.set_modulate(Color(1,1,1,0))

class Empty extends State:
	func enter(model):
		state_name = "Empty"
		.enter(model)
		model.hide()
			
	func handle_input(input_name):
		if(input_name == "menu_select"):
			model.NameSelector.reset()
			return NameFocused.new()
		return null
		
	func exit():
		model.show()
		model.hide_player_arrows()
		
class NameFocused extends State:
	func enter(model):
		state_name = "NameFocused"
		.enter(model)
		model.NameSelector.set_current_letter(0)
	
	func handle_input(input_name):
		if(input_name == "menu_select"):
			var last_letter = model.NameSelector.confirm_letter()
			if(last_letter):
				return PlayerFocused.new()
		elif(input_name == "menu_back"):
			if(!model.NameSelector.is_input_started()):
				return Empty.new()
			else:
				model.NameSelector.reset()
				return NameFocused.new()
			
		elif(input_name == "menu_up"):
			model.NameSelector.decrement()
		elif(input_name == "menu_down"):
			model.NameSelector.increment()
		return null


class PlayerFocused extends State:
	func enter(model):
		state_name = "PlayerFocused"
		.enter(model)
		model.show_player_arrows()
		
	func handle_input(input_name):
		if(input_name == "menu_select"):
			model.hide_player_arrows()
			return Ready.new()
		elif(input_name == "menu_back"):
			model.hide_player_arrows()
			return NameFocused.new()
			
		
class Ready extends State:
	func enter(model):
		state_name = "Ready"
		.enter(model)
		model.hide_player_arrows()
		
	func handle_input(input_name):
		if(input_name == "menu_back"):
			model.show_player_arrows()
			return PlayerFocused.new()
