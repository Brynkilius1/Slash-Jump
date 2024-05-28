extends Node2D

@export var play_intro_cutscene = true
@onready var cutscene_animation_player = $CutsceneAnimationPlayer
@onready var player_hammock = $CutsceneObjects/PlayerHammock
@onready var death_transistion_canvas_layer = $"../WorldNessecities/TransitionManager/DeathTransistionCanvasLayer"
@onready var cutscene_camera = $Camera2D


@onready var textbox_handler = $IntroTextboxHandler





# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.first_respawn == true and play_intro_cutscene == true:
		#death_transistion_canvas_layer.visible = false
		PlayCutscene("IntroHammock")
	else:
		player_hammock.play("Fallen")
		cutscene_camera.visible = false

func PlayCutscene(cutscene_name : String):
	cutscene_animation_player.play(cutscene_name)
	await get_tree().create_timer(0.1).timeout
	GlobalObjects.player.visible = false
	GlobalObjects.player.has_control = false
	GlobalObjects.camera.enabled = false


func _on_cutscene_animation_player_animation_finished(anim_name):
	if anim_name == "IntroHammock":
		textbox_handler.BeginTextbox()
	
	if anim_name == "IntroHammockAfterCall":
		print("cutscene ended")
		GlobalObjects.player.visible = true
		GlobalObjects.player.has_control = true
		GlobalObjects.camera.enabled = true
		cutscene_camera.enabled = false
		death_transistion_canvas_layer.visible = true





func _on_intro_textbox_handler_text_finished():
	PlayCutscene("IntroHammockAfterCall")
