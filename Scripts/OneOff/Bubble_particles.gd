extends Node2D

@export var spawn_test : bool = true: set = SpawnTest

@onready var big_droplets = $BigDroplets
@onready var mist = $Mist



func SpawnTest(new_var):
	spawn_test = new_var
	SpawnParticles(2.0)

func SpawnParticles(angle, big_amount = -1, small_amount = -1):
	big_droplets.emitting = false
	mist.emitting = false
	await get_tree().create_timer(0.1).timeout
	
	var vectorized_angle = Vector2.UP.rotated(angle)
	big_droplets.process_material.set("direction", vectorized_angle)
	mist.process_material.set("direction", vectorized_angle)
	
	if big_amount > -1:
		big_droplets.amount = big_amount
	if small_amount > -1:
		mist.amount = small_amount
	
	big_droplets.emitting = true
	mist.emitting = true
