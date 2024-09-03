extends Control

var main_menu = preload("res://Scenes/UI/GameStart/main_menu.tscn")
@onready var pause_menu_backround = $PauseMenuBackround

@onready var return_button = $PauseMenuBackround/PauseMenuButtons/Return
@onready var settings_button = $PauseMenuBackround/PauseMenuButtons/Settings

@onready var fps_slider = $Settings/SettingsHolder/VBoxContainer/VideoSettings/VBoxContainer/FPSContainer/FpsSlider
@onready var ambience_volume_slider = $Settings/SettingsHolder/VBoxContainer/CategoryMarginContainer/AudioSettings/MarginContainer/VBoxContainer/AmbienceSlider/AmbienceVolumeSlider
@onready var rumble_check_box = $Settings/SettingsHolder/VBoxContainer/ContolSettings/VBoxContainer/RumbleCheckBox

@onready var settings_back_button = %SettingsBackButton

@onready var audio_master = $"../../AudioMaster"


@onready var settings = $Settings


signal pause_menu_closed

func _unhandled_input(event):
	if visible == true:
		if settings.current_settings_menu == 0:
			if Input.is_action_just_pressed("ui_cancel"):
				accept_event()
				_on_return_pressed()

	elif GlobalObjects.camera != null:
		if Input.is_action_just_pressed("Pause"):
			accept_event()
			settings.UpdateSettingsVisuals()
			TogglePauseMenu(not visible)


func _on_return_pressed():
	audio_master.PlayRandomSound("MenuClick")
	pause_menu_closed.emit()
	TogglePauseMenu(false)
	GlobalObjects.player.UpdateControlSettings()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_settings_pressed():
	audio_master.PlayRandomSound("MenuClick")
	ToggleSettingsVisible(true)
	settings.GetExpectedFocus()
	settings.current_settings_menu = 1
	_on_settings_settings_category_changed(0)

func _on_settings_back_button_pressed():
	audio_master.PlayRandomSound("MenuClick")
	print("pressed settings back button")
	ToggleSettingsVisible(false)
	SaverAndLoader.save_data(SaverAndLoader.SAVE_DIR + SaverAndLoader.SAVE_FILE_NAME)
	settings.ChangeToCategory(0)
	settings.current_settings_menu = 0
	settings_button.grab_focus()

func _on_back_to_menu_pressed():
	audio_master.PlayRandomSound("MenuClick")
	GlobalVariables.ResetGlobalVariables()
	TogglePauseMenu(false)
	get_tree().change_scene_to_packed(main_menu)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_quit_game_pressed():
	audio_master.PlayRandomSound("MenuClick")
	get_tree().quit()


func TogglePauseMenu(toggle):
	visible = toggle
	Pause(toggle)
	if toggle == true:
		return_button.grab_focus()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		ToggleSettingsVisible(false)
		settings.current_settings_menu = 0

func Pause(pause_: bool):
	if pause_ == true:
		GlobalObjects.camera.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().paused = true
	else:
		get_tree().paused = false


func ToggleSettingsVisible(toggle):
	settings.visible = toggle
	pause_menu_backround.visible = not toggle





func _on_settings_settings_category_changed(settings_category):
	
	var focus_neighbor
	if settings_category == 0:
		focus_neighbor = fps_slider
	elif settings_category == 1:
		focus_neighbor = ambience_volume_slider
	elif settings_category == 2:
		focus_neighbor = rumble_check_box
	
	print("changed back buttons neighbor to : ", focus_neighbor)
	settings_back_button.set_focus_neighbor(SIDE_TOP, settings_back_button.get_path_to(focus_neighbor))

"""
func SetBottomButtonsFocusNeighbor():
	fps_slider.set_focus_neighbor(SIDE_BOTTOM, fps_slider.get_path_to(settings_back_button))
	ambience_volume_slider.set_focus_neighbor(SIDE_BOTTOM, ambience_volume_slider.get_path_to(settings_back_button))
	rumble_check_box.set_focus_neighbor(SIDE_BOTTOM, rumble_check_box.get_path_to(settings_back_button))
"""
