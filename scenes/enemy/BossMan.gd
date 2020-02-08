extends Enemy
onready var game = get_tree().get_root().get_node("Game")
var BossMan = load("res://scenes/enemy/BossMan.tscn")
var is_child  = false
var has_split = false
var children = []

func die():
	if not is_child and len(children) > 1:
		print('asdf!')
		var new_parent = children.pop_front()
		new_parent.is_child = false
		new_parent.has_split = true
		new_parent.children = children
		new_parent.get_node('MergeTimer').start($MergeTimer.time_left)
	.die()

func _split(num_split):
	var new_health = health / (num_split + 1)
	for i in range(num_split):
		var b = BossMan.instance()
		b.init(
			Vector2(global_position.x+i, global_position.y), 
			game.get_map(),
			game.get_players())
		b.is_child = true
		b.health = new_health
		b._scale(0.8)
		b.connect('dead', self, '_on_child_dead')
		game.add_child(b)
		children.append(b)
	_scale(0.8)
	health = new_health

func _merge():
	for child in children:
		health += child.health
		child.queue_free()
	children = []
	_scale(1.25)

func _scale(factor):
	$Sprite.set_scale($Sprite.get_scale() * factor)
	$Bubble/CollisionShape2D.set_scale($Bubble/CollisionShape2D.get_scale() * factor)
	$CollisionShape2D.set_scale($CollisionShape2D.get_scale() * factor)
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	_shared_update(delta)
	
	target = _get_nearest_player()
	_chase_target()
	
	if not has_split and $AttackTimer.is_stopped():
		$AttackTimer.start(3)

func _on_AttackTimer_timeout():
	if not is_child and not has_split:
		_split(3)
		has_split = true
		$MergeTimer.start(10)

func _on_MergeTimer_timeout():
	_merge()
	has_split = false

func _on_child_dead(child):
	children.erase(child)