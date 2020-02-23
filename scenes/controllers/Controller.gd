extends Node
signal menu_up
signal menu_down
signal menu_left
signal menu_right
signal menu_select
signal menu_back
signal menu_select_secondary
signal player_move
signal player_aim
signal player_shoot
signal player_not_shoot
signal player_open_store

const min_joy_value = 0.05
const menu_threshold = 0.8
var device
var mapping = {}

func init(device):
	self.device = device
	self.mapping['menu_select'] = JOY_XBOX_A
	self.mapping['menu_back'] = JOY_XBOX_B
	self.mapping['menu_select_secondary'] = JOY_XBOX_Y
	self.mapping['player_open_store'] = JOY_XBOX_Y

func _physics_process(delta):
	var left_joy_pos = Vector2(
		Input.get_joy_axis(device, JOY_AXIS_0), 
		Input.get_joy_axis(device, JOY_AXIS_1))
	
	if abs(left_joy_pos.x) < min_joy_value:
		left_joy_pos.x = 0
	if abs(left_joy_pos.y) < min_joy_value:
		left_joy_pos.y = 0
	
	if abs(left_joy_pos.x) > menu_threshold:
		if left_joy_pos.x > 0:
			emit_signal("menu_right")
		if left_joy_pos.x < 0:
			emit_signal("menu_left")
	
	if abs(left_joy_pos.y) > menu_threshold:
		if left_joy_pos.y  > 0:
			emit_signal("menu_down")
		if left_joy_pos.y < 0:
			emit_signal("menu_up")
		
	emit_signal("player_move", left_joy_pos.normalized())
	
	if abs(Input.get_joy_axis(device, JOY_AXIS_7)) > min_joy_value:
		emit_signal("player_shoot")
	else:
		emit_signal("player_not_shoot")
	
	for signal_name in mapping.keys():
		if Input.is_joy_button_pressed(device, mapping[signal_name]):
			emit_signal(signal_name)
