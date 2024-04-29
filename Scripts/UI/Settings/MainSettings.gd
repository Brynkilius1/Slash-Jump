extends Control

@onready var video_settings = $SettingsHolder/VBoxContainer/VideoSettings
@onready var audio_settings = $SettingsHolder/VBoxContainer/AudioSettings
@onready var contol_settings = $SettingsHolder/VBoxContainer/ContolSettings

@onready var full_screen_check_box = $SettingsHolder/VBoxContainer/VideoSettings/VBoxContainer/FullScreenCheckBox
@onready var master_volume_slider = $SettingsHolder/VBoxContainer/AudioSettings/VBoxContainer/MasterVolumeSlider/MasterVolumeSlider
@onready var change_keybinds_button = $SettingsHolder/VBoxContainer/ContolSettings/VBoxContainer/ChangeKeybindsButton
@onready var settings_holder = $SettingsHolder

@onready var settings_back_button = $SettingsHolder/SettingsBackButton
@onready var pause_settings_back_button = $SettingsBackButton
@onready var rebind_back_button = $RebindControls/RebindBackButton



var current_settings_category : int = 0: set = SetCurrentSettingsCategory

var current_settings_menu = settings_menus.NONE: set = SetCurrentSettingsMenu

enum settings_menus {
	NONE,
	AVC_SETTINGS,
	REBIND_CONTROLS,
	CURRENTLY_REBINDING
}


func SetCurrentSettingsMenu(new_value):
	current_settings_menu = new_value
	print("set current settings menu to: ", new_value)

func _ready():
	UpdateSettingsVisuals()




func SetCurrentSettingsCategory(new_value):
	new_value %= 3
	if new_value < 0:
		new_value = 2
	print(new_value)
	current_settings_category = new_value

func _unhandled_input(event):

	if current_settings_menu == settings_menus.AVC_SETTINGS:
		if event is InputEventJoypadButton:
			if event.pressed and event.is_action_pressed("LeftBumper") == true:
				print("current_settings_menu: ", settings_menus.AVC_SETTINGS)
				accept_event()
				current_settings_category -= 1
				ChangeToCategory(current_settings_category)
				GetExpectedFocus()
			elif event.pressed and event.is_action_pressed("RightBumper") == true:
				print("current_settings_menu: ", settings_menus.AVC_SETTINGS)
				accept_event()
				current_settings_category += 1
				ChangeToCategory(current_settings_category)
				GetExpectedFocus()

func _process(delta):
	if Input.is_action_just_pressed("SmallSwing") or Input.is_action_just_pressed("Pause"):
		print("tried to go back through menu")
		print("current menu number: ", current_settings_menu)
		if current_settings_menu == settings_menus.AVC_SETTINGS:
			if settings_back_button:
				settings_back_button.emit_signal("pressed")
			elif pause_settings_back_button:
				pause_settings_back_button.emit_signal("pressed")
		elif current_settings_menu == settings_menus.REBIND_CONTROLS:
			rebind_back_button.emit_signal("pressed")
	

func _on_video_category_button_pressed():
	ChangeToCategory(0)

func _on_audio_category_button_pressed():
	ChangeToCategory(1)

func _on_control_category_button_pressed():
	ChangeToCategory(2)

func ChangeToCategory(category : int):
	if category == 0:
		video_settings.visible = true
		audio_settings.visible = false
		contol_settings.visible = false
	elif category == 1:
		video_settings.visible = false
		audio_settings.visible = true
		contol_settings.visible = false
	elif category == 2:
		video_settings.visible = false
		audio_settings.visible = false
		contol_settings.visible = true




func GetExpectedFocus():
	if current_settings_category == 0:
		full_screen_check_box.grab_focus()
	elif current_settings_category == 1:
		master_volume_slider.grab_focus()
	elif current_settings_category == 2:
		change_keybinds_button.grab_focus()
func UpdateSettingsVisuals():
	video_settings.UpdateSettingsVisuals()
	audio_settings.UpdateSettingsVisuals()
	contol_settings.UpdateSettingsVisuals()
