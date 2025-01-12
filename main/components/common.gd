extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func changeToLoadedScene(paramLoadedScene):
	var sceneChanger = get_tree().root.get_node("main/scene_changer");
	
	var chilren = sceneChanger.get_children();
	for child in chilren:
		sceneChanger.remove_child(child);
		continue
	
	var inst = paramLoadedScene.instantiate();
	sceneChanger.add_child(inst);
	return
