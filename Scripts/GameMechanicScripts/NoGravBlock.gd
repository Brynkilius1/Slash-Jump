extends Area2D

@onready var sword_collision_hitbox_1 = $SwordCollisionHandler/SwordCollisionHitbox1



func _on_body_entered(body):
	if body == GlobalObjects.player:
		print(GlobalObjects.player.zero_g_counter)
		GlobalObjects.player.zero_g_counter += 1
		ToggleEdgeHittable(false)


func _on_body_exited(body):
	if body == GlobalObjects.player:
		GlobalObjects.player.zero_g_counter -= 1
		ToggleEdgeHittable(true)


func ToggleEdgeHittable(is_hittable : bool):
	sword_collision_hitbox_1.set_deferred("disabled",  not is_hittable)
