extends TileMap
const VectorArrow = preload("res://scenes/map/VectorArrow.tscn")
const MAX_WEIGHT = 999999

enum {WATER, TREE, GRASS}
onready var Game = get_tree().get_root().get_node('Game')
var traversable = [GRASS]
var vector_arrows
var vector_fields = {}
var calculating = {}
var worker_threads = {}
var debug = false
var lock = Mutex.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if debug:
		_load_vector_arrows()
		
	for player in Game.get_players():
		var player_name = player.get_name()
		vector_fields[player_name] = null
		calculating[player_name] = true
		worker_threads[player_name] = Thread.new()
		worker_threads[player_name].start(self, '_async_calc_vector_field', [player_name, player.get_position()])
	$PathUpdateTimer.start(0.1)

func get_vector_to_target(target, pos):
	var vector = Vector2(0, 0)
	lock.lock()
	var field = vector_fields[target]
	
	if field == null:
		lock.unlock()
		return vector
	else:
		var neighbors = [
			pos,
#			pos + Vector2(0, 1),
#			pos + Vector2(1, 0),
#			pos + Vector2(0, -1),
#			pos + Vector2(-1, 0), 
#			pos + Vector2(1, 1),
#			pos + Vector2(-1, -1),
#			pos + Vector2(1, -1),
#			pos + Vector2(-1, 1)
		]
		
		for pos in neighbors:
			var map_pos = world_to_map(pos)
			if map_pos.x >= 0 and map_pos.x < len(field) and map_pos.y >= 0 and map_pos.y < len(field[0]):
				vector += field[map_pos.x][map_pos.y]
		lock.unlock()
		return vector.normalized()

func _async_calc_vector_field(player_data):
	var player_name = player_data[0]
	var player_pos  = player_data[1]
	var temp = _vector_field(player_pos)
	lock.lock()
	vector_fields[player_data[0]] = temp
	calculating[player_name] = false
	lock.unlock()

func _on_PathUpdateTimer_timeout():
	for player in Game.get_players():
		var player_name = player.get_name()
		var done_calculating
		
		lock.lock()
		done_calculating = calculating[player_name]
		lock.unlock()
		
		if done_calculating:
			worker_threads[player_name].wait_to_finish()
			
		calculating[player_name] = true
		worker_threads[player_name].start(self, '_async_calc_vector_field', [player_name, player.get_position()])
	$PathUpdateTimer.start(0.1)
	
func _on_player_moved(player_name, player_pos):
	if debug:
		if player_name == "Player1":
			lock.lock()
			var vector_field_exists = vector_fields[player_name] != null
			var temp_field
			if vector_field_exists:
				temp_field = vector_fields[player_name].duplicate()
			lock.unlock()
			if vector_field_exists:
				_align_vector_arrows(temp_field)

func _align_vector_arrows(field):
	for y in len(vector_arrows[0]):
		for x in len(vector_arrows):
			vector_arrows[x][y].set_rotation(field[x][y].angle() + PI/2)

func _load_vector_arrows():
	var cells = get_used_cells()
	vector_arrows = _gen_null_map()
	
	for cell_pos in cells:
		var arrow = VectorArrow.instance()
		arrow.set_position(map_to_world(cell_pos) + Vector2(8, 8))
		arrow.set_scale(Vector2(0.5, 0.5))
		vector_arrows[cell_pos.x][cell_pos.y] = arrow
		add_child(arrow)

func _gen_null_map():
	var rect = get_used_rect()
	var map = []
	for x in range(rect.size.x):
		map.append([])
		for y in range(rect.size.y):
			map[x].append(null)
	return map

func _gen_dist_map(target):
	var queue = []
	var map = _gen_null_map()
	queue.append([target, 0])
	

	while len(queue) > 0:
		var next = queue.pop_front()
		var tile = next[0]
		var dist = next[1]
		
		if get_cellv(tile) != -1 and map[tile.x][tile.y] == null:
			var cell = get_cellv(tile)
			
			if cell in traversable:
				map[tile.x][tile.y] = dist
				
				var right_tile = Vector2(tile.x+1, tile.y)
				var left_tile = Vector2(tile.x-1, tile.y)
				var top_tile = Vector2(tile.x, tile.y-1)
				var bot_tile = Vector2(tile.x, tile.y+1)
				
				if get_cellv(right_tile) != -1 and map[right_tile.x][right_tile.y] == null:
					queue.append([right_tile, dist+1])
				if get_cellv(left_tile) != -1 and map[left_tile.x][left_tile.y] == null:
					queue.append([left_tile, dist+1])
				if get_cellv(top_tile) != -1 and map[top_tile.x][top_tile.y] == null:
					queue.append([top_tile, dist+1])
				if get_cellv(bot_tile) != -1 and map[bot_tile.x][bot_tile.y] == null:
					queue.append([bot_tile, dist+1])
			else:
				map[tile.x][tile.y] = MAX_WEIGHT
	return map

func _get_neighbors(x, y, map):
	var neighbors = {}
	
	if x - 1 < 0:
		neighbors['left'] = MAX_WEIGHT
	else:
		neighbors['left'] = map[x-1][y]
	if x + 1 >= len(map):
		neighbors['right'] = MAX_WEIGHT
	else:
		neighbors['right'] = map[x+1][y]
	if y - 1 < 0:
		neighbors['top'] = MAX_WEIGHT
	else:
		neighbors['top'] = map[x][y-1]
	if y + 1 >= len(map[0]):
		neighbors['bottom'] = MAX_WEIGHT
	else:
		neighbors['bottom'] = map[x][y+1]
		
	if neighbors['bottom'] == null:
		neighbors['bottom'] = MAX_WEIGHT
	if neighbors['top'] == null:
		neighbors['top'] = MAX_WEIGHT
	if neighbors['left'] == null:
		neighbors['left'] = MAX_WEIGHT
	if neighbors['right'] == null:
		neighbors['right'] = MAX_WEIGHT
		
	return neighbors
	
func _gen_vector_field(dist_map):
	var field = _gen_null_map()
	
	var x = 10
	var y = 10
	var n = _get_neighbors(x, y, dist_map)
	
	for x in range(0, len(dist_map)):
		for y in range(0, len(dist_map[0])):
			var neighbors = _get_neighbors(x, y, dist_map)

			var xcomp = neighbors['left'] - neighbors['right']
			var ycomp = neighbors['top'] - neighbors['bottom']
			
			if xcomp != 0:
				xcomp = xcomp / abs(xcomp)
			if ycomp != 0:
				ycomp = ycomp / abs(ycomp)
			
			field[x][y] = Vector2(xcomp, ycomp).normalized()
	return field

func _vector_field(target):
	var target_map_pos = world_to_map(target)
	var dist_map
	var vector_field
	
	if not get_used_rect().has_point(target_map_pos):
		return null
	dist_map = _gen_dist_map(target_map_pos)
	vector_field = _gen_vector_field(dist_map)

	return vector_field
