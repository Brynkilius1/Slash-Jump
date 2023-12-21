extends Area2D

@export var mushroom_is_blue = false
var jump_strength = 210


var mushroom_active = true

signal bounced_on


@onready var mushroom_sprite = $MushroomSprite
@onready var mushroom_collider = $MushroomCollider


func _ready():
	get_parent().connect("change_color", ChangeState)
	if mushroom_is_blue == true:
		mushroom_active = false
		mushroom_collider.disabled = true
	ChangeVisuals()


func _on_body_entered(body):
	if mushroom_active == true:
		if body is CharacterBody2D:
			body.velocity.y = -jump_strength
			bounced_on.emit()


func ChangeState():
	mushroom_active = not mushroom_active
	mushroom_collider.call_deferred("set_disabled", not mushroom_collider.disabled) 
	ChangeVisuals()

func ChangeVisuals():
	if mushroom_is_blue == true:
		if mushroom_active == true:
			mushroom_sprite.frame = 2
		else:
			mushroom_sprite.frame = 3
	else:
		if mushroom_active == true:
			mushroom_sprite.frame = 0
		else:
			mushroom_sprite.frame = 1
