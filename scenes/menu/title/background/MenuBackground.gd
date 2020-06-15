extends Node2D

const ZombieAI = preload("res://scenes/enemy/zombie/ZombieAI.gd")

onready var EnemyFactory = get_node("/root/EnemyFactory")

var zombie_count = 300
var center_pos = self.get_position()
var center_zone_radius = 500
var distance = 600

func _ready():
	spawn_zombies()
	play_animation()

func spawn_zombies():
	for n in range(zombie_count):
		var area_id = str(randi() % 10 + 1)
		var spawn_area2d = find_node("Area2D" + area_id)
		var spawn_colshape2d = find_node("CollisionShape2D" + area_id)
		
		var centerpos = spawn_colshape2d.position + spawn_area2d.position
		var size = spawn_colshape2d.shape.extents
		var xpos = (randi() % int(size.x)) - (size.x/2) + centerpos.x
		var ypos = (randi() % int(size.y)) - (size.y/2) + centerpos.y
		var position_in_area = Vector2(xpos, ypos)
		
		var zombie = EnemyFactory.create(EnemyFactory.EnemyType.ZOMBIE, {"ai_kind": Zombie})
		zombie.position = position_in_area
		add_child(zombie)

func play_animation():
	var random_angle = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	var new_start_pos = center_pos + random_angle.normalized() * center_zone_radius
	self.set_position(new_start_pos)
	
	random_angle = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	var new_end_pos = new_start_pos + random_angle.normalized() * distance
	
	var animation = $AnimationPlayer.get_animation("Move")
	animation.track_set_key_value(0, 0, new_start_pos)
	animation.track_set_key_value(0, 1, new_end_pos)
	
	$AnimationPlayer.play("Move")

func _on_AnimationPlayer_animation_finished(anim_name):
	play_animation()
