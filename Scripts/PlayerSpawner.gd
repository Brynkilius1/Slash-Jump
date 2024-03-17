extends Node2D

const PLAYER = preload("res://Scenes/Player.tscn")
@onready var player_spawn_point = %PlayerSpawnPoint
@export var spawn_player : bool = true

var local_player

signal player_died #connected to transition manager

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawn_player == true:
		FirstRespawnCheck()
		SpawnPlayer()
		local_player.get_node("HazardDetector").player_died.connect(PlayerDied)
		local_player.player_died.connect(PlayerDied)
	
	


func FirstRespawnCheck():
	if GlobalVariables.first_respawn == true:
		GlobalVariables.respawn_point = player_spawn_point.global_position
		GlobalVariables.first_respawn = false

func PlayerDied():
	player_died.emit()


func SpawnPlayer():
	var p = PLAYER.instantiate()
	p.global_position = GlobalVariables.respawn_point
	add_child(p)
	local_player = p



