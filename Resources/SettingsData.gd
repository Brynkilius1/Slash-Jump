extends Resource
class_name SettingsData


#Video
@export var fullscreen : bool = false
@export var v_sync : bool = false
@export var screenshake : bool = true
@export var fps : int = 60


#Audio:
@export var master_volume : int = 60
@export var sound_effect_volume : int = 100
@export var music_volume : int = 100
@export var ambience_volume : = 100

#Controls:
@export var inverted_controls : bool = false
@export var controller_deadzone : float = 0.3
@export var big_swing_button : InputEvent = InputMap.action_get_events("BigSwing")[0]
@export var big_swing_input_type : String = "InputEventKey"
@export var small_swing_button : InputEvent = InputMap.action_get_events("SmallSwing")[0]
@export var small_swing_input_type : String = "InputEventKey"
