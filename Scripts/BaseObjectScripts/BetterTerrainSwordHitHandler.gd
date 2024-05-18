extends TileMap

const DUSTCLOUDS = preload("res://Scenes/Particles/dustclouds.tscn")
var hit_particles_list = [preload("res://Scenes/Particles/dirt_particles.tscn"), load("res://Scenes/Particles/ParticleTests/SpikesSparks.tscn"), load("res://Scenes/Particles/StoneHitPatricles.tscn"), load("res://Scenes/Particles/wood_particles.tscn")]
@export var higher_particle_count : int = 4
@export var lower_particle_count : int = 2

@export var shake_camera_when_hit = false


@onready var audio_master = $AudioMaster

func _ready():
	randomize()
	if OptionsManager.screenshake == false:
		shake_camera_when_hit = false
	print(self, hit_particles_list[0], hit_particles_list[1])
	
	


#Callable Fucntions

func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	
	var hit_tile = floor(hit_pos/12)
	if sword_angle < -0.7 and sword_angle > -2.2:
		hit_tile.x -= 1 
		print("moved to left")
	
	var hit_terrain = CheckTileTerrainType(hit_tile)  #gets the type of tile at the position you hit
	
	if hit_terrain == 8 or hit_terrain == 10: #spikes
		SwordHitPaticles(hit_particles_list[1], hit_pos, sword_angle, player_x_speed)
		HitTilemap("SpikeHit", 13, true)
		ControllerRumble(0, 1.0, 0.9, 0.15)
	elif hit_terrain == 2 or hit_terrain == 3: #grass/autumn grass
		SwordHitPaticles(hit_particles_list[0], hit_pos, sword_angle, player_x_speed)
		EmitParticles(DUSTCLOUDS, -1, hit_pos, false)
		HitTilemap("GrassHit", 0, false)
		ControllerRumble(0, 0.9, 0.2, 0.1)
	elif hit_terrain == 4: # Stone
		SwordHitPaticles(hit_particles_list[2], hit_pos, sword_angle, player_x_speed)
		HitTilemap("StoneHit", 0, false)
		ControllerRumble(0, 0.2, 0.9, 0.1)
	elif hit_terrain == 5: #WoodPlatforms
		SwordHitPaticles(hit_particles_list[3], hit_pos, sword_angle, player_x_speed)
		ControllerRumble(0, 0.8, 0.5, 0.1)
	print("terrain hit: ", hit_terrain)
	print("Sword rotation: ", sword_angle)
	print("")
	


func CheckTileTerrainType(hit_tile):
	var hit_terrain = BetterTerrain.get_cell(self, 0, hit_tile)
	
	if hit_terrain == -1:
		var new_hit_tile = hit_tile
		new_hit_tile.x -= 1
		hit_terrain = BetterTerrain.get_cell(self, 0, new_hit_tile)
	if hit_terrain == -1:
		var new_hit_tile = hit_tile
		new_hit_tile.x += 1
		hit_terrain = BetterTerrain.get_cell(self, 0, new_hit_tile)
	if hit_terrain == -1:
		var new_hit_tile = hit_tile
		new_hit_tile.y -= 1
		hit_terrain = BetterTerrain.get_cell(self, 0, new_hit_tile)
	if hit_terrain == -1:
		var new_hit_tile = hit_tile
		new_hit_tile.y += 1
		hit_terrain = BetterTerrain.get_cell(self, 0, new_hit_tile)
	return hit_terrain


func IndirectSwordHit(_angle):
	if get_parent().has_method("HitWithSword") == true:
		get_parent().HitWithSword(_angle)



func HitTilemap(hit_sound, volume, camera_shake : bool):
	
	PlayHitSound(hit_sound, volume)
	if camera_shake == true:
		ShakeCamera()

func LandOnTilemap(player_pos):
	print("landed on tilemap")
	var hit_tile = floor(player_pos/12)
	var hit_terrain = CheckTileTerrainType(hit_tile)
	if hit_terrain == 2 or hit_terrain == 3: #grass/autumn grass
		EmitParticles(hit_particles_list[0], 3, player_pos + Vector2(0, 9), false)
		EmitParticles(hit_particles_list[0], 3, player_pos + Vector2(0, 9), true)
		print("playing land on grass sound")
		audio_master.PlayRandomSound("LandGrass")
	elif hit_terrain == 4: #Stone
		EmitParticles(hit_particles_list[2], 3, player_pos + Vector2(0, 9), false)
		EmitParticles(hit_particles_list[2], 3, player_pos + Vector2(0, 9), true)
		HitTilemap("StoneHit", 0, false)
	else:
		print("landed on unknown ground type")



func EmitParticles(particle_type, amount, emit_location, flipped : bool):
	var p = particle_type.instantiate()
	


	if flipped == true:
		p.scale.x = -1
	
	if amount >= 0:
		p.amount = amount
	p.global_position = emit_location
	p.z_index = 2
	get_tree().current_scene.add_child(p)

func AddShaderToTileType(tileset : TileMap, shader : Material):
	pass
	#for child in tileset.get_children():
		#if CheckTileTerrainType(child) == 2:
		#	library.tile_set_material(id, material)

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
	p.z_index = 2
	get_tree().current_scene.add_child(p)

func PlayHitSound(hit_sound, volume):
	audio_master.PlayRandomSound(hit_sound)

func ControllerRumble(controller_number : int, small_rumble : float, big_rumble : float, rumble_time : float):
	if OptionsManager.rumble_enabled == true:
		Input.start_joy_vibration(controller_number, small_rumble, big_rumble, rumble_time)

func ShakeCamera():
	if OptionsManager.screenshake == true:
		GlobalObjects.player.ShakeCamera(0.4, 0, 1)


