extends Node2D

@export var current_node : Node2D
@onready var block = $Block
@onready var line_2d = $Line2D
@onready var block_positions = $BlockPositions





func _ready():
	for i in block_positions.get_children():
		line_2d.add_point(i.position)
	



func IndirectHit(_angle):
	_angle = deg_to_rad(_angle)
	var next_node = GetNextNode(_angle)
	if next_node != null and next_node != current_node:
		TweenToNextNode(next_node.position)
		current_node = next_node


func GetNextNode(_angle):
	return current_node.GetNextNode(_angle, block.position)


func TweenToNextNode(tween_end_pos : Vector2):
	var block_pos_tween = create_tween()
	block_pos_tween.tween_property(block, "position", tween_end_pos, 0.5)
