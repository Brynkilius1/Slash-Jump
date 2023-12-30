extends CharacterBody2D


const SPEED = 50.0
const STONE_HIT_PATRICLES = preload("res://Scenes/Particles/StoneHitPatricles.tscn")
const BASE_SOUND_EFFECT = preload("res://Scenes/base_sound_effect.tscn")

var hit_sound = preload("res://Sounds/SoundEffects/Player/Sword/SwordHit/enemy damage.mp3")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction : = 1

@onready var wall_raycast = $WallRaycast
@onready var wall_raycast_2 = $WallRaycast2
@onready var edge_raycast = $EdgeRaycast
@onready var edge_raycast_2 = $EdgeRaycast2



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


	velocity.x = direction * SPEED
	
	if wall_raycast.is_colliding() == true:
		direction = -1
	elif wall_raycast_2.is_colliding() == true:
		direction = 1
	elif edge_raycast.is_colliding() == false:
		direction = 1
	elif edge_raycast_2.is_colliding() == false:
		direction = -1
	
	move_and_slide()


func HitWithSword(_angle):
	PlayHitSound()
	queue_free()

func PlayHitSound():
	var sound = BASE_SOUND_EFFECT.instantiate()
	sound.stream = hit_sound
	sound.volume_db = 3
	get_parent().add_child(sound)
