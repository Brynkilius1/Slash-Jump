extends Area2D

const DEATH_PARTICLES = preload("res://Scenes/Particles/death_particles.tscn")

@onready var player_audio_master = $"../PlayerAudioMaster"

signal player_died #connected to player spawner


func _on_body_entered(body):
	DeathVisuals()
	DeathSound()
	DeathTechnical()
	player_died.emit()


func DeathVisuals():
	get_parent().visible = false
	EmitParticles(DEATH_PARTICLES, global_position)

func DeathSound():
	player_audio_master.PlayRandomSound("Die")

func DeathTechnical():
	get_parent().has_control = false
	get_parent().velocity = Vector2.ZERO
	

func EmitParticles(particles, emit_pos):
	var s = particles.instantiate()
	s.global_position = emit_pos
	
	get_tree().current_scene.add_child(s)
