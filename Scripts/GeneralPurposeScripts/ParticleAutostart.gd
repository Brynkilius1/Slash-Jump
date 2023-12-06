extends Node2D

@export var autostart_target : Node = self

# Called when the node enters the scene tree for the first time.
func _ready():
	autostart_target.emitting = true
