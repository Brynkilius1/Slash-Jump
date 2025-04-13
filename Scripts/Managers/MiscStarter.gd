extends Node

@onready var timer_manager = $"../TimerManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if OptionsManager.speedrun_timer == true:
		timer_manager.visible = true
	
	await get_tree().create_timer(0.6).timeout
	timer_manager.running = true
