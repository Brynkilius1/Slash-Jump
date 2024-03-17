extends Control

@onready var video_settings = $VBoxContainer/VideoSettings
@onready var audio_settings = $VBoxContainer/AudioSettings
@onready var contol_settings = $VBoxContainer/ContolSettings

@onready var full_screen_check_box = $VBoxContainer/VideoSettings/VBoxContainer/FullScreenCheckBox
@onready var master_volume_slider = $VBoxContainer/AudioSettings/VBoxContainer/MasterVolumeSlider/MasterVolumeSlider
@onready var change_keybinds_button = $VBoxContainer/ContolSettings/VBoxContainer/ChangeKeybindsButton


var current_settings_category : int = 0: set = SetCurrentSettingsCategory


func _ready():
	UpdateSettingsVisuals()




func SetCurrentSettingsCategory(new_value):
	new_value %= 3
	if new_value < 0:
		new_value = 2
	print(new_value)
	current_settings_category = new_value

func _physics_process(delta):
	if Input.is_action_just_pressed("LeftBumper"):
		current_settings_category -= 1
		ChangeToCategory(current_settings_category)
		GetExpectedFocus()
	if Input.is_action_just_pressed("RightBumper"):
		current_settings_category += 1
		ChangeToCategory(current_settings_category)
		GetExpectedFocus()

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
