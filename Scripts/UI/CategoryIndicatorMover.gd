extends Control

@onready var video_sword_indicator = $"../SettingsHolder/VBoxContainer/CategoryMarginContainer/VideoSettings/SwordIndicatorMover/SwordIndicator"
@onready var audio_sword_indicator = $"../SettingsHolder/VBoxContainer/CategoryMarginContainer/AudioSettings/SwordIndicatorMover/SwordIndicator"
@onready var control_sword_indicator = $"../SettingsHolder/VBoxContainer/CategoryMarginContainer/ContolSettings/SwordIndicatorMover/SwordIndicator"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SwapOutAndMoveSwordIndicator(previous_sword_indicator, new_sword_indicator_number):
	var sword_indicator
	match new_sword_indicator_number:
		0:
			sword_indicator = video_sword_indicator
		1:
			sword_indicator = audio_sword_indicator
		2:
			sword_indicator = control_sword_indicator
	
	print("new sword indicator pos: ", sword_indicator.position)
	print("old sword indicator pos: ", previous_sword_indicator.position)
	sword_indicator.position = previous_sword_indicator.position
	TweenSelectionSwordPos(-22, 31, sword_indicator)



func TweenSelectionSwordPos(button, pos, sword_indicator):
	TweenSelectionSwordPosY(button, sword_indicator)
	TweenSelectionSwordPosX(pos, sword_indicator)

func TweenSelectionSwordPosY(button, sword_indicator):
	if button is int:
		var sword_tween = create_tween()
		sword_tween.tween_property(sword_indicator, "global_position:y",  button, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		if button.global_position.y != 0:
			var sword_tween = create_tween()
			sword_tween.tween_property(sword_indicator, "global_position:y",  button.global_position.y + 8, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)


func TweenSelectionSwordPosX(pos, sword_indicator):
	var sword_tween = create_tween()
	sword_tween.tween_property(sword_indicator, "global_position:x",  pos, 0.04).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

