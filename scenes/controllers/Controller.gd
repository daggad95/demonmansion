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

const threshold = 0.5
const menu_delay = 0.25
var device
var signals = [
	 {
		"name": "menu_up",
		"emit_value": false,
		"triggers": [
			{
				"is_analog": true,
				"mapping": JOY_AXIS_1,
				"dir": 1,
			}
		],
		"timer": Timer.new(),
		"delay": menu_delay
	}
]

func init(device):
	for signal_data in signals:
		signal_data['timer'].one_shot = true

func _handle_signal(signal_data):
	var triggers = signal_data['triggers']
	var signal_name = signal_data['name']
	var timer = signal_data['timer']
	var delay = signal_data['delay']
	
	for trigger in triggers:
		if timer.is_stopped():
			if trigger["is_analog"]:
					var value = Input.get_joy_axis(device, trigger["mapping"])
		
					if (trigger["dir"] > 0 and value > threshold or
						trigger["dir"] < 0 and value < -threshold):
						
						if trigger['emit_value']:
							emit_signal(signal_name, value)
						else:
							emit_signal(signal_name)
						
						if delay > 0:
							timer.start(delay)
			else:
				if Input.is_joy_button_pressed(device, trigger['mapping']):
					emit_signal(signal_name)
				
func _physics_process(delta):
	for signal_data in signals:
		_handle_signal(signal_data)
