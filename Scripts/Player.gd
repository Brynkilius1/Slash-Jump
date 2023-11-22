extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #490


#export variables
@export var swing_power = Vector2(0, 170) #Vector2(0, 205)
@export var extra_grounded_power := 20  #20
@export var swing_shortended_cooldown := 0.05
@export var swing_cooldown := 0.4
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




@onready var wall_climb_prevention_raycast_1 = $WallClimbPreventionRaycast1
@onready var wall_climb_prevention_raycast_2 = $WallClimbPreventionRaycast2
@onready var walljump_raycasts = $SwordPivot/ExtendedSword/WalljumpRaycasts

@onready var swing_cooldown_timer = $SwingCooldownTimer
@onready var swing_miss_timer = $SwingMissTimer





#code variables
var swing_cooldown_active = false
var can_rotate_sword = true
var just_pressed = false
var saved_x_speed : float


#to be removed later variables
var fullscreen_on = false
@onready var swird_temp_sprite = $SwordPivot/ExtendedSword/SwirdTempSprite



func _unhandled_input(event):
	
	if event is InputEventJoypadMotion:
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
	if Input.is_action_just_pressed("ControllerButton"):
		just_pressed = true
		$CoyoteTimer.start(swing_coyote_time)
		
	
	if swing_cooldown_active == false:
		if just_pressed == true:
			Swing()


func Swing():
	swing_anim.play("Swing")
	swing_anim.visible = true
	sword_colision_shape.disabled = false
	
	swing_cooldown_active = true
	swing_cooldown_timer.stop()
	swing_cooldown_timer.start(swing_cooldown)
	
	just_pressed = false
	can_rotate_sword = false
	swing_miss_timer.start(swing_anim_length)


func _on_sword_collision_body_entered(body):
	Bounce(sword_pivot.rotation, IsWallJumping())
	sword_colision_shape.call_deferred("set_disabled", true)
	swing_cooldown_timer.stop()
	swing_cooldown_timer.start(swing_shortended_cooldown)
	swing_miss_timer.stop()


func _on_swing_miss_timer_timeout():
	sword_colision_shape.disabled = true
	swing_anim.visible = false
	


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
		print("Is wall jumping: ", false)
		return false
	elif wall_hits > floor_hits:
		print("Is wall jumping: ", true)
		return true
	else:
		print("Is wall jumping: ", false)
		return false


func Bounce(angle, is_wall_jumping):
	var bounce_power = swing_power 
	bounce_power.y += int(is_on_floor()) * extra_grounded_power #add slighty mode power if player is grounded
	bounce_power = bounce_power.rotated(angle)
	print(angle)
	if is_wall_jumping == true:
		bounce_power = AddWallJumpBias(bounce_power, angle)
	
	saved_x_speed = bounce_power.x
	velocity = bounce_power
	just_pressed = false

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




func CheckSavedXSpeed():
	if velocity.x == 0 and wall_climb_prevention_raycast_1.is_colliding() == false and wall_climb_prevention_raycast_2.is_colliding() == false:
		velocity.x = saved_x_speed
		saved_x_speed = 0.0
	saved_x_speed = lerp(saved_x_speed, 0.0, 0.1)




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


func _on_swing_cooldown_timer_timeout():
	swing_cooldown_active = false
	sword_colision_shape.disabled = true





func _on_swing_anim_animation_finished():
	swing_anim.visible = false
	can_rotate_sword = true



