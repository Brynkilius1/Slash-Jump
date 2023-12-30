extends Camera2D

var limit_point_1 : Vector2 = Vector2.ZERO
var limit_point_2 : Vector2 = Vector2.ZERO


var camera_is_free = false

@onready var viewport_size : Vector2 = get_viewport_rect().size



func _ready():
	GlobalObjects.camera = self




func _physics_process(delta):
	if camera_is_free == false:
		FollowPlayer()
		global_position = EnforceCameraLimit(global_position)

func FollowPlayer():
	global_position = GlobalObjects.player.global_position

func EnforceCameraLimit(object_limited : Vector2):
	#clamp camera to the two variables set by GetCameraLimits
	object_limited.x = clamp(object_limited.x, GlobalVariables.camera_limit_2.x, GlobalVariables.camera_limit_1.x) 
	object_limited.y = clamp(object_limited.y, GlobalVariables.camera_limit_2.y, GlobalVariables.camera_limit_1.y)
	return object_limited
