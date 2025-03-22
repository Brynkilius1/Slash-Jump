extends Node2D

@onready var ui = $UI
@onready var first_option = $UI/Control/VBoxContainer/SwingRaycastPosHit

@onready var swing_raycast_pos_hit_indicator = $Indicators/SwingRaycastPosHitIndicator
@onready var swing_raycast_object_hit_indicator = $Indicators/SwingRaycastObjectHitIndicator
@onready var current_respawn_point_indicator = $Indicators/CurrentRespawnpointIndicator
@onready var expected_line_indicator = $Indicators/ExpectedLineIndicator
@onready var new_control_scheme_toggle = $UI/Control/VBoxContainer/NewControlScheme



var print_object_sword_hit = false

var anti_grav_controls = true

func _ready():
	ui.visible = false
	await get_tree().create_timer(0.1).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	if Input.is_action_just_pressed("ToggleDebug"):
		
		ui.visible = not ui.visible
		first_option.grab_focus()


#Info Updates
func UpdateSwingRaycastIndicators(hit_pos, hit_object, player_sword_rotation):
	swing_raycast_pos_hit_indicator.global_position = hit_pos
	swing_raycast_object_hit_indicator.global_position = hit_object.global_position
	
	
	UpdateExpectedLine(player_sword_rotation)
	
	
	if print_object_sword_hit == true:
		print(hit_object)

func UpdateExpectedLine(player_sword_rotation):
	var line_endpoint_pos = Vector2(0, 200).rotated(player_sword_rotation)
	line_endpoint_pos += GlobalObjects.player.global_position
	
	expected_line_indicator.clear_points()
	expected_line_indicator.add_point(GlobalObjects.player.global_position)
	expected_line_indicator.add_point(line_endpoint_pos)


func UpdateSpawnLocation(pos):
	current_respawn_point_indicator.global_position = pos

#Options
func _on_swing_raycast_pos_hit_toggled(toggled_on):
	swing_raycast_pos_hit_indicator.visible = toggled_on

func _on_swing_raycast_object_hit_toggled(toggled_on):
	swing_raycast_object_hit_indicator.visible = toggled_on

func _on_show_spawn_point_toggled(toggled_on):
	current_respawn_point_indicator.visible = toggled_on
	
func _on_print_swing_raycast_object_hit_toggled(toggled_on):
	print_object_sword_hit = toggled_on

func _on_screenshake_disabled_toggled(toggled_on):
	GlobalObjects.player.screenshake_disabled = toggled_on



func _on_fullscreen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_new_control_scheme_toggled(toggled_on):
	GlobalObjects.player.new_control_feel = toggled_on
	anti_grav_controls = toggled_on


func _on_show_expected_line_toggled(toggled_on):
	expected_line_indicator.visible = toggled_on


func _on_show_player_travel_line_toggled(toggled_on):
	pass # Replace with function body.



