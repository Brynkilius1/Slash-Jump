extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")#320 is too little #400 was nice, 420 too, 455 too much

#slökkti á sfx í tilesets, breytti settings gravity í 325 frá 410, breytti hopp power, breytti walljump bias frá 20 og 25, tók í burtu player anims og sprites

#export variables
@export var swing_power = Vector2(0, 174) #(0, 160) #(0, 140)
@export var small_swing_power = Vector2(0, 100)
@export var extra_grounded_power := 16  #20
@export var friction := 0.3
@export var cut_x_speed := 0.15
@export var swing_cooldown := 0.10
@export var swing_miss_cooldown := 0.19
@export var swing_coyote_time := 0.2
@export var swing_anim_length := 0.15
@export var max_fall_speed := 250
@export var ledge_stop_speed := 94
@export var controller_dead_zone := 0.25

@export_category("Walljump bias")

@export_range (0, 3.14) var wall_bias_upper_limit : float = 2.6
@export var upper_boost : int = 20  #10
@export_range (0, 3.14) var wall_bias_middle_limit : float = 1.9
@export var lower_boost : int = 25   #12
@export_range (0, 3.14) var wall_bias_lower_limit : float = 1.5

@export_category("Animations")
@export var sword_resting_rotation = 95
@export var sword_miss_max_rotation = 150
@export var sword_miss_time = 0.1
@export var sword_miss_recover_time = 0.1


#node references
#Sword
@onready var sword_pivot = $SwordPivot
@onready var extended_sword = $SwordPivot/Extended
@onready var sword_collision = $SwordPivot/Extended/Sword/SwordCollision
@onready var sword_colision_shape = $SwordPivot/Extended/Sword/SwordCollision/SwordColisionShape
@onready var sword_swing_anim = $SwordPivot/Extended/Sword/SwingAnim

#SwordVisual
@onready var sword_visual = $SwordPivot/Rotator/SwordVisualPivot/SwordNotPixelart

@onready var sword_visual_pivot = $SwordPivot/Rotator/SwordVisualPivot




#Knife
@onready var knife_swing_anim = $SwordPivot/Extended/Knife/KnifeSwingAnim
@onready var knife_collision = $SwordPivot/Extended/Knife/KnifeCollision
@onready var knife_collision_shape = $SwordPivot/Extended/Knife/KnifeCollision/KnifeCollisionShape

#DirectionIndicator
@onready var indicator_pivot = $IndicatorPivot


#Raycasts
@onready var wall_climb_prevention_raycast_1 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast1
@onready var wall_climb_prevention_raycast_2 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast2
@onready var wall_climb_prevention_raycast_3 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast3
@onready var wall_climb_prevention_raycast_4 = $Raycasts/WallClimbPrevention/WallClimbPreventionRaycast4
@onready var walljump_raycasts = $SwordPivot/Extended/WalljumpRaycasts
@onready var ledge_forgiveness_raycast_1 = $Raycasts/LedgeForgiveness/LedgeForgivenessRaycast1
@onready var ledge_forgiveness_raycast_2 = $Raycasts/LedgeForgiveness/LedgeForgivenessRaycast2
@onready var ledge_forgiveness_raycast_3 = $Raycasts/LedgeForgiveness/LedgeForgivenessRaycast3
@onready var ledge_forgiveness_raycast_4 = $Raycasts/LedgeForgiveness/LedgeForgivenessRaycast4
@onready var ledge_stop_raycast_1 = $Raycasts/LedgeStop/LedgeStopRaycast1
@onready var ledge_stop_raycast_2 = $Raycasts/LedgeStop/LedgeStopRaycast2
@onready var ledge_stop_raycast_3 = $Raycasts/LedgeStop/LedgeStopRaycast3
@onready var corner_boost_stopper_raycasts = $Raycasts/CornerBoostStopperRaycasts
@onready var decoration_particle_raycast = $Raycasts/ParticleSpawningRaycasts/DecorationParticleRaycast
@onready var decoration_particle_raycast_2 = $Raycasts/ParticleSpawningRaycasts/DecorationParticleRaycast2
@onready var ground_particle_raycast_1 = $Raycasts/ParticleSpawningRaycasts/GroundParticleRaycast1
@onready var ground_particle_raycast_2 = $Raycasts/ParticleSpawningRaycasts/GroundParticleRaycast2
@onready var knife_raycasts = $SwordPivot/Extended/KnifeRaycasts




