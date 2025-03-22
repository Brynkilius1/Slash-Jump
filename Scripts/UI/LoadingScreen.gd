extends Node2D

var progress = []
var scene_name
var scene_load_status

@onready var percent_loaded_label = $LoadingDisplayHolder/PercentLoadedLabel
@onready var player_single = $LoadingDisplayHolder/PlayerSingle


# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name = LoadingSceneTransistioner.next_scene
	ResourceLoader.load_threaded_request(scene_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scene_name == null:
		return
	scene_load_status =  ResourceLoader.load_threaded_get_status(scene_name, progress)
	percent_loaded_label.text = str(floor(progress[0] * 100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)
