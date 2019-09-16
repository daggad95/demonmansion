extends Node2D

signal esc_pressed

func _ready():
	set_process(true)
	
func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("esc_pressed")
		get_tree().paused = true

func _on_ExitConfirmation_popup_hide():
	get_tree().paused = false

func _on_ExitConfirmation_confirmed():
	get_tree().quit()


