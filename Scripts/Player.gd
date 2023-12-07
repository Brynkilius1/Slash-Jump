extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #490


#export variables
@export var swing_power = Vector2(0, 174) #Vector2(0, 205)
@export var small_swing_power = Vector2(0, 100)
@export var extra_grounded_power := 16  #20
@export var swing_shortended_cooldown := 0.05
@export var swing_cooldown := 0.10
@export var swing_miss_cooldown := 0.19
@export var swing_coyote_time := 0.1
@export var swing_anim_length := 0.15
@export var max_fall_speed := 250

@export_category("Walljump bias")

@export_range (0, 3.14) var wall_bias_upper_limit : float = 2.6
@export var upper_boost : int = 30  #40
@export_range (0, 3.14) var wall_bias_middle_limit : float = 1.9
@export var lower_boost : int = 40   #50
@export_range (0, 3.14) var wall_bias_lower_limit : float = 1.5





#node references
@onready var sword_pivot = $SwordPivot
@onready var extended_sword = $SwordPivot/Extended
@onready var sword_collision = $SwordPivot/Extended/Sword/SwordCollision
@onready var sword_colision_shape = $SwordPivot/Extended/Sword/SwordCollision/SwordColisionShape
@onready var sword_swing_anim = $SwordPivot/Extended/Sword/SwingAnim

@onready var knife_swing_anim = $SwordPivot/Extended/Knife/KnifeSwingAnim
@onready var knife_collision = $SwordPivot/Extended/Knife/KnifeCollision
@onready var knife_collision_shape = $SwordPivot/Extended/Knife/KnifeCollision/KnifeCollisionShape

@onready var sword_visual = $SwordPivot/Rotator/SwordVisualPivot/SwordVisual
@onready var sword_visual_pivot = $SwordPivot/Rotator/SwordVisualPivot

@onready var indicator_pivot = $IndicatorPivot


@onready var wall_climb_prevention_raycast_1 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast1
@onready var wall_climb_prevention_raycast_2 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast2
@onready var wall_climb_prevention_raycast_3 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast3
@onready var wall_climb_prevention_raycast_4 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast4
@onready var walljump_raycasts = $SwordPivot/Extended/WalljumpRaycasts
@onready var corner_boost_raycast_1 = $Raycasts/CornerBoost/CornerBoostRaycast1
@onready var corner_boost_raycast_2 = $Raycasts/CornerBoost/CornerBoostRaycast2
@onready var corner_boost_raycast_3 = $Raycasts/CornerBoost/CornerBoostRaycast3
@onready var corner_boost_raycast_4 = $Raycasts/CornerBoost/CornerBoostRaycast4



@onready var swing_linger_timer = $SwingLingerTimer
@onready var swing_miss_timer = $SwingMissTimer
@onready var coyote_timer = $CoyoteTimer


@onready var camera_shaker = $Camera2D/Shaker



#instances
var sword_colision_particles = preload("res://Scenes/Player/Particles/sword_colision_particles.tscn")
const AFTER_SWING_VFX = preload("res://Scenes/Player/Particles/after_swing_vfx.tscn")



#code variables
var can_rotate_sword = true
var saved_x_speed : float
var sword_resting_rotation = 95


#to be removed later variables
var fullscreen_on = false




func _ready():
	GlobalObjects.player = self
	swing_linger_timer.connect("timeout", SwingLingerTimeout)


func _unhandled_input(event):
	if event is InputEventJoypadMotion:
		indicator_pivot.rotation = GetControllerAngle()
		if can_rotate_sword == true:
			sword_pivot.rotation = GetControllerAngle()


func _physics_process(delta):
	
	PreventWallClimb()
	GetSlashInput()
	CheckSavedXSpeed()
	CheckCornerBoost()
	
	
	Friction()
	Gravity(delta)
	
	
	move_and_slide()
	
	
	CheckToggleFullscreen()





func GetControllerAngle():
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ControllerRight") - Input.get_action_strength("ControllerLeft")
	input_vector.y = Input.get_action_strength("ControllerDown") - Input.get_action_strength("ControllerUp")
	
	var return_angle = Vector2.UP.angle_to(input_vector)
	return return_angle

