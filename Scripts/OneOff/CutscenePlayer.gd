extends Node2D

var confirm_menu_visible = false
@export var play_intro_cutscene = true

@onready var cutscene_animation_player = $CutsceneAnimationPlayer
@onready var player_hammock = $CutsceneObjects/PlayerHammock
@onready var death_transistion_canvas_layer = $"../WorldNessecities/TransitionManager/DeathTransistionCanvasLayer"
@onready var cutscene_camera = $Camera2D
@onready var skip_cutscene_confirm_label = $Camera2D/SkipCutsceneConfirmLabel
@onready var timer_manager = $"../WorldNessecities/TimerManager"
@onready var transition_manager = $"../WorldNessecities/TransitionManager"



@onready var textbox_handler = $IntroTextboxHandler




# Called when the node enters the scene tree for the first time.
func _ready():
	PauseMenu.get_child(0).get_child(0).skip_cutscene.connect(SkipCutscene)
	print("play cutcene")
	print("first respawn: ", GlobalVariables.first_respawn)
	print("play_intro_cutscene: ", play_intro_cutscene)
	if GlobalVariables.first_respawn == true and play_intro_cutscene == true:
		
		#death_transistion_canvas_layer.visible = false
		PlayCutscene("IntroHammock")
		GlobalVariables.cutscene_playing = 1
	else:
		player_hammock.play("Fallen")
		cutscene_camera.visible = false
		#timer_manager.running = true

func PlayCutscene(cutscene_name : String):
	cutscene_animation_player.play(cutscene_name)
	await get_tree().create_timer(0.1).timeout
	GlobalObjects.player.visible = false
	GlobalObjects.player.has_control = false
	GlobalObjects.camera.enabled = false


func _on_cutscene_animation_player_animation_finished(anim_name):
	if anim_name == "IntroHammock":
		textbox_handler.BeginTextbox()
	
	if anim_name == "IntroHammockAfterCall" or anim_name == "SkipCutscene":
		GlobalObjects.player.visible = true
		GlobalVariables.cutscene_playing = 0
		if anim_name == "SkipCutscene":
			await get_tree().create_timer(0.25).timeout
		
		
		print("cutscene ended")
		
		GlobalObjects.player.has_control = true
		
		GlobalObjects.camera.enabled = true
		death_transistion_canvas_layer.visible = true
		MusicMaster.PlaySong("res://Sounds/Music/slashjumpmainthemeprobablymaybe.mp3")
		timer_manager.running = true
		
		await get_tree().create_timer(0.1).timeout
		cutscene_camera.enabled = false
		textbox_handler.EndDialouge()
	





func SkipCutscene(cutscene_number):
	if cutscene_number == 1:
		transition_manager.CoverUncoverScreen()
		await get_tree().create_timer(0.35).timeout
		cutscene_animation_player.play("SkipCutscene")


func _on_intro_textbox_handler_text_finished():
	if GlobalVariables.cutscene_playing == 0:
		return
	PlayCutscene("IntroHammockAfterCall")
