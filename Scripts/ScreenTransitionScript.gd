extends Control

@export var uncover_screen_when_loaded : bool = true

var screen_cover_anim : String = "CoverScreen"
@onready var animation_player = $AnimationPlayer

signal cover_finished

func _ready():
	if uncover_screen_when_loaded == true:
		visible = true
		animation_player.play("LeaveScreen")

func PlayScreenCoverAnim():
	visible = true
	animation_player.play(screen_cover_anim)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == screen_cover_anim:
		cover_finished.emit()
