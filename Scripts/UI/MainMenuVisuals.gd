extends Control

@onready var start_button = $"../Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/StartButton"
@onready var settings_button = $"../Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/SettingsButton"
@onready var credits_button = $"../Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/CreditsButton"
@onready var quit_button = $"../Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/QuitButton"



@onready var selection_swords = %SelectionSwords

@onready var backround_camera_2d = $"../../../BackroundCamera2D"

@onready var audio_master = $"../../AudioMaster"


"""
func _ready():
	await get_tree().create_timer(0.1).timeout
	selection_swords.global_position.y = start_button.global_position.y
	selection_swords.width = 31
"""

#Move the Sword indicators
func _on_start_button_focus_entered():
	if start_button.global_position.y != 0:
		TweenSelectionSwordPos(start_button, 31)
		TweenBackroundCamera(78)
		audio_master.PlayRandomSound("MenuHover")
func _on_start_button_mouse_entered():
	if start_button.global_position.y != 0:
		TweenSelectionSwordPos(start_button, 31)
		TweenBackroundCamera(78)
		audio_master.PlayRandomSound("MenuHover")


func _on_settings_button_focus_entered():
	TweenSelectionSwordPos(settings_button, 47)
	TweenBackroundCamera(90)
	audio_master.PlayRandomSound("MenuHover")
func _on_settings_button_mouse_entered():
	TweenSelectionSwordPos(settings_button, 47)
	TweenBackroundCamera(90)
	audio_master.PlayRandomSound("MenuHover")


func _on_credits_button_focus_entered():
	TweenSelectionSwordPos(credits_button, 41)
	TweenBackroundCamera(102)
	audio_master.PlayRandomSound("MenuHover")
func _on_credits_button_mouse_entered():
	TweenSelectionSwordPos(credits_button, 41)
	TweenBackroundCamera(102)
	audio_master.PlayRandomSound("MenuHover")


func _on_quit_button_focus_entered():
	TweenSelectionSwordPos(quit_button, 24)
	TweenBackroundCamera(114)
	audio_master.PlayRandomSound("MenuHover")
func _on_quit_button_mouse_entered():
	TweenSelectionSwordPos(quit_button, 24)
	TweenBackroundCamera(114)
	audio_master.PlayRandomSound("MenuHover")



func TweenSelectionSwordPos(button, width):
	TweenSelectionSwordPosX(button)
	TweenSelectionSwordPosY(width)


func TweenSelectionSwordPosX(button):
	print("selecetionswords trying to move to: ", button)
	var sword_tween = create_tween()
	sword_tween.tween_property(selection_swords, "global_position:y",  button.global_position.y, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func TweenSelectionSwordPosY(width):
	var sword_tween = create_tween()
	sword_tween.tween_property(selection_swords, "width",  width, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)



func TweenBackroundCamera(y_pos):
	print("tween camera")
	var camera_tween = create_tween()
	camera_tween.tween_property(backround_camera_2d, "global_position:y",  y_pos, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)












