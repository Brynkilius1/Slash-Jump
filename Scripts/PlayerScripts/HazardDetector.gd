extends Area2D

const DEATH_PARTICLES = preload("res://Scenes/Particles/death_particles.tscn")
signal player_died

func _on_body_entered(body):
	DeathVisuals()
	DeathTechnical()
	player_died.emit()


func DeathVisuals():
	get_parent().visible = false
	EmitParticles(DEATH_PARTICLES, global_position)

func DeathTechnical():
	get_parent().has_control = false

func EmitParticles(particles, emit_pos):
	var s = particles.instantiate()
	s.global_position = emit_pos
	
	get_tree().root.get_child(0).add_child(s)