#Timers
@onready var swing_linger_timer = $SwingLingerTimer
@onready var knife_swing_linger_timer = $KnifeSwingLingerTimer
@onready var swing_miss_timer = $SwingMissTimer
@onready var coyote_timer = $CoyoteTimer
@onready var knife_coyote_timer = $KnifeCoyoteTimer


#Particles
@onready var sword_lingering_particles = $SwordPivot/Rotator/SwordVisualPivot/SwordLingeringParticles
@onready var dirt_skidding_particles = $Particles/DirtSkiddingParticles


#Animations
@onready var player_anim_tree = $PlayerAnimationTree
@onready var player_sprite = $PlayerSprite

#Sounds
@onready var player_audio_master = $PlayerAudioMaster



#Misc
@onready var camera_shaker = $Camera2D/Shaker



enum player_animation_states { #UNUSED
	IDLE,
	SWINGING,
	IN_AIR,
	LANDING
}

var current_anim_state = player_animation_states.IDLE: #UNUSED
	set(value):
		current_anim_state = value
		PlayerAnimStateChanged(value)


#instances
const SWORD_COLISION_PARTICLES = preload("res://Scenes/Particles/sword_colision_particles.tscn")
const AFTER_SWING_VFX = preload("res://Scenes/Particles/after_swing_vfx.tscn")
const DUSTCLOUDS = preload("res://Scenes/Particles/dustclouds.tscn")
const SMALL_LANDING_DUST = preload("res://Scenes/Particles/player_landing_dust.tscn")
const DIRT_PARTICLES = preload("res://Scenes/Particles/dirt_particles.tscn")

#signals
signal player_died


#code variables
var has_control = true

var can_rotate_sword = true
var graity_enabled = true
var was_on_ground_last_frame = false
var saved_x_speed : float
var saved_coyote_direction : float
var saved_controller_angle : float
var swing_dir = 1
var sword_has_hit_this_swing = false
var knife_has_hit_this_swing = false
var checking_sword_hitbox = false
var checking_knife_hitbox = false
var extra_swing_power : int = 0
var last_frame_velocity : Vector2

var playing_with_controller = true

#options variables
var screenshake_disabled = false
var inverted_controls = false


#set variables
var zero_g_counter : int = 0: set = SetZeroGCounter

#to be removed later variables





func _ready():
	GlobalObjects.player = self
	swing_linger_timer.connect("timeout", SwingLingerTimeout)
	knife_swing_linger_timer.connect("timeout", KnifeSwingLingerTimeout)
	
	#Settings:
	UpdateControlSettings()
	


func _unhandled_input(event):
	if event is InputEventJoypadMotion:
		if playing_with_controller == false:
			playing_with_controller = true
		indicator_pivot.rotation = GetInputAngle()
		if can_rotate_sword == true:
			sword_pivot.rotation = GetInputAngle()
			
			#if GetControllerAngle() == 0:
				#pass
				#add code that puts away your sword afer a seconds or two
	
	elif event is InputEventMouseMotion:
		if playing_with_controller == true:
			playing_with_controller = false
		
		indicator_pivot.rotation = GetInputAngle()
		if can_rotate_sword == true:
			sword_pivot.rotation = GetInputAngle()




#called each frame
func _process(delta):
	CheckIfSwordBehindPlayer()
	


#8 times each frame (or how many times a physics frame is per fame)
func _physics_process(delta):
	
	Friction()
	if graity_enabled == true:
		Gravity(delta)
	
	
	PreventWallClimb()
	GetSlashInput()
	CheckCornerBoost()
	CheckLedgeForgiveness()
	CheckLedgeStop()
	CheckIfPlayerImpact()
	CheckSwordColision()
	
	
	UpdateAnimationParameteres()
	
	
	
	
	
	move_and_slide()
	
	CheckIfReload()




