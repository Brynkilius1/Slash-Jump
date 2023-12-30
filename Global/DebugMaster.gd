extends Node2D

@onready var ui = $UI
@onready var first_option = $UI/Control/VBoxContainer/SwingRaycastPosHit

@onready var swing_raycast_pos_hit_indicator = $Indicators/SwingRaycastPosHitIndicator
@onready var swing_raycast_object_hit_indicator = $Indicators/SwingRaycastObjectHitIndicator



var print_object_sword_hit = false

func _ready():
	pass
	ui.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ToggleDebug"):
		ui.visible = not ui.visible
		first_option.grab_focus()


#Info Updates
func UpdateSwingRaycastIndicators(hit_pos, hit_object):
	swing_raycast_pos_hit_indicator.global_position = hit_pos
	swing_raycast_object_hit_indicator.global_position = hit_object.global_position
	
	if print_object_sword_hit == true:
		print(hit_object)




#Options
func _on_swing_raycast_pos_hit_toggled(toggled_on):
	swing_raycast_pos_hit_indicator.visible = toggled_on

func _on_swing_raycast_object_hit_toggled(toggled_on):
	swing_raycast_object_hit_indicator.visible = toggled_on

func _on_print_swing_raycast_object_hit_toggled(toggled_on):
	print_object_sword_hit = toggled_on

func _on_screenshake_disabled_toggled(toggled_on):
	GlobalObjects.player.screenshake_disabled = toggled_on



func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
