extends Control

@export var uncover_screen_when_loaded : bool = true
@export var black = false#: set = ChangeToBlack

var screen_cover_anim : String = "CoverScreen"
@onready var animation_player = $AnimationPlayer
@onready var bar_holder = $BarHolder
@onready var black_bar_holder = $BlackBarHolder
@onready var shader_color_rect = $ShaderColorRect

signal cover_finished

func _ready():
	if uncover_screen_when_loaded == true:
		PlayScreenUncoverAnim()
		

func PlayScreenUncoverAnim():
	visible = true
	animation_player.play("LeaveScreen")

func PlayScreenCoverAnim():
	visible = true
	animation_player.play(screen_cover_anim)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == screen_cover_anim:
		cover_finished.emit()

func ChangeToBlack(new_value):
	black = new_value
	bar_holder.visible = not black
	shader_color_rect.visible = not black
	black_bar_holder.visible = black
