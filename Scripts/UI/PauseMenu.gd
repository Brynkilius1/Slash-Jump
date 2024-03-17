extends Control

var main_menu = preload("res://Scenes/UI/GameStart/main_menu.tscn")
@onready var pause_menu_buttons = $PauseMenuButtons

@onready var settings = $Settings


func _unhandled_input(event):
	if Input.is_action_just_pressed("Pause"):
		settings.UpdateSettingsVisuals()
		TogglePauseMenu(not visible)


func _on_return_pressed():
	TogglePauseMenu(false)


func _on_settings_pressed():
	ToggleSettingsVisible(true)
	settings.GetExpectedFocus()

func _on_settings_back_button_pressed():
	ToggleSettingsVisible(false)
	SaverAndLoader.save_data(SaverAndLoader.SAVE_DIR + SaverAndLoader.SAVE_FILE_NAME)

func _on_back_to_menu_pressed():
	TogglePauseMenu(false)
	get_tree().change_scene_to_packed(main_menu)


func _on_quit_game_pressed():
	get_tree().quit()


func TogglePauseMenu(toggle):
	visible = toggle
	Pause(toggle)

func Pause(pause_: bool):
	if pause_ == true:
		GlobalObjects.camera.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().paused = true
	else:
		get_tree().paused = false


func ToggleSettingsVisible(toggle):
	settings.visible = toggle
	pause_menu_buttons.visible = not toggle



