extends Control

var next_level_path : String

@onready var audio_master = $AudioMaster
@onready var next_level = $CanvasLayer/PauseMenuBackround/HBoxContainer/NextLevel
@onready var restart_game = $CanvasLayer/PauseMenuBackround/HBoxContainer/RestartGame

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if next_level_path == "":
		print("no path")
		next_level.visible = false
		restart_game.grab_focus()
	else:
		next_level.grab_focus()

func _on_next_level_pressed():
	StatsHolder.run_count += 1
	SaverAndLoader.save_data(SaverAndLoader.SAVE_DIR + SaverAndLoader.SAVE_FILE_NAME)
	audio_master.PlayRandomSound("MenuClick")
	GlobalVariables.ResetGlobalVariables()
	LoadingSceneTransistioner.ChangeSceneWithLoadingScreen(next_level_path)
	MusicMaster.PlaySong("res://Sounds/Ambience/Silence.wav")

func _on_restart_game_pressed():
	StatsHolder.run_count += 1
	SaverAndLoader.save_data(SaverAndLoader.SAVE_DIR + SaverAndLoader.SAVE_FILE_NAME)
	audio_master.PlayRandomSound("MenuClick")
	GlobalVariables.ResetGlobalVariables()
	LoadingSceneTransistioner.ChangeSceneWithLoadingScreen(get_tree().current_scene.scene_file_path)
	MusicMaster.PlaySong("res://Sounds/Ambience/Silence.wav")
	
	
func _on_back_to_menu_pressed():
	SaverAndLoader.save_data(SaverAndLoader.SAVE_DIR + SaverAndLoader.SAVE_FILE_NAME)
	audio_master.PlayRandomSound("MenuClick")
	GlobalVariables.ResetGlobalVariables()
	LoadingSceneTransistioner.ChangeSceneWithLoadingScreen("res://Scenes/UI/GameStart/main_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE








