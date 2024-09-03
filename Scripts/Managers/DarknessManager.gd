extends Node2D


func ChangeDarknessLevel(darkness_level : float):
	print("change darkness level to: ", darkness_level)
	var darkness_solid = GlobalObjects.camera.get_child(2)
	var darkness_vignette = GlobalObjects.camera.get_child(1)
	
	
	var color_tween = create_tween()
	color_tween.tween_property(darkness_solid, "color", Vector4(0, 0, 0, darkness_level * 33), 0.5)
	#darkness_solid.color.a = (darkness_level * 33) / 255
	darkness_vignette.material.set_shader_parameter("alpha", 1)
	#darkness_vignette.material.set_shader_parameter("inner_radius", abs((darkness_level * 0.855) - 1))
	#darkness_vignette.material.set_shader_parameter("outer_radius", 1 + darkness_level)
	#_create_shader_tween(darkness_vignette, "alpha", darkness_vignette.material.get_shader_parameter("alpha"), darkness_level * 0.5, 0.5)
	_create_shader_tween(darkness_vignette, "inner_radius", darkness_vignette.material.get_shader_parameter("inner_radius"), abs((darkness_level * 0.855) - 1), 0.5)
	_create_shader_tween(darkness_vignette, "outer_radius", darkness_vignette.material.get_shader_parameter("outer_radius"), 2 - darkness_level, 0.5)
	
	


func _create_shader_tween(node: Node, shader_property: String, value_start: float, value_end: float, duration: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_method(
	func(value): node.material.set_shader_parameter(shader_property, value),  
		value_start,
		value_end,
		duration
	);
	return tween
