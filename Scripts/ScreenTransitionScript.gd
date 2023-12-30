extends Control

var screen_cover_anim : String = "CoverScreen"
@onready var animation_player = $AnimationPlayer

signal cover_finished

func _ready():
	visible = true

func PlayScreenCoverAnim():
	animation_player.play(screen_cover_anim)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == screen_cover_anim:
		cover_finished.emit()
