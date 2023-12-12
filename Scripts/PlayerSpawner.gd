extends Node2D

const PLAYER = preload("res://Scenes/Player.tscn")
var local_player

signal player_died

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnPlayer()
	local_player.get_node("HazardDetector").player_died.connect(PlayerDied)

func PlayerDied():
	player_died.emit()


func SpawnPlayer():
	var p = PLAYER.instantiate()
	p.global_position = GlobalVariables.respawn_point
	add_child(p)
	local_player = p



