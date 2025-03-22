extends Node

const LOADING_SCREEN = preload("res://Scenes/LoadingScreen.tscn")

var next_scene = null

func ChangeSceneWithLoadingScreen(scene_path):
	next_scene = scene_path
	get_tree().change_scene_to_packed(LOADING_SCREEN)
