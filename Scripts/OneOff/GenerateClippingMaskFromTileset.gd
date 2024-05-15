@tool
extends Node2D

@export var generate_clipping_mask : bool = false: set = SetGenerateClippingMask



func SetGenerateClippingMask(new_var):
	generate_clipping_mask = new_var
	