func GetInputAngle():
	if playing_with_controller == true:
		var input_vector : Vector2 = Vector2.ZERO
		input_vector.x = Input.get_action_strength("ControllerRight") - Input.get_action_strength("ControllerLeft")
		input_vector.y = Input.get_action_strength("ControllerDown") - Input.get_action_strength("ControllerUp")
		
		
		if inverted_controls == false:
			input_vector = input_vector.rotated(1.5708)
		else:
			input_vector = input_vector.rotated(-1.5708)
		
		input_vector = ApplyDeadZone(input_vector)
		
		var return_angle = Vector2.ZERO.angle_to_point(input_vector)
		
		if return_angle == 0.0:
			return_angle = saved_controller_angle
		else:
			saved_controller_angle = return_angle
		
		
		
		return return_angle
		
	else:
		var dir = get_global_mouse_position() - position
		var return_angle = Vector2.UP.angle_to(dir)
		return return_angle

func ApplyDeadZone(input_vector):
	if abs(input_vector.x) < controller_dead_zone and abs(input_vector.y) < controller_dead_zone:
		input_vector.x = 0.0
		input_vector.y = 0.0
	return input_vector

func GetSlashInput():
	if has_control == true:
		if Input.is_action_just_pressed("BigSwing"):
			coyote_timer.start(swing_coyote_time)
			saved_coyote_direction = GetInputAngle()
		elif Input.is_action_just_pressed("SmallSwing"):
			knife_coyote_timer.start(swing_coyote_time)
			saved_coyote_direction = GetInputAngle()
		
		
		if SwingCooldownActive() == false:
			if coyote_timer.time_left > 0:
				sword_pivot.rotation = saved_coyote_direction
				coyote_timer.stop()
				knife_coyote_timer.stop()
				Swing()
			elif knife_coyote_timer.time_left > 0:
				sword_pivot.rotation = saved_coyote_direction
				coyote_timer.stop()
				knife_coyote_timer.stop()
				SwingKnife()
	
func CheckSwordColision():
	if checking_sword_hitbox == true:
		if sword_collision.get_overlapping_bodies() != []:
			SwordDetectsHit("bodyballs")
	if checking_knife_hitbox == true:
		if knife_collision.get_overlapping_bodies() != []:
			KnifeDetectsHit("temp")

func Swing():
	SwingSoundEffects()
	SwingVisuals()
	SwingParticles()
	SwingTechnical()


func SwingSoundEffects():
	#maybe add changing sound effects depending on the type of tile hit
	player_audio_master.PlayRandomSound("SwingSword")


func SwingVisuals():
	SwingAnimation()
	PlayerSwingAnimation()
	SwingVFX()
