extends Node

var player_datum = []
var player_count = 0

func _ready():
	player_datum.resize(4)

func set_single_player_data(data):
	var id = data["id"]
	player_datum[id] = data
	player_count += 1
	print("player_count: ", player_count)
	
func delete_single_player_data(id):
	player_datum[id] = null
	player_count -= 1
	print("player_count: ", player_count)
	
func print_player_data():
	for idx in range(4):
		var data = player_datum[idx]
		if data == null:
			print("id: " + str(idx) + ": no data")
		else:
			print("id: " + str(data["id"]))
			print("name: " + data["name"])
			
