extends Area2D

@onready var collision_shape = $CollisionShape2D
@onready var viewport_size : Vector2 = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	GlobalObjects.camera.queued_limit_point_1 = global_position + ((collision_shape.shape.size / 2) * collision_shape.scale * scale)
	GlobalObjects.camera.queued_limit_point_2 = global_position - ((collision_shape.shape.size / 2) * collision_shape.scale * scale)


func _on_body_exited(body):
	#if the object calling the screen change is already on screen then it refuses
	if GlobalObjects.camera.queued_limit_point_1 != global_position + ((collision_shape.shape.size / 2) * collision_shape.scale * scale):
		CalculatePlayerLeavingDir()
		GlobalObjects.camera.ChangeScreen()

func CalculatePlayerLeavingDir():
	#make it local to the screen you're leaving
	var player_local_pos = GlobalObjects.player.global_position - GlobalObjects.camera.global_position
	var player_distance_to_center : Vector2 = player_local_pos
	#take player pos and add the negative sign of its local pos times the screens width
	player_distance_to_center.x += -sign(player_local_pos.x) * (viewport_size.x / 2)
	player_distance_to_center.y += -sign(player_local_pos.y) * (viewport_size.y / 2)
	
	print(player_distance_to_center)
	
