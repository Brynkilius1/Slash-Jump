extends Node2D

@onready var conversation_left = $"../TextboxLayer/Control/ConversationSides/ConversationLeft"
@onready var conversation_right = $"../TextboxLayer/Control/ConversationSides/ConversationRight"

@onready var textbox_text = $"../TextboxLayer/Control/TextboxText"


@onready var actor_portrait_left = $"../TextboxLayer/Control/ConversationSides/ConversationLeft/ActorPortraitLeft"
@onready var actor_portrait_right = $"../TextboxLayer/Control/ConversationSides/ConversationRight/ActorPortraitRight"


func SwitchToLeft(left_toggle):
	if left_toggle == "true":
		left_toggle = true
	elif left_toggle == "false":
		left_toggle = false
	else:
		print(left_toggle, " is not a valid input into SwitchToLeft in: ", self)
	
	
	conversation_left.visible = left_toggle
	conversation_right.visible = not left_toggle
	if left_toggle:
		textbox_text.position.x = 55
	else:
		textbox_text.position.x = 20




func ChangeLeftActorPortrait(new_actor_sprite):
	print("change left actor to: ", new_actor_sprite)
	actor_portrait_left.texture = load(new_actor_sprite)

func ChangeRightActorPortrait(new_actor_sprite):
	print("change right actor to: ", new_actor_sprite)
	actor_portrait_right.texture = load(new_actor_sprite)
