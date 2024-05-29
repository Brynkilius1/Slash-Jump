extends Node2D

var player_entered_area = false

@onready var outro_animation_player = $OutroAnimationPlayer
@onready var outro_textbox_handler = $OutroTextboxHandler


func _on_screen_21_set_next_screen_local(screen):
	outro_animation_player.play("HavingFun")


func _on_cutscene_initiation_area_2d_body_entered(body):
	GlobalObjects.player.velocity.x = 0
	player_entered_area = true
	MusicMaster.PlaySong("res://Sounds/Music/Happy_Hot_Dogs.mp3", 1)
	GlobalObjects.player.has_control = false
	GlobalObjects.player.can_rotate_indicator = false


func CheckIfPlayerEntered():
	if player_entered_area == true:
		player_entered_area = false
		#Makes both friends fall down
		await get_tree().create_timer(1.2).timeout
		outro_animation_player.play("HavingFunFall")
		await get_tree().create_timer(0.8).timeout
		outro_textbox_handler.BeginTextbox()




