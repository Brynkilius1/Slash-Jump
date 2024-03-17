extends Timer


@export var node_to_call_function_on : Node2D
@export var function_name : String
@export var send_empty_string_in_call : bool = false




func _on_timeout():
	var call_object_callable = Callable(node_to_call_function_on, function_name)
	if send_empty_string_in_call == false:
		call_object_callable.call()
	else:
		call_object_callable.call("")
