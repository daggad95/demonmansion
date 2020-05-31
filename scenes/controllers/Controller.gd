extends Node

const PLAYER_THRESHOLD = 0.1
const MENU_THRESHOLD = 0.5
const MENU_DELAY = 0.25

enum Dir {NEG, POS, ANY, NONE}

signal menu_up
signal menu_down
signal menu_left
signal menu_right
signal menu_select
signal menu_back
signal menu_select_secondary
signal player_change_dir
signal player_aim
signal player_start_shooting
signal player_stop_shooting
signal player_interact
signal player_inventory_1
signal player_inventory_2
signal player_inventory_3
signal player_inventory_4
signal player_dodge

var device
var signals = [
	{
		"name": "menu_up",
		"triggers": [
			{
				"inputs": [JOY_AXIS_1],
				"eval_func": funcref(self, "_below_neg_threshold"),
				"emit_func": funcref(self, "_no_data")
			},
			{
				"inputs": [JOY_DPAD_UP],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_down",
		"triggers": [
			{
				"inputs": [JOY_AXIS_1],
				"eval_func": funcref(self, "_above_pos_threshold"),
				"emit_func": funcref(self, "_no_data")
			},
			{
				"inputs": [JOY_DPAD_DOWN],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_left",
		"triggers": [
			{
				"inputs": [JOY_AXIS_0],
				"eval_func": funcref(self, "_below_neg_threshold"),
				"emit_func": funcref(self, "_no_data")
			},
			{
				"inputs": [JOY_DPAD_LEFT],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_right",
		"triggers": [
			{
				"inputs": [JOY_AXIS_0],
				"eval_func": funcref(self, "_above_pos_threshold"),
				"emit_func": funcref(self, "_no_data")
			},
			{
				"inputs": [JOY_DPAD_RIGHT],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_select",
		"triggers": [
			{
				"inputs": [JOY_XBOX_A],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_select_secondary",
		"triggers": [
			{
				"inputs": [JOY_XBOX_Y],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "menu_back",
		"triggers": [
			{
				"inputs": [JOY_XBOX_B],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_interact",
		"triggers": [
			{
				"inputs": [JOY_XBOX_Y],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_inventory_1",
		"triggers": [
			{
				"inputs": [JOY_DPAD_UP],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_inventory_2",
		"triggers": [
			{
				"inputs": [JOY_DPAD_RIGHT],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_inventory_3",
		"triggers": [
			{
				"inputs": [JOY_DPAD_DOWN],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_inventory_4",
		"triggers": [
			{
				"inputs": [JOY_DPAD_LEFT],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": MENU_DELAY
	},
	{
		"name": "player_change_dir",
		"triggers": [
			{
				"inputs": [JOY_AXIS_0, JOY_AXIS_1],
				"eval_func": funcref(self, "_always_emit"),
				"emit_func": funcref(self, "_flattened_data")
			}
		],
		"delay": 0
	},
	{
		"name": "player_aim",
		"triggers": [
			{
				"inputs": [JOY_AXIS_2, JOY_AXIS_3],
				"eval_func": funcref(self, "_always_emit"),
				"emit_func": funcref(self, "_flattened_data")
			}
		],
		"delay": 0
	},
	{
		"name": "player_start_shooting",
		"triggers": [
			{
				"inputs": [JOY_ANALOG_R2],
				"eval_func": funcref(self, "_above_abs_threshold"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": 0
	},
	{
		"name": "player_stop_shooting",
		"triggers": [
			{
				"inputs": [JOY_ANALOG_R2],
				"eval_func": funcref(self, "_below_abs_threshold"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": 0
	},
	{
		"name": "player_dodge",
		"triggers": [
			{
				"inputs": [JOY_XBOX_A],
				"eval_func": funcref(self, "_pressed"),
				"emit_func": funcref(self, "_no_data")
			}
		],
		"delay": 0
	}
]

func init(device):
	self.device = device
	
	for signal_data in signals:
		signal_data['timer'] = Timer.new()
		signal_data['timer'].one_shot = true
		add_child(signal_data['timer'])

func _handle_signal(signal_data):
	var triggers = signal_data['triggers']
	var signal_name = signal_data['name']
	var timer = signal_data['timer']
	var delay = signal_data['delay']
	
	for trigger in triggers:
		if timer.is_stopped():
			if trigger['eval_func'].call_func(trigger['inputs']):
				trigger['emit_func'].call_func(
					signal_name, 
					trigger['inputs']
				)
				
				if delay > 0:
					timer.start(delay)
				
func _physics_process(delta):
	for signal_data in signals:
		_handle_signal(signal_data)

func _above_pos_threshold(inputs, threshold := MENU_THRESHOLD):
	return Input.get_joy_axis(device, inputs[0]) > threshold

func _below_neg_threshold(inputs, threshold := MENU_THRESHOLD):
	return Input.get_joy_axis(device, inputs[0]) < -threshold

func _above_abs_threshold(inputs, threshold := MENU_THRESHOLD):
	return abs(Input.get_joy_axis(device, inputs[0])) > threshold

func _below_abs_threshold(inputs, threshold := MENU_THRESHOLD):
	return abs(Input.get_joy_axis(device, inputs[0])) < threshold
	
func _pressed(inputs):
	return Input.is_joy_button_pressed(device, inputs[0])

func _always_emit(inputs):
	return true

func _no_data(signal_name, inputs):
	emit_signal(signal_name)

func _flattened_data(signal_name, inputs, threshold := PLAYER_THRESHOLD):
	var values = []
	
	for input in inputs:
		var value = Input.get_joy_axis(device, input)
		values.append(
			value if abs(value) > threshold
			else 0
		)
	emit_signal(signal_name, values)

