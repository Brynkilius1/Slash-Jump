extends StaticBody2D

@export var animations : AnimatedSprite2D
@export var particles : ParticleGroup
var original_position

@onready var ring_particles = $RingParticles
@onready var collect_anim_player = $CollectAnimPlayer
@onready var camera_2d = $Camera2D

const CUSTOM_LEVEL_WIN_SCREEN = preload("res://Scenes/UI/custom_level_win_screen.tscn")

func _ready():
	original_position = global_position



func _process(delta):
	global_position.y = original_position.y + sin(Time.get_ticks_msec() * 0.002)
	#camera_2d.position.y = -sin(Time.get_ticks_msec() * 0.002)



func HitWithSword(_angle):
	GlobalVariables.CollectedlevelEndObject()
	print("hit angle ", _angle)
	particles.rotation = deg_to_rad(_angle)
	particles.EmitParticles()
	animations.offset = Vector2(-4, 0)
	collect_anim_player.play("CollectObjcet")
	#TweenImplosion()
	

func LandOnTilemap(land_position):
	pass #add goopy particles later


func TweenImplosion():
	$RingParticles/RingOutside.lifetime = 0.3
	var new_tween = create_tween()
	new_tween.tween_property(ring_particles, "scale", Vector2.ZERO, 2.0)


func SpawnLevelEndScreen():
	var level_end = CUSTOM_LEVEL_WIN_SCREEN.instantiate()
	get_tree().current_scene.add_child(level_end)
	



