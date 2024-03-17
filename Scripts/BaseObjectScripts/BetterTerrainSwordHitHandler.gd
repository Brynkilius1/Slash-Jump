extends TileMap

var hit_particles_list = [preload("res://Scenes/Particles/dirt_particles.tscn"), load("res://Scenes/Particles/MetalObjectSparks.tscn")]
@export var higher_particle_count : int = 5
@export var lower_particle_count : int = 2

@export var shake_camera_when_hit = false

@export var hit_sound_player : AudioStreamPlayer
@export var hit_sound_list : Array = [preload("res://Sounds/SoundEffects/Player/Sword/SwordHit/breakable wall hit 1.mp3"), preload("res://Sounds/SoundEffects/Player/Sword/SwordHit/sword terrain temp.mp3")]

func _ready():
	randomize()
	if OptionsManager.screenshake == false:
		shake_camera_when_hit = false
	print(self, hit_particles_list[0], hit_particles_list[1])


#Callable Fucntions

func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	
	var hit_terrain = BetterTerrain.get_cell(self, 0, floor(hit_pos/12)) #gets the type of tile at the position you hit
	if hit_terrain == 8: #spikes
		SwordHitPaticles(hit_particles_list[1], hit_pos, sword_angle, player_x_speed)
		HitTilemap(hit_sound_list[1], 13, true)
	else:# hit_terrain == 2 or hit_terrain == 3: #grass/autumn grass
		SwordHitPaticles(hit_particles_list[0], hit_pos, sword_angle, player_x_speed)
		HitTilemap(hit_sound_list[0], 0, false)
	
	





func IndirectSwordHit(_angle):
	if get_parent().has_method("HitWithSword") == true:
		get_parent().HitWithSword(_angle)



func HitTilemap(hit_sound, volume, camera_shake : bool):
	
	PlayHitSound(hit_sound, volume)
	if camera_shake == true:
		ShakeCamera()





func SwordHitPaticles(particle_type, hit_pos : Vector2, sword_angle, player_x_speed):
	EmitSwordHitParticles(particle_type, higher_particle_count, player_x_speed, hit_pos, false)
	EmitSwordHitParticles(particle_type, lower_particle_count, player_x_speed, hit_pos, true)
func EmitSwordHitParticles(particle_type, amount, player_x_speed, emit_location, flipped : bool):
	
	var p = particle_type.instantiate()
	
	var emit_direction = sign(player_x_speed)
	if flipped == true:
		emit_direction *= -1
	
	if emit_direction == 1:
		p.scale.x = -1
	
	p.amount = amount
	p.global_position = emit_location
	get_tree().root.get_child(0).add_child(p)

func PlayHitSound(hit_sound, volume):
	if hit_sound_player != null:
		hit_sound_player.stream = hit_sound
		hit_sound_player.volume_db = volume
		hit_sound_player.pitch_scale = randf_range(0.9, 1.1)
		hit_sound_player.play()
	else:
		print(self, " doesnt have a hit sound player connected!")
	
	
	

func ShakeCamera():
	if OptionsManager.screenshake == true:
		GlobalObjects.player.ShakeCamera(0.4, 0, 1)


