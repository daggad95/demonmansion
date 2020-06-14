extends "res://scripts/StateMachine.gd"
const State = preload("res://scripts/State.gd")
enum {EMPTY, NAME_FOCUSED, PLAYER_FOCUSED, READY}

func _init(model, init_state):
	states = {
		EMPTY: Empty.new().init(model),
		NAME_FOCUSED: NameFocused.new().init(model),
		PLAYER_FOCUSED: PlayerFocused.new().init(model),
		READY: Ready.new().init(model)
	}
	init(model, init_state)

class Empty extends State:
	func enter():
		state_name = "Empty"
		model.hide()
		
	func handle_input(input_name):
		if(input_name == "menu_select"):
			model.NameSelector.reset()
			return NAME_FOCUSED
		
	func exit():
		model.show()
		model.hide_player_arrows()
		model.reset_player_icon()
		model.StatusIcon.set_texture(model.not_ready_icon)
		model.emit_signal("player_joined", model.single_player_data["id"])
		
class NameFocused extends State:
	func enter():
		state_name = "NameFocused"
		model.NameSelector.set_current_letter(0)
	
	func handle_input(input_name):
		if(input_name == "menu_select"):
			var last_letter = model.NameSelector.confirm_letter()
			if(last_letter):
				model.single_player_data["name"] = model.NameSelector.get_name()
				return PLAYER_FOCUSED
		elif(input_name == "menu_back"):
			if(!model.NameSelector.is_input_started()):
				model.emit_signal("player_exited", model.single_player_data["id"])
				return EMPTY
			else:
				model.NameSelector.reset()
				model.reset_player_icon()
				return NAME_FOCUSED
		elif(input_name == "menu_up"):
			model.NameSelector.decrement()
		elif(input_name == "menu_down"):
			model.NameSelector.increment()
		
class PlayerFocused extends State:
	func enter():
		model.show_player_arrows()
		
	func handle_input(input_name):
		if(input_name == "menu_select"):
			model.hide_player_arrows()
			model.single_player_data["icon"] = model.get_player_icon()
			model.single_player_data["textures"] = model.sprite_dict["spritesheets"][model.current_sprite_idx]
			return READY
		elif(input_name == "menu_back"):
			model.hide_player_arrows()
			return NAME_FOCUSED
		elif(input_name == "menu_up"):
			model.next_icon()
		elif(input_name == "menu_down"):
			model.prev_icon()
			
class Ready extends State:
	func enter():
		state_name = "Ready"
		model.hide_player_arrows()
		model.StatusIcon.set_texture(model.ready_icon)
		model.emit_signal("player_ready", model.single_player_data)
		
	func handle_input(input_name):
		if(input_name == "menu_back"):
			model.emit_signal("countdown_cancelled")
			model.emit_signal("player_unready")
			model.show_player_arrows()
			model.StatusIcon.set_texture(model.not_ready_icon)
			return PLAYER_FOCUSED
			
