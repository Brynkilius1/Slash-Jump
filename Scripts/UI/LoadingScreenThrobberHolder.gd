extends Node2D

const ROTATION_SPEED = 2
@onready var player_throbber = $PlayerThrobber
@onready var percent_loaded_label = $PercentLoadedLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(player_throbber, "modulate", Color.WHITE, 0.4)
	await get_tree().create_timer(3.0).timeout
	var percent_fade_in_tween = create_tween()
	percent_fade_in_tween.tween_property(percent_loaded_label, "modulate", Color.WHITE, 1.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_throbber.rotation += ROTATION_SPEED * delta
