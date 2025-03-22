extends Node

@onready var timer_manager = $"../TimerManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	timer_manager.running = true
	if OptionsManager.speedrun_timer == true:
		timer_manager.visible = true
		
