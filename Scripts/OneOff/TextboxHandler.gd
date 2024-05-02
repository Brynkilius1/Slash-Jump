extends Node2D


@onready var textbox_layer = $TextboxLayer
@onready var textbox_text : Label = $TextboxLayer/TextboxText
@onready var text_progress_timer = $TextboxLayer/TextProgressTimer

@export_multiline var text_array : PackedStringArray



var current_text_number : int =  0
var finished_reading = false

signal advance_textbox
signal text_finished


func BeginTextbox():
	print("begin textbox")
	textbox_layer.visible = true
	text_progress_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	advance_textbox.connect(TextboxInput)
	textbox_text.visible_characters = 0
	textbox_text.text = text_array[current_text_number]
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	if textbox_layer.visible == true:
		if finished_reading == false:
			if Input.is_action_just_pressed("ui_accept"):# or Input.is_action_just_pressed("BigSwing"):
				advance_textbox.emit()




func TextboxInput():
	if textbox_text.visible_characters == -1 or textbox_text.visible_ratio == 1.0:
		AdvanceText()
	else:
		QuickFillTextbox()


func AdvanceText():
	current_text_number += 1
	
	if current_text_number < text_array.size(): #Checks  to see if text has been finished
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
