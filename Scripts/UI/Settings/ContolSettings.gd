extends Control

@onready var invert_stick_input_check_box = $VBoxContainer/InvertStickInputCheckBox
@onready var controller_deadzone_volume_label = $VBoxContainer/ControllerDeadzoneSlider/ControllerDeadzoneVolumeLabel
@onready var controller_deadzone_volume_slider = $VBoxContainer/ControllerDeadzoneSlider/ControllerDeadzoneVolumeSlider
@onready var rumble_check_box = $VBoxContainer/RumbleCheckBox
@onready var rebind_controls = $"../../../RebindControls"
@onready var settings_holder = $"../.."
@onready var settings = $"../../.."
@onready var change_sword_swing_button = %ChangeSwordSwingButton
@onready var rebind_back_button = $"../../../RebindControls/RebindBackButton"







func _on_invert_stick_input_check_box_toggled(toggled_on):
	OptionsManager.inverted_controls = toggled_on


func _on_controller_deadzone_volume_slider_value_changed(value):
	OptionsManager.controller_deadzone = value
	controller_deadzone_volume_label.text = str("Controller Deadzone: ", value)

func _on_rumble_check_box_toggled(toggled_on):
	OptionsManager.rumble_enabled = toggled_on


func UpdateSettingsVisuals():
	invert_stick_input_check_box.button_pressed = OptionsManager.inverted_controls
	controller_deadzone_volume_slider.value = OptionsManager.controller_deadzone
	controller_deadzone_volume_slider.actual_value = OptionsManager.controller_deadzone
	controller_deadzone_volume_label.text = str("Controller Deadzone: ", OptionsManager.controller_deadzone)
	rumble_check_box.button_pressed = OptionsManager.rumble_enabled

func _on_change_keybinds_button_pressed():
	rebind_controls.GetFocus()
	rebind_controls.visible = true
	settings_holder.visible = false
	settings.current_settings_menu = 2


func _on_rebind_back_button_pressed():
	settings.GetExpectedFocus()
	rebind_controls.visible = false
	settings_holder.visible = true
	settings.current_settings_menu = 1


func _on_rebind_controls_opened_rebind_menu():
	rebind_back_button.visible = false
	settings.current_settings_menu = 3


func _on_rebind_controls_closed_rebind_menu():
	rebind_back_button.visible = true
	settings.current_settings_menu = 2



