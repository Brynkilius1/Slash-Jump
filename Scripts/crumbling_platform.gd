extends Node2D

const STONE_HIT_PATRICLES = preload("res://Scenes/Particles/StoneHitPatricles.tscn")

@export var platform_width : int = 1
@export var particle_rotation : float = 0
@export var flip_tree : bool = false

var crumble_time : float = 0.8
var platform_respawn_time : float = 3.0


@onready var sword_collision_handler = $SwordCollisionHandler
@onready var sword_collision_handler_shape = $SwordCollisionHandler/SwordCollisionShape

@onready var collision_shape_2d = $CollisionShape2D
@onready var player_detector = $PlayerDetector
@onready var player_detector_shape = $PlayerDetector/PlayerDetectorShape
@onready var player_leaving_detector = $PlayerLeavingDetector
@onready var player_leaving_detector_shape = $PlayerLeavingDetector/PlayerLeavingDetectorShape
@onready var audio_master = $AudioMaster
@onready var particle_spawner = $ParticleSpawner
@onready var tree_animated_sprite = $CrumbingPlatformTree


@onready var sprite_2d = $Sprite2D
@onready var platform_animated_sprite = $PlatformAnimatedSprite
@onready var shaker = $Shaker
@onready var respawner = $Respawner
@onready var disapear_timer = $DisapearTimer


var triggerable = true


# Called when the node enters the scene tree for the first time.
func _ready():
	disapear_timer.wait_time = crumble_time
	shaker.stop()
	SetPlatformWidth()
	tree_animated_sprite.play("Regrow")
	if flip_tree == true:
		tree_animated_sprite.flip_h = true

func SetPlatformWidth():
	sword_collision_handler.scale.x = platform_width
	player_detector.scale.x = platform_width
	collision_shape_2d.scale.x = platform_width
	player_leaving_detector.scale.x = platform_width
	sprite_2d.set_region_rect(Rect2(0, 0, platform_width * 12, 12))



func HitWithSword(_angle):
	respawner.StartRespawn()
	shaker.stop()



func DisableSelf(disabled_self : bool):
	print("called DisableSelf", self)
	#animations
	if disabled_self == false:
		StoodOn(false)
		platform_animated_sprite.play("appear")
		platform_animated_sprite.visible = not disabled_self
		tree_animated_sprite.play("Regrow")
		await get_tree().create_timer(0.3).timeout
		
		TogglePlatformEnabled(disabled_self)
		
	else:
		particle_spawner.SpawnParticles(particle_rotation)
		platform_animated_sprite.play("disapear")
		tree_animated_sprite.play("Hit")
		await get_tree().create_timer(0.1).timeout
		TogglePlatformEnabled(disabled_self)
		await get_tree().create_timer(0.25).timeout
		platform_animated_sprite.visible = not disabled_self
	
	
func TogglePlatformEnabled(disabled_self):
	collision_shape_2d.call_deferred("set_disabled", disabled_self)
	sword_collision_handler_shape.call_deferred("set_disabled", disabled_self)
	player_detector_shape.call_deferred("set_disabled", disabled_self)
	player_leaving_detector_shape.call_deferred("set_disabled", disabled_self)
	if disabled_self == false:
		triggerable = true

func _on_player_detector_body_entered(body):
	if triggerable == true:
		triggerable = false
		StoodOn(true)
		disapear_timer.start()
		shaker.start()


func _on_player_leaving_detector_body_exited(body):
	if triggerable == false:
		StoodOn(false)
		platform_animated_sprite.play("disapear")
		respawner.StartRespawn()
		shaker.stop()


func _on_disapear_timer_timeout():
	respawner.StartRespawn()
	shaker.stop()

func LandOnTilemap(position):
	particle_spawner.SpawnParticles(particle_rotation, 4)
	audio_master.PlayRandomSound("Land")


func StoodOn(standing_toggle):
	if rotation_degrees == 0:
		if standing_toggle == true:
			tree_animated_sprite.play("StoodOn")
			platform_animated_sprite.position.y = -4
			collision_shape_2d.position.y = 5

		elif standing_toggle == false:
			platform_animated_sprite.position.y = -3
			collision_shape_2d.position.y = 3

