@tool
extends Node2D

@export_range(0, 11) var flower_type : int = 0: set = SetFlowerType



@onready var flower_sprites = $FlowerCode/FlowerSprites
@onready var no_head_flower_sprites = $FlowerCode/NoHeadFlowerSprites



func _ready():
	if Engine.is_editor_hint():
		flower_type = randi_range(0, 11)
	else:
		UpdateFlowerTypeVisuals()


func SetFlowerType(new_variable):
	flower_type = new_variable
	if Engine.is_editor_hint():
		UpdateFlowerTypeVisuals()

func UpdateFlowerTypeVisuals():
	flower_sprites.frame = flower_type
	no_head_flower_sprites.frame = flower_type
