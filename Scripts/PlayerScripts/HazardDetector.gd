extends Area2D

signal player_died

func _on_body_entered(body):
	player_died.emit()
