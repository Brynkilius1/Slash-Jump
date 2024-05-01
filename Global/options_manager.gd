extends Node

#Audio bus refrences:
var master_bus_index = AudioServer.get_bus_index("Master")
var sound_effect_bus_index = AudioServer.get_bus_index("SoundEffects")
var music_bus_index = AudioServer.get_bus_index("Music")
var ambience_bus_index = AudioServer.get_bus_index("Ambience")


#Options:
#Video:
var fullscreen : bool = false: set = SetFullscreen
var v_sync : bool = false: set = SetVSync
var screenshake : bool = true
var fps : int = 60: set = SetFPS
#region Video Settings set calls (it updates the actual settings when you change the variable)
func SetFullscreen(new_value):
	fullscreen = new_value
	if new_value == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
func SetVSync(new_value):
	v_sync = new_value
	if new_value == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	MaxOutFrameRateIfVSync(new_value)
func MaxOutFrameRateIfVSync(new_value):
	if new_value == true:
		Engine.max_fps = 360
	else:
		Engine.max_fps = fps
func SetFPS(new_value):
	fps = new_value
	Engine.max_fps = new_value

#endregion



#Audio:
var master_volume : int = 60: set = SetMasterVolume
var sound_effect_volume : int = 100: set = SetSoundEffectVolume
var music_volume : int = 100: set = SetMusicVolume
var ambience_volume : = 100: set = SetAmbienceVolume
#region Audio Settings set calls (it updates the actual settings when you change the variable)
func SetMasterVolume(new_value):
	master_volume = new_value
	UpdateVolume(new_value, master_bus_index)
func SetSoundEffectVolume(new_value):
	sound_effect_volume = new_value
	UpdateVolume(new_value, sound_effect_bus_index)
func SetMusicVolume(new_value):
	music_volume = new_value
	UpdateVolume(new_value, music_bus_index)
func SetAmbienceVolume(new_value):
	ambience_volume = new_value
	UpdateVolume(new_value, ambience_bus_index)

func UpdateVolume(volume_value, bus_index):
	#update volume
	volume_value *= 0.25
	volume_value = volume_value - 15
	AudioServer.set_bus_volume_db(bus_index, volume_value)
	print(AudioServer.get_bus_volume_db(bus_index))
#endregion

#Controls:
var inverted_controls : bool = false: set = SetInvertedControls
var controller_deadzone : float = 0.3: set = SetControllerDeadzone
var rumble_enabled : bool = true
var big_swing_button : InputEvent = InputMap.action_get_events("BigSwing")[0]: set = SetBigSwingButton
var big_swing_input_type : String = "InputEventKey": set = SetBigSwingType
var small_swing_button : InputEvent = InputMap.action_get_events("SmallSwing")[0]: set = SetSmallSwingButton
var small_swing_input_type : String = "InputEventKey": set = SetSmallSwingType

#region Video Settings set calls (it updates the actual settings when you change the variable)
func SetInvertedControls(new_value):
	inverted_controls = new_value
	
func SetControllerDeadzone(new_value):
	controller_deadzone = new_value

func SetBigSwingType(new_value):
	print("set big swing type: ", new_value)
	big_swing_input_type = new_value

func SetBigSwingButton(new_value):
	big_swing_button  = new_value
	
	RebindControl("BigSwing", new_value)
	print("GetInputTypeFromAction: ", GetInputTypeFromAction(new_value))
	big_swing_input_type = GetInputTypeFromAction(new_value)

func SetSmallSwingType(new_value):
	small_swing_input_type = new_value

func SetSmallSwingButton(new_value):
	small_swing_button = new_value
	
	RebindControl("SmallSwing", new_value)
	small_swing_input_type = GetInputTypeFromAction(new_value)


func RebindControl(input_name, new_key):
	InputMap.action_erase_events(input_name)
	InputMap.action_add_event(input_name, new_key)
	print("just changed the input map of ", input_name, " to: ", new_key)

func GetInputTypeFromAction(action):
	action = str(action)
	action = action.get_slice(":", 0)
	return action

#endregion
