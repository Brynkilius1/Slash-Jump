extends Area2D

var bounce_velocity = Vector2(0, -300)
var min_bounce = Vector2(0, -150)

# Called when the node enters the scene tree for the first time.
#func _ready():
	#bounce_velocity = bounce_velocity.rotated(rotation)
	#min_bounce = min_bounce.rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body == GlobalObjects.player:
		var calculated_bounce = body.velocity + bounce_velocity
		
		if calculated_bounce.y < min_bounce.y:
			body.velocity = calculated_bounce
		else:
			body.velocity.y = min_bounce.y
		
