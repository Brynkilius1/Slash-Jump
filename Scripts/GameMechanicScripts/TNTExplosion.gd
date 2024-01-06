extends Area2D


var sword_angle 

var explosion_power = Vector2(0, 250)


func _on_body_entered(body):
	if body == GlobalObjects.player:
		KnockBackPlayer()


func KnockBackPlayer():
	var bounce_power = explosion_power
	bounce_power = bounce_power.rotated(deg_to_rad(sword_angle))
	GlobalObjects.player.velocity = bounce_power
