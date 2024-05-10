extends Node2D
@export_category("General Hit Settings")
@export var hit_particles : PackedScene = preload("res://Scenes/Particles/dirt_particles.tscn")
@export var higher_particle_count : int = 5
@export var lower_particle_count : int = 2

@export var shake_camera_when_hit = false

@export var direct_hit_on : bool = true
@export_category("Rumble Settings")
@export_range(0.0, 1.0) var small_motor_rumble = 0.5
@export_range(0.0, 1.0) var big_motor_rumble = 0.5
@export var rumble_duration = 0.1


@export_category("Node Refrences")
@export var audio_master : Node2D


func _ready():
	randomize()
	if OptionsManager.screenshake == false:
		shake_camera_when_hit = false


#Callable Fucntions

func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	if direct_hit_on == true:
		#BetterTerrain.get_cell(self, 0, hit_pos)
		
		if hit_particles != null:
			SwordHitPaticles(hit_pos, sword_angle, player_x_speed)
		PlayHitSound()
		
		if OptionsManager.rumble_enabled:
			Input.start_joy_vibration(0, small_motor_rumble, big_motor_rumble, rumble_duration)
		if shake_camera_when_hit == true:
			ShakeCamera()

func IndirectSwordHit(_angle):
	if get_parent().has_method("HitWithSword") == true:
		get_parent().HitWithSword(_angle)






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
	if audio_master != null:
		audio_master.PlayRandomSound("Hit")
	else:
		print(get_parent(), " has no hit sounds registered!")

func ShakeCamera():
	GlobalObjects.player.ShakeCamera(0.4, 0, 1)


