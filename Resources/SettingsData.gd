extends Resource
class_name SettingsData


#Video
@export var fullscreen : bool = false
@export var v_sync : bool = false
@export var speedrun_timer : bool = false
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
@export var rumble_enabled : bool = true
@export var big_swing_button : InputEvent = InputMap.action_get_events("BigSwing")[0]
@export var big_swing_input_type : String = "InputEventKey"
@export var small_swing_button : InputEvent = InputMap.action_get_events("SmallSwing")[0]
@export var small_swing_input_type : String = "InputEventKey"

#Stats
@export var run_count : int = 0
@export var death_count : int = 0
@export var fastest_split_1 : String = ""
@export var fastest_split_2 : String = ""
@export var fastest_split_3 : String = ""
@export var fastest_split_4 : String = ""
@export var fastest_split_5 : String = ""
@export var fastest_split_6 : String = ""
@export var fastest_split_7 : String = ""
@export var fastest_completion : String = ""

