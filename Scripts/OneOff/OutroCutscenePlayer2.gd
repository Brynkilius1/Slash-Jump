extends Node2D

var player_entered_area = false

@onready var outro_animation_player = $OutroAnimationPlayer
@onready var outro_textbox_handler = $OutroTextboxHandler

@onready var one_way_collision_shape_2d = $PlayerStopperOneWay/CollisionShape2D
@onready var player_stopper_collision_shape_2d = $PayerStopper/CollisionShape2D
@onready var bar_transition = $BarTransition
@onready var player_double = $Decorations/PlayerDouble



func _on_screen_21_set_next_screen_local(screen):
	outro_animation_player.play("HavingFun")


func _on_cutscene_initiation_area_2d_body_entered(body):
	GlobalObjects.player.indicator_pivot.visible = false
	one_way_collision_shape_2d.disabled = false
	GlobalObjects.player.velocity.x = 0
	player_entered_area = true
	MusicMaster.PlaySong("res://Sounds/Music/Happy_Hot_Dogs.mp3", 1)
	GlobalObjects.player.has_control = false
	GlobalObjects.player.can_rotate_indicator = false



func CheckIfPlayerEntered():
	if player_entered_area == true:
		player_entered_area = false
		#Makes both friends fall down
		await get_tree().create_timer(0.6).timeout
		GlobalObjects.player.indicator_pivot.rotation = -1.5
		GlobalObjects.player.sword_pivot.rotation = -1.5
		await get_tree().create_timer(0.6).timeout
		outro_animation_player.play("HavingFunFall")
		await get_tree().create_timer(0.8).timeout
		outro_textbox_handler.BeginTextbox()






func _on_outro_textbox_handler_text_finished():
	player_stopper_collision_shape_2d.disabled = true
	await get_tree().create_timer(0.7).timeout
	GlobalObjects.player.indicator_pivot.rotation = 2.35
	GlobalObjects.player.sword_pivot.rotation = 2.35
	await get_tree().create_timer(0.3).timeout
	GlobalObjects.player.Swing()
	await get_tree().create_timer(0.4).timeout
	GlobalObjects.player.indicator_pivot.rotation = -1.5
	GlobalObjects.player.sword_pivot.rotation = -1.5
	await get_tree().create_timer(1.0).timeout
	GlobalObjects.player.visible = false
	player_double.visible = true
	outro_animation_player.play("StartHavingFunWithPlayer")
	
	


func _on_outro_animation_player_animation_finished(anim_name):
	if anim_name == "StartHavingFunWithPlayer":
		outro_animation_player.play("HavingFunWithPlayer")
		await get_tree().create_timer(4.0).timeout
		bar_transition.visible = true
		bar_transition.PlayScreenCoverAnim()


func _on_bar_transition_cover_finished():
	get_tree().change_scene_to_file("res://Scenes/UI/GameStart/main_menu.tscn")



