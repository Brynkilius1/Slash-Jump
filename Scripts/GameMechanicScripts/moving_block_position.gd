extends Node2D

class_name moving_block_position

@export var connection_1 : Node2D
@export var connection_2 : Node2D
@export var connection_3 : Node2D
@export var connection_4 : Node2D

@onready var connection_list = [connection_1, connection_2, connection_3, connection_4]

var angle_check_forgiveness = 1.5708/2








func GetNextNode(sword_angle, block_pos):
	for i in connection_list:
		if i != null:
			var angle_vector = i.position - block_pos
			angle_vector = angle_vector.rotated(1.5708)
			var angle_to_connection = Vector2.ZERO.angle_to_point(angle_vector)
			
			var angles_similar = AnglesSimilar(sword_angle, angle_to_connection, angle_check_forgiveness)
			print("block_pos: ", block_pos)
			print("connection point pos: ", i.position)
			print("angle to connection: ", angle_to_connection)
			print("sword angle: ", sword_angle)
			print(" ")
			if angles_similar == true:
				return i











func AnglesSimilar(main_angle, check_angle, angle_forgiveness):
	if check_angle < main_angle + angle_forgiveness and check_angle > main_angle - angle_forgiveness:
		return true
	return false
