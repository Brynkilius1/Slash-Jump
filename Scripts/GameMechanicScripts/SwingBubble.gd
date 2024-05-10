extends Area2D

@export var hit_particles : PackedScene = preload("res://Scenes/Particles/dirt_particles.tscn")
@export var higher_particle_count : int = 5
@export var lower_particle_count : int = 2

var stay_in_bubble_time = 2.0
var extra_swing_power = 15


@onready var audio_master = $AudioMaster
@onready var self_collision = $CollisionShape2D
@onready var hit_detector_colision = $HitDetector/CollisionShape2D
@onready var bubble_animated_sprite = $Bubble

@onready var respawner = $Respawner
@onready var stay_in_bubble_timer = $StayInBubbleTimer


var last_hit_angle : float
var in_bubble : bool = false
var saved_spawn_pos : Vector2
var velocity : Vector2

func _ready():
	randomize()
	saved_spawn_pos = global_position


func _physics_process(delta):
	if in_bubble == true:
		GlobalObjects.player.global_position = global_position
		GlobalObjects.player.velocity = Vector2.ZERO
	global_position = global_position.lerp(saved_spawn_pos, 0.05)
	position += velocity * delta
	velocity = velocity.lerp(Vector2.ZERO, 0.1)

func _on_body_entered(body):
	if body == GlobalObjects.player:
		CapturePlayer(body)
		GlobalObjects.player.IncreaseNextJumpPower(extra_swing_power)
		audio_master.PlayRandomSound("Enter")
		
func CapturePlayer(body):
	in_bubble = true
	velocity = GlobalObjects.player.velocity / 3.5
	SpawnPopParticles(hit_particles, 1, 4)
	body.global_position = global_position
	body.saved_x_speed = 0
	body.velocity = Vector2.ZERO
	#body.TurnOffGravity(true)
	stay_in_bubble_timer.start(stay_in_bubble_time)


func BubbleTimeout():
	GlobalObjects.player.IncreaseNextJumpPower(-extra_swing_power)
	IndirectSwordHit("ballin")

func IndirectSwordHit(_angle):
	#GlobalObjects.player.TurnOffGravity(false)
	respawner.StartRespawn()
	stay_in_bubble_timer.stop()
	if _angle is float:
		last_hit_angle = _angle
	


func DirectSwordHit(hit_pos : Vector2, sword_angle, player_x_speed):
	#print("Sword hit bubble at: ", hit_pos, " with angle: ", sword_angle, " with x_speed: ", player_x_speed)
	last_hit_angle = sword_angle
	#SwordHitPaticles(hit_pos, sword_angle, player_x_speed)
	if OptionsManager.rumble_enabled:
		Input.start_joy_vibration(0, 0.4, 0.05, 0.1)
	PlayHitSound()








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
	audio_master.PlayRandomSound("Hit")




func DisableSelf(disabled_self : bool):
	#THIS FUNC SHOULD ONLY BE USED BY CALLING IT THOUGH THE RESPAWNER NODE
	if disabled_self == true:
		DisableTechnical(disabled_self)
		SpawnPopParticles(hit_particles)
		bubble_animated_sprite.play("Pop")
		
		await get_tree().create_timer(0.2).timeout
		visible = not disabled_self
	else:
		visible = not disabled_self
		bubble_animated_sprite.play("Appear")
		await get_tree().create_timer(0.2).timeout
		DisableTechnical(disabled_self)
		

func SpawnPopParticles(particles, big_amount = -1, small_amount = -1):
	var p = particles.instantiate()
	p.global_position = global_position
	get_tree().root.get_child(0).add_child(p)
	p.SpawnParticles(last_hit_angle, big_amount, small_amount)


func DisableTechnical(disabled_self):
	in_bubble = false
	self_collision.disabled = disabled_self
	hit_detector_colision.disabled = disabled_self
