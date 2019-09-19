extends Control

func _on_StartButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/menu/title/TitleScene.tscn")
