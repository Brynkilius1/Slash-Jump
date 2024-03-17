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
var inverted_controls : bool = false
var controller_deadzone : float = 0.3
