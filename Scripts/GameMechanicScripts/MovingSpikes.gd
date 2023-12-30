extends StaticBody2D

@export var start_with_spikes_active = false

@onready var spike_moving_animation_player = $SpikeMovingAnimationPlayer
@onready var spike_move_timer = $SpikeMoveTimer

var spikes_out = false



#Sword Hit
func HitWithSword(_angle):
	SwapSpikes()


func _ready():
	if start_with_spikes_active == true:
		SpikesOut()

func SwapSpikes():
	if spikes_out == false:
		SpikesOut()
	else:
		SpikesIn()
func SpikesIn():
	spike_moving_animation_player.play("SpikesIn")
	spikes_out = false
func SpikesOut():
	spike_moving_animation_player.play("SpikesOut")
	spikes_out = true











