extends Node2D

#sent to camera manager
signal set_next_screen(screen)
signal change_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		i.set_next_screen_local.connect(SetNextScreen)
		i.change_screen_local.connect(ChangeScreen)
	

		

func SetNextScreen(screen, screen_darkness = 0.0):
	set_next_screen.emit(screen, screen_darkness)

func ChangeScreen(screen_exited):
	change_screen.emit(screen_exited)
