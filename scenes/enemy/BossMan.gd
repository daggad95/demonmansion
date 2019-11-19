extends Enemy
var BossMan = load("res://scenes/enemy/BossMan.tscn")
onready var game = get_tree().get_root().get_node("Game")
var is_child  = false
var has_split = false
var children = []

func _split(num_split):
	for i in range(num_split):
		var b = BossMan.instance()
		b.init(
			Vector2(position.x, position.y), 
			game.get_players(),
			game.get_map())
		b.is_child = true
		add_child(b)
		children.append(b)
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	_shared_update(delta)
	
	target = _get_nearest_player()
	_chase_target()
	
	if not is_child and not has_split:
		_split(3)
		has_split = true
