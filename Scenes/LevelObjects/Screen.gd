extends Area2D

signal set_next_screen_local(screen)
signal change_screen_local(screen_exited)



func _on_body_entered(body):
	set_next_screen_local.emit(self)

func _on_body_exited(body):
	change_screen_local.emit(self)

