extends Node2D

const FADE_OUT_TIME = 5

func _on_Area2D_body_entered(body):
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	if $Timer.get_time_left() <= FADE_OUT_TIME and not $FadePlayer.is_playing():
		$FadePlayer.play("FadeOut")
