extends Control


const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "non_gameplay_save.json"
const SECURITY_KEY = "JWI68N92JB"

var settings_data = SettingsData.new()

func _ready():
	VerifySaveDirectory(SAVE_DIR)
	load_data(SAVE_DIR + SAVE_FILE_NAME)

func VerifySaveDirectory(path : String):
	print("verified save directory")
	DirAccess.make_dir_absolute(path)



func save_data(path : String):
	#open the file
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	#if the file open fails, return error
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	#declaring the variables i want saved as a dictionary
	var data = {
		"settings_data":{
			"fullscreen": OptionsManager.fullscreen,
			"v_sync": OptionsManager.v_sync,
			"screenshake": OptionsManager.screenshake,
			"fps": OptionsManager.fps,
			"master_volume": OptionsManager.master_volume,
			"sound_effect_volume": OptionsManager.master_volume,
			"music_volume": OptionsManager.music_volume,
			"ambience_volume": OptionsManager.ambience_volume,
			"inverted_controls": OptionsManager.inverted_controls,
			"controller_deadzone": OptionsManager.controller_deadzone
		}
	}
	
	#make teh dictionary into a string
	var json_string = JSON.stringify(data, "\t")
	#save the string
	file.store_string(json_string)
	#close teh file
	file.close()

func load_data(path : String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
			
		
		var file_contents = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(file_contents)
		if data == null:
			print("Cannot parse ", path, " as a json string: ", file_contents)
			return
		
		LoadInData(data)
		ApplyLoadedVariablesToOptionManager()
	
	else:
		print("Cant open a file that doesnt exist! At path: ", path)
func LoadInData(data):
	settings_data = SettingsData.new()
	#Video
	settings_data.fullscreen = data.settings_data.fullscreen
	settings_data.v_sync = data.settings_data.v_sync
	settings_data.screenshake = data.settings_data.screenshake
	settings_data.fps = data.settings_data.fps
	
	#Audio
	settings_data.master_volume = data.settings_data.master_volume
	settings_data.sound_effect_volume = data.settings_data.sound_effect_volume
	settings_data.music_volume = data.settings_data.music_volume
	settings_data.ambience_volume = data.settings_data.ambience_volume
	
	#Controls
	settings_data.inverted_controls = data.settings_data.inverted_controls
	settings_data.controller_deadzone = data.settings_data.controller_deadzone


func ApplyLoadedVariablesToOptionManager():
	OptionsManager.fullscreen = settings_data.fullscreen
	OptionsManager.v_sync = settings_data.v_sync
	OptionsManager.screenshake = settings_data.screenshake
	OptionsManager.fps = settings_data.fps
	
	#Audio
	OptionsManager.master_volume = settings_data.master_volume
	OptionsManager.sound_effect_volume = settings_data.sound_effect_volume
	OptionsManager.music_volume = settings_data.music_volume
	OptionsManager.ambience_volume = settings_data.ambience_volume
	
	#Controls
	OptionsManager.inverted_controls = settings_data.inverted_controls
	OptionsManager.controller_deadzone = settings_data.controller_deadzone



func _on_save_button_pressed():
	save_data(SAVE_DIR + SAVE_FILE_NAME)


func _on_load_button_pressed():
	load_data(SAVE_DIR + SAVE_FILE_NAME)
