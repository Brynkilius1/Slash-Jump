extends TileMap

@export var hit_particles : PackedScene = preload("res://Scenes/Particles/dirt_particles.tscn")
@export var higher_particle_count : int = 5
@export var lower_particle_count : int = 2

@export var shake_camera_when_hit : bool = false

@onready var hit_sounds = $SoundEffects/Hit



func _ready():
	randomize()


func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	SwordHitPaticles(hit_pos, sword_angle, player_x_speed)
	PlayHitSound()
	if shake_camera_when_hit == true:
		ShakeCamera()






func SwordHitPaticles(hit_pos : Vector2, sword_angle, player_x_speed):
	EmitSwordHitParticles(higher_particle_count, player_x_speed, hit_pos, false)
	EmitSwordHitParticles(lower_particle_count, player_x_speed, hit_pos, true)
func EmitSwordHitParticles(amount, player_x_speed, emit_location, flipped : bool):
	
	var p = hit_particles.instantiate()
	
	var emit_direction = sign(player_x_speed)
	if flipped == true:
		emit_direction *= -1
	
	if emit_direction == 1:
		p.scale.x = -1
	
	p.amount = amount
	p.global_position = emit_location
	get_tree().root.get_child(0).add_child(p)

func PlayHitSound():
	var random_child = hit_sounds.get_child(randi_range(0, hit_sounds.get_child_count()) - 1)
	random_child.pitch_scale = randf_range(0.9, 1.1)
	random_child.play()

func ShakeCamera():
	GlobalObjects.player.ShakeCamera(0.4, 0, 1)
