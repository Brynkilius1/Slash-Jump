extends Control

@onready var video_settings = %VideoSettings
@onready var audio_settings = %AudioSettings
@onready var contol_settings = %ContolSettings

@onready var full_screen_check_box = %FullScreenCheckBox
@onready var master_volume_slider = %MasterVolumeSlider
@onready var change_keybinds_button = %ChangeKeybindsButton
@onready var settings_holder = $SettingsHolder
@onready var rebind_controls = %RebindControls

@onready var settings_back_button = $SettingsHolder/SettingsBackButton
@onready var pause_settings_back_button = $SettingsBackButton
@onready var rebind_back_button = $RebindControls/RebindBackButton

@onready var video_category_button = %VideoCategoryButton
@onready var audio_category_button = %AudioCategoryButton
@onready var control_category_button = %ControlCategoryButton

@onready var video_sword_indicator = $SettingsHolder/VBoxContainer/CategoryMarginContainer/VideoSettings/SwordIndicatorMover/SwordIndicator
@onready var audio_sword_indicator = $SettingsHolder/VBoxContainer/CategoryMarginContainer/AudioSettings/SwordIndicatorMover/SwordIndicator
@onready var control_sword_indicator = $SettingsHolder/VBoxContainer/CategoryMarginContainer/ContolSettings/SwordIndicatorMover/SwordIndicator



var current_settings_category : int = 0: set = SetCurrentSettingsCategory

var current_settings_menu = settings_menus.NONE: set = SetCurrentSettingsMenu
var current_sword_indicator

var rebind_control_dead_time_active = false

enum settings_menus {
	NONE,
	AVC_SETTINGS,
	REBIND_CONTROLS,
	CURRENTLY_REBINDING
}


signal settings_category_changed(settings_category)


func SetCurrentSettingsMenu(new_value):
	current_settings_menu = new_value
	print("set current settings menu to: ", new_value)

func _ready():
	current_sword_indicator = video_sword_indicator
	UpdateSettingsVisuals()




func SetCurrentSettingsCategory(new_value):
	new_value %= 3
	if new_value < 0:
		new_value = 2
	current_settings_category = new_value

func _unhandled_input(event):

	if current_settings_menu == settings_menus.AVC_SETTINGS:
		if event is InputEventJoypadButton:
			if event.pressed and event.is_action_pressed("LeftBumper") == true:
				accept_event()
				current_settings_category -= 1
				ChangeToCategory(current_settings_category)
				GetExpectedFocus()
			elif event.pressed and event.is_action_pressed("RightBumper") == true:
				accept_event()
				current_settings_category += 1
				ChangeToCategory(current_settings_category)
				GetExpectedFocus()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("Pause"):
		print("tried to go back through menu")
		print("current menu number: ", current_settings_menu)
		if current_settings_menu == settings_menus.AVC_SETTINGS:
			if settings_back_button:
				settings_back_button.emit_signal("pressed")
			elif pause_settings_back_button:
				pause_settings_back_button.emit_signal("pressed")
		elif current_settings_menu == settings_menus.REBIND_CONTROLS:
			if rebind_control_dead_time_active == false:
				rebind_back_button.emit_signal("pressed")


func _on_video_category_button_pressed():
	ChangeToCategory(0)


func _on_audio_category_button_pressed():
	ChangeToCategory(1)


func _on_control_category_button_pressed():
	ChangeToCategory(2)


func _on_video_category_button_focus_entered():
	if current_settings_category != 0:
		ChangeToCategory(0)


func _on_audio_category_button_focus_entered():
	if current_settings_category != 1:
		ChangeToCategory(1)


func _on_control_category_button_focus_entered():
	if current_settings_category != 2:
		ChangeToCategory(2)



func ChangeToCategory(category : int):
	if category == 0:
		video_settings.visible = true
		audio_settings.visible = false
		contol_settings.visible = false
		current_settings_category = 0
		ChangeCategoriesBottonNeighbor(0)
		settings_category_changed.emit(0)
	elif category == 1:
		video_settings.visible = false
		audio_settings.visible = true
		contol_settings.visible = false
		current_settings_category = 1
		current_sword_indicator = audio_sword_indicator
		ChangeCategoriesBottonNeighbor(1)
		settings_category_changed.emit(1)
	elif category == 2:
		video_settings.visible = false
		audio_settings.visible = false
		contol_settings.visible = true
		current_settings_category = 2
		current_sword_indicator = control_sword_indicator
		ChangeCategoriesBottonNeighbor(2)
		settings_category_changed.emit(2)




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
	

func ChangeCategoriesBottonNeighbor(category_number):
	var focus_neighbor
	if category_number == 0:
		focus_neighbor = full_screen_check_box
	elif category_number == 1:
		focus_neighbor = master_volume_slider
	elif category_number == 2:
		focus_neighbor = change_keybinds_button
		
	video_category_button.set_focus_neighbor(SIDE_BOTTOM, video_category_button.get_path_to(focus_neighbor))
	audio_category_button.set_focus_neighbor(SIDE_BOTTOM, video_category_button.get_path_to(focus_neighbor))
	control_category_button.set_focus_neighbor(SIDE_BOTTOM, video_category_button.get_path_to(focus_neighbor))


func _on_rebind_controls_activate_rebind_control_dead_timer():
	rebind_control_dead_time_active = true
	await get_tree().create_timer(0.1).timeout
	rebind_control_dead_time_active = false






func _on_settings_category_changed(settings_category):
	video_sword_indicator.global_position.y = full_screen_check_box.global_position.y + 8
	audio_sword_indicator.global_position.y = master_volume_slider.global_position.y  + 8
	control_sword_indicator.global_position.y = change_keybinds_button.global_position.y  + 8
	video_sword_indicator.global_position.x = 41
	audio_sword_indicator.global_position.x = 41
	control_sword_indicator.global_position.x = 41
