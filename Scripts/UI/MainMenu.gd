extends Control

@export var start_takes_to : PackedScene = preload("res://Scenes/TestLevels/test_level_7.tscn")



func _on_start_button_pressed():
	get_tree().change_scene_to_packed(start_takes_to)


func _on_quit_button_pressed():
	get_tree().quit()
