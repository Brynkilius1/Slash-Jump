extends Control

@onready var fps_label = $VBoxContainer/FPSContainer/FPSLabel
@onready var fps_container = $VBoxContainer/FPSContainer

@onready var full_screen_check_box = $VBoxContainer/FullScreenCheckBox
@onready var v_sync_check_box = $VBoxContainer/VSyncCheckBox
@onready var screenshake_check_box = $VBoxContainer/ScreenshakeCheckBox
@onready var fps_slider = $VBoxContainer/FPSContainer/FpsSlider



var saved_fps : int = 144

func _ready():
	UpdateSettingsVisuals()



func _on_full_screen_check_box_toggled(toggled_on):
	OptionsManager.fullscreen = toggled_on
func _on_v_sync_check_box_toggled(toggled_on):
	OptionsManager.v_sync = toggled_on
	fps_container.visible = not toggled_on
func _on_screenshake_check_box_toggled(toggled_on):
	OptionsManager.screenshake = toggled_on




func _on_fps_slider_value_changed(value): #Updates the FPS number visualy
	fps_label.text = str("FPS: ", value)
	saved_fps = value
func _on_fps_slider_drag_ended(value_changed): #Actualy changes the MAx fps
	OptionsManager.fps = saved_fps


func UpdateSettingsVisuals():
	full_screen_check_box.button_pressed = OptionsManager.fullscreen
	v_sync_check_box.button_pressed = OptionsManager.v_sync
	screenshake_check_box.button_pressed = OptionsManager.screenshake
	fps_slider.value = OptionsManager.fps
	fps_label.text = str("FPS: ", OptionsManager.fps)
