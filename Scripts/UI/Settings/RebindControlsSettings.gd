extends Control

@onready var swing_selector = $SwingSelector
@onready var key_button_confirmer = %KeyButtonConfirmer
@onready var change_sword_swing_button = %ChangeSwordSwingButton

@onready var sword_swing_label = $SwingSelector/ChangeSwordSwingButton/SwordSwingLabel
@onready var knife_swing_label = $SwingSelector/ChangeKnifeSwingButton/KnifeSwingLabel


var listening_for_new_key = false


var input_to_be_changed

signal opened_rebind_menu
signal closed_rebind_menu
signal activate_rebind_control_dead_timer

#func _process(delta):
	#print(InputMap.action_get_events("BigSwing"))


func _unhandled_input(event):
	if listening_for_new_key == true:
		if event is InputEventKey || (event is InputEventMouseButton && event.pressed) || event is InputEventJoypadButton:
			#if event.axis_value > 0.9:
			#print(event)
			listening_for_new_key = false
			key_button_confirmer.visible = false
			accept_event()
			if input_to_be_changed == "BigSwing":
				UpdateControlVisual(sword_swing_label, event)
				OptionsManager.big_swing_button = event
			else:
				UpdateControlVisual(knife_swing_label, event)
				OptionsManager.small_swing_button = event
			
			activate_rebind_control_dead_timer.emit()
			closed_rebind_menu.emit()
			change_sword_swing_button.grab_focus()


func _on_change_sword_swing_button_pressed():
	opened_rebind_menu.emit()
	accept_event()
	swing_selector.hide()
	swing_selector.show()
	input_to_be_changed = "BigSwing"
	
	key_button_confirmer.visible = true
	#await get_tree().create_timer(0.3).timeout
	listening_for_new_key = true



func _on_change_knife_swing_button_pressed():
	opened_rebind_menu.emit()
	accept_event()
	swing_selector.hide()
	swing_selector.show()
	input_to_be_changed = "SmallSwing"
	
	key_button_confirmer.visible = true
	#await get_tree().create_timer(0.3).timeout
	listening_for_new_key = true



func UpdateControlVisual(label, event):
	label.text = event.as_text().trim_suffix(" (Physical)")

func GetFocus():
	change_sword_swing_button.grab_focus()
