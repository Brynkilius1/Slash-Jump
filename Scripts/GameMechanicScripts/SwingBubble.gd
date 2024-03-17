extends Area2D

@export var hit_particles : PackedScene = preload("res://Scenes/Particles/dirt_particles.tscn")
@export var higher_particle_count : int = 5
@export var lower_particle_count : int = 2

var stay_in_bubble_time = 2.0


@onready var hit_sounds = $SoundEffects/Hit
@onready var self_collision = $CollisionShape2D
@onready var hit_detector_colision = $HitDetector/CollisionShape2D


@onready var respawner = $Respawner
@onready var stay_in_bubble_timer = $StayInBubbleTimer



func _on_body_entered(body):
	if body == GlobalObjects.player:
		CapturePlayer(body)
		GlobalObjects.player.IncreaseNextJumpPower(10)
		
func CapturePlayer(body):
	body.global_position = global_position
	body.saved_x_speed = 0
	body.velocity = Vector2.ZERO
	body.TurnOffGravity(true)
	stay_in_bubble_timer.start(stay_in_bubble_time)



func IndirectSwordHit(_angle):
	GlobalObjects.player.TurnOffGravity(false)
	respawner.StartRespawn()
	stay_in_bubble_timer.stop()


func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	#print("Sword hit bubble at: ", hit_pos, " with angle: ", sword_angle, " with x_speed: ", player_x_speed)
	SwordHitPaticles(hit_pos, sword_angle, player_x_speed)
	PlayHitSound()





func _ready():
	randomize()





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




func DisableSelf(disabled_self : bool):
	#THIS FUNC SHOULD ONLY BE USED BY CALLING IT THOUGH THE RESPAWNER NODE
	visible = not disabled_self
	self_collision.disabled = disabled_self
	hit_detector_colision.disabled = disabled_self
