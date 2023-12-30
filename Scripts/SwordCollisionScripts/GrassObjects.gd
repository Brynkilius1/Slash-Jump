extends TileMap

const DIRT_PARTICLES = preload("res://Scenes/Particles/dirt_particles.tscn")
const BASE_SOUND_EFFECT = preload("res://Scenes/base_sound_effect.tscn")

const BREAKABLE_WALL_HIT_1 = preload("res://Sounds/SoundEffects/Player/Sword/SwordHit/breakable wall hit 1.mp3")
const BREAKABLE_WALL_HIT_2 = preload("res://Sounds/SoundEffects/Player/Sword/SwordHit/breakable wall hit 2.mp3")

@onready var sound_array = [BREAKABLE_WALL_HIT_1, BREAKABLE_WALL_HIT_2]


func _ready():
	randomize()


func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	EmitSwordHitPaticles(hit_pos, sword_angle, player_x_speed)
	PlayGrassSound()






func EmitSwordHitPaticles(hit_pos : Vector2, sword_angle, player_x_speed):
	EmitSwordDirtParticles(5, player_x_speed, hit_pos, false)
	EmitSwordDirtParticles(2, player_x_speed, hit_pos, true)
func EmitSwordDirtParticles(amount, player_x_speed, emit_location, flipped : bool):
	
	var p = DIRT_PARTICLES.instantiate()
	
	var emit_direction = sign(player_x_speed)
	if flipped == true:
		emit_direction *= -1
	
	if emit_direction == 1:
		p.scale.x = -1
	
	p.amount = amount
	p.global_position = emit_location
	get_tree().root.get_child(0).add_child(p)

func PlayGrassSound():
	var sound = BASE_SOUND_EFFECT.instantiate()
	sound.stream = sound_array.pick_random()
	sound.volume_db = -10
	get_tree().root.get_child(0).add_child(sound)
