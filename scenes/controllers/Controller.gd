extends Node
signal menu_up
signal menu_down
signal menu_left
signal menu_right
signal menu_select
signal player_move
signal player_aim
signal player_shoot
signal player_not_shoot

const min_joy_value = 0.05
var device

func init(device):
	self.device = device

func _physics_process(delta):
	var left_joy_pos = Vector2(
		Input.get_joy_axis(device, JOY_AXIS_0), 
		Input.get_joy_axis(device, JOY_AXIS_1))
	
	if abs(left_joy_pos.x) < min_joy_value:
		left_joy_pos.x = 0
	if abs(left_joy_pos.y) < min_joy_value:
		left_joy_pos.y = 0
	emit_signal("player_move", left_joy_pos.normalized())
	
	if abs(Input.get_joy_axis(device, JOY_AXIS_7)) > min_joy_value:
		emit_signal("player_shoot")
	else:
		emit_signal("player_not_shoot")