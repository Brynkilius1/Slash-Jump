extends Label




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = str(Engine.get_frames_per_second())
