extends Control

@onready var fps_label = %FPSLabel
@onready var fps_container = %FPSContainer

@onready var full_screen_check_box = %FullScreenCheckBox
@onready var v_sync_check_box = %VSyncCheckBox
@onready var screenshake_check_box = %ScreenshakeCheckBox
@onready var fps_slider = %FpsSlider



var saved_fps : int = 144

func _ready():
	UpdateSettingsVisuals()



func _on_full_screen_check_box_toggled(toggled_on):
	OptionsManager.fullscreen = toggled_on
func _on_v_sync_check_box_toggled(toggled_on):
	OptionsManager.v_sync = toggled_on
	fps_slider.editable = not toggled_on
	if toggled_on:
		fps_container.modulate = Color("939393")
		fps_slider.value = 300
	else:
		fps_container.modulate = Color.WHITE
		fps_slider.value = OptionsManager.fps
func _on_screenshake_check_box_toggled(toggled_on):
	OptionsManager.screenshake = toggled_on




func _on_fps_slider_value_changed(value): #Updates the FPS number visualy
	fps_label.text = str("FPS: ", value)
	OptionsManager.fps = value
	#saved_fps = value
#func _on_fps_slider_drag_ended(value_changed): #Actualy changes the MAx fps
	


func UpdateSettingsVisuals():
	full_screen_check_box.button_pressed = OptionsManager.fullscreen
	v_sync_check_box.button_pressed = OptionsManager.v_sync
	screenshake_check_box.button_pressed = OptionsManager.screenshake
	fps_slider.value = OptionsManager.fps
	fps_slider.actual_value = OptionsManager.fps
	fps_label.text = str("FPS: ", OptionsManager.fps)
