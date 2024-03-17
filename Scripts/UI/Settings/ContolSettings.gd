extends Control

@onready var invert_stick_input_check_box = $VBoxContainer/InvertStickInputCheckBox
@onready var controller_deadzone_volume_label = $VBoxContainer/ControllerDeadzoneSlider/ControllerDeadzoneVolumeLabel
@onready var controller_deadzone_volume_slider = $VBoxContainer/ControllerDeadzoneSlider/ControllerDeadzoneVolumeSlider



func _on_invert_stick_input_check_box_toggled(toggled_on):
	OptionsManager.inverted_controls = toggled_on


func _on_controller_deadzone_volume_slider_value_changed(value):
	OptionsManager.controller_deadzone = value
	controller_deadzone_volume_label.text = str("Controller Deadzone: ", value)



func UpdateSettingsVisuals():
	invert_stick_input_check_box.button_pressed = OptionsManager.inverted_controls
	controller_deadzone_volume_slider.value = OptionsManager.controller_deadzone
	controller_deadzone_volume_label.text = str("Controller Deadzone: ", OptionsManager.controller_deadzone)
