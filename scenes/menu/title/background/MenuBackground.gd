extends Node2D

var center_pos = self.get_position()
var center_zone_radius = 500
var distance = 600

func _ready():
	play_animation()

func _on_AnimationPlayer_animation_finished(anim_name):
	play_animation()
	
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
