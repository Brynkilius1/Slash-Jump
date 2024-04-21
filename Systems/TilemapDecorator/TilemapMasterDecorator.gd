@tool
extends Node2D

@export var redecorate_all_tilemaps : bool:
	set(value):
		redecorate_all_tilemaps = value
		RedecorateAllTilemaps()


func RedecorateAllTilemaps():
	if Engine.is_editor_hint():
		for i in get_children():
			if i.has_method("CallRedecoration"):
				i.CallRedecoration()
			else:
				print(self, " has a child that isnt a TilemapDecorator!")
