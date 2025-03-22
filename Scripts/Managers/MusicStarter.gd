extends Node

@export var starting_song : String = "res://Sounds/Music/slashjumpmainthemeprobablymaybe.mp3"

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicMaster.PlaySong(starting_song)
	



