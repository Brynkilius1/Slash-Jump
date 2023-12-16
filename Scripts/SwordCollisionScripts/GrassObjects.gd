extends TileMap

const DIRT_PARTICLES = preload("res://Scenes/Player/Particles/dirt_particles.tscn")


func SwordHitDetected(hit_pos : Vector2, sword_angle, player_x_speed):
	EmitSwordDirtParticles(5, player_x_speed, hit_pos, false)
	EmitSwordDirtParticles(2, player_x_speed, hit_pos, true)


func EmitSwordDirtParticles(amount, player_x_speed, emit_location, flipped : bool):
	
	var p = DIRT_PARTICLES.instantiate()
	
	var emit_direction = sign(player_x_speed)
	if flipped == true:
		emit_direction *= -1
	
	if emit_direction == 1:
		p.scale.x = -1
	
	p.amount = amount
	p.global_position = emit_location
	get_tree().root.get_child(0).add_child(p)
