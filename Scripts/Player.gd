extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #490


#export variables
@export var swing_power = Vector2(0, 176) #Vector2(0, 205)
@export var small_swing_power = Vector2(0, 100)
@export var extra_grounded_power := 16  #20
@export var swing_shortended_cooldown := 0.05
@export var swing_cooldown := 0.10
@export var swing_miss_cooldown := 0.19
@export var swing_coyote_time := 0.15
@export var swing_anim_length := 0.2
@export var max_fall_speed := 250

@export_category("Walljump bias")

@export_range (0, 3.14) var wall_bias_upper_limit : float = 2.6
@export var upper_boost : int = 30  #40
@export_range (0, 3.14) var wall_bias_middle_limit : float = 1.9
@export var lower_boost : int = 40   #50
@export_range (0, 3.14) var wall_bias_lower_limit : float = 1.5





#node references
@onready var sword_pivot = $SwordPivot
@onready var extended_sword = $SwordPivot/ExtendedSword
@onready var sword_collision = $SwordPivot/ExtendedSword/SwordCollision
@onready var sword_colision_shape = $SwordPivot/ExtendedSword/SwordCollision/SwordColisionShape
@onready var swing_anim = $SwordPivot/ExtendedSword/SwingAnim

@onready var knife_swing_anim = $SwordPivot/ExtendedSword/Knife/KnifeSwingAnim
@onready var knife_collision = $SwordPivot/ExtendedSword/Knife/KnifeCollision
@onready var knife_collision_shape = $SwordPivot/ExtendedSword/Knife/KnifeCollision/KnifeCollisionShape


@onready var indicator_pivot = $IndicatorPivot


@onready var wall_climb_prevention_raycast_1 = $WallClimbPreventionRaycast1
@onready var wall_climb_prevention_raycast_2 = $WallClimbPreventionRaycast2
@onready var corner_boost_raycast_1 = $CornerBoostRaycast1
@onready var corner_boost_raycast_2 = $CornerBoostRaycast2
@onready var walljump_raycasts = $SwordPivot/ExtendedSword/WalljumpRaycasts

@onready var swing_cooldown_timer = $SwingCooldownTimer
@onready var swing_miss_timer = $SwingMissTimer



#instances
var sword_colision_particles = preload("res://Scenes/Player/Particles/sword_colision_particles.tscn")



#code variables
var swing_cooldown_active = false
var can_rotate_sword = true
var just_pressed = false
var saved_x_speed : float
var hit_swing = false


#to be removed later variables
var fullscreen_on = false
@onready var swird_temp_sprite = $SwordPivot/ExtendedSword/SwirdTempSprite




func _ready():
	GlobalObjects.player = self


func _unhandled_input(event):
	if event is InputEventJoypadMotion:
		indicator_pivot.rotation = GetControllerAngle()
		if can_rotate_sword == true:
			sword_pivot.rotation = GetControllerAngle()


func _physics_process(delta):
	
	PreventWallClimb()
	GetSlashInput()
	CheckSavedXSpeed()
	
	
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
		just_pressed = true
		$CoyoteTimer.start(swing_coyote_time)
		
	
	if swing_cooldown_active == false:
		if Input.is_action_just_pressed('SmallSwing'):
			pass
			swing_anim.stop()
			knife_swing_anim.stop()
			knife_swing_anim.visible = true
			knife_collision_shape.disabled = false
			
			just_pressed = false
			can_rotate_sword = false
			
			StartSwingCooldown()
			
		
		
		if just_pressed == true:
			Swing()
		
		
		


func Swing():
	swing_anim.stop()
	swing_anim.play("Swing")
	swing_anim.visible = true
	sword_colision_shape.disabled = false
	
	just_pressed = false
	can_rotate_sword = false
	
	$Sounds/SwordSwing.play()
	
	StartSwingCooldown()


func StartSwingCooldown():
	swing_cooldown_active = true
	hit_swing = false
	swing_cooldown_timer.start(swing_cooldown)
	

func _on_sword_collision_body_entered(body):
	Bounce(swing_power, sword_pivot.rotation, IsWallJumping())
	$Sounds/SwordHit.play()
	sword_colision_shape.call_deferred("set_disabled", true)
	swing_miss_timer.stop()
	hit_swing = true

func _on_knife_collision_body_entered(body):
	Bounce(small_swing_power, sword_pivot.rotation, IsWallJumping())
	$Sounds/SwordHit.play()
	knife_collision_shape.call_deferred("set_disabled", true)
	swing_miss_timer.stop()
	hit_swing = true



func _on_swing_cooldown_timer_timeout():
	sword_colision_shape.disabled = true
	knife_collision_shape.disabled = true
	swing_anim.visible = false
	knife_swing_anim.visible = false
	can_rotate_sword = true
	
	if hit_swing == true:
		swing_cooldown_active = false
	else:
		swing_miss_timer.start(swing_miss_cooldown)

func _on_swing_miss_timer_timeout():
	$Sounds/SwordMiss.play()
	swing_cooldown_active = false
	hit_swing = false
	


	


func PreventWallClimb():
	if (wall_climb_prevention_raycast_1.is_colliding() == true or wall_climb_prevention_raycast_2.is_colliding() == true) and is_on_floor() == false:
		sword_colision_shape.scale.x = 0.25
	else:
		sword_colision_shape.scale.x = 1

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


func Bounce(power, angle, is_wall_jumping):
	var bounce_power = power 
	bounce_power.y += int(is_on_floor()) * extra_grounded_power #add slighty mode power if player is grounded
	bounce_power = bounce_power.rotated(angle)
	if is_wall_jumping == true:
		bounce_power = AddWallJumpBias(bounce_power, angle)
	
	saved_x_speed = bounce_power.x
	velocity = bounce_power
	just_pressed = false
	EmitSwordImpactParticles(angle)

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

func EmitSwordImpactParticles(angle):
	var emit_location = walljump_raycasts.get_child(0).global_position + walljump_raycasts.get_child(0).target_position.rotated(angle)
	
	var s = sword_colision_particles.instantiate()
	s.rotation = angle
	s.global_position = emit_location
	get_tree().root.get_child(0).add_child(s)


func CheckSavedXSpeed():
	if velocity.x == 0:
		if sign(saved_x_speed) == 1:
			if wall_climb_prevention_raycast_1.is_colliding() == false and corner_boost_raycast_1.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
		elif sign(saved_x_speed) == -1:
			if wall_climb_prevention_raycast_2.is_colliding() == false and corner_boost_raycast_2.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
	
	
	saved_x_speed = lerp(saved_x_speed, 0.0, 0.1) #return saved_x_spped to 0 over time




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





func _on_coyote_timer_timeout():
	just_pressed = false








func _on_swing_anim_animation_finished():
	swing_anim.visible = false





