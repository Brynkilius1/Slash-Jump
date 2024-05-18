@tool
extends Control

@export var width : int = 30: set = SetWidth

@onready var sword_left = $SwordLeft
@onready var sword_right = $SwordRight


func SetWidth(new_var):
	if sword_left:
		width = new_var
		sword_left.position.x = 25 - width
		sword_right.position.x = 49 + width


