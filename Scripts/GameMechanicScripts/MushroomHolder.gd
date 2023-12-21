extends Node2D

signal change_color

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		i.connect("bounced_on", SwapShrooms)


func SwapShrooms():
	print("swap shrooms")
	change_color.emit()
