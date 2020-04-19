extends Node
var id_map
onready var astar = AStar.new()
onready var cell_size = $Ground.get_cell_size()
var rng = RandomNumberGenerator.new()

func get_nav_path(start, end):
	start = _get_nearest_nav_point(start)
	end = _get_nearest_nav_point(end)
	
	if start == null or end == null:
		return []
		
	var path = astar.get_point_path(id_map[start], id_map[end])
	var path_world = []
	for point in path:
		var point_world = $Ground.map_to_world(Vector2(point.x, point.y)) + (cell_size/2)
		path_world.append(point_world)
	return path_world

func _get_nearest_nav_point(pos):
	var tile_pos = $Ground.world_to_map(pos)
	
	if tile_pos in id_map:
		return tile_pos
	
	var adj_tiles = _get_adj_tiles(tile_pos)
	var adj_navigable_tiles = []
	
	for adj_tile_pos in adj_tiles:
		if adj_tile_pos in id_map:
			return adj_tile_pos
	return null
	
func _get_adj_tiles(tile_pos):
	var adj_tiles = []
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			if not (x == 0 and y == 0):
				adj_tiles.append(tile_pos + Vector2(x, y))
	return adj_tiles

func get_cell_size():
	return cell_size
	
func _ready():
	_add_tiles() 
	_connect_tiles()
	

func _add_tiles():
	id_map = {}
	var id = 0
	
	var ground_tiles = $Ground.get_used_cells()
	
	for tile_pos in ground_tiles:
		var wall_tile = $Walls.get_cellv(tile_pos)

		if wall_tile == -1:
			astar.add_point(id, Vector3(tile_pos.x, tile_pos.y, 0))
			id_map[tile_pos] = id
			id += 1

func _connect_tiles():
	var ground_tiles = $Ground.get_used_cells()
	
	for tile_pos in ground_tiles:
		if !tile_pos in id_map:
			continue 
			
		var astar_id = id_map[tile_pos]
		var adjacent = _get_adj_tiles(tile_pos)
		
		for adjacent_tile_pos in adjacent:
			if adjacent_tile_pos in id_map:
				var astar_adjacent_id = id_map[adjacent_tile_pos]
				
				if not astar.are_points_connected(astar_id, astar_adjacent_id):
					astar.connect_points(astar_id, astar_adjacent_id)
