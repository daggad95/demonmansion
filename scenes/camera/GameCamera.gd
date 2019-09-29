extends Node2D
var players

func init(init_game, init_players):
	players = init_players

func _ready():
	self.zoom(2)

func zoom(scale):
	var canvas_transform = get_viewport().get_canvas_transform()
	get_viewport().set_canvas_transform(canvas_transform.scaled(Vector2(scale, scale)))

func center(focus):
	var viewport_size = get_viewport().get_visible_rect().size
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform.origin = viewport_size/2 - focus*canvas_transform.get_scale()
	get_viewport().set_canvas_transform(canvas_transform)
	
func _on_player_moved(player_name, player_pos):
	var player_center = Vector2(0, 0)
	
	for player in players:
		player_center += player.get_position()
	center(player_center/len(players))