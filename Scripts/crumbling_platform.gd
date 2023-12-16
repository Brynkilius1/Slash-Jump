extends Node2D

const STONE_HIT_PATRICLES = preload("res://Scenes/Particles/StoneHitPatricles.tscn")

@export var platform_width : int = 1

var crumble_time : float = 2.0
var platform_respawn_time : float = 4.0
var leaving_plaform_grace_period : float = 0.6


@onready var static_body_2d = $StaticBody2D
@onready var player_detector = $PlayerDetector
@onready var sprite_2d = $Sprite2D
@onready var shaker = $Shaker


@onready var crumble_timer = $CrumbleTimer
@onready var respawn_timer = $RespawnTimer
@onready var leaving_platform_timer = $LeavingPlatformTimer



# Called when the node enters the scene tree for the first time.
func _ready():
	shaker.stop()
	static_body_2d.scale.x = platform_width
	player_detector.scale.x = platform_width
	sprite_2d.set_region_rect(Rect2(0, 0, platform_width * 12, 12))





func SwordHitDetected(hit_pos : Vector2, sword_angle, player_x_speed):
	crumble_timer.stop()
	DisablePlatform(true)
	EmitSwordStoneParticles(5, player_x_speed, hit_pos, false)
	EmitSwordStoneParticles(2, player_x_speed, hit_pos, true)


func EmitSwordStoneParticles(amount, player_x_speed, emit_location, flipped : bool):
	
	var p = STONE_HIT_PATRICLES.instantiate()
	
	var emit_direction = sign(player_x_speed)
	if flipped == true:
		emit_direction *= -1
	
	if emit_direction == 1:
		p.scale.x = -1
	
	p.amount = amount
	p.global_position = emit_location
	get_tree().root.get_child(0).add_child(p)


func _on_player_detector_body_entered(body):
	if crumble_timer.time_left <= 0:
		shaker.start(2.0)
		crumble_timer.start(crumble_time)


func _on_crumble_t_imer_timeout():
	DisablePlatform(true)

func _on_player_detector_body_exited(body):
	leaving_platform_timer.start(leaving_plaform_grace_period)



	


func LeavingPlatformTimerCheck():
	if player_detector.get_overlapping_bodies() == []: #if the player aint on the platform anymore
		crumble_timer.stop()
		DisablePlatform(true)


func DisablePlatform(disable : bool):
	if disable == true:
		sprite_2d.visible = false
		static_body_2d.get_node("CollisionShape2D").set_deferred("disabled", true)
		player_detector.get_node("CollisionShape2D").set_deferred("disabled", true)
		respawn_timer.start(platform_respawn_time)
		shaker.stop()
	else:
		sprite_2d.visible = true
		static_body_2d.get_node("CollisionShape2D").set_deferred("disabled", false)
		player_detector.get_node("CollisionShape2D").set_deferred("disabled", false)

func _on_respawn_timer_timeout():
	DisablePlatform(false)



