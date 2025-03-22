extends Node2D


func ResetState():
	print("reset platform parent")
	get_child(0).ResetState()
