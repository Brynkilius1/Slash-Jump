extends Area2D

#@export_range(0, 1) var screen_darkness : float = 0
@export var split_timer : bool = false
@export_range(0, 100) var gravity_minus : int = 0
var screen_activated = false
#sent to screen holder
signal set_next_screen_local(screen)
signal change_screen_local(screen_exited)




func _on_body_entered(body):
	set_next_screen_local.emit(self)
	ActivateScreenObjects()
	
	
	#sets camera start pos to the room the player starts in
	if GlobalVariables.first_respawn_camera_has_moved == false:
		GlobalVariables.first_respawn_camera_has_moved = true
		change_screen_local.emit(null)

func _on_body_exited(body):
	change_screen_local.emit(self)
	if GlobalObjects.player.velocity.y <= -10:
		GlobalObjects.player.velocity.y += gravity_minus
	

func ActivateScreenObjects():
	print(self, " activated!")
	screen_activated = true
	for i in get_children():
		if i.is_in_group("ScreenActivated"):
			i.EnteredScreenActivate()

func ResetScreenObjects():
	if screen_activated:
		for i in get_children():
			if i.is_in_group("LevelObject"):
				i.ResetState()
