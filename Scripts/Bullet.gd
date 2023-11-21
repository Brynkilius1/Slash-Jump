extends Area2D


var speed = 4
var direction = Vector2.ZERO
var velocity = Vector2.ZERO


func _ready():
	velocity = direction * speed


func _physics_process(delta):
	position += velocity

func Change_Direction(changed_dir):
	velocity = Vector2.UP.rotated(changed_dir) * speed
	



func _on_body_entered(body):
	queue_free()
