extends Node2D


var acceleration_power : Vector2 = Vector2(0, 210)


func HitWithSword(_angle):
	AcceleratePlayer(_angle)


func AcceleratePlayer(_angle):
	var bounce_power = acceleration_power
	bounce_power = bounce_power.rotated(deg_to_rad(_angle))
	GlobalObjects.player.velocity = -bounce_power
