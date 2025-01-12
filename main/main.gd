extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Common.changeToLoadedScene(load("res://main/components/scene_title.tscn"));
	pass # Replace with function body.
