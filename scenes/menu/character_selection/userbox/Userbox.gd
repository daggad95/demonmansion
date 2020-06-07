extends MarginContainer
export var skip : bool

const StateMachine = preload("res://scripts/StateMachine.gd")
const State = preload("res://scripts/State.gd")

onready var NameSelector = $VBoxContainer/PlayerNameContainer/PlayerName
onready var UpArrow = $VBoxContainer/FrameContainer/VBoxContainer/UpArrow
onready var DownArrow = $VBoxContainer/FrameContainer/VBoxContainer/DownArrow
onready var PlayerIcon = $VBoxContainer/FrameContainer/VBoxContainer/MarginContainer/MarginContainer/PlayerIcon
onready var StatusIcon = $VBoxContainer/StatusIconContainer/TextureRect

var single_player_data = {}
var controller = null
var current_state = null
var current_sprite_idx = 0
var fsm
var sprite_dict
var ready_icon
var not_ready_icon

signal player_joined
signal player_ready
signal player_unready
signal player_exited
signal countdown_cancelled

func init(sprite_dict, ready_icons):
	fsm = StateMachine.new()
	fsm.init(self, Empty.new())
	self.sprite_dict = sprite_dict
	ready_icon = ready_icons[0]
	not_ready_icon = ready_icons[1]

func link_controller(controller):
	self.controller = controller
	single_player_data["controller"] = controller
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

# Called from SelectionScreen when the userbox is created
func set_id(id):
	single_player_data["id"] = id

func show_player_arrows():
	UpArrow.set_modulate(Color(1,1,1,1))
	DownArrow.set_modulate(Color(1,1,1,1))
	
func hide_player_arrows():
	UpArrow.set_modulate(Color(1,1,1,0))
	DownArrow.set_modulate(Color(1,1,1,0))

func get_player_icon():
	return PlayerIcon.get_texture()
	
func reset_player_icon():
	current_sprite_idx = 0
	update_icon()

func next_icon():
	current_sprite_idx += 1
	if current_sprite_idx == len(sprite_dict["spritesheets"]):
		current_sprite_idx = 0
	update_icon()
	
func prev_icon():
	current_sprite_idx += -1
	if current_sprite_idx == -1:
		current_sprite_idx = len(sprite_dict["icons"]) - 1
	update_icon()

func update_icon():
	idle_animation(0)

func idle_animation(frame: int):
	var tex_subregion = AtlasTexture.new()
	tex_subregion.set_atlas(sprite_dict["spritesheets"][current_sprite_idx]["idle"])
	tex_subregion.set_region(Rect2(8 + 48*frame,8,32,32))
	PlayerIcon.set_texture(tex_subregion)
	
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
		model.reset_player_icon()
		model.StatusIcon.set_texture(model.not_ready_icon)
		model.emit_signal("player_joined", model.single_player_data["id"])
		
class NameFocused extends State:
	func enter(model):
		state_name = "NameFocused"
		.enter(model)
		model.NameSelector.set_current_letter(0)
	
	func handle_input(input_name):
		if(input_name == "menu_select"):
			var last_letter = model.NameSelector.confirm_letter()
			if(last_letter):
				model.single_player_data["name"] = model.NameSelector.get_name()
				return PlayerFocused.new()
		elif(input_name == "menu_back"):
			if(!model.NameSelector.is_input_started()):
				model.emit_signal("player_exited", model.single_player_data["id"])
				return Empty.new()
			else:
				model.NameSelector.reset()
				model.reset_player_icon()
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
			model.single_player_data["icon"] = model.get_player_icon()
			model.single_player_data["textures"] = model.sprite_dict["spritesheets"][model.current_sprite_idx]
			return Ready.new()
		elif(input_name == "menu_back"):
			model.hide_player_arrows()
			return NameFocused.new()
		elif(input_name == "menu_up"):
			model.next_icon()
		elif(input_name == "menu_down"):
			model.prev_icon()
			
class Ready extends State:
	func enter(model):
		state_name = "Ready"
		.enter(model)
		model.hide_player_arrows()
		model.StatusIcon.set_texture(model.ready_icon)
		model.emit_signal("player_ready", model.single_player_data)
		
	func handle_input(input_name):
		if(input_name == "menu_back"):
			model.emit_signal("countdown_cancelled")
			model.emit_signal("player_unready")
			model.show_player_arrows()
			model.StatusIcon.set_texture(model.not_ready_icon)
			return PlayerFocused.new()
			
