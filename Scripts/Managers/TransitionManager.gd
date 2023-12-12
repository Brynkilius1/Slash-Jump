extends Node2D

@onready var player_spawner = %PlayerSpawner
@onready var death_transistion_canvas_layer = $DeathTransistionCanvasLayer
var scene_transition

const SIMPLE_BARS_TRANSITION = preload("res://Scenes/Player/DeathTransitions/SimpleBarsTransition.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	scene_transition = death_transistion_canvas_layer.get_child(0)
	
	if scene_transition != null:
		player_spawner.player_died.connect(PlayerDied)
		scene_transition.cover_finished.connect(ReloadScene)
	else:
		print("Transition manager doesnt have tranistion!")
	



func PlayerDied():
	scene_transition.PlayScreenCoverAnim()

func ReloadScene():
	get_tree().reload_current_scene()
