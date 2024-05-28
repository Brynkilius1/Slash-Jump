extends Control

@onready var big_swing_icon = $"../SwingSelector/ChangeSwordSwingButton/BigSwingIcon"
@onready var small_swing_icon = $"../SwingSelector/ChangeKnifeSwingButton/SmallSwingIcon"

func ChangeBigSwingIcon(event):
	print("big event: ", event)
	var returned_icon = ReturnButtonIcon(event)
	if returned_icon:
		big_swing_icon.texture = returned_icon
	else:
		big_swing_icon.texture = load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Down.png")

func ChangeSmallSwingIcon(event):
	print("small event: ", event)
	var returned_icon = ReturnButtonIcon(event)
	if returned_icon:
		small_swing_icon.texture = returned_icon
	else:
		small_swing_icon.texture = load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Right.png")
	


func ReturnButtonIcon(event):
	if event is InputEventJoypadButton:
		return CheckButtons(event.button_index)
	elif event is InputEventJoypadMotion:
		return CheckBumpers(event.axis)
	else:
		print("ReturnButtonIcon got invalid event: ", event)
		return null
	

func CheckButtons(button_index):
	match button_index:
		0:#Face buttons
			return load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Down.png")
		1:
			return load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Right.png")
		2:
			return load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Left.png")
		3:
			return load("res://Images/UI/RebindMenu/ButtonImages/FButtons_Up.png")
		7:#Sticks pressed
			return load("res://Images/UI/RebindMenu/ButtonImages/Stick_Left_Pressed.png")
		8:
			return load("res://Images/UI/RebindMenu/ButtonImages/Stick_Right_Pressed.png")
		9: #Bumpers
			return load("res://Images/UI/RebindMenu/ButtonImages/Trigger_Left.png")
		10:
			return load("res://Images/UI/RebindMenu/ButtonImages/TriggerRight.png")
		11:#Directional buttons
			return load("res://Images/UI/RebindMenu/ButtonImages/Dpad_Up.png")
		12:
			return load("res://Images/UI/RebindMenu/ButtonImages/Dpad_Down.png")
		13:
			return load("res://Images/UI/RebindMenu/ButtonImages/Dpad_Left.png")
		14:
			return load("res://Images/UI/RebindMenu/ButtonImages/Dpad_Right.png")

func CheckBumpers(axis_index):
	match axis_index:
		4:
			return load("res://Images/UI/RebindMenu/ButtonImages/Bumper_Left.png")
		5:
			return load("res://Images/UI/RebindMenu/ButtonImages/Bumper_Right.png")
