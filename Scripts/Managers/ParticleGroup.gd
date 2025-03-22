class_name ParticleGroup
extends Node2D



func EmitParticles():
	for i in get_children():
		if i is GPUParticles2D:
			i.emitting = true
