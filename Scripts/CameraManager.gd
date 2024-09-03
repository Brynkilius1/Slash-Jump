extends Node2D

@export var transition_time : float = 0.5
@export var screen_transistion_upwards_boost = 150
@export var screen_transistion_sideways_boost = 30


@onready var viewport_size : Vector2 = get_viewport_rect().size
#@onready var darkness_solid = null
#@onready var darkness_vignette = null


var respawn_points


var current_screen
var next_screen
var next_screen_darkness

var queued_limit_point_1 : Vector2
var queued_limit_point_2 : Vector2

var current_point_1 : Vector2
var current_point_2 : Vector2


var limit_array

func _ready():
	var top_limit = Vector2(-viewport_size.x /2, 0)
	var bottom_limit = Vector2(viewport_size.x /2, 0)
	var left_limit = Vector2(0, -viewport_size.y /2)
	var right_limit = Vector2(0, viewport_size.y /2)
	
	limit_array = [top_limit, bottom_limit, left_limit, right_limit]
	
	



func UpdateNextScreen(screen, screen_darkness):
	next_screen = screen
	next_screen_darkness = screen_darkness
	UpdateQueuedPoints()

func UpdateQueuedPoints():
	var collision_shape = next_screen.get_node("CollisionShape2D")
	queued_limit_point_1 = (next_screen.global_position + collision_shape.position) + ((collision_shape.shape.size / 2) * collision_shape.scale * next_screen.scale)
	queued_limit_point_2 = (next_screen.global_position + collision_shape.position) - ((collision_shape.shape.size / 2) * collision_shape.scale * next_screen.scale)




func ChangeScreen(screen_exited):
	if GlobalObjects.player.has_control == true: #makes sure the camera doesnt chaneg screens when player is dead
		if next_screen != screen_exited:
			current_screen = next_screen
			
			
			ChangeDarknessLevel(next_screen_darkness)
			ChooseRespawnPoint()
			MoveScreen()
			


func ChooseRespawnPoint():
	respawn_points = current_screen.get_node("RespawnPoints")
	
	var closest_distance : float = 1000.0
	var closest_point : Vector2
	
	
	for i in respawn_points.get_children():
		var temp_distance = i.global_position.distance_to(GlobalObjects.player.global_position)
		if temp_distance < closest_distance:
			closest_distance = temp_distance
			closest_point = i.global_position
	
	
	GlobalVariables.respawn_point = closest_point


func MoveScreen():
	Pause(true)
	SetCameraLimits(queued_limit_point_1, queued_limit_point_2)
	
	if CalculatePlayerLeavingDir() == Vector2(0, -90):
		UpwardsScreenBoost()
	
	var screen_tween = create_tween()
	var tween_end_pos : Vector2 = GlobalObjects.player.global_position
	tween_end_pos = ClampCameraLimit(tween_end_pos)
	
	screen_tween.tween_property(GlobalObjects.camera, "global_position", tween_end_pos, transition_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	GlobalObjects.camera.camera_is_free = true
	
	
	
	await get_tree().create_timer(0.5).timeout
	if PauseMenu.get_child(0).get_child(0).visible == false:
		Pause(false)
	GlobalObjects.camera.camera_is_free = false
	
	




func SetCameraLimits(point_1, point_2):
	current_point_1 = point_1
	current_point_2 = point_2
	
	GlobalVariables.camera_limit_1 = current_point_1 - viewport_size / 2
	GlobalVariables.camera_limit_2 = current_point_2 + viewport_size / 2


func UpwardsScreenBoost():
	if GlobalObjects.player.velocity.y > -screen_transistion_upwards_boost:
		GlobalObjects.player.velocity.y = -screen_transistion_upwards_boost
	if abs(GlobalObjects.player.velocity.x) < screen_transistion_sideways_boost:
		GlobalObjects.player.velocity.x = sign(GlobalObjects.player.velocity.x) * screen_transistion_sideways_boost




func ClampCameraLimit(object_limited : Vector2):
	#clamp camera to the two variables set by GetCameraLimits

	object_limited.x = clamp(object_limited.x, GlobalVariables.camera_limit_2.x, GlobalVariables.camera_limit_1.x) 
	object_limited.y = clamp(object_limited.y, GlobalVariables.camera_limit_2.y, GlobalVariables.camera_limit_1.y)
	return object_limited



func CalculatePlayerLeavingDir():
	var local_player_pos = GlobalObjects.player.global_position - GlobalObjects.camera.global_position
	
	
	if abs(local_player_pos.x) > abs(limit_array[0].x):
		if sign(local_player_pos.x) == -1:
			return limit_array[0]
		else:
			return limit_array[1]
	elif abs(local_player_pos.y) > abs(limit_array[3].y):
		if sign(local_player_pos.y) == -1:
			return limit_array[2]
		else:
			return limit_array[3]




func Pause(pause_: bool):
	if pause_ == true:
		process_mode = Node.PROCESS_MODE_ALWAYS
		GlobalObjects.camera.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
	else:
		process_mode = Node.PROCESS_MODE_INHERIT
		GlobalObjects.camera.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().paused = false

func ChangeDarknessLevel(darkness_level : float):
	pass
	"""
	print("change darkness level to: ", darkness_level)
	var darkness_solid = GlobalObjects.camera.get_child(2)
	var darkness_vignette = GlobalObjects.camera.get_child(1)
	
	
	var color_tween = create_tween()
	color_tween.tween_property(darkness_solid, "color", Color8(0, 0, 0, int(darkness_level * 33)), transition_time)
	#darkness_solid.color.a = (darkness_level * 33) / 255
	#darkness_vignette.material.set_shader_parameter("alpha", 1)
	#darkness_vignette.material.set_shader_parameter("inner_radius", abs((darkness_level * 0.855) - 1))
	#darkness_vignette.material.set_shader_parameter("outer_radius", 1 + darkness_level)
	_create_shader_tween(darkness_vignette, "alpha", darkness_vignette.material.get_shader_parameter("alpha"), darkness_level * 0.5, transition_time)
	_create_shader_tween(darkness_vignette, "inner_radius", darkness_vignette.material.get_shader_parameter("inner_radius"), abs((darkness_level * 0.855) - 1), transition_time)
	_create_shader_tween(darkness_vignette, "outer_radius", darkness_vignette.material.get_shader_parameter("outer_radius"), 2 - darkness_level, transition_time)
	"""
	


func _create_shader_tween(node: Node, shader_property: String, value_start: float, value_end: float, duration: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_method(
	func(value): node.material.set_shader_parameter(shader_property, value),  
		value_start,
		value_end,
		duration
	);
	return tween
