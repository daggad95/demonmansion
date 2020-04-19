#extends Enemy
#
#const CrackAOE = preload('res://scenes/areaOfEffect/CrackAOE.tscn')
#const ATTACK_START_FRAME = 68
#var attack_range = 50
#var attack_delay = 3
#var attacking = false
#var attack_pos
#
#func _physics_process(delta):
#	_shared_update(delta)
#
#	target = _get_nearest_player()
#	if position.distance_to(target.get_position()) <= attack_range:
#		if linear_velocity.length() > 0:
#			_brake()
#		else:
#			if $AttackTimer.is_stopped():
#				$AttackTimer.start(attack_delay)
#				_attack()
#			elif not attacking:
#				$AnimationPlayer.stop()
#				$Sprite.frame = ATTACK_START_FRAME
#	else:
#		if not attacking:
#			if !$AnimationPlayer.is_playing() and linear_velocity.length() > 0:
#				$AnimationPlayer.play('Walk')
#			_chase_target()
#
#func _attack():
#	attacking = true
#	attack_pos = target.get_global_position()
#	$AnimationPlayer.play("Attack")
#
#func _gen_aoe():
#	var aoe = CrackAOE.instance()
#	aoe.init(
#		0.1, 			# duration
#		50,			# damage
#		['player']) # damage groups
#	aoe.set_position(attack_pos)
#	get_tree().get_root().add_child(aoe)
#
#func _on_AnimationPlayer_animation_finished(anim_name):
#	if anim_name == 'Attack':
#		$Sprite.frame = ATTACK_START_FRAME
#		attacking = false
