extends Area2D

#sent to screen holder
signal set_next_screen_local(screen)
signal change_screen_local(screen_exited)




func _on_body_entered(body):
	set_next_screen_local.emit(self)
	
	
	#sets camera start pos to the room the player starts in
	if GlobalVariables.first_respawn_camera_has_moved == false:
		GlobalVariables.first_respawn_camera_has_moved = true
		change_screen_local.emit(null)

func _on_body_exited(body):
	change_screen_local.emit(self)