func GetSlashInput():
	if Input.is_action_just_pressed("BigSwing"):
		coyote_timer.start(swing_coyote_time)
		
	
	if SwingCooldownActive() == false:
		if Input.is_action_just_pressed('SmallSwing'):
			SwingKnife()

		elif coyote_timer.time_left > 0:
			Swing()
		
		
		


func Swing():
	SwingSoundEffects()
	SwingVisuals()
	SwingParticles()
	SwingTechnical()


func SwingSoundEffects():
	#maybe add changing sound effects depending on the type of tile hit
	$Sounds/SwordSwing.play()
func SwingVisuals():
	SwingAnimation()
	SwingVFX()
func SwingAnimation():
	#rotating the sword the player is holding
	var swing_anim_tween = create_tween()
	swing_anim_tween.tween_property(sword_visual_pivot, "rotation_degrees", sign(-sword_visual_pivot.rotation_degrees) * sword_resting_rotation, swing_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await get_tree().create_timer(swing_anim_length/5).timeout
	sword_visual.scale.x = -sword_visual.scale.x
func SwingVFX():
	#show the woosh in the air
	sword_swing_anim.visible = true
	sword_swing_anim.stop()
	knife_swing_anim.stop()
	sword_swing_anim.play("Swing")
func SwingParticles():
	#lingering swing vfx particle
	var after_swing_vfx = AFTER_SWING_VFX.instantiate()
	after_swing_vfx.rotation = sword_pivot.rotation
	after_swing_vfx.process_material.angle_min = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.process_material.angle_max = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.position = extended_sword.global_position
	get_tree().current_scene.add_child(after_swing_vfx)
func SwingTechnical():
	sword_colision_shape.disabled = false
	can_rotate_sword = false
	coyote_timer.stop()
	
	StartSwingLingerTimer()

func StartSwingLingerTimer():
	swing_linger_timer.start(swing_cooldown)




func SwingLingerTimeout():
	LingerTimeoutVisuals()
	LingerTimeoutTechnical()
	
	CheckIfSwingHit()
	swing_linger_timer.stop()

func LingerTimeoutVisuals():
	sword_swing_anim.visible = false
	knife_swing_anim.visible = false
func LingerTimeoutTechnical():
	can_rotate_sword = true
	sword_colision_shape.call_deferred("set_disabled", true)
	knife_collision_shape.call_deferred("set_disabled", true)
func CheckIfSwingHit():
	if swing_linger_timer.time_left > 0:
		swing_miss_timer.stop()
	else:
		swing_miss_timer.start(swing_miss_cooldown)




#called when the sword collides with something
func SwordDetectsHit(body):
	#Juice
	SwordHitSounds()
	SwordHitParticles()
	ShakeCamera(0.4, 1, 3) #(0.7, 0, 6)
	SwordHitFramePause(0.05)
	
	SwordHitTechnical()
	
	SwordHitVelocity(swing_power, sword_pivot.rotation, IsWallJumping())
	
	SwingLingerTimeout()

func SwordHitSounds():
	#maybe add more sounds later
	$Sounds/SwordHit.play()
func SwordHitParticles():
	EmitSwordDustParticles(sword_pivot.rotation)
func EmitSwordDustParticles(angle):
	var emit_location = walljump_raycasts.get_child(0).global_position + walljump_raycasts.get_child(0).target_position.rotated(angle)
	
	var s = sword_colision_particles.instantiate()
	s.rotation = angle
	s.global_position = emit_location
	get_tree().root.get_child(0).add_child(s)
func SwordHitFramePause(pause_time):
	get_tree().paused = true
	
	await get_tree().create_timer(pause_time).timeout
	get_tree().paused = false
func SwordHitTechnical():
	sword_colision_shape.call_deferred("set_disabled", true)
func SwordHitVelocity(power, angle, is_wall_jumping):
	var bounce_power = power 
	bounce_power.y += int(is_on_floor()) * extra_grounded_power #add slighty mode power if player is grounded
	bounce_power = bounce_power.rotated(angle)
	if is_wall_jumping == true:
		bounce_power = AddWallJumpBias(bounce_power, angle)
	
	saved_x_speed = bounce_power.x
	velocity = bounce_power
	coyote_timer.stop()

func AddWallJumpBias(bounce_power, angle):
	if abs(angle) > wall_bias_upper_limit:
		return bounce_power
	elif abs(angle) > wall_bias_middle_limit:
		bounce_power.y -= upper_boost
		return bounce_power
	elif abs(angle) > wall_bias_lower_limit:
		bounce_power.y -= lower_boost
		return bounce_power
	else:
		return bounce_power

func IsWallJumping():
	var floor_hits := 0
	var wall_hits := 0
	for raycast in walljump_raycasts.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding() == true:
			if raycast.get_collision_normal().x != 0:
				wall_hits += 1
			elif raycast.get_collision_normal().y != 0:
				floor_hits += 1
			
	if is_on_floor() == true:
		return false
	elif wall_hits > floor_hits:
		return true
	else:
		return false




func SwingKnife():
	KnifeSwingSounds()
	KnifeSwingVisuals()
	KnifeSwingParticles()
	KnifeSwingTechnical()
	
	
	StartSwingLingerTimer()

func KnifeSwingSounds():
	#add sounds
	pass
func KnifeSwingVisuals():
	sword_swing_anim.stop()
	knife_swing_anim.stop()
	knife_swing_anim.visible = true
	knife_swing_anim.play("Swing")
func KnifeSwingParticles():
	#add particles
	pass
func KnifeSwingTechnical():
	knife_collision_shape.disabled = false
	can_rotate_sword = false
	coyote_timer.stop()


func KnifeDetectsHit(body):
	KnifeHitSounds()
	KnifeHitParticles()
	KnifeHitTechnical()
	ShakeCamera(0.3, 1, 2)
	
	
	SwordHitVelocity(small_swing_power, sword_pivot.rotation, IsWallJumping())

func KnifeHitSounds():
	$Sounds/SwordHit.play()
func KnifeHitParticles():
	EmitSwordDustParticles(sword_pivot.rotation)
func KnifeHitTechnical():
	knife_collision_shape.call_deferred("set_disabled", true)
	swing_miss_timer.stop()







func PreventWallClimb():
	if (wall_climb_prevention_raycast_1.is_colliding() == true or wall_climb_prevention_raycast_2.is_colliding() == true) and is_on_floor() == false:
		sword_colision_shape.scale.x = 0.25
	else:
		sword_colision_shape.scale.x = 1

func CheckSavedXSpeed():
	if velocity.x == 0:
		if sign(saved_x_speed) == 1:
			if wall_climb_prevention_raycast_1.is_colliding() == false and wall_climb_prevention_raycast_3.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
		elif sign(saved_x_speed) == -1:
			if wall_climb_prevention_raycast_2.is_colliding() == false and wall_climb_prevention_raycast_4.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
	
	
	saved_x_speed = lerp(saved_x_speed, 0.0, 0.1) #return saved_x_spped to 0 over time

func CheckCornerBoost():
	#print(saved_x_speed)
	if sign(saved_x_speed) == 1:
		if corner_boost_raycast_1.is_colliding() == true and corner_boost_raycast_3.is_colliding() == false:
			if velocity.y > 0:
				global_position.y -= 5
				global_position.x += 1
	elif sign(saved_x_speed) == -1:
		if corner_boost_raycast_2.is_colliding() == true and corner_boost_raycast_4.is_colliding() == false:
			if velocity.y > 0:
				global_position.y -= 5
				global_position.x -= 1

func Friction():
	if is_on_floor():
		velocity.x  = lerp(velocity.x, 0.0, 0.2)

func Gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed #cap fall speed

func CheckToggleFullscreen():
	if Input.is_action_just_pressed("fullscreen"):
		if fullscreen_on == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen_on = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen_on = false






func _on_swing_miss_timer_timeout():
	$Sounds/SwordMiss.play()

func _on_coyote_timer_timeout():
	pass

func _on_swing_anim_animation_finished():
	sword_swing_anim.visible = false




func SwingCooldownActive():
	# can add more ifs, if more cooldowns are added
	var return_bool = false
	if swing_miss_timer.time_left > 0:
		return_bool = true
	if swing_linger_timer.time_left > 0:
		return_bool = true
	return return_bool


func ShakeCamera(time, min, max):
	camera_shaker.min_value = min
	camera_shaker.max_value = max
	camera_shaker.start(time)
