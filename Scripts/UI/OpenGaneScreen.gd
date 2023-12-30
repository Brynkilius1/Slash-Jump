extends Control

var game_opened_amount : int = 60




@onready var first_open = $Sounds/FirstOpen
@onready var few_times_open = $Sounds/FewTimesOpen
@onready var many_times_open = $Sounds/ManyTimesOpen


# Called when the node enters the scene tree for the first time.
func _ready():
	ChooseTalk()
	IncreaseGameOpenedCount()



func ChooseTalk():
	var few_times_open_child_count = few_times_open.get_child_count()
	
	if game_opened_amount == 0:
		ChooseRandomAudio(first_open)
	elif game_opened_amount > 0 and game_opened_amount <= few_times_open_child_count:
		ChooseRandomAudio(few_times_open)
	elif game_opened_amount > few_times_open_child_count:
		ChooseRandomAudio(many_times_open)
func ChooseRandomAudio(sound_parent_path):
	var random_child = sound_parent_path.get_children().pick_random()
	random_child.play()

func IncreaseGameOpenedCount():
	game_opened_amount += 1



func RambleFinished():
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(load("res://Scenes/UI/GameStart/main_menu.tscn"))
