extends Control

@export var level_1_path : String = "res://Scenes/TestLevels/VisualTests/CrayonVisualtest.tscn"
@export var level_2_path : String = "res://Scenes/TestLevels/test_level_12.tscn"

@onready var main_menu_buttons = %MainMenuButtons
@onready var settings = %Settings
@onready var rebind_controls = $Menu/Menu/Settings/RebindControls
@onready var saver_and_loader = %SaverAndLoader
@onready var start_button = $Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/StartButton
@onready var settings_button = $Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/SettingsButton
@onready var full_screen_check_box = $Menu/Menu/Settings/SettingsHolder/VBoxContainer/VideoSettings/VBoxContainer/FullScreenCheckBox
@onready var level_select = $Menu/Menu/LevelSelect
@onready var level_1 = $Menu/Menu/LevelSelect/Level1
@onready var level_2 = $Menu/Menu/LevelSelect/Level2
@onready var level_zoom_animation_player = $Menu/LevelZoomAnimationPlayer
@onready var root_node = $".."
@onready var menu = $Menu/Menu
@onready var settings_holder = $Menu/Menu/Settings/SettingsHolder
@onready var bar_transition = $DeathTransistionCanvasLayer/BarTransition
@onready var settings_back_button = $Menu/Menu/Settings/SettingsHolder/SettingsBackButton
@onready var selection_swords = $MainMenuVisuals/SelectionSwords

@onready var fps_slider = $Menu/Menu/Settings/SettingsHolder/VBoxContainer/VideoSettings/VBoxContainer/FPSContainer/FpsSlider
@onready var ambience_volume_slider = $Menu/Menu/Settings/SettingsHolder/VBoxContainer/AudioSettings/VBoxContainer/AmbienceSlider/AmbienceVolumeSlider
@onready var rumble_check_box = $Menu/Menu/Settings/SettingsHolder/VBoxContainer/ContolSettings/VBoxContainer/RumbleCheckBox







@onready var selection_swords_start = $Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/StartButton/SelectionSwords
@onready var selection_swords_settings = $Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/SettingsButton/SelectionSwords
@onready var selection_swords_quit = $Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/QuitButton/SelectionSwords


var next_scene_path : String
var next_scene_loaded


func _ready():
	start_button.grab_focus()
	menu.size = Vector2(320, 180)
	


func _on_start_button_pressed():
	bar_transition.PlayScreenCoverAnim()
	
	
	#level_select.visible = true
	#main_menu_buttons.visible = false

func _on_bar_transition_cover_finished():
	get_tree().change_scene_to_file("res://Scenes/PlaytestLevels/playtest_level_2_buffed.tscn")


func _on_start_level_1_button_pressed():
	StartLevel(level_1_path)


func _on_start_level_2_button_pressed():
	StartLevel(level_2_path)

func StartLevel(level_path):
	set_process_input(false)
	TheadedLoadNextLevel(level_path)
	
	await get_tree().create_timer(0.05).timeout
	level_zoom_animation_player.play("ZoomOnLevel")
	await get_tree().create_timer(4.0).timeout
	print("try to swap scenes")
	queue_free()


func TheadedLoadNextLevel(level_path):
	print("start next level load")
	ResourceLoader.load_threaded_request(level_path)
	next_scene_path = level_path


func _process(delta):
	if next_scene_loaded == null:
		if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
			print("finished next level load")
			next_scene_loaded = ResourceLoader.load_threaded_get(next_scene_path)
			next_scene_loaded = next_scene_loaded.instantiate()
			root_node.add_child(next_scene_loaded)


func _on_next_level_button_pressed():
	level_1.visible = false
	level_2.visible = true


func _on_prev_level_button_pressed():
	level_1.visible = true
	level_2.visible = false

func _on_quit_button_pressed():
	get_tree().quit()






func _on_settings_button_pressed():
	ToggleSettingsVisible(true)
	settings.GetExpectedFocus()
	settings.current_settings_menu = 1
	_on_settings_settings_category_changed(0)


func _on_settings_back_button_pressed():
	saver_and_loader.save_data(saver_and_loader.SAVE_DIR + saver_and_loader.SAVE_FILE_NAME)
	settings.UpdateSettingsVisuals()
	ToggleSettingsVisible(false)
	settings_button.grab_focus()
	settings.ChangeToCategory(0)
	settings.current_settings_menu = 0

func _on_level_select_back_button_pressed():
	level_1.visible = true
	level_2.visible = false
	level_select.visible = false
	main_menu_buttons.visible = true
	start_button.grab_focus()

func ToggleSettingsVisible(toggle):
	settings.visible = toggle
	settings_holder.visible = toggle
	main_menu_buttons.visible = not toggle
	selection_swords.visible = not toggle






func _on_change_keybinds_button_pressed():
	ToggleRebindControlsVisible(true)

func _on_rebind_controls_back_button_pressed():
	ToggleRebindControlsVisible(false)

func ToggleRebindControlsVisible(toggle):
	settings.visible = not toggle
	rebind_controls.visible = toggle



#Focus entered
"""
func _on_start_button_focus_entered():
	DisableVisibilityOnAllSwordSelectors()
	selection_swords_start.visible = true
func _on_settings_button_focus_entered():
	DisableVisibilityOnAllSwordSelectors()
	selection_swords_settings.visible = true
func _on_quit_button_focus_entered():
	DisableVisibilityOnAllSwordSelectors()
	selection_swords_quit.visible = true

func DisableVisibilityOnAllSwordSelectors():
	selection_swords_start.visible = false
	selection_swords_settings.visible = false
	selection_swords_quit.visible = false
"""



















func _on_settings_settings_category_changed(settings_category):
	var focus_neighbor
	if settings_category == 0:
		focus_neighbor = fps_slider
	elif settings_category == 1:
		focus_neighbor = ambience_volume_slider
	elif settings_category == 2:
		focus_neighbor = rumble_check_box
		
	settings_back_button.set_focus_neighbor(SIDE_TOP, settings_back_button.get_path_to(focus_neighbor))
