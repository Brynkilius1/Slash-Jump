extends CharacterBody2D


@export var bullet_direction = Vector2.ZERO
var bullet = preload("res://Scenes/bullet.tscn")



func _on_shot_timer_timeout():
	var b = bullet.instantiate()
	b.global_position = global_position
	b.direction = bullet_direction
	get_parent().add_child(b)
	$ShotTimer.start()

func Die():
	queue_free()
