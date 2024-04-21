extends StaticBody2D

@export var bullet_speed : float = 100
@export var shots_per_second : float = 2.0

const TURRET_BULLET = preload("res://Scenes/SpawnableItems/turret_bullet.tscn")

@onready var bullet_spawn_point = $BulletSpawnPoint
@onready var function_caller_timer = $FunctionCallerTimer
@onready var animation_player = $AnimationPlayer


func _ready():
	function_caller_timer.wait_time = shots_per_second

func EnteredScreenActivate(): #Gets called on all children of a screen in the group "ScreenActivated" when the player enters a screen
	await get_tree().create_timer(0.5).timeout
	PlayShootAnim()
	function_caller_timer.start()
	


func HitWithSword(_angle):
	#implament logic for indirect hits
	print("hit turrent")


func PlayShootAnim():
	animation_player.play("Shoot")


func Shoot():
	SpawnBullet()


func SpawnBullet():
	var  b = TURRET_BULLET.instantiate()
	b.speed = bullet_speed
	b.bullet_angle = rotation
	b.global_position = bullet_spawn_point.global_position
	get_tree().current_scene.add_child(b)
