extends Node2D

@onready var player_spawner = %PlayerSpawner
@onready var death_transistion_canvas_layer = $DeathTransistionCanvasLayer
var scene_transition
@onready var screen_holder = $"../ScreenHolder"
@export var mechanic_tilemap : TileMap

const SIMPLE_BARS_TRANSITION = preload("res://Scenes/Player/DeathTransitions/SimpleBarsTransition.tscn")

@onready var particle_holder = $"../ParticleHolder"


# Called when the node enters the scene tree for the first time.
func _ready():
	scene_transition = death_transistion_canvas_layer.get_child(0)
	
	if scene_transition != null:
		player_spawner.player_died.connect(PlayerDied)
		scene_transition.cover_finished.connect(ReloadScene)
	else:
		print("Transition manager doesnt have tranistion!")
	
	
func CoverUncoverScreen():
	scene_transition.PlayScreenCoverAnim()
	await get_tree().create_timer(0.35).timeout
	scene_transition.PlayScreenUncoverAnim()


func PlayerDied():
	scene_transition.PlayScreenCoverAnim()

func ReloadScene():
	particle_holder.ClearParticles()
	GlobalObjects.player.global_position = GlobalVariables.respawn_point
	GlobalObjects.player.TurnOffGravity(false)
	await get_tree().create_timer(0.2).timeout
	scene_transition.PlayScreenUncoverAnim()
	GlobalObjects.player.visible = true
	screen_holder.ResetScreenObjects()
	if mechanic_tilemap != null:
		for i in mechanic_tilemap.get_children():
			if i.is_in_group("LevelObject"):
				i.ResetState()
	
	await get_tree().create_timer(0.2).timeout
	GlobalObjects.player.has_control = true
	#get_tree().reload_current_scene()