func SwingAnimation():
	#rotating the sword the player is holding
	
	swing_dir = sign(sword_visual_pivot.rotation_degrees)
	
	sword_visual.rotation_degrees = 16 #-swing_dir * 25
	sword_visual_pivot.rotation_degrees = 45 #-swing_dir * 45
	
	
	var swing_visual_pivot_tween = create_tween()
	swing_visual_pivot_tween.tween_property(sword_visual_pivot, "rotation_degrees", -swing_dir * sword_resting_rotation, swing_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	var swing_visual_tween = create_tween()
	swing_visual_tween.tween_property(sword_visual, "rotation_degrees", -swing_dir * 90, swing_anim_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	await get_tree().create_timer(swing_anim_length/3).timeout
	sword_visual.flip_v = swing_dir + 1

func PlayerSwingAnimation():
	pass
	#FlickOnAnimState("IsSwinging")
	#current_anim_state = player_animation_states.SWINGING

func SwingVFX():
	#show the woosh in the air
	sword_swing_anim.visible = true
	sword_swing_anim.flip_v = swing_dir + 1
	sword_swing_anim.stop()
	knife_swing_anim.stop()
	sword_swing_anim.play("Swing")
func SwingParticles():
	EmitSwingLingerParticles()
func EmitSwingLingerParticles():
	sword_lingering_particles.emitting = true
	
	#await get_tree().create_timer(swing_anim_length/3).timeout
	sword_lingering_particles.emitting = false
	sword_lingering_particles.scale.x = sign(sword_visual_pivot.rotation_degrees)
func SwingTechnical():
	
	checking_sword_hitbox = true
	sword_colision_shape.disabled = false
	
	#sword_colision_shape.disabled = false
	sword_has_hit_this_swing = false
	can_rotate_sword = false
	
	StartSwingLingerTimer()

func StartSwingLingerTimer():
	swing_linger_timer.start(swing_cooldown)





func SwingLingerTimeout():
	LingerTimeoutVisuals()
	#LingerTimeoutParticles()
	LingerTimeoutTechnical()
	
	CheckIfSwingHit()
	swing_linger_timer.stop()

func LingerTimeoutVisuals():
	LingerMissAnim()
	knife_swing_anim.visible = false
func LingerMissAnim():
	var miss_anim_tween = create_tween()
	miss_anim_tween.tween_property(sword_visual_pivot, "rotation_degrees", sign(sword_visual_pivot.rotation_degrees) * sword_miss_max_rotation, sword_miss_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	await miss_anim_tween.finished
	var miss_return_anim_tween = create_tween()
	miss_return_anim_tween.tween_property(sword_visual_pivot, "rotation_degrees", sign(sword_visual_pivot.rotation_degrees) * sword_resting_rotation, sword_miss_recover_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
func LingerTimeoutParticles():
	#lingering swing vfx particle
	var after_swing_vfx = AFTER_SWING_VFX.instantiate()
	
	after_swing_vfx.rotation = sword_pivot.rotation
	after_swing_vfx.process_material.angle_min = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.process_material.angle_max = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.global_position = $SwordPivot/Extended/Sword/LingeringVFXEmitter.global_position
	
	get_tree().current_scene.add_child(after_swing_vfx)
func LingerTimeoutTechnical():
	checking_sword_hitbox = false
func CheckIfSwingHit():
	if swing_linger_timer.time_left > 0:
		swing_miss_timer.stop()
	else:
		swing_miss_timer.start(swing_miss_cooldown)




#called when the sword collides with something
func SwordDetectsHit(body):
	if sword_has_hit_this_swing == false:
		#Hit
		SwordHitVelocity(swing_power, sword_pivot.rotation, IsWallJumping(walljump_raycasts))
		
		#Juice
		SwordHitSounds()
		SwordHitParticles()
		DeformPlayer(swing_power, sword_pivot.rotation)
		
		
		#ShakeCamera(0.4, 0, 1) #(0.7, 0, 6)
		#SwordHitFramePause(0.05)
		
		#Technical
		SwordHitTechnical()
		HitObjects()
		DeactivateSwordHitbox()

func SwordHitSounds():
	#moved to the tilesets themselves
	pass
func SwordHitParticles():
	var sword_tip = walljump_raycasts.get_child(0).global_position + walljump_raycasts.get_child(0).target_position.rotated(sword_pivot.rotation)
	var nearest_ground = GetClosestGround(walljump_raycasts)
	#EmitParticles(sword_colision_particles, nearest_ground, sword_pivot.rotation)
	EmitParticles(DUSTCLOUDS, nearest_ground + Vector2(0, -2), 0)
	
	#ground particles are spawned in their respective scripts


func DeformPlayer(deformation_power, sword_rotation):

	var deformation = Vector2(0.6, 0).rotated(sword_rotation)
	var limited_sword_rotation
	
	sword_rotation = rad_to_deg(sword_rotation)
	if abs(sword_rotation) > 90:
		sword_rotation += 180
		if sword_rotation > 200:
			sword_rotation -= 360
	

	print(sword_rotation)


func SwordHitFramePause(pause_time):
	get_tree().paused = true
	
	await get_tree().create_timer(pause_time).timeout
	get_tree().paused = false
func SwordHitTechnical():
	#sword_colision_shape.call_deferred("set_disabled", true)
	checking_sword_hitbox = false
	sword_has_hit_this_swing = true
func HitObjects():
	var hit_objects = sword_collision.get_overlapping_bodies()
	for i in hit_objects:
		CallIndirectHitOnObject(i)

func CallIndirectHitOnObject(object_hit):
	if object_hit:
		if object_hit.has_method("IndirectSwordHit") == true:
			object_hit.IndirectSwordHit(sword_pivot.rotation_degrees)
		elif object_hit.get_parent().has_method("IndirectSwordHit") == true:
			object_hit.get_parent().IndirectSwordHit(sword_pivot.rotation_degrees)
func SwordHitVelocity(power, angle, is_wall_jumping):
	var bounce_power = power + Vector2(0, extra_swing_power)
	extra_swing_power = 0
	bounce_power.y += int(is_on_floor()) * extra_grounded_power #add slighty mode power if player is grounded
	bounce_power = bounce_power.rotated(angle)
	if is_wall_jumping == true:
		bounce_power = AddWallJumpBias(bounce_power, angle)
	
	saved_x_speed = bounce_power.x
	velocity = bounce_power
	
	velocity.x = lerp(velocity.x, 0.0, cut_x_speed)
	coyote_timer.stop()
func DeactivateSwordHitbox():
	LingerTimeoutTechnical()
	CheckIfSwingHit()
	#LingerTimeoutParticles()
	swing_linger_timer.stop()

func AddWallJumpBias(bounce_power, angle):
	if abs(angle) > wall_bias_upper_limit:
		print("Walljump power: ", 0)
		return bounce_power
	elif abs(angle) > wall_bias_middle_limit:
		bounce_power.y -= upper_boost
		print("Walljump power: ", upper_boost)
		return bounce_power
	elif abs(angle) > wall_bias_lower_limit:
		bounce_power.y -= lower_boost
		print("Walljump power: ", lower_boost)
		return bounce_power
	else:
		print("Walljump power: ", 0)
		return bounce_power

func IsWallJumping(raycast_group):
	var floor_hits := 0
	var wall_hits := 0
	for raycast in raycast_group.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding() == true:
			if raycast.get_collision_normal().x != 0:
				wall_hits += 1
			elif raycast.get_collision_normal().y != 0:
				floor_hits += 1
			else:
				#for edge cases where you jump from inside an object (made for bubble, might have to change later)
				wall_hits += 1
	if is_on_floor() == true:
		return false
	elif wall_hits > floor_hits:
		return true
	else:
		return false

func GetClosestGround(raycast_group):
	#optimise later
	var main_raycast = raycast_group.get_child(0)
	var emit_pos : Vector2 = main_raycast.global_position + main_raycast.target_position.rotated(sword_pivot.rotation)
	var object_hit
	
	for i in raycast_group.get_children():
		i.force_raycast_update()
		if i.is_colliding() == true:
			emit_pos = i.get_collision_point()
			object_hit = i.get_collider()
			break
	
	DirectSwordHitOnObject(object_hit, emit_pos)
	
	if object_hit != null: 
		DebugMaster.UpdateSwingRaycastIndicators(emit_pos, object_hit) #update debug stuff
	
	return emit_pos

func DirectSwordHitOnObject(object_hit, emit_pos):
	if object_hit:
		if object_hit.has_method("DirectSwordHit") == true:
			object_hit.DirectSwordHit(emit_pos, sword_pivot.rotation, saved_x_speed)
		elif object_hit.get_parent().has_method("DirectSwordHit") == true:
			object_hit.get_parent().DirectSwordHit(emit_pos, sword_pivot.rotation, saved_x_speed)

func SwingKnife():
	KnifeSwingSounds()
	KnifeSwingVisuals()
	KnifeSwingParticles()
	KnifeSwingTechnical()


func KnifeSwingSounds():
	player_audio_master.PlayRandomSound("SwingSword")
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
	
	checking_knife_hitbox = true
	knife_collision_shape.disabled = false
	
	#sword_colision_shape.disabled = false
	knife_has_hit_this_swing = false
	can_rotate_sword = false
	
	StartKnifeSwingLingerTimer()

func StartKnifeSwingLingerTimer():
	knife_swing_linger_timer.start(swing_cooldown)




func KnifeSwingLingerTimeout():
	KnifeLingerTimeoutVisuals()
	#KnifeLingerTimeoutParticles()
	KnifeLingerTimeoutTechnical()
	
	CheckIfKnifeSwingHit()
	knife_swing_linger_timer.stop()


func KnifeLingerTimeoutVisuals():
	KnifeLingerMissAnim()
	knife_swing_anim.visible = false
func KnifeLingerMissAnim():
	var miss_anim_tween = create_tween()
	miss_anim_tween.tween_property(sword_visual_pivot, "rotation_degrees", sign(sword_visual_pivot.rotation_degrees) * sword_miss_max_rotation, sword_miss_time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	await miss_anim_tween.finished
	var miss_return_anim_tween = create_tween()
	miss_return_anim_tween.tween_property(sword_visual_pivot, "rotation_degrees", sign(sword_visual_pivot.rotation_degrees) * sword_resting_rotation, sword_miss_recover_time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
func KnifeLingerTimeoutParticles():
	#lingering swing vfx particle
	var after_swing_vfx = AFTER_SWING_VFX.instantiate()
	
	after_swing_vfx.rotation = sword_pivot.rotation
	after_swing_vfx.process_material.angle_min = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.process_material.angle_max = -sword_pivot.rotation_degrees + 90
	after_swing_vfx.global_position = $SwordPivot/Extended/Sword/LingeringVFXEmitter.global_position
	
	get_tree().current_scene.add_child(after_swing_vfx)
func KnifeLingerTimeoutTechnical():
	checking_knife_hitbox = false
	
func CheckIfKnifeSwingHit():
	if knife_swing_linger_timer.time_left > 0:
		print("stop swing miss timer")
		swing_miss_timer.stop()
	else:
		print("start swing miss timer")
		swing_miss_timer.start(swing_miss_cooldown)



func KnifeDetectsHit(body):
	if knife_has_hit_this_swing == false:
		SwordHitVelocity(small_swing_power, sword_pivot.rotation, IsWallJumping(knife_raycasts))
		
		#Juice
		KnifeHitSounds()
		KnifeHitParticles()
		
		#ShakeCamera(0.3, 0, 0.5)
		
		
		
		
		#Technical
		KnifeHitTechnical()
		DeactivateKnifeHitbox()
func KnifeHitSounds():
	#moved to the tilsets themselves
	pass
func KnifeHitParticles():
	var sword_tip = knife_raycasts.get_child(0).global_position + knife_raycasts.get_child(0).target_position.rotated(sword_pivot.rotation)
	var nearest_ground = GetClosestGround(knife_raycasts)
	EmitParticles(DUSTCLOUDS, nearest_ground + Vector2(0, -2), 0)
func KnifeHitTechnical():
	checking_knife_hitbox = false
	knife_has_hit_this_swing = true
func DeactivateKnifeHitbox():
	LingerTimeoutTechnical()
	CheckIfKnifeSwingHit()

	knife_swing_linger_timer.stop()


func NearestGroundKnife():
	
	return



func PreventWallClimb():
	if (wall_climb_prevention_raycast_1.is_colliding() == true or wall_climb_prevention_raycast_2.is_colliding() == true or wall_climb_prevention_raycast_3.is_colliding() == true or wall_climb_prevention_raycast_4.is_colliding() == true) and is_on_floor() == false:
		sword_colision_shape.scale.x = 0.25
		knife_collision_shape.scale.x = 0.3
	else:
		sword_colision_shape.scale.x = 1
		knife_collision_shape.scale.x = 1

func CheckCornerBoost():
	if velocity.x == 0:
		if sign(saved_x_speed) == 1:
			if wall_climb_prevention_raycast_1.is_colliding() == false and wall_climb_prevention_raycast_3.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
		elif sign(saved_x_speed) == -1:
			if wall_climb_prevention_raycast_2.is_colliding() == false and wall_climb_prevention_raycast_4.is_colliding() == false:
				velocity.x = saved_x_speed
				saved_x_speed = 0.0
	
	
	saved_x_speed = lerp(saved_x_speed, sign(saved_x_speed), 0.1) #return saved_x_speed to 0 over time

func DoesLedgeForgivenessGoIntoHazards():
	var return_bool = false
	for i in corner_boost_stopper_raycasts.get_children():
		if i.is_colliding() == true:
			return_bool = true
	return return_bool

func CheckLedgeForgiveness():
	if sign(saved_x_speed) == 1:
		if ledge_forgiveness_raycast_1.is_colliding() == true and ledge_forgiveness_raycast_3.is_colliding() == false:
			if DoesLedgeForgivenessGoIntoHazards() == false:
				if velocity.y > 0:
					global_position.y -= 5
					global_position.x += 1
	elif sign(saved_x_speed) == -1:
		if ledge_forgiveness_raycast_2.is_colliding() == true and ledge_forgiveness_raycast_4.is_colliding() == false:
			if DoesLedgeForgivenessGoIntoHazards() == false:
				if velocity.y > 0:
					global_position.y -= 5
					global_position.x -= 1

func CheckLedgeStop():
	if velocity.x < ledge_stop_speed and velocity.x >= 0:
		if ledge_stop_raycast_1.is_colliding() == true and ledge_stop_raycast_2.is_colliding() == false: #XOR for if theyre colliding 
			#if ledge_stop_raycast_3.is_colliding() == true:
			velocity.x  = 0
	elif velocity.x > -ledge_stop_speed and velocity.x < 0:
		if ledge_stop_raycast_1.is_colliding() == false and ledge_stop_raycast_2.is_colliding() == true: #XOR for if theyre colliding 
			#if ledge_stop_raycast_3.is_colliding() == true:
			velocity.x  = 0
func CheckIfPlayerImpact():
	CheckVerticalInpact()
	CheckHorisontalInpact()
	last_frame_velocity = velocity

func CheckVerticalInpact():
	var vertical_impact = JustLandedPower()
	
	if vertical_impact > 200:
		player_anim_tree["parameters/Landing/blend_position"] = vertical_impact / (max_fall_speed)
		#SpawnLandingParticles(DUSTCLOUDS)
		#SpawnLandingParticles(DIRT_PARTICLES, 4, Vector2(0, 6))
		print("vertical impact: ", vertical_impact)
		LandingParticlesTechnical()
		
		
		
		FlickOnAnimState("IsLanding")
		
		#enable colision box to make flowers make particles
		
	elif vertical_impact > 120:
		player_anim_tree["parameters/Landing/blend_position"] = vertical_impact / (max_fall_speed)
		SpawnLandingParticles(SMALL_LANDING_DUST)
		FlickOnAnimState("IsLanding")
		
	elif vertical_impact > 20:
		SpawnLandingParticles(SMALL_LANDING_DUST, 3)


func LandingParticlesTechnical():
	ground_particle_raycast_1.force_raycast_update()
	ground_particle_raycast_2.force_raycast_update()
	
	if ground_particle_raycast_1.is_colliding():
		ground_particle_raycast_1.get_collider().LandOnTilemap(position)
	elif decoration_particle_raycast_2.is_colliding():
		ground_particle_raycast_2.get_collider().LandOnTilemap(position)
	else:
		print("ground landing particles failed to be summoned")


func CheckHorisontalInpact():
	var horisontal_impact = abs(JustWallBonked())
	if horisontal_impact > 120:
		player_anim_tree["parameters/SidewaysLanding/blend_position"] = horisontal_impact / (swing_power.y)
		SpawnLandingParticles(SMALL_LANDING_DUST)
		FlickOnAnimState("IsWallBonking")
		
	elif horisontal_impact > 65:
		SpawnLandingParticles(SMALL_LANDING_DUST, 3)
		FlickOnAnimState("IsWallBonking")

func SpawnLandingParticles(particles, amount_override: int = 0, spawn_location_override: Vector2 = Vector2.ZERO, flipped: bool = false):
	var d = particles.instantiate()
	d.global_position = position + Vector2(0, 9)
	if amount_override > 0:
		d.amount = amount_override
	if spawn_location_override != Vector2.ZERO:
		d.global_position = position + spawn_location_override
	get_tree().current_scene.add_child(d)

func Friction():
	if is_on_floor():
		velocity.x  = lerp(velocity.x, 0.0, friction)
		
	#if JustLanded() == true:
	#	dirt_skidding_particles.emitting = true

func JustLandedPower():
	var return_var : float = 0.0
	if is_on_floor() and velocity.y == 0:
		return_var = last_frame_velocity.y
	else:
		return_var =  0
	return return_var

func JustWallBonked():
	var return_var : float = 0.0
	if is_on_wall() and velocity.x == 0:
		return_var = last_frame_velocity.x
		#print(return_var)
	else:
		return_var =  0
	return return_var

func FrictionParticles():
	if abs(velocity.x) > 0.1 and is_on_floor() == true:
		dirt_skidding_particles.emitting = true
	else:
		dirt_skidding_particles.emitting = false


func Gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed #cap fall speed




func CheckIfReload():
	if Input.is_action_just_pressed("Reload"):
		player_died.emit()





func _on_swing_miss_timer_timeout():
	player_audio_master.PlayRandomSound("SwordMiss")
	

func _on_coyote_timer_timeout():
	pass

func _on_swing_anim_animation_finished():
	sword_swing_anim.visible = false
	knife_swing_anim.visible = false
	can_rotate_sword = true
	sword_colision_shape.disabled = true
	
	#current_anim_state = player_animation_states.IDLE

func _on_knife_swing_anim_animation_finished():
	sword_swing_anim.visible = false
	knife_swing_anim.visible = false
	can_rotate_sword = true
	knife_collision_shape.disabled = true
func SwingCooldownActive():
	# can add more ifs, if more cooldowns are added
	
	var return_bool = false
	if swing_miss_timer.time_left > 0:
		return_bool = true
	if swing_linger_timer.time_left > 0:
		return_bool = true
	if knife_swing_linger_timer.time_left > 0:
		return_bool = true
	return return_bool

func ShakeCamera(time, min, max):
	if screenshake_disabled == false:
		camera_shaker.min_value = min
		camera_shaker.max_value = max
		camera_shaker.start(time)

func EmitParticles(particles, emit_pos, angle):
	var s = particles.instantiate()
	s.rotation = angle
	s.global_position = emit_pos
	s.z_index = 2
	
	get_tree().current_scene.add_child(s)


#Set functions
func SetZeroGCounter(new_value):
	zero_g_counter = new_value
	if zero_g_counter < 0:
		zero_g_counter = 0
	
	if zero_g_counter == 0:
		TurnOffGravity(false)
	elif zero_g_counter >= 1:
		TurnOffGravity(true)



#Externally callable functions
func TurnOffGravity(turn_off : bool):
	graity_enabled = not turn_off

func IncreaseNextJumpPower(strength):
	extra_swing_power = strength

func UpdateControlSettings():
	controller_dead_zone = OptionsManager.controller_deadzone
	inverted_controls = OptionsManager.inverted_controls











#Player Animations!!!       Updates Animation tree's states and conditions
@onready var temp_player_sprite = $TempPlayerSprite

func UpdateAnimationParameteres(): #every frame
	
	#Update transistion conditions
	player_anim_tree["parameters/conditions/IsIdle"] = is_on_floor()
	player_anim_tree["parameters/conditions/IsAirborne"] = not is_on_floor()
	
	
	
	
	
	#Updates Animation tree's conditions
	var sword_rotation_vector = Vector2.UP.rotated(sword_pivot.rotation)
	player_anim_tree["parameters/Idle/blend_position"] = sword_rotation_vector
	player_anim_tree["parameters/Swing/blend_position"] = sword_rotation_vector
	player_anim_tree["parameters/Airborne/blend_position"] = Vector2(velocity.y / max_fall_speed, velocity.x / (swing_power.y)) 
	
	
	
	player_sprite.material.set_shader_parameter("deformation",
	lerp(player_sprite.material.get_shader_parameter("deformation"), Vector2.ZERO, 0.1) )
	

	
	#Flip player 
	if abs(rad_to_deg(sword_pivot.rotation)) > 15 and abs(rad_to_deg(sword_pivot.rotation)) < 165:
		player_sprite.flip_h = sign(rad_to_deg(sword_pivot.rotation)) - 1
	
		
	
	#player_anim_tree["parameters/conditions/IsSwinging"]
	#player_anim_tree["parameters/conditions/NotSwinging"]


func FlickOnAnimState(state, flick_time = 0.05):
	player_anim_tree["parameters/conditions/" + str(state)] = true
	await get_tree().create_timer(flick_time).timeout
	player_anim_tree["parameters/conditions/" + str(state)] = false


func PlayerAnimStateChanged(anim): #UNUSED
	if anim == player_animation_states.IDLE:
		player_anim_tree["parameters/conditions/IsIdle"] = true
		player_anim_tree["parameters/conditions/IsSwinging"] = false
	
	elif  anim == player_animation_states.SWINGING:
		player_anim_tree["parameters/conditions/IsIdle"] = false
		player_anim_tree["parameters/conditions/IsSwinging"] = true


func CheckIfSwordBehindPlayer():
	
	var sword_rotation_with_flip = sword_pivot.rotation_degrees * swing_dir
	if sword_rotation_with_flip > 0 or abs(sword_rotation_with_flip) > 160:
		sword_visual.z_index = -1
	else:
		sword_visual.z_index = 0
