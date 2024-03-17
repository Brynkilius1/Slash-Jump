extends Node2D


@export var cache_1 : String
@export var cache_2 : String

var cache : Array = []

func _ready():
	cache.push_back(load(cache_1))
	cache.push_back(load(cache_2))
