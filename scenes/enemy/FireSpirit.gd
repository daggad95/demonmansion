extends Enemy
const Projectile = preload("res://scenes/projectile/Projectile.tscn")
onready var attack_range = 150
onready var aim_dir = Vector2(0, 0)
onready var can_fire = true

func _physics_process(delta):
	var vector_to_target
	var has_line_of_sight

	_shared_update(delta)
	target = _get_nearest_player()
	vector_to_target = target.get_position() - position

	$LineOfSight.set_cast_to(vector_to_target)
	$LineOfSight.force_raycast_update()

	has_line_of_sight = $LineOfSight.get_collider() == target
	aim_dir = vector_to_target.normalized()

	if position.distance_to(target.get_position()) > attack_range or !has_line_of_sight:
		_chase_target()
		$AnimationPlayer.play("move_hop")
	else:
		_brake()
		
		if position.direction_to(target.get_position()).x < 0:
			$Sprite.set_flip_h(true)
		else:
			$Sprite.set_flip_h(false)
		
		if $AnimationPlayer.current_animation == 'move_hop':
			$AnimationPlayer.stop()
			$Sprite.set_frame(0)

		if can_fire:
			$AnimationPlayer.play('attack')
			can_fire = false
			$FireTimer.start(1)

func _shoot_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		100,  # speed
		300,  # range
		1,    # penetration
		25,   # damage
		0.01, # damage dropoff
		global_position,
		false)
	projectile.init_burn(
		2.5, # damage/second
		5   # duration
	)
	projectile.set_sprite('fireball')
	projectile.set_scale(Vector2(2,2))
	projectile.rotate_sprite(position.direction_to(target.get_position()).angle())
	get_tree().get_root().add_child(projectile)

func _on_FireTimer_timeout():
	can_fire = true
