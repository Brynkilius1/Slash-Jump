extends Node

var current_ms : float
var current_time_in_sec : int = 0

var room_clear_times_array = []
var rooms_cleared = []
var split_rooms_array = ["Screen29", "Screen4", "Screen8", "Screen25", "Screen12", "Screen23", "Screen19"]
var changed_timer_size = false

@export var running = false
@onready var timer_display_label = $Control/TimerDisplayLabel
@onready var split_display_label = $Control/SplitDisplayLabel
@onready var camera_manager = %CameraManager
@onready var timer_ui = $Control/TimerUi

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseMenu.get_child(0).get_child(0).connect("changed_speedrun_timer_visibility_2", UpdateVisibility)
	GlobalVariables.connect("level_end_object_collected", StopTimer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		MsToSec(delta)
		
		var timer_text : String = SecToMinAndHours(current_time_in_sec, current_ms)
		timer_display_label.text = timer_text
		
		if current_time_in_sec == 3600 and changed_timer_size == false:
			changed_timer_size = true
			timer_ui.texture = load("res://Images/UI/TimerUIExpanded.png")

func StopTimer():
	running = false
	timer_display_label.modulate = Color(0.1, 0.5, 1.0, 1.0)

func TimeRoom(room):
	var room_name = room.name
	if rooms_cleared.find(room_name) == -1 and rooms_cleared.find(camera_manager.next_screen.name) == -1 and room_name != camera_manager.next_screen.name:
		#Update list on what rooms are cleared
		rooms_cleared.append(room_name)
		room_clear_times_array.append(SecToMinAndHours(current_time_in_sec, current_ms))
		print("clear time arraY: ", room_clear_times_array)
		#Visually time Split 
		if room.split_timer == true:
			
			split_display_label.text = room_clear_times_array[room_clear_times_array.size() - 1]
			FadeInOutSplit()




func ResetSplitVisuals():
	split_display_label.position = Vector2(4, 2)
	split_display_label.modulate = Color(1.0, 1.0, 1.0, 0.0)


func FadeInOutSplit():
	ResetSplitVisuals()
	var pos_tween = create_tween()
	pos_tween.tween_property(split_display_label, "position", Vector2(4, 14), 0.1).set_ease(Tween.EASE_IN)
	var fade_tween = create_tween()
	fade_tween.tween_property(split_display_label, "modulate", Color.WHITE, 0.2).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(9.0).timeout
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property(split_display_label, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.8).set_ease(Tween.EASE_IN_OUT)

func SecToMinAndHours(seconds : int, miliseconds : float):
	var return_time : String
	if seconds >= 3600:
		return_time += CheckForExtraZero(str(seconds/3600)) #hours
		return_time += ":"
	return_time += CheckForExtraZero(str(fmod(seconds/60, 60))) #minutes
	return_time += ":"
	return_time += CheckForExtraZero(str(fmod(seconds, 60))) # seconds
	
	
	
	var ms = str(snappedf(miliseconds, 0.001))
	ms =  "%.3f" % (miliseconds)
	ms = ms.lstrip("0")
	ms = ms.lstrip("1")
	
	return_time += ms
	
	return return_time

func CheckForExtraZero(new_var : String):
	if float(new_var) < 10:
		new_var = "0" + new_var
	return new_var
	

func MsToSec(delta):
	current_ms += delta
	if current_ms > 1.0:
		current_time_in_sec += 1
		current_ms -= 1.0


func UpdateVisibility():
	print("update timer visibility")
	self.visible = OptionsManager.speedrun_timer
