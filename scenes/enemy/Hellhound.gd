#extends Enemy
#var charging
#var precharge = false
#var can_hit = true
#var charge_range = 100
#var charge_target
#var hit_damage = 25
#
#func _ready():
#	face_right = false
#	charging = false
#	precharge = false
#
#func _physics_process(delta):
#	_shared_update(delta)
#	target = _get_nearest_player()
#
#	if charging:
#		if precharge:
#			_brake()
#		else:
#			_charge(charge_target)
#
#			if position.distance_to(charge_target) < 10:
#				charging = false
#				speed /= 4
#				$AnimationPlayer.play('Walk')
#
#	elif position.distance_to(target.get_position()) < charge_range:
#		if not charging:
#			precharge = true
#			charging = true
#			speed *= 4
#			charge_target = target.get_position()
#			$AnimationPlayer.stop()
#			$Sprite.set_frame(7)
#			$ChargeTimer.start(1)
#	else:
#		_chase_target()
#
#func _on_ChargeTimer_timeout():
#	precharge = false
#	$AnimationPlayer.play('attack')
