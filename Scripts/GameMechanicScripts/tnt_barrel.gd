extends CharacterBody2D

const TNT_EXPLOSION = preload("res://Scenes/LevelObjects/tnt_explosion.tscn")
const BASE_SOUND_EFFECT = preload("res://Scenes/base_sound_effect.tscn")

var hit_sound = preload("res://Sounds/SoundEffects/Objects/Mechanics/Tnt/ExplosionTemp.mp3")

func HitWithSword(_angle):
	PlayHitSound()
	CreateExplosion(_angle)
	queue_free()


func CreateExplosion(_angle):
	var e = TNT_EXPLOSION.instantiate()
	e.global_position = global_position
	e.sword_angle = _angle
	get_tree().root.get_child(0).add_child(e)

func PlayHitSound():
	var sound = BASE_SOUND_EFFECT.instantiate()
	sound.stream = hit_sound
	sound.volume_db = 3
	get_parent().add_child(sound)
