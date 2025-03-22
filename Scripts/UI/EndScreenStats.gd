extends CanvasLayer

@onready var timer_manager = $"../WorldNessecities/TimerManager"
@onready var screen_times_display_label_1 = $ScreenTimesDisplayLabel1
@onready var screen_times_display_label_2 = $ScreenTimesDisplayLabel2
@onready var screen_times_display_label_3 = $ScreenTimesDisplayLabel3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func UpdateRoomClearTimeLabel():
	var current_room_counter = 0
	var final_text : String
	
	for i in timer_manager.rooms_cleared:
		final_text = final_text +  "screen " + str(current_room_counter + 1) + ": " + timer_manager.room_clear_times_array[current_room_counter] + "\n"
		current_room_counter += 1
		if current_room_counter == 9:
			screen_times_display_label_1.text = final_text
			final_text = ""
		elif current_room_counter == 18:
			screen_times_display_label_2.text = final_text
			final_text = ""
		elif current_room_counter == 25:
			final_text = final_text + "final time" + ": " + str(timer_manager.timer_display_label.text)
			screen_times_display_label_3.text = final_text
