extends Node2D

@export var respawn_time : float = 1.0
@export var respawning_object : Node2D
@export var respawn_function : String

var respawn_timer = Timer.new()


#Externaly callable functions
func StartRespawn():
	CallDisableFunction(true)
	respawn_timer.start(respawn_time)




#Local Functions
func _ready():
	SetUpRespawnTimer()


func RespawnTimerTimeout():
	CallDisableFunction(false)


	

func SetUpRespawnTimer():
	respawn_timer.connect("timeout", RespawnTimerTimeout)
	respawn_timer.one_shot = true
	add_child(respawn_timer)
	

func CallDisableFunction(disable_object):
	var respawning_object_callable = Callable(respawning_object, respawn_function)
	respawning_object_callable.call(disable_object)
