extends CanvasLayer

onready var row_1 = find_node("Row1")
onready var row_2 = find_node("Row2")
var num_player_hud = 0

func add_player_hud(player_hud):
	if num_player_hud == 0:
		row_1.add_child(player_hud)
		row_1.move_child(player_hud, 0)
	elif num_player_hud == 1:
		row_1.add_child(player_hud)
		row_1.move_child(player_hud, 2)
	elif num_player_hud == 2:
		row_2.add_child(player_hud)
		row_2.move_child(player_hud, 0)
	elif num_player_hud == 3:
		row_2.add_child(player_hud)
		row_2.move_child(player_hud, 2)
		
	num_player_hud += 1
