extends Timer

@export var delete_time : float
@export var delete_target : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	wait_time = delete_time
	start()




func _on_timeout():
	delete_target.queue_free()
