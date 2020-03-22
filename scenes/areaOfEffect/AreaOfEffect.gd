extends Node2D
var damage_groups
var already_hit = []
var dot
var damage

func _ready():
	pass # Replace with function body.

func init(duration, damage, damage_groups, dot=false):
	$DurationTimer.start(duration)
	self.damage_groups = damage_groups
	self.dot = dot
	self.damage = damage

func _on_DurationTimer_timeout():
	$Hitbox.set_collision_mask(0)
	$AnimationPlayer.play('FadeOut')

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'FadeOut':
		queue_free()

func _on_Hitbox_body_entered(body):
	if not dot and not body in already_hit:
		var can_hit = false
		
		for group in damage_groups:
			if body.is_in_group(group):
				can_hit = true
		
		if can_hit:
			body.take_damage(damage)
			already_hit.append(body)
