extends Control

var current_time_in_sec : float
var running = true
@onready var timer_label = $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if running:
		current_time_in_sec += delta
		timer_label.text = str(snapped(current_time_in_sec, 0.001))

