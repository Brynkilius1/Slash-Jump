extends Camera2D

@export var transition_time : float = 0.01

var queued_limit_point_1 : Vector2
var queued_limit_point_2 : Vector2

var limit_point_1 : Vector2 = Vector2.ZERO
var limit_point_2 : Vector2 = Vector2.ZERO


var camera_is_free = false

@onready var viewport_size : Vector2 = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalObjects.camera = self
	print("veiwport: ", viewport_size)


func ChangeScreen():
	var screen_tween = create_tween()
	var tween_end_pos : Vector2 = global_position
	
	screen_tween.tween_property(self, "global_position", tween_end_pos, transition_time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	camera_is_free = true
	
	
	await screen_tween.finished
	camera_is_free = false
	GetCameraLimits(queued_limit_point_1, queued_limit_point_2)


func GetCameraLimits(point_1, point_2):
	limit_point_1 = point_1 - viewport_size / 2
	limit_point_2 = point_2 + viewport_size / 2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if camera_is_free == false:
		FollowPlayer()
		global_position = EnforceCameraLimit(global_position)
	

func FollowPlayer():
	global_position = GlobalObjects.player.global_position


func EnforceCameraLimit(object_limited : Vector2):
	#clamp camera to the two variables set by GetCameraLimits
	object_limited.x = clamp(object_limited.x, limit_point_2.x, limit_point_1.x) 
	object_limited.y = clamp(object_limited.y, limit_point_2.y, limit_point_1.y)
	return object_limited
