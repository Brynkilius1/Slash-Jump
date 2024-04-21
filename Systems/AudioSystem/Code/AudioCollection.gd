extends Node2D


func PlayRandomSound():
	
	var random_child = GetRandomAudioChild()
	random_child.pitch_scale = randf_range(0.85, 1.15)
	random_child.play()

func StopCollectionsSound():
	for i in get_children():
		if i.is_in_group("AudioCollection") == false:
			i.stop()


func GetRandomAudioChild():
	var random_child
	while random_child == null:
		random_child = get_children().pick_random()
		if random_child.is_in_group("AudioCollection"):
			random_child = null
	return random_child
