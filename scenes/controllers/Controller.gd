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
	var analog_values = {
		'left_joy_x': Input.get_joy_axis(device, JOY_AXIS_0),
		'left_joy_y': Input.get_joy_axis(device, JOY_AXIS_1),
		'right_joy_x': Input.get_joy_axis(device, JOY_AXIS_2),
		'right_joy_y': Input.get_joy_axis(device, JOY_AXIS_3),
		'right_trigger': Input.get_joy_axis(device, JOY_AXIS_7)
	}
	
	for key in analog_values.keys():
		if abs(analog_values[key]) < min_joy_value:
			analog_values[key] = 0
	
	if abs(analog_values['left_joy_x']) > menu_threshold:
		if analog_values['left_joy_x'] > 0:
			emit_signal("menu_right")
		if analog_values['left_joy_x'] < 0:
			emit_signal("menu_left")
	
	if analog_values['left_joy_y'] > menu_threshold:
		if analog_values['left_joy_y']  > 0:
			emit_signal("menu_down")
		if analog_values['left_joy_y'] < 0:
			emit_signal("menu_up")
		
	emit_signal("player_move", Vector2(
		analog_values['left_joy_x'], 
		analog_values['left_joy_y']
	).normalized())
	
	if abs(analog_values['right_joy_x']) > 0 or abs(analog_values['right_joy_y']) > 0:
		emit_signal("player_aim", Vector2(
			analog_values['right_joy_x'],
			analog_values['right_joy_y']
		).normalized())
	
	if abs(Input.get_joy_axis(device, JOY_AXIS_7)) > min_joy_value:
		emit_signal("player_shoot")
	else:
		emit_signal("player_not_shoot")
	
	for signal_name in mapping.keys():
		if Input.is_joy_button_pressed(device, mapping[signal_name]):
			emit_signal(signal_name)
