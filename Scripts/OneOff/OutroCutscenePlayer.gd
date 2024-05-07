extends Node2D

@onready var outro_textbox_handler = $OutroTextboxHandler
@onready var bar_transition = $BarTransition
@onready var animation_player = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_cutscene_initiation_area_2d_body_entered(body):
	GlobalObjects.player.has_control = false
	GlobalObjects.player.can_rotate_indicator = false
	await get_tree().create_timer(1.0).timeout
	animation_player.play("TurnAround")
	await get_tree().create_timer(0.7).timeout
	GlobalObjects.player.indicator_pivot.rotation = -1.5
	GlobalObjects.player.swing_dir = -1
	GlobalObjects.player.player_sprite.flip_h = true
	
	outro_textbox_handler.BeginTextbox()
	
	await get_tree().create_timer(1.0).timeout
	animation_player.stop()
	#GlobalObjects.player.can_rotate_sword = false
	
	
	





func _on_bar_transition_cover_finished():
	get_tree().change_scene_to_file("res://Scenes/UI/GameStart/main_menu.tscn")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "TurnAround":
		animation_player.play("OutroWave")
	if anim_name == "PlayerMoveToBench":
		animation_player.play("HavingFunWithPlayer")
		await get_tree().create_timer(3.5).timeout
		bar_transition.PlayScreenCoverAnim()

func _on_outro_textbox_handler_text_finished():
	await get_tree().create_timer(0.7).timeout
	animation_player.play("PlayerMoveToBench")
	GlobalObjects.player.visible = false
