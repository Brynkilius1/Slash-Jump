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
			"controller_deadzone": OptionsManager.controller_deadzone,
			"rumble_enabled": OptionsManager.rumble_enabled,
			"big_swing_button": OptionsManager.big_swing_button,
			"big_swing_input_type": OptionsManager.big_swing_button ,
			"small_swing_button": OptionsManager.small_swing_button,
			"small_swing_input_type": OptionsManager.small_swing_button
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
	settings_data.rumble_enabled = data.settings_data.rumble_enabled
	settings_data.big_swing_input_type = data.settings_data.big_swing_input_type
	settings_data.small_swing_input_type = data.settings_data.small_swing_input_type
	
	print("big swing input type: ",settings_data.big_swing_input_type)
	LoadKeybinds(data.settings_data)
	#settings_data.big_swing_button = data.settings_data.big_swing_button
	#settings_data.small_swing_button = data.settings_data.small_swing_button


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
	OptionsManager.rumble_enabled = settings_data.rumble_enabled
	OptionsManager.big_swing_input_type = settings_data.big_swing_input_type
	OptionsManager.big_swing_button = settings_data.big_swing_button
	OptionsManager.small_swing_input_type = settings_data.small_swing_input_type
	OptionsManager.small_swing_button = settings_data.small_swing_button
	print("loaded big swing input type: ", settings_data.big_swing_input_type)


func LoadKeybinds(data):
	var loaded_big_swing = ReturnInputEventType(data.big_swing_input_type)
	var loaded_small_swing = ReturnInputEventType(data.small_swing_input_type)

	SetUntypedKeycode(loaded_big_swing, data.big_swing_button)
	SetUntypedKeycode(loaded_small_swing, data.small_swing_button)
	
	settings_data.big_swing_button = loaded_big_swing
	settings_data.small_swing_button = loaded_small_swing

func ReturnInputEventType(type):
	type = GetInputTypeFromAction(type)
	if type == "InputEventKey":
		return InputEventKey.new()
	elif type == "InputEventMouseButton":
		return InputEventMouseButton.new()
	elif type == "InputEventJoypadButton":
		return InputEventJoypadButton.new()
	elif type == "InputEventJoypadMotion":
		return InputEventJoypadMotion.new()
	else:
		print("ReturnInputEventType did not get a proper event type!: ", type)
		return InputEventKey.new()

func GetInputTypeFromAction(action):
	action = str(action)
	action = action.get_slice(":", 0)
	return action

func SetUntypedKeycode(loaded_swing, keycode):
	if loaded_swing is InputEventKey:
		loaded_swing.set_physical_keycode(int(keycode))
	elif loaded_swing is InputEventMouseButton:
		keycode = keycode.get_slice(":", 1)
		keycode = keycode.get_slice(",", 0)
		loaded_swing.set_button_index(int(keycode))
	elif loaded_swing is InputEventJoypadButton:
		keycode = keycode.get_slice(":", 1)
		keycode = keycode.get_slice(",", 0)
		loaded_swing.set_button_index(int(keycode))
	elif loaded_swing is InputEventJoypadMotion:
		keycode = keycode.get_slice(":", 1)
		keycode = keycode.get_slice(",", 0)
		loaded_swing.set_axis(int(keycode))
	else:
		print("SaverAndLoader: SetUntypedKeycode recived invalid input!: ", keycode)
func _on_save_button_pressed():
	save_data(SAVE_DIR + SAVE_FILE_NAME)


func _on_load_button_pressed():
	load_data(SAVE_DIR + SAVE_FILE_NAME)
