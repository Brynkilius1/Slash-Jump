extends Node2D

@onready var main_music_player = %MainMusicPlayer
@onready var fade_music_player = %FadeMusicPlayer

@export var starting_song : AudioStream


# Called when the node enters the scene tree for the first time.
func _ready():
	main_music_player.stream = starting_song
	main_music_player.play()


func PlaySong(song, transition_type = 0): #Input a song to play
	song = load(song)
	
	#Transitions:
	if transition_type == 1: #1 is fade in/out
		if  main_music_player.stream:
			FadeInOut(song)
	
	
	#Play the songs
	main_music_player.stream = song
	main_music_player.play()


func FadeInOut(song):
	#Set fade player to same song and pos of main player and tween it downwards
	fade_music_player.stream = main_music_player.stream
	fade_music_player.play(main_music_player.get_playback_position())
	fade_music_player.volume_db = -5
	var down_volume_tween = create_tween()
	down_volume_tween.tween_property(fade_music_player, "volume_db", -60, 1.5)
	
	print("fade player is playing: ", fade_music_player.stream)
	print("main player is playing: ", main_music_player.stream)
	
	
	#
	main_music_player.stream = song
	main_music_player.volume_db = -60
	main_music_player.play()
	var up_volume_tween = create_tween()
	up_volume_tween.tween_property(main_music_player, "volume_db", -5, 1.2)
	
	await down_volume_tween.finished
	fade_music_player.stop()


func _on_main_music_player_finished(): #makes the song loop
	main_music_player.play()
