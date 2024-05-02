extends GPUParticles2D

@export var flower_type : int = 0



func _ready():
	print("flower type is: ", flower_type)
	var flower_type_under_one : float = 1.0/12.0 * flower_type
	print("flower head color is: ", flower_type_under_one)
	process_material = process_material.duplicate()
	process_material.set("anim_offset_min", flower_type_under_one)
	process_material.set("anim_offset_max", flower_type_under_one)



