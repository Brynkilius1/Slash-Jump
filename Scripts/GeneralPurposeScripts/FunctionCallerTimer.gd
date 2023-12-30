extends Timer


@export var node_to_call_function_on : Node2D
@export var function_name : String




func _on_timeout():
	var call_object_callable = Callable(node_to_call_function_on, function_name)
	call_object_callable.call()
