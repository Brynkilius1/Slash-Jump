extends Node2D

@export var decortaion_sprite : Sprite2D

@export var hit_particles_list : Array
@export var enter_area_particles_list : Array


const FLOWER_POLLEN = preload("res://Scenes/Particles/FlowerPollen.tscn")
const FLOWER_1_HEADS = preload("res://Scenes/Particles/Flower1Heads.tscn")

const FLOWER_1_HEAD_2_IMG = preload("res://Images/Particles/Flower1Head2.png")
var been_hit = false


func _on_sword_detector_area_entered(area):
	if been_hit == false:
		decortaion_sprite.frame = 1
		been_hit = true
		
		for i in hit_particles_list:
			SpawnParticles(i, 0, Vector2(0, -8))



func _on_player_detector_body_entered(body):
	if been_hit == false:
		
		for i in enter_area_particles_list:
			SpawnParticles(i, 2, Vector2(0, -8))


func SpawnParticles(particle, amount = 0, position_offset = Vector2.ZERO):
	var f = particle.instantiate()
	f.global_position = global_position
	f.global_position += position_offset
	f.z_index = 2
	if amount != 0:
		f.amount = amount
	
	get_tree().current_scene.add_child(f)

