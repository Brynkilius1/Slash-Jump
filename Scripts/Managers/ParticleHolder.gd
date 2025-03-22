extends Node2D


func ClearParticles():
	for i in get_children():
		i.queue_free()
