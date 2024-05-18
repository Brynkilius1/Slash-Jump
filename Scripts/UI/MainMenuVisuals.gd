extends Control

@onready var start_button = $"../Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/StartButton"
@onready var settings_button = $"../Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/SettingsButton"
@onready var credits_button = $"../Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/CreditsButton"
@onready var quit_button = $"../Menu/Menu/MainMenuButtons/MarginContainer/VBoxContainer2/MarginContainer/VBoxContainer/QuitButton"



@onready var selection_swords = $SelectionSwords

func _ready():
	selection_swords.global_position.y = start_button.global_position.y
	selection_swords.width = 31


#Move the Sword indicators
func _on_start_button_focus_entered():
	TweenSelectionSwordPos(start_button, 31)


func _on_settings_button_focus_entered():
	TweenSelectionSwordPos(settings_button, 47)


func _on_credits_button_focus_entered():
	TweenSelectionSwordPos(credits_button, 41)


func _on_quit_button_focus_entered():
	TweenSelectionSwordPos(quit_button, 24)




func TweenSelectionSwordPos(button, width):
	TweenSelectionSwordPosX(button)
	TweenSelectionSwordPosY(width)


func TweenSelectionSwordPosX(button):
	
	var sword_tween = create_tween()
	sword_tween.tween_property(selection_swords, "global_position:y",  button.global_position.y, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func TweenSelectionSwordPosY(width):
	var sword_tween = create_tween()
	sword_tween.tween_property(selection_swords, "width",  width, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
