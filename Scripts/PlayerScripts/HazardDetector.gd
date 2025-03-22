extends Area2D

const DEATH_PARTICLES = preload("res://Scenes/Particles/death_particles.tscn")

@onready var player_audio_master = $"../PlayerAudioMaster"
@onready var sword_collision = $"../SwordPivot/Extended/Sword/SwordCollision"
@onready var knife_collision = $"../SwordPivot/Extended/Knife/KnifeCollision"

signal player_died #connected to player spawner


func _on_body_entered(body):
	DeathVisuals()
	DeathSound()
	DeathTechnical()
	player_died.emit()


func DeathVisuals():
	get_parent().visible = false
	EmitParticles(DEATH_PARTICLES, global_position)
	get_parent().ShakeCamera(0.6, 0, 2)

func DeathSound():
	player_audio_master.PlayRandomSound("Die")

func DeathTechnical():
	get_parent().has_control = false
	get_parent().TurnOffGravity(true)
	get_parent().velocity = Vector2.ZERO
	#get_parent().max_fall_speed = 0
	#monitoring = false
	#get_parent().gravity = 0
	#sword_collision.monitoring = false
	#knife_collision.monitoring = false
	#player_audio_master.StopCollectionSound("SwingSword")
	
	

func EmitParticles(particles, emit_pos):
	var s = particles.instantiate()
	s.global_position = emit_pos
	
	get_tree().current_scene.get_child(0).get_child(0).add_child(s)
