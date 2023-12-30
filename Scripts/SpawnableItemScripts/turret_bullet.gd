extends Area2D

var speed : float = 100
var bullet_angle : float = 0.0

func _ready():
	rotation = bullet_angle

func _process(delta):
	MoveBullet(delta)

func MoveBullet(delta):
	var travel_distance = speed * delta
	var bullet_movement = Vector2(travel_distance, 0).rotated(bullet_angle)
	position += bullet_movement



func HitWithSword(_angle):
	bullet_angle = deg_to_rad(_angle - 90)


func _on_body_entered(body):
	queue_free()
