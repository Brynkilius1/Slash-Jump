extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 490 #490


#export variables
@export var swing_power = Vector2(0, 205)
@export var extra_grounded_power := 20


#node references
@onready var sword_pivot = $SwordPivot
@onready var extended_sword = $SwordPivot/ExtendedSword
@onready var sword_collision = $SwordPivot/ExtendedSword/SwordCollision
@onready var sword_collision_shape = $SwordPivot/ExtendedSword/SwordCollision/SwordCollisionShape


@onready var wall_climb_prevention_raycast_1 = $WallClimbPreventionRaycast1
@onready var wall_climb_prevention_raycast_2 = $WallClimbPreventionRaycast2
@onready var walljump_raycasts = $SwordPivot/ExtendedSword/WalljumpRaycasts




#code variables
var just_pressed = false
var saved_x_speed : float


#to be removed later variables
var fullscreen_on = false


func _unhandled_input(event):
	
	if event is InputEventJoypadMotion:
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
		$CoyoteTimer.start()
	
	if just_pressed == true:
		if sword_collision.get_overlapping_bodies() != []:
			#GetControllerAngle()
			Bounce(sword_pivot.rotation, IsWallJumping())

func PreventWallClimb():
	if wall_climb_prevention_raycast_1.is_colliding() == true or wall_climb_prevention_raycast_2.is_colliding() == true and is_on_floor() == false:
		sword_collision_shape.shape.size.x = 16
	else:
		sword_collision_shape.shape.size.x = 26

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
	if abs(angle) > 2.6:
		return bounce_power
	elif abs(angle) > 2.0:
		bounce_power.y -= 40
		return bounce_power
	elif abs(angle) > 1.5:
		bounce_power.y -= 60
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
