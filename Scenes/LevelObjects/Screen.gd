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
	
	
	
	
	
	var first = Vector2(player_local_pos.x, 0) - Vector2(viewport_size.x / 2, 0)
	var second = Vector2(player_local_pos.x, 0) + Vector2(viewport_size.x / 2, 0) 
	var third = Vector2(0, player_local_pos.y) - Vector2(1000, viewport_size.y / 2)
	var fourth = Vector2(0, player_local_pos.y) + Vector2(1000, viewport_size.y / 2)
	
	var distances = [first, second, third, fourth]
	
	var distance_checker = Vector2(1000, 1000)
	var temp_x_or_y = 0
	for i in distances:
		if temp_x_or_y < 3:
			if abs(i.x) < distance_checker.x:
				distance_checker = i
		else:
			if abs(i.y) < distance_checker.x:
				distance_checker = i
		temp_x_or_y += 1
	#print("d checker: ", distance_checker)
	
	var leaving_dir = min(player_local_pos.x - viewport_size.x / 2, player_local_pos.x + viewport_size.x / 2, player_local_pos.y - viewport_size.y / 2, player_local_pos.y + viewport_size.y / 2)
	
	#print(first)
	#print(second)
	#print(third)
	#print(fourth)
	
