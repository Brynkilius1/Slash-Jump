extends Node2D

@export var dissapear_time := 1.5
@export var dissapear_target : Node = self


var disapear_timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	disapear_timer.connect("timeout", DisapearTimeout)
	add_child(disapear_timer)
	disapear_timer.start(dissapear_time)


func DisapearTimeout():
	dissapear_target.queue_free()
