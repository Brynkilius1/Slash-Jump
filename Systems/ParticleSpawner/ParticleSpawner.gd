extends Node2D

@export var particles : PackedScene

func SpawnParticles(particle_rotation : float = 0, amount : int = -1):
	if particles:
		var p = particles.instantiate()
		
		if amount > -1:
			p.amount = amount
		
		if particle_rotation != 0:
			p.rotation = particle_rotation
		
		p.global_position = global_position
		get_tree().root.get_child(0).add_child(p)
	else:
		print(self, " particle spawner doent have particles!")
