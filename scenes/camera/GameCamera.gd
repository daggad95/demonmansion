extends Node2D
var game
var players

func init(init_game, init_players):
	game = init_game
	players = init_players
	
func zoom(scale):
	game.apply_scale(Vector2(scale, scale))

func center(focus):
	game.translate(game.get_position() - focus)