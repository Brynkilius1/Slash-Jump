extends Node


var just_opened : bool = true

var respawn_point : Vector2 = Vector2(4800, 548) #(-123, 39)
var first_respawn = true
var first_respawn_camera_has_moved = false 
var cutscene_playing : int = 0

var camera_limit_1 : Vector2
var camera_limit_2 : Vector2

signal level_end_object_collected

func ResetGlobalVariables():
	first_respawn = true
	first_respawn_camera_has_moved = false

func CollectedlevelEndObject():
	level_end_object_collected.emit()
