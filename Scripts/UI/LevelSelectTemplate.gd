extends HBoxContainer

@export var level : PackedScene 
@export var level_name : String = "Level"
@export var author_name : String = "Author"
@export var level_preview_image : Texture 

@onready var level_name_label = $VBoxContainer/LevelNameLabel
@onready var author_name_label = $VBoxContainer/AuthorNameLabel
@onready var image_preview = $ImagePreview


func _on_play_button_pressed():
	LoadingSceneTransistioner.ChangeSceneWithLoadingScreen(level.scene_file_path)

func _ready():
	level_name_label.text = level_name
	author_name_label.text = "By: " + author_name
	image_preview.texture = level_preview_image
