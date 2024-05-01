extends Node2D

@onready var flower_sprites = $FlowerSprites


const FLOWER_POLLEN = preload("res://Scenes/Particles/FlowerPollen.tscn")
const FLOWER_1_HEADS = preload("res://Scenes/Particles/Flower1Heads.tscn")

const FLOWER_1_HEAD_2_IMG = preload("res://Images/Particles/Flower1Head2.png")
var been_hit = false


func _ready():
	flower_sprites.material.set("shader_paramater/position_offset", position.x);
	print("set ", self, "'s position offset to: ", position.x)


func _on_sword_detector_area_entered(area):
	if been_hit == false:
		flower_sprites.frame = 1
		#emit pollen particles
		var f = FLOWER_POLLEN.instantiate()
		f.global_position = global_position
		f.global_position.y -= 8
		f.z_index = 2
		get_tree().current_scene.add_child(f)
		
		#emit flower head particles
		var h = FLOWER_1_HEADS.instantiate()
		h.global_position = global_position
		h.global_position.y -= 8
		h.z_index = 2
		get_tree().current_scene.add_child(h)
		
		var h2 = FLOWER_1_HEADS.instantiate()
		h2.global_position = global_position
		h2.global_position.y -= 8
		h2.texture = FLOWER_1_HEAD_2_IMG
		h2.z_index = 2
		get_tree().current_scene.add_child(h2)
		
		been_hit = true
		
	


func _on_player_detector_body_entered(body):
	if been_hit == false:
		var f = FLOWER_POLLEN.instantiate()
		f.global_position = global_position
		f.global_position.y -= 8
		f.amount = 2
		get_tree().current_scene.add_child(f)






