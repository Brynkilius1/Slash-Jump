extends Node2D


@onready var textbox_layer = $TextboxLayer
@onready var textbox_text = $TextboxLayer/Control/TextboxText
@onready var text_progress_timer = $TextboxLayer/TextProgressTimer
@onready var textbox_visual_master = $TextboxVisualMaster

@export_multiline var text_array : PackedStringArray
@export_multiline var actions :  Dictionary #dialouge number : action : input    make it a dict


enum action_types {
	change_to_left,
	change_left_actor,
	change_right_actor
}

var current_text_number : int =  0
var finished_reading = false

signal advance_textbox
signal text_finished


func BeginTextbox():
	print("begin textbox")
	textbox_layer.visible = true
	text_progress_timer.start()
	CheckEvents(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	advance_textbox.connect(TextboxInput)
	textbox_text.visible_characters = 0
	textbox_text.text = text_array[current_text_number]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if textbox_layer.visible == true:
		if finished_reading == false:
			if Input.is_action_just_pressed("BigSwing"): #Input.is_action_just_pressed("ui_accept"):# or 
				advance_textbox.emit()




func TextboxInput():
	if textbox_text.visible_characters == -1 or textbox_text.visible_ratio == 1.0:
		AdvanceText()
	else:
		QuickFillTextbox()


func AdvanceText():
	current_text_number += 1
	
	if current_text_number < text_array.size(): #Checks  to see if text has been finished
		CheckEvents(current_text_number)
		textbox_text.text = text_array[current_text_number]
		textbox_text.visible_ratio = 0.0
		text_progress_timer.start()
		
	else:
		text_finished.emit()
		finished_reading = true
		textbox_layer.visible = false


func QuickFillTextbox():
	textbox_text.visible_characters = -1
	text_progress_timer.stop()



func _on_text_progress_timer_timeout(): #advance text by one
	textbox_text.visible_characters += 1
	if textbox_text.visible_characters >= textbox_text.get_total_character_count():
		text_progress_timer.stop()

func CheckEvents(text_number):
	var action_commands_string = actions.get(text_number) #convert actions dictionary to usable array
	print("Checking number: ", text_number, " for events")
	if action_commands_string != null:
		var action_commands = action_commands_string.split(",\n")
		print(text_number, " passed, with value: ", action_commands)
		
		
		for action in action_commands:
			var action_func = ReturnActionFunction(action.get_slice(";", 0)) #get the name of the func
			var action_input = action.get_slice(";", 1) #get the input to the func
			
			print("action input: ", action_input)
			var callable = Callable(textbox_visual_master, action_func)
			callable.call(action_input)

func ReturnActionFunction(input_string : String):
	if input_string == "change_to_left":
		return "SwitchToLeft"
	elif input_string == "change_left_actor":
		return "ChangeLeftActorPortrait"
	elif input_string == "change_right_actor":
		return "ChangeRightActorPortrait"
	else:
		print(input_string, " is not a valid textbox action in: ", self)
